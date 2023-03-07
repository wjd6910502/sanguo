#ifndef __GNET_VERIFICATIONGAMESERVER_HPP
#define __GNET_VERIFICATIONGAMESERVER_HPP

#include "protocol.h"
#include "thread.h"
#include "glog.h"

namespace GNET
{

class VerificationGameServer : public Protocol::Manager
{
	static VerificationGameServer instance;
	size_t		accumulate_limit;
	std::map<int, Session::ID> sid_info;
	bool		conn_state;
	Thread::Mutex2	locker_state;
	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
	//void OnAbortSession(const SockAddr &sa);
	//void OnCheckAddress(SockAddr &) const;
	//void Reconnect();
public:
	static VerificationGameServer *GetInstance() { return &instance; }
	std::string Identification() const { return "VerificationGameServer"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	VerificationGameServer() : accumulate_limit(0), locker_state("VerificationGameServer::locker_state") { }
	
	bool SendProtocol(const Protocol &protocol, int battle_ver)
	{
		return SendProtocol(&protocol, battle_ver);
	}
	bool SendProtocol(const Protocol *protocol, int battle_ver)
	{
		Session::ID     sid;
		if(sid_info.find(battle_ver) != sid_info.end())
		{
			sid = sid_info.find(battle_ver)->second;
			return conn_state && Send(sid, protocol); 
		}
		else
		{
			return false;
		}
	}
	void SetSid(Session::ID sid, int battle_ver)
	{
		sid_info[battle_ver] = sid;
	}
};

};
#endif
