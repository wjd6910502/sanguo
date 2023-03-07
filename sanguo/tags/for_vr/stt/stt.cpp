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


std::mutex g_lock;
extern "C" 
{
	#include "qisr.h"
	#include "msp_cmn.h"
	#include "msp_errors.h"
	#define	BUFFER_SIZE	4096
	//#define FRAME_LEN	640 
	#define HINTS_SIZE  100

    std::string iat_GetText( std::string sessionid, unsigned char* p_pcm,unsigned int pcm_size,const char* session_begin_params)
	{
		const char*		session_id					=	NULL;
		char			rec_result[BUFFER_SIZE]		=	{NULL};	
		char			hints[HINTS_SIZE]			=	{NULL}; //hintsΪ�������λػ���ԭ�����������û��Զ���
		unsigned int	total_len					=	0; 
		int				aud_stat					=	MSP_AUDIO_SAMPLE_CONTINUE ;		//��Ƶ״̬
		int				ep_stat						=	MSP_EP_LOOKING_FOR_SPEECH;		//�˵���
		int				rec_stat					=	MSP_REC_STATUS_SUCCESS ;		//ʶ��״̬
		int				errcode						=	MSP_SUCCESS ;
		
		printf("\n��ʼ������д ...\n");
			
		session_id = QISRSessionBegin(NULL, session_begin_params, &errcode);
		
		if (MSP_SUCCESS != errcode)
		{
			printf("\nQISRSessionBegin failed! error code:%d\n", errcode);
			QISRSessionEnd(session_id, hints);
			return "";
		}
		
		long len = pcm_size;
		if (len <= 0)
		{
			printf("\nQISRSessionBegin input len Wrong\n");
			QISRSessionEnd(session_id, hints);
			return "";
		}
		aud_stat = MSP_AUDIO_SAMPLE_FIRST;

		printf(">");
		printf("----------------- timethread = %u sessindi = %s ppcm = %s\n",(unsigned int)pthread_self() ,session_id, p_pcm);
		int ret = QISRAudioWrite(session_id, (const void *)p_pcm, len, aud_stat, &ep_stat, &rec_stat);
		if (MSP_SUCCESS != ret)
		{
			printf("\nQISRAudioWrite failed! error code:%d\n", ret);
			QISRSessionEnd(session_id, hints);
			return "";
		}
			
		errcode = QISRAudioWrite(session_id, NULL, 0, MSP_AUDIO_SAMPLE_LAST, &ep_stat, &rec_stat);
		if (MSP_SUCCESS != errcode)
		{
			printf("\nQISRAudioWrite failed! error code:%d \n", errcode);
			QISRSessionEnd(session_id, hints);
			return "";
		}
		
		while (MSP_REC_STATUS_COMPLETE != rec_stat) 
		{	
			printf("\nQISRGetResult \n");
			const char *rslt = QISRGetResult(session_id, &rec_stat, 0, &errcode);
			if (MSP_SUCCESS != errcode)
			{
				printf("\nQISRGetResult failed, error code: %d\n", errcode);
				QISRSessionEnd(session_id, hints);
				return "";
			}
			if (NULL != rslt)
			{
				unsigned int rslt_len = strlen(rslt);
				total_len += rslt_len;
				if (total_len >= BUFFER_SIZE)
				{
					printf("\nno enough buffer for rec_result !\n");
					QISRSessionEnd(session_id, hints);
					return "";
				}
				strncat(rec_result, rslt, rslt_len);
			}
			usleep(150*1000); //��ֹƵ��ռ��cpu
			
		}
			
		//������Ϣ���ͻ���
		printf("\n������д����\n");
		printf("iat_gettext\n");
		printf("=============================================================\n");
		printf("%s\n",rec_result);
		printf("=============================================================\n");
		
		QISRSessionEnd(session_id, hints);
	
		return std::string(rec_result);
	}

	void GetAndSendTextToGamed(std::string session_id,SpeechMsg* msg )
	{
		const char* session_begin_params	=	"sub = iat, domain = iat, language = zh_ch, accent = mandarin, sample_rate = 16000, result_type = plain, result_encoding = utf8";
		
		/* *******************************************************************************
		 *
		 *	��ѹ���Ľӿ� �����ṩ
		 *
		 * *******************************************************************************/
		//��ѹ���Ľӿ�	
		unsigned char* speech = msg->GetSpeech();
		float pbufferOut[MAX_SPEECH_SIZE*10];
		memset(pbufferOut,'\0',MAX_SPEECH_SIZE*10);
		unsigned int spSize = msg->_speech_size;
		
		std::string result = "";
		unsigned int realLength =0;
		unsigned int decompressnum = AudioCode_CalcDecompressSize(speech,spSize);
		float* pf = (float*)malloc(sizeof(float)*(decompressnum));
		if ( AudioCode_Decompress(speech,spSize,pf,decompressnum) )
		{
			unsigned char* puc = (unsigned char *)malloc(sizeof(float)*decompressnum / 2);
			for (unsigned int i = 0; i < decompressnum; ++i)
			{
				short tmp = (short)(*(pf + i) * 32767);
				memcpy(puc + i*2, &tmp, sizeof(short));
			}											
			realLength = sizeof(float)*decompressnum / 2;

			result = iat_GetText(session_id, puc,realLength,session_begin_params);	

		}
				
		if(result == "")
		{
			result = "Cannot Recognized";
		}

		//���ͽ����������
		GetIATextInSpeechRe res;
		res.src_id = msg->_srcid;
		res.dest_id =Octets(msg->_destid,strlen(msg->_destid));
		res.zone_id = msg->_zoneid;
		res.time = msg->_time;
		res.chat_type = msg->_chatype;
		//��base64����
		
		Octets speech_content;			
		Base64Encoder::Convert(speech_content,Octets((char*)msg->_speech,msg->_speech_size));


		res.speech_content = speech_content;	
		res.text_content = Octets(result.c_str(),result.size());
		STTServer::GetInstance()->DispatchProtocol(res.zone_id,&res);	
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



int main(int argc, char *argv[])
{
	const char* login_params			=	"appid = 57847211, work_dir = ."; 
	
	if (argc != 2 || access(argv[1], R_OK) == -1)
	{
		std::cerr << "Usage: " << argv[0] << " configurefile" << std::endl;
		exit(-1);
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
	
	//��̬ʵ���̵߳����������
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
	}
	

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

	read_size = fread((void *)p_pcm, 1, pcm_size, f_pcm); //读取音频文件内容
	if (read_size != pcm_size)
	{
		printf("\nread [%s] error!\n", audio_file);
		//goto iat_exit;
	}
	
	//����ѹ�� ��ѹ��
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
	
	//����ѹ��
	
	unsigned int inDataSize = AudioCode_CalcCompressSize(dataIn,pcm_size/4,amrnb_enc::MR67);
	unsigned char* pBufferOut = new unsigned char[pcm_size];
	unsigned int outSize = inDataSize;
	AudioCode_Compress(dataIn, inDataSize, pBufferOut, outSize, amrnb_enc::MR67);	
	printf("Compress pcm_size = %u ----> outSize = %u\n",pcm_size,outSize );

	//��ѹ����
	
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
	int			upload_on				=	1; //是否上传用户词表
	const char* login_params			=	"appid = 57847211, work_dir = ."; // 登录参数，appid与msc库绑定,请勿随意改动

	ret = MSPLogin(NULL, NULL, login_params); //第一个参数是用户名，第二个参数是密码，均传NULL即可，第三个参数是登录参数	
	if (MSP_SUCCESS != ret)
	{
		printf("MSPLogin failed , Error code %d.\n",ret);
		goto exit; //登录失败，退出登录
	}

	run_iat("test2", session_begin_params);
	printf("------------------------------ѹ�����ݲ���\n");
	run_iat("databeforebase64", session_begin_params);
	printf("------------------------------��׼�ݲ���\n");
	run_iat("iflytek02.wav", session_begin_params);
	
exit:
	printf("按任意键退出 ...\);
	getchar();
	MSPLogout(); //退出登录

	return 0;
}*/