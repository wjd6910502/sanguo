#ifndef _MESSAGEMANAGER_NEW_H
#define _MESSAGEMANAGER_NEW_H

#include <thread>
#include <mutex>
#include <condition_variable>
#include <queue>
#include <vector>
#include "objectmanager.h"

extern "C" 
{
	#include "qisr.h"
	#include "msp_cmn.h"
	#include "msp_errors.h"
}
extern "C" void GetAndSendTextToGamed(std::string sid,SpeechMsg* msg ); 
 
class MessageManagerNew
{
public:
	MessageManagerNew() {}
	~MessageManagerNew() {}

private:
	static MessageManagerNew instance;
	static std::vector<SpeechMsg*> m_vecMsgs; //共享数据

	static std::mutex mtx;
	static std::condition_variable cv;

public:

	static MessageManagerNew *GetInstance() {return &instance;}
	
	void Push_back(SpeechMsg* msg)
	{
		std::unique_lock<std::mutex> lck(mtx);		
		m_vecMsgs.push_back(msg);
		cv.notify_one();
	}
	
	static void* HandleMessage(void* arg)
	{	
		std::unique_lock<std::mutex> lck(mtx);
		while(true)
		{
			cv.wait(lck);
			
			/*创建一个新线程*/
			int i = 0;
			std::thread(HandleMessage,&i).detach();
			
			std::vector<SpeechMsg*> m_tmpMsgs;	
			m_vecMsgs.swap(m_tmpMsgs);
			m_vecMsgs.clear(); 
			m_vecMsgs.swap(std::vector<SpeechMsg*>());
		
			auto ibeg = m_tmpMsgs.begin();
			for(; ibeg != m_tmpMsgs.end(); ibeg++)
			{
				SpeechMsg* pmsg = *ibeg;
				std::string sid;
				GetAndSendTextToGamed(sid,pmsg);
				printf(" TIMER THREAD: %u 处理来自 srcid = %ld \n",(unsigned int)pthread_self(),pmsg->_srcid);	
			
				ObjectManager::GetInstance()->setState(pmsg,POOL_OBJECT_STATUS_FREE);	
			}
		
			m_tmpMsgs.clear(); 
			m_tmpMsgs.swap(std::vector<SpeechMsg*>());				
				
			break;
		}
		return 0;
	}
		
};

#endif
