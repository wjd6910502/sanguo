#ifndef __GNET_GATESERVER_HPP
#define __GNET_GATESERVER_HPP

#include "protocol.h"
#include "thread.h"
#include "mutex.h"

namespace GNET
{

class GateServer : public Protocol::Manager
{
public:
	struct SessionInfo
	{
		Octets _server_rand1;
		Octets _trans_token;
	};

private:
	static GateServer instance;
	size_t		accumulate_limit;

	std::map<Session::ID,SessionInfo> _session_map;
	mutable Thread::Mutex _session_map_lock;
	//std::map<Octets,Session::ID> _account_map;

	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
public:
	static GateServer *GetInstance() { return &instance; }
	std::string Identification() const { return "GateServer"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	GateServer() : accumulate_limit(0) { }

	bool FindSession(Session::ID sid, Octets& server_rand1, Octets& trans_token) const;
	//void MapAccount(const Octets& account, Session::ID sid);
	//Session::ID FindSIDByAccount(const Octets& account) const;
};

};
#endif
