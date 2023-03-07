#ifndef  _GMESSAGEMANAGER_HPP_
#define  _GMESSAGEMANAGER_HPP_

#include <vector>
#include <iostream>
#include <algorithm>
#include "thread.h"
#include "mutex.h"
#include <thread>
#include "objectmanager.h"
//#include "iat.h"
#include "sttserver.hpp"
class GMessageManager
{
public:
	GMessageManager();
	~GMessageManager();

private:
	static GMessageManager instance;
	
	abase::vector<SpeechMsg*> m_vecMsgs; //插入的消息队列
	abase::vector<SpeechMsg*> m_vecMiddleMegs; //过度队列
	//方案二数据
	std::vector<SpeechMsg*>	m_vecMsgs_s;
	std::map<unsigned int,std::vector<SpeechMsg*>> m_mapMsgs;

	static GNET::Thread::Mutex _thread_lock;
	static std::mutex m_lock;

public:
	static GMessageManager *GetInstance() {return &instance;}
		
	void Push_back(SpeechMsg* msg)
	{
		GNET::Thread::Mutex::Scoped keeper2(_thread_lock);	
		m_vecMsgs.push_back(msg);
	}
	
	void Push_back2(SpeechMsg* msg)
	{
		GNET::Thread::Mutex::Scoped keeper2(_thread_lock);	
		m_vecMsgs_s.push_back(msg);
	}


	void LoopGetSpeechText();
	void LoopGetSpeechText2();
	void LoopGetSpeechTextFuzhu(unsigned int thread_id);
};

#endif
