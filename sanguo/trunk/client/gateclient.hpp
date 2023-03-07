#ifndef __GNET_GATECLIENT_HPP
#define __GNET_GATECLIENT_HPP

#include "protocol.h"
#include "thread.h"

class Connection;

namespace GNET
{

class GateClient : public Protocol::Manager
{
	//static GateClient instance;
	size_t		accumulate_limit;
	Session::ID	sid;
	bool		conn_state;
	Thread::Mutex	locker_state;

	Session::ID	_discard_sid_le_than;

	Connection*	_conn;

	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
	void OnAbortSession(const SockAddr &sa);
	void OnCheckAddress(SockAddr &) const;

public:
	//static GateClient *GetInstance() { return &instance; }
	std::string Identification() const { return "GateClient"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	GateClient() : accumulate_limit(0), sid(0), conn_state(false), locker_state("GateClient::locker_state"), _discard_sid_le_than(0), _conn(0) { }

	int GetCurSID() const;

	void SetConnection(Connection *c) { _conn=c; }
	Connection* GetConnection() const { return _conn; }

	bool SendProtocol(const Protocol &protocol) { return conn_state && Send(sid, protocol); }
	bool SendProtocol(const Protocol *protocol) { return conn_state && Send(sid, protocol); }

	virtual bool LoadSessionConfig(GNET::NetSession::Config &cnf);
	void DiscardPendingSession() { _discard_sid_le_than = _session_id; } //TODO: _session_id的精确含义
	void CloseCur();
};

};
#endif
