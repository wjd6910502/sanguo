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
		//memcpy 直接内存拷贝
		memcpy(pMsg->_speech,"wwwwwwwwwwwwwwwww",125);
		pMsg->_speech_size = 125;

		GMessageManager::GetInstance()->Push_back2(pMsg);	
	}
}
*/

int main1(int argc, char *argv[])
{
	const char* login_params			=	"appid = 57847211, work_dir = ."; 
	
	if (argc != 2 || access(argv[1], R_OK) == -1)
	{
		std::cerr << "Usage: " << argv[0] << " configurefile" << std::endl;
		exit(-1);
	}
	
	//初始化libcurl
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
	
	//动态实现线程的增加与减少
	//std::thread(consumer2,&i).detach();
	for(int i = 0; i < 3; i++)
	{
		//void* arg = NULL;
		GNET::Thread::Pool::_pool.CreateThread(consumerfuzhu, NULL);
		//std::thread(consumerfuzhu,&i).detach();
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
		if(g_sdktype == 0) 
		{ 	
			printf("!!!!!!!!!!!!!!!gamesys.conf lack sdk_type\n");
		  	exit(0);
		}
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


/*********************************************
 *
 *	content：语音服务器多线程修改 提高并发处理
 *	date：   2017-03-09
 *  author： wjd
 *
 * ******************************************/


#include "messagemanagernew.h"

/*
void producer(void *arg)
{
	for(int i = 0 ; i < 100 ; i++)
	{
		SpeechMsg* pMsg = ObjectManager::GetInstance()->allocMsg();
		//memcpy 直接内存拷贝
		memcpy(pMsg->_speech,"wwwwwwwwwwwwwwwww",125);
		pMsg->_speech_size = 125;

		MessageManagerNew::GetInstance()->Push_back(pMsg);	
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
	
	//初始化libcurl
	CURLcode result1 = curl_global_init(CURL_GLOBAL_DEFAULT);
    if(result1) 
	{
      fprintf(stderr, "Error: curl_global_init failed\n");
     return NULL;
    }

	int ret = MSPLogin(NULL, NULL, login_params); 
	if (MSP_SUCCESS != ret)
	{	
		printf("MSPLogin failed , Error code %d.\n",ret);
		return 0; 
	}
		
	for(int i = 0; i < 5; i++)
	{
		std::thread(MessageManagerNew::HandleMessage,&i).detach();
	//	usleep(50*1000);
	}
	
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
		if(g_sdktype == 0) 
		{ 	
			printf("!!!!!!!!!!!!!!!gamesys.conf lack sdk_type\n");
		  	exit(0);
		}
	}
		
	printf("g_sdktype = %d\n",g_sdktype);

	//int i = 1;
	//std::thread(producer,&i).detach(); 
	

	while(1)
	{
		GNET::PollIO::Poll(5);
		GNET::Thread::Pool::_pool.TryProcessAllTask();
	}
	
	MSPLogout();
	curl_global_cleanup();
	return 0;
	
	
	
}
