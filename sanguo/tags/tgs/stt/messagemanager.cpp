#include "messagemanager.h"
#include <thread>

extern std::mutex g_lock;

extern "C" 
{
	#include "qisr.h"
	#include "msp_cmn.h"
	#include "msp_errors.h"
}
extern "C" void GetAndSendTextToGamed(std::string sid,SpeechMsg* msg ); 
GNET::Thread::Mutex GMessageManager::_thread_lock;
GMessageManager GMessageManager::instance;
std::mutex GMessageManager::m_lock;

GMessageManager::GMessageManager()
{
	
}

GMessageManager::~GMessageManager()
{
	//在释放一下多有函数	
}

void GMessageManager::LoopGetSpeechText()
{
	while(1)
	{
		//不用一直循环 休息一下 把cpu让给其他线程做
		sleep(1);
		
		if(m_vecMiddleMegs.size() == 0 && m_vecMsgs.size() > 0)
		{
			//GNET::Thread::Mutex::Scoped keeper1(_thread_lock);	
			m_vecMiddleMegs.swap(m_vecMsgs);	
			m_vecMsgs.clear();
			abase::vector<SpeechMsg*> tmp1;
			m_vecMsgs.swap(tmp1);
			tmp1.clear();
	

			//printf("m_vecMsgs 的容量为 %d\n",(int)m_vecMsgs.capacity()); 	
				
			//改造成while(true)
			{

				for(unsigned int i = 0; i < m_vecMiddleMegs.size(); i++) 
				{
					//SpeechMsg* pmsg = m_vecMiddleMegs[i];
					//保证最多开辟200多个线程
					//这里面创建一个线程 杜宇每一个请求 做单独的线程 后续任务都交给这个单独的线程单独处理 111111111111111111111111
					//if(pmsg == NULL)
					//	break;
					/*
					struct argument arg;
					arg.num = pmsg->GetType();
					char* st = pmsg->GetStr();
					printf("11111111111111");
					memcpy(arg.str,st,strlen(st));
					//printf("...................... arg.num = %d",arg.num);
					//usleep(1000);
					//GNET::Thread::Pool::_pool.CreateThread(iat_Write, &arg);
					ObjectManager::GetInstance()->setState(pmsg,POOL_OBJECT_STATUS_FREE);	
					std::thread(iat_Write,&arg).detach();
					
					m_lock.lock();
					g_count++;
					m_lock.unlock();
					int count = g_count;
					printf("-------gcount = %d \n",count);
					//delete pmsg;
					//pmsg = NULL;
					*/
					
				}
			}
						
			m_vecMiddleMegs.clear();
			abase::vector<SpeechMsg*> tmp;
			m_vecMiddleMegs.swap(tmp);
			tmp.clear();
			//printf("m_vecMiddleMsgs1 的容量为 %d\n",(int)m_vecMiddleMegs.capacity());	
		}
	
	}
}	

//方案2
void GMessageManager::LoopGetSpeechText2()
{
	while(1)
	{	
		if(m_vecMsgs_s.size() <= 0)
		{
			sleep(5);
			printf("sleep..............\n");
			continue;
		}
		sleep(1);
		unsigned int count = 0;
		GNET::Thread::Mutex::Scoped keeper1(_thread_lock);

		for(auto it = m_mapMsgs.begin(); it != m_mapMsgs.end(); it++)
		{ 
			m_lock.lock();
			count = count + it->second.size();	
			m_lock.unlock();
		}
			
		if(count > 0)
		{	
			sleep(3);
			printf("处理压入队列数据中...........................................\n");
			continue;	
		}
			
		//printf("开始处理压入队列数据 count =%d \n",count);
		printf("msg size = %u\n",(unsigned int)m_vecMsgs_s.size());
		
		auto ibeg = m_mapMsgs.begin();	
		for(unsigned int i = 0; i < m_vecMsgs_s.size(); i++)
		{
			SpeechMsg* pmsg = m_vecMsgs_s[i];
			//printf("ibeg->first=%u,ibeg->second=%d\n",(unsigned int)ibeg->first,ibeg->second.size());
			if(pmsg == NULL)
			{
				printf("pmsg cuowu \n");
				continue;
			}
			m_lock.lock();
			ibeg->second.push_back(pmsg);
			m_lock.unlock();
			//printf(".................%d , thread = %u map size = %d\n",i,(unsigned int)ibeg->first,ibeg->second.size());
			ibeg++;
			if(ibeg == m_mapMsgs.end())
				ibeg = m_mapMsgs.begin();	
		}
	
		m_vecMsgs_s.clear();
		std::vector<SpeechMsg*> tmp1;
		m_vecMsgs_s.swap(tmp1);
		tmp1.clear();
					
	}	
}	

void GMessageManager::LoopGetSpeechTextFuzhu(unsigned int thread_id)
{	
	//printf("LoopGetSpeechText() INSERT TIMER THREAD: %u \n",()pthread_self());
	m_lock.lock();
	std::vector<SpeechMsg*> tmpvec;
	tmpvec.reserve(100);
	m_mapMsgs.insert(make_pair(thread_id,tmpvec));
	m_lock.unlock(); 
	std::string sid = "";
	while(true)
	{
		//GNET::Thread::Mutex::Scoped keeper(_thread_lock);
		auto ifind = m_mapMsgs.find((unsigned int)pthread_self());
		if( ifind == m_mapMsgs.end() )
		{
			//printf(" thread %u can not find\n",(unsigned int)pthread_self()); 
			m_lock.lock();
			std::vector<SpeechMsg*> tmpvec;
			tmpvec.reserve(100);
			m_mapMsgs.insert(make_pair((unsigned int)pthread_self(),tmpvec));
			m_lock.unlock();
		}
		
		//printf(" thread %u can not find\n",(unsigned int)pthread_self());
		if(ifind->second.size() == 0 )
		{	
			//printf("fuzhu TIMER THREAD  %u sleep\n",pthread_self());
			usleep(150*1000);
			continue;
		}

		std::vector<SpeechMsg*> vec;
		m_lock.lock();
		vec.swap(ifind->second);
		m_lock.unlock();
		auto ibeg = vec.begin();
		for(; ibeg != vec.end(); ibeg++)
		{
			SpeechMsg* pmsg = *ibeg;
			
			GetAndSendTextToGamed(sid,pmsg);
			printf(" TIMER THREAD: %u 处理来自 srcid = %ld \n",(unsigned int)pthread_self(),pmsg->_srcid);	
			
			/*
			g_lock.lock();
			delete pmsg;
			pmsg = NULL;
			g_lock.unlock();
			*/
			ObjectManager::GetInstance()->setState(pmsg,POOL_OBJECT_STATUS_FREE);
		}
			
		ifind->second.clear();
		vec.clear();		
		ifind->second.swap(std::vector<SpeechMsg*>());
		vec.swap(std::vector<SpeechMsg*>());	
	}

}

