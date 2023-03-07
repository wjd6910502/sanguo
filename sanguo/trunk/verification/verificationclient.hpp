#ifndef __GNET_VERIFICATIONCLIENT_HPP
#define __GNET_VERIFICATIONCLIENT_HPP

#include "protocol.h"
#include "thread.h"

namespace GNET
{

class VerificationClient : public Protocol::Manager
{
	static VerificationClient instance;
	size_t		accumulate_limit;
	Session::ID	sid;
	bool		conn_state;
	Thread::Mutex	locker_state;
	enum { BACKOFF_INIT = 2, BACKOFF_DEADLINE = 256 };
	size_t		backoff;
	void Reconnect();
	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
	void OnAbortSession(const SockAddr &sa);
	void OnCheckAddress(SockAddr &) const;
	size_t		battle_ver;
public:
	static VerificationClient *GetInstance() { return &instance; }
	std::string Identification() const { return "VerificationClient"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	VerificationClient() : accumulate_limit(0), conn_state(false), locker_state("VerificationClient::locker_state"), backoff(BACKOFF_INIT) { }
	void SetBattleVer(size_t battle_ver)
	{
		this->battle_ver = battle_ver;
	}

	bool SendProtocol(const Protocol &protocol) { return conn_state && Send(sid, protocol); }
	bool SendProtocol(const Protocol *protocol) { return conn_state && Send(sid, protocol); }
};

};
#endif
