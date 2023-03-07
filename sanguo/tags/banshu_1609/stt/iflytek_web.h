
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include "objectmanager.h"
#include "base64.h"
#include <curl/curl.h>

static std::mutex tokenlock;
static time_t g_refreshTokenTime = 0;
static std::string g_token = "";

/* 定制的字符串分割 */
static std::string parsestr(const char* raw_str, int raw_size, const char *reqir, const char* delim = ",", const char* reqdelim = ":")
{	
	if(raw_str == NULL || reqir == NULL || raw_size > 1024)
	{
		printf("parsestr args wrong\n");
		return "";
	}
		
	char tmp_str[1024];
	memset(tmp_str,'\0',1024);
	memcpy(tmp_str,raw_str,raw_size);
	
	char* p = strtok(tmp_str, delim);
	while(p)
	{
		//printf("%s\n",p);
		if( strstr(p,reqir) == NULL)
		{
			p = strtok(NULL,delim);
			continue;
		}

		std::string tmp = strtok(p,reqdelim);
		//printf("key = %s ",(char*)tmp.c_str());
		tmp = strtok(NULL,reqdelim);
		//printf("value = %s\n",(char*)tmp.c_str());
		if(tmp.empty())
		{
			return "";
		}

		return std::string(tmp.substr(1,tmp.size()-2));
	}
	return "";
}

static size_t getcharCode(void *ptr, size_t size, size_t nmemb, void *userdata)
{
	std::string *version = (std::string*)userdata;
	version->append((char*)ptr, size * nmemb);
	return (size * nmemb);
}

//获取token 这个不要随意修改 只要修改appid就行 
std::string http_get_token()
{
	std::string result = "";
	//这个地方需要枷锁
	CURL *handle =  curl_easy_init();
	if ( ! handle)
	{
		printf(" czan not init curl \n");
		return "";
	}
	
	curl_easy_setopt(handle, CURLOPT_HEADER,0);
	curl_easy_setopt(handle, CURLOPT_NOSIGNAL, 1L);

	//传入头部的参数 base64 编码参数
	Octets oxpar;
	struct curl_slist *slist = NULL;	
	std::string xpar = "imei=1111&imsi=1111&mac=1111&appid=57847211";
	Base64Encoder::Convert(oxpar,Octets((char*)xpar.c_str(), xpar.size()));
	std::string head = "X-Par:" + std::string((char*)oxpar.begin(),oxpar.size()); 
	slist = curl_slist_append(slist, head.c_str());

	curl_easy_setopt(handle, CURLOPT_HTTPHEADER,slist);
	curl_easy_setopt(handle, CURLOPT_WRITEFUNCTION, getcharCode);
	curl_easy_setopt(handle, CURLOPT_URL, "openapi.openspeech.cn/index.htm?svc=token");
	curl_easy_setopt(handle, CURLOPT_WRITEDATA, &result);
	CURLcode res = curl_easy_perform(handle);
	
	Octets rlt;
	Base64Decoder::Convert(rlt, Octets((char*)result.c_str(), result.size()));	
	printf("base64 result = %.*s\n",(int)rlt.size(),(char*)rlt.begin());
	
	if (res == CURLE_OK)
	{
		printf("result = %s \n", result.c_str());	
	}
	else
	{
		printf("curl res = %d \n", (int)res);
	}
	
	curl_easy_cleanup(handle);

	return parsestr((char*)rlt.begin(),rlt.size(),"token"); 
}

//获取语音返回的文字
std::string http_post_get_text(std::string content)
{
	
	string result = "";
	CURL *handle =  curl_easy_init();
	if ( ! handle)
	{
		printf(" czan not init curl \n");
		return "";
	}
	
	//组合字符串	
	std::string url = "openapi.openspeech.cn/index.htm?svc=iat&token=" + g_token + "&auf=audio/L16;rate=16000&aue=raw&ent=sms16k";	
	printf("url = %s\n", url.c_str());

	curl_easy_setopt(handle, CURLOPT_URL, url.c_str());	
	curl_easy_setopt(handle, CURLOPT_POST,1);
	curl_easy_setopt(handle, CURLOPT_POSTFIELDSIZE,content.size());
	curl_easy_setopt(handle, CURLOPT_POSTFIELDS,content.c_str());
	curl_easy_setopt(handle, CURLOPT_NOSIGNAL, 1L);

	//传入头部的参数 base64 编码参数
	Octets oxpar;
	struct curl_slist *slist = NULL;	
	std::string xpar = "imei=1111&imsi=1111&mac=1111&appid=57847211";
	Base64Encoder::Convert(oxpar,Octets((char*)xpar.c_str(), xpar.size()));
	std::string head =std::string("Content-Type:binary\r\n") + "X-Par:" + std::string((char*)oxpar.begin(),oxpar.size()); 
	slist = curl_slist_append(slist, head.c_str());
	
	curl_easy_setopt(handle, CURLOPT_HTTPHEADER,slist);
	curl_easy_setopt(handle, CURLOPT_WRITEFUNCTION, getcharCode);
	curl_easy_setopt(handle, CURLOPT_WRITEDATA, &result);	
	//curl_easy_setopt(handle, CURLOPT_VERBOSE,1);
	//curl_easy_setopt(handle, CURLOPT_HEADER,0);	
	//curl_easy_setopt(handle, CURLOPT_FOLLOWLOCATION,1);
	
	CURLcode res = curl_easy_perform(handle);
	curl_slist_free_all(slist);

	Octets rlt;
	Base64Decoder::Convert(rlt, Octets((char*)result.c_str(), result.size()));	
	printf("base64 result = %.*s\n",(int)rlt.size(),(char*)rlt.begin());

	if (res == CURLE_OK)
	{
		printf("result = %s \n", result.c_str());
	}
	
	curl_easy_cleanup(handle);
	
	//解析字符串
	std::string ret = parsestr((char*)rlt.begin(),rlt.size(),"result");
	return ret;
}

void GetAndSendTextToGamedWeb(std::string sid, SpeechMsg* msg)
{	
	//获取token 支持多线程接口
	time_t now = time(NULL);
	if( g_refreshTokenTime == 0 || now - g_refreshTokenTime > 7200 )
	{
		tokenlock.lock();
		g_refreshTokenTime = 	now;
		g_token = http_get_token();
		tokenlock.unlock();	
	}
	
	//这里还原过程中base64编码的语音,放在前面还原是因为放在后面中间的压缩函数把这个数据改变了
	Octets speech_content;			
	Base64Encoder::Convert(speech_content,Octets((char*)msg->_speech,msg->_speech_size));
	//printf(" web ----- bse64  speech_content = %.*s\n",(int)speech_content.size(),(char*)speech_content.begin());
	
	/*****************************************
		 
		 	解压缩的接口 由周提供
		 
	******************************************/
			
 	Octets base64_content;	
	unsigned char* speech = msg->GetSpeech();
	unsigned int spSize = msg->_speech_size;
		
	std::string result = "";
	unsigned int realLength =0;
	unsigned int decompressnum = AudioCode_CalcDecompressSize(speech,spSize);
	float* pf = (float*)malloc(sizeof(float)*(decompressnum));
	if(pf == NULL)
	{
		printf("*************** malloc defeat *************\n");
		return;
	}

	if ( AudioCode_Decompress(speech,spSize,pf,decompressnum) )
	{
		unsigned char* puc = (unsigned char *)malloc(sizeof(float)*decompressnum / 2);
		if(puc == NULL)
		{
			printf("*************** malloc defeat *************\n");
			return;
		}

		for (unsigned int i = 0; i < decompressnum; ++i)
		{
			short tmp = (short)(*(pf + i) * 32767);
			memcpy(puc + i*2, &tmp, sizeof(short));
		}											
		realLength = sizeof(float)*decompressnum / 2;
			
		//把 puc 转化成 base64编码		
		Base64Encoder::Convert(base64_content,Octets((char*)puc,realLength));	
		
		free(puc);
		puc = NULL;
	}	
	
	free(pf); //释放内存 线程是否安全	
	pf = NULL;
	
	//get text from kedaxunfei web, 科大讯飞服务器需要的字符串是base64编码
	result = http_post_get_text(std::string((char*)base64_content.begin(),base64_content.size()));
							
	if(result == "")
	{
		result = "Cannot Recognized...";
	}

	//发送结果给服务器
	GetIATextInSpeechRe res;
	res.src_id = msg->_srcid;
	res.dest_id =Octets(msg->_destid,strlen(msg->_destid));
	res.zone_id = msg->_zoneid;
	res.time = msg->_time;
	res.chat_type = msg->_chatype;	
	res.speech_content = speech_content;	
	res.text_content = Octets(result.c_str(),result.size());
	STTServer::GetInstance()->DispatchProtocol(res.zone_id,&res);	
}

/*
void testSplit()
{
	Octets oct; 
	std::string wwoct = "{\"expires\":7200,\"ret\":0,\"token\":\"d5e463622e2e4d5af880f0d798141cea\",\"sid\":\"wbs1d4ca8ff@ch01110b1257503d7f01\"}";
	oct =Octets(wwoct.c_str(),wwoct.size());
	std::string result = parsestr((char*)oct.begin(),"token");
	printf("test result = %s\n",result.c_str());
	
	wwoct =  "{\"ret\":-1,\"result\":\"wwwwwwwww \",\"sid\":\"wbs1d4c28ff@ch01200b1257503d7f01\"}";
	oct =Octets(wwoct.c_str(),wwoct.size());

	 result = parsestr((char*)oct.begin(),"result");
	printf("test result = %s\n",result.c_str());


}
*/

/************************ 测试代码  ****************************/
	/*
	const char*		session_id					=	"";
	char			rec_result[BUFFER_SIZE]		=	{NULL};	
	char			hints[HINTS_SIZE]			=	{NULL}; 
	unsigned int	total_len					=	0; 
	int				aud_stat					=	MSP_AUDIO_SAMPLE_CONTINUE ;
	int				ep_stat						=	MSP_EP_LOOKING_FOR_SPEECH;	
	int				rec_stat					=	MSP_REC_STATUS_SUCCESS ;
	int				errcode						=	MSP_SUCCESS ;

	FILE*			f_pcm						=	NULL;
	unsigned char*			p_pcm						=	NULL;
	long			pcm_count					=	0;
	unsigned int			pcm_size					=	0;
	long			read_size					=	0;
	
	//if (NULL == audio_file)
	{
	//	return;
	}
		//goto iat_exit;

	f_pcm = fopen("databeforebase64", "rb");
	if (NULL == f_pcm) 
	{
		printf("\nopen databeforebase64 failed! \n");
		//goto iat_exit;
		return;
	}
	
	fseek(f_pcm, 0, SEEK_END);
	pcm_size = ftell(f_pcm); 
	fseek(f_pcm, 0, SEEK_SET);		

	p_pcm = (unsigned char *)malloc(pcm_size);
	if (NULL == p_pcm)
	{
		printf("\nout of memory! \n");
		//goto iat_exit;
	}

	read_size = fread((void *)p_pcm, 1, pcm_size, f_pcm); //璇诲彇闊抽鏂囦欢鍐呭
	if (read_size != pcm_size)
	{
		printf("\nread databeforebase64 error!\n");
		//goto iat_exit;
	}
	*/
	/************************ 测试代码  ****************************/

