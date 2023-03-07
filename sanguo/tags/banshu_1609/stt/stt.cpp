#include "conf.h"
#include "log.h"
#include "thread.h"
#include "gnet_init.h"
#include <iostream>
#include <unistd.h>
#include <thread>
#include "messagemanager.h" 
#include "getiatextinspeechre.hpp"
#include "AMrnb/audioplugin.h"
#include "base64.h"
using namespace GNET;

static int g_sdktype = 0;
std::mutex g_lock;
#include "iflytek_msp.h"
#include "iflytek_web.h"

extern "C" void GetAndSendTextToGamed(std::string sid,SpeechMsg* msg )
{	
	if(msg == NULL)
		return;

	switch(g_sdktype)
	{
		case 1:
			GetAndSendTextToGamedMSP(sid,msg);	
			break;
	    case 2:
			GetAndSendTextToGamedWeb(sid,msg);	
			break;
		case 3:
			
			break;
		
		default:
			break;
	}
}

// method1
/*
static void* consumer(void *arg)
{
	printf("TIMER THREAD: %u\n", (unsigned int)pthread_self());	
	GMessageManager::GetInstance()->LoopGetSpeechText();	
	return 0;		
}
*/

// method2
static void* consumer2(void *arg)
{
	printf("TIMER THREAD: %u\n", (unsigned int)pthread_self());
	GMessageManager::GetInstance()->LoopGetSpeechText2();	
	return 0;		
}
static void* consumerfuzhu(void *arg)
{
	printf("TIMER THREAD: %u\n", (unsigned int)pthread_self());	
	unsigned int id = pthread_self();
	GMessageManager::GetInstance()->LoopGetSpeechTextFuzhu(id);	
	
	GetIATextInSpeechRe TextInSpeechRe;

	return 0;		
}

/*
void producer(void *arg)
{
	for(int i = 0 ; i < 100 ; i++)
	{
		SpeechMsg* pMsg = ObjectManager::GetInstance()->allocMsg();
		//memcpy Ö±½ÓÄÚ´æ¿½±´
		memcpy(pMsg->_speech,"wwwwwwwwwwwwwwwww",125);
		pMsg->_speech_size = 125;

		GMessageManager::GetInstance()->Push_back2(pMsg);	
	}
}
*/

int main(int argc, char *argv[])
{
	const char* login_params			=	"appid = 57847211, work_dir = ."; 
	
	if (argc != 2 || access(argv[1], R_OK) == -1)
	{
		std::cerr << "Usage: " << argv[0] << " configurefile" << std::endl;
		exit(-1);
	}
	
	//³õÊ¼»¯libcurl
	CURLcode result1 = curl_global_init(CURL_GLOBAL_DEFAULT);
    if(result1) 
	{
      fprintf(stderr, "Error: curl_global_init failed\n");
     return NULL;
    }

	//method1
	//int i= 0;
	//GNET::Thread::Pool::_pool.CreateThread(consumer, NULL);
	//std::thread(producer,&i).detach(); 
	int ret = MSPLogin(NULL, NULL, login_params); 
	if (MSP_SUCCESS != ret)
	{	
		printf("MSPLogin failed , Error code %d.\n",ret);
		return 0; 
	}
		
	//method2
	//int i =0;
	GNET::Thread::Pool::_pool.CreateThread(consumer2, NULL);
	
	//¶¯Ì¬ÊµÏÖÏß³ÌµÄÔö¼ÓÓë¼õÉÙ
	//std::thread(consumer2,&i).detach();
	for(int i = 0; i < 3; i++)
	{
		//void* arg = NULL;
		//GNET::Thread::Pool::_pool.CreateThread(consumerfuzhu, NULL);
		std::thread(consumerfuzhu,&i).detach();
		//usleep(50*1000);
	}
	//std::thread(producer,&i).detach(); 
	
	GNET::InitStaticObjects();
	GNET::IOMan::_man.SetDelayThreshold(50, 500);
	GNET::PollIO::Init(true);
	GNET::Thread::Pool::_pool.Init( new ThreadPolicySingle());
	GNET::IntervalTimer::StartTimer(50000, true);
	Conf *conf = Conf::GetInstance(argv[1]);
	Log::setprogname("stt");
	{
		STTServer *manager = STTServer::GetInstance();
		manager->SetAccumulate(atoi(conf->find(manager->Identification(), "accumulate").c_str()));
		Protocol::Server(manager);
		g_sdktype = atoi(conf->find(manager->Identification(), "sdk_type").c_str());
	}
		
	printf("g_sdktype = %d\n",g_sdktype);

	while(1)
	{
		//ObjectManager::GetInstance()->Staticdata();
		//sleep(5);
		GNET::PollIO::Poll(5);
		//GNET::Timer::Update();
		//GNET::IntervalTimer::UpdateTimer();
		GNET::Thread::Pool::_pool.TryProcessAllTask();
	}
	
	MSPLogout();
	curl_global_cleanup();
	return 0;
}
/*
void run_iat(const char* audio_file, const char* session_begin_params)
{
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
	
	if (NULL == audio_file)
	{
	return;
	}
		//goto iat_exit;

	f_pcm = fopen(audio_file, "rb");
	if (NULL == f_pcm) 
	{
		printf("\nopen [%s] failed! \n", audio_file);
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

	read_size = fread((void *)p_pcm, 1, pcm_size, f_pcm); //è¯»å–éŸ³é¢‘æ–‡ä»¶å†…å®¹
	if (read_size != pcm_size)
	{
		printf("\nread [%s] error!\n", audio_file);
		//goto iat_exit;
	}
	
	//Êı¾İÑ¹Ëõ ·´Ñ¹Ëõ
	float *dataIn =new float[pcm_size/sizeof(float)];
	if (dataIn == NULL)
	{
	 	printf("array float fail\n");
		return;
	}
	
	//--------------  char  -> float  -----------------
	int i =0; 
	int k = 0;
	unsigned char* ppcm = p_pcm;
	while(i<pcm_size)
	{
		float aa;
		memcpy(&aa,ppcm,sizeof(float));
		ppcm = ppcm + 4;
		i =i +4;
		dataIn[k] = aa;	
		k++;
	}
	//----------------------------------------------
		
	
	unsigned char* www = new unsigned char[pcm_size];
	
	//------------------float -- > char---------------
	i=0;
	k =0;
	union {
		float a;
		unsigned char x[4];
		
	}w;

	while(k<pcm_size/4)
	{
		float aa = dataIn[k];
		w.a = aa;
		www[i++] = w.x[0];
		www[i++] = w.x[1];
		www[i++] = w.x[2];
		www[i++] = w.x[3];
		k++;
	}
	//-------------------------------------------------
	
	//Êı¾İÑ¹Ëõ
	
	unsigned int inDataSize = AudioCode_CalcCompressSize(dataIn,pcm_size/4,amrnb_enc::MR67);
	unsigned char* pBufferOut = new unsigned char[pcm_size];
	unsigned int outSize = inDataSize;
	AudioCode_Compress(dataIn, inDataSize, pBufferOut, outSize, amrnb_enc::MR67);	
	printf("Compress pcm_size = %u ----> outSize = %u\n",pcm_size,outSize );

	//½âÑ¹Êı¾İ
	
	unsigned int outlen = AudioCode_CalcDecompressSize(pBufferOut,outSize);
	
	float* data = new float[pcm_size/4];
	//unsigned char* pBufferout = new unsigned char[pcm_szie];
	printf("pre dattasize = %u\n",outlen);
	unsigned int datasize = outlen;
	AudioCode_Decompress( pBufferOut,outSize,data,datasize);
	
		std::string result = "";
		unsigned int realLength =0;
		unsigned int decompressnum = AudioCode_CalcDecompressSize(pBufferOut,outSize);
		float* pf = (float*)malloc(sizeof(float)*(decompressnum));
		if ( AudioCode_Decompress(pBufferOut,outSize,pf,decompressnum) )
		{

			unsigned char* puc = (unsigned char *)malloc(sizeof(float)*decompressnum / 2);
			for (int i = 0; i < decompressnum; ++i)
			{
				short tmp = (short)(*(pf + i) * 32767);
				memcpy(puc + i*2, &tmp, sizeof(short));
			}											
			realLength = sizeof(float)*decompressnum / 2;
			
			result = iat_GetText(session_id, puc,realLength,session_begin_params);	

		}
	
	return;
	printf("DeCompress outSize = %u ----> dataSize = %u\n",outSize,datasize );
	//float ->char	
	char* out = new char[datasize];
	memcpy(out,data,datasize);


	if (MSP_SUCCESS != errcode)
	{
		printf("\nQISRSessionBegin failed! error code:%d\n", errcode);
		//goto iat_exit;
	}
		
	//iat_GetText(session_id, p_pcm, pcm_size, session_begin_params);
	
	printf("-------------------------------compress decompress----------\n");
	iat_GetText(session_id, out, datasize, session_begin_params); 

//iat_exit:
	if (NULL != f_pcm)
	{
		fclose(f_pcm);
		f_pcm = NULL;
	}
	if (NULL != p_pcm)
	{	free(p_pcm);
		p_pcm = NULL;
	}
	if(dataIn != NULL)
	{
		delete dataIn;
		dataIn = NULL;
	}

}

int test(int argc, char* argv[])
{
	int			ret						=	MSP_SUCCESS;
	int			upload_on				=	1; //æ˜¯å¦ä¸Šä¼ ç”¨æˆ·è¯è¡¨
	const char* login_params			=	"appid = 57847211, work_dir = ."; // ç™»å½•å‚æ•°ï¼Œappidä¸mscåº“ç»‘å®š,è¯·å‹¿éšæ„æ”¹åŠ¨

	ret = MSPLogin(NULL, NULL, login_params); //ç¬¬ä¸€ä¸ªå‚æ•°æ˜¯ç”¨æˆ·åï¼Œç¬¬äºŒä¸ªå‚æ•°æ˜¯å¯†ç ï¼Œå‡ä¼ NULLå³å¯ï¼Œç¬¬ä¸‰ä¸ªå‚æ•°æ˜¯ç™»å½•å‚æ•°	
	if (MSP_SUCCESS != ret)
	{
		printf("MSPLogin failed , Error code %d.\n",ret);
		goto exit; //ç™»å½•å¤±è´¥ï¼Œé€€å‡ºç™»å½•
	}

	run_iat("test2", session_begin_params);
	printf("------------------------------Ñ¹ËõÊı¾İ²âÊÔ\n");
	run_iat("databeforebase64", session_begin_params);
	printf("------------------------------±ê×¼¾İ²âÊÔ\n");
	run_iat("iflytek02.wav", session_begin_params);
	
exit:
	printf("æŒ‰ä»»æ„é”®é€€å‡º ...\);
	getchar();
	MSPLogout(); //é€€å‡ºç™»å½•

	return 0;
}*/

/*int main()
{
	//g_token = http_get_token();
	//testSplit();
	CURLcode result1 = curl_global_init(CURL_GLOBAL_DEFAULT);
    if(result1) {
      fprintf(stderr, "Error: curl_global_init failed\n");
     return NULL;
    }
	printf("-----------------------\n");

	SpeechMsg* pmsg = new SpeechMsg();
	GetSpeechTextwithWeb(1,pmsg);
	while(1)
	{
		sleep(1);
		//printf("slslls\n");
	}
	return 0;
}*/
