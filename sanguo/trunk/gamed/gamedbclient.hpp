#ifndef __GNET_GAMEDBCLIENT_HPP
#define __GNET_GAMEDBCLIENT_HPP

#include "protocol.h"
#include "thread.h"
#include "glog.h"

namespace GNET
{
class GameDBClient : public Protocol::Manager
{
	static GameDBClient instance;
	size_t		accumulate_limit;
	Session::ID	sid;
	bool		conn_state;
	Thread::Mutex2	locker_state;
	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
	void OnAbortSession(const SockAddr &sa);
	void OnCheckAddress(SockAddr &) const;
	void Reconnect();
public:
	static GameDBClient *GetInstance() { return &instance; }
	std::string Identification() const { return "GameDBClient"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	GameDBClient() : accumulate_limit(0), conn_state(false), locker_state("GameDBClient::locker_state") { }

	bool SendProtocol(const Protocol &protocol) { return conn_state && Send(sid, protocol); }
	bool SendProtocol(const Protocol *protocol) { return conn_state && Send(sid, protocol); }
};

};
#endif
