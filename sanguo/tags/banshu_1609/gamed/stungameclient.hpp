#ifndef __GNET_STUNGAMECLIENT_HPP
#define __GNET_STUNGAMECLIENT_HPP

#include "protocol.h"
#include "thread.h"

namespace GNET
{

class STUNGameClient : public Protocol::Manager
{
	static STUNGameClient instance;
	size_t		accumulate_limit;
	Session::ID	sid;
	bool		conn_state;
	Thread::Mutex	locker_state;
	enum { BACKOFF_INIT = 2, BACKOFF_DEADLINE = 256 };
	size_t		backoff;

	Octets stund_public_address;
	unsigned short stund_public_port;

	void Reconnect();
	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
	void OnAbortSession(const SockAddr &sa);
	void OnCheckAddress(SockAddr &) const;
public:
	static STUNGameClient *GetInstance() { return &instance; }
	std::string Identification() const { return "STUNGameClient"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	STUNGameClient() : accumulate_limit(0), conn_state(false), locker_state("STUNGameClient::locker_state"), backoff(BACKOFF_INIT), stund_public_port(0) { }

	bool SendProtocol(const Protocol &protocol) { return conn_state && Send(sid, protocol); }
	bool SendProtocol(const Protocol *protocol) { return conn_state && Send(sid, protocol); }

	void SetStundPublicAddress(const char *addr) { stund_public_address = Octets(addr, strlen(addr)); }
	void SetStundPublicPort(unsigned short p) { stund_public_port = p; }

	const Octets& GetStundPublicAddress() const { return stund_public_address; }
	unsigned short GetStundPublicPort() const { return stund_public_port; }
};

};
#endif
