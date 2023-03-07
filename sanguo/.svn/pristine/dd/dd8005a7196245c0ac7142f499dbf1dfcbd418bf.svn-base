#ifndef _MESSAGE_H_
#define _MESSAGE_H_

#include <string>
#include <vector>
#include <list>
#include "thread.h"
#include "mutex.h"
#include "statistic_manager.h"

struct Message
{
	int64_t _target;
	int64_t _src; //TODO:
	std::string _data;
	time_t _delay;
	std::vector<int64_t> _extra_roles;
	std::vector<int64_t> _extra_mafias;
	std::vector<int> _extra_pvps;	//√ª”√¡À

	Message(int64_t target, int64_t src, const std::string& data, time_t delay, const std::vector<int64_t> *extra_roles,
	        const std::vector<int64_t> *extra_mafias, const std::vector<int> *extra_pvps)
	       : _target(target), _src(src), _data(data), _delay(delay)
	{
		if(extra_roles) _extra_roles = *extra_roles;
		if(extra_mafias) _extra_mafias = *extra_mafias;
		if(extra_pvps) _extra_pvps = *extra_pvps;
	}
};

class MessageManager
{
	std::list<Message> _msgs;

	time_t _prev_now;
	std::map<time_t, std::list<Message> > _delay_msgs;

	GNET::Thread::Mutex2 _lock;

	MessageManager(): _prev_now(0), _lock("MessageManager::_lock") {}

public:
	static MessageManager& GetInstance()
	{
		static MessageManager _instance;
		return _instance;
	}

	void OnTimer(int tick, time_t now);

	void Put(int64_t target, int64_t src, const std::string& data, int delay, const std::vector<int64_t> *extra_roles=0,
	         const std::vector<int64_t> *extra_mafias=0, const std::vector<int> *extra_pvps=0);
	void Put(const Message& msg);
};

#endif //_MESSAGE_H_

