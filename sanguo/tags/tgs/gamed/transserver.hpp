#ifndef __GNET_TRANSSERVER_HPP
#define __GNET_TRANSSERVER_HPP

#include "protocol.h"
#include "thread.h"
#include "mutex.h"

namespace GNET
{

class TransServer : public Protocol::Manager
{
public:
	struct SessionInfo
	{
		Octets _server_rand2;
	};

private:
	static TransServer instance;
	size_t		accumulate_limit;

	std::map<Session::ID,SessionInfo> _session_map;
	mutable Thread::Mutex _session_map_lock;

	Octets public_address;
	unsigned short public_port;

	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
public:
	static TransServer *GetInstance() { return &instance; }
	std::string Identification() const { return "TransServer"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	TransServer() : accumulate_limit(0), public_port(0) { }

	bool FindSession(Session::ID sid, Octets& server_rand2);

	void SetPublicAddress(const char *addr) { public_address = Octets(addr, strlen(addr)); }
	void SetPublicPort(unsigned short p) { public_port = p; }

	const Octets& GetPublicAddress() const { return public_address; }
	unsigned short GetPublicPort() const { return public_port; }
};

};
#endif
