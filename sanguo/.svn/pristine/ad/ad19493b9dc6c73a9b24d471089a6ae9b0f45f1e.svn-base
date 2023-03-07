#include "laohuproxyserver.hpp"
#include "conf.h"
#include "log.h"
#include "thread.h"
#include <iostream>
#include <unistd.h>
#include <unistd.h>
#include "pollio.h"
#include "threadpolicy.h"
#include "gnet_init.h"
#include "curldef.h"

using namespace GNET;

CURLM* g_cm = NULL;
std::string url ="103.53.171.11:8072/vietnam/web/AddCash";
std::map<std::string, CURL_OBJ* > g_mapobj;
Thread::Mutex g_locker_state("laohuproxycheck");

void CurlM_Init()
{
	curl_global_init(CURL_GLOBAL_ALL);
	g_cm = curl_multi_init();
	curl_multi_setopt(g_cm, CURLMOPT_MAXCONNECTS, (long)MAX);
}


void CurlM_Cleanup()
{
	if(g_cm != NULL )
	{
		curl_multi_cleanup(g_cm);
		curl_global_cleanup();	
		g_cm = NULL;
	}
}

int CurlM_Process()
{
	CURLMsg *msg;
    long L;
    int M, Q, U = -1;
    fd_set R, W, E;
    struct timeval T;

    while(U && g_mapobj.size() != 0 )
	{
		 //这个只支持很短的返回结果 如果很长需要循环
		curl_multi_perform(g_cm, &U);

		std::cout<<"111111111111111111111111U = "<<U<<std::endl;
		//sleep(1);
     	if(U)
	 	{	 	    
			FD_ZERO(&R);
			FD_ZERO(&W);
	 	   	FD_ZERO(&E);
	 	   	if(curl_multi_fdset(g_cm, &R, &W, &E, &M)) 
	 	   	{
	 	       fprintf(stderr, "E: curl_multi_fdset\n");
	 	       break;
	 	   	}

     	   	if(curl_multi_timeout(g_cm, &L))
	 	   	{
	 	       fprintf(stderr, "E: curl_multi_timeout\n");
     	       break;
     	   	}
     	   
	 	   	if(L == -1)
	 	   	   L = 100;
	 	   	if(M == -1) 
	 	   	{
     	     	sleep((unsigned int)L / 1000);
     	   	}
     	   	else 
	 	   	{
     	     	T.tv_sec = L/1000;
     	     	T.tv_usec = (L%1000)*1000;

     	     	if(0 > select(M+1, &R, &W, &E, &T))
	 	     	{
     	       		fprintf(stderr, "E: select(%i,,,,%li): %i: %s\n", M+1, L, errno, strerror(errno));
     	       		break;
     	     	}
     	   	}   
     	 }
		 
     	 while((msg = curl_multi_info_read(g_cm, &Q))) 
	 	 {
			if(msg->msg == CURLMSG_DONE) 
	 	   	{
				//TODO:?????? 我什么用这个 其他都不好使
				char tmp[256];
				memset(tmp,'\0',256);
				char *account=tmp;
     	     	CURL *e = msg->easy_handle;
     	     	curl_easy_getinfo(msg->easy_handle, CURLINFO_PRIVATE, &account);
				
			 	//互斥变量
				GNET::Thread::Mutex::Scoped scoped_lock(g_locker_state); 
				auto it = g_mapobj.find(std::string(account));
			 	if ( it != g_mapobj.end() )
			 	{
					CURL_OBJ* pobj = it->second;
				 	LaohuProxyServer::GetInstance()->SendContent( pobj->content, pobj->account );
					
					curl_multi_remove_handle(g_cm, e);
					
					fprintf(stderr, "R: %d - %s <account = %s>\n",msg->data.result, curl_easy_strerror(msg->data.result), account);
					g_mapobj.erase(it++);
					delete pobj;
					pobj = NULL;
					
				 	//保证析构
			 	}
			 	else
			 	{
					std::cout<<"not find account "<<account<<std::endl;	 
			 	}
     	     	scoped_lock.Unlock();

		    }
			else 
	 	   	{
     	     	fprintf(stderr, "E: CURLMsg (%d)\n", msg->msg);
     	    }
     	 }
    }

	return 0;
}

void test()
{ 	
	std::string account;
	for(int i = 0; i< 10; i++)
	{
		char str[10];
		sprintf(str,"%d",i);
		account.append(str);
		CURL_OBJ* obj = new CURL_OBJ(account);
		
		g_mapobj.insert(std::make_pair(obj->account,obj));	
	}
}

int main(int argc, char *argv[])
{
	if (argc != 2 || access(argv[1], R_OK) == -1)
	{
		std::cerr << "Usage: " << argv[0] << " configurefile" << std::endl;
		exit(-1);
	}
	
	GNET::InitStaticObjects();
	GNET::IOMan::_man.SetDelayThreshold(50, 500);
	GNET::PollIO::Init(true);
	GNET::Thread::Pool::_pool.Init( new ThreadPolicySingle());
	GNET::IntervalTimer::StartTimer(50000, true);
	Conf *conf = Conf::GetInstance(argv[1]);
	
	Log::setprogname("laohuproxyd");
	{
		LaohuProxyServer *manager = LaohuProxyServer::GetInstance();
		manager->SetAccumulate(atoi(conf->find(manager->Identification(), "accumulate").c_str()));
		Protocol::Server(manager);
	}
	
	
	//全局curlm初始化	
	CurlM_Init();
	
	//test();
	
	while(1)
	{
		GNET::PollIO::Poll(100);
		GNET::Thread::Pool::_pool.TryProcessAllTask();
		
		//一个http处理循环
		CurlM_Process();		
	}	
	//全局curlm释放
	CurlM_Cleanup();
	
	return 0;
}

