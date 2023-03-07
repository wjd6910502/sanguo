#ifndef __GNET_GMCLIENT_HPP
#define __GNET_GMCLIENT_HPP

#include "protocol.h"
#include "thread.h"

namespace GNET
{

class GMClient : public Protocol::Manager
{
	static GMClient instance;
	size_t		accumulate_limit;
	Session::ID	sid;
	bool		conn_state;
	Thread::Mutex	locker_state;
	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
	void OnAbortSession(const SockAddr &sa);
	void OnCheckAddress(SockAddr &) const;
public:
	short cmd;
	std::string arg[6];
	std::string game_sys_file;
	static GMClient *GetInstance() { return &instance; }
	std::string Identification() const { return "GMClient"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	GMClient() : accumulate_limit(0), conn_state(false), locker_state("GMClient::locker_state") { }

	bool SendProtocol(const Protocol &protocol) { return conn_state && Send(sid, protocol); }
	bool SendProtocol(const Protocol *protocol) { return conn_state && Send(sid, protocol); }
};

};
#endif
