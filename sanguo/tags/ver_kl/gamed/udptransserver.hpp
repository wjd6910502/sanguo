#ifndef __GNET_UDPTRANSSERVER_HPP
#define __GNET_UDPTRANSSERVER_HPP

#include "protocol.h"
#include "thread.h"
#include "mutex.h"

namespace GNET
{

class UDPTransServer : public Protocol::Manager
{
	static UDPTransServer instance;
	size_t		accumulate_limit;

	Octets public_address;
	unsigned short public_port;

	std::map<unsigned int,SockAddr> sid_2_addr;

	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
	void OnSetTransport(SESSION_ID sid, const SockAddr& local, const SockAddr& peer);

public:
	static UDPTransServer *GetInstance() { return &instance; }
	std::string Identification() const { return "UDPTransServer"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	UDPTransServer() : accumulate_limit(0), public_port(0) { }

	void SetPublicAddress(const char *addr) { public_address = Octets(addr, strlen(addr)); }
	void SetPublicPort(unsigned short p) { public_port = p; }

	const Octets& GetPublicAddress() const { return public_address; }
	unsigned short GetPublicPort() const { return public_port; }

	const SockAddr* GetSockAddrBySid(unsigned int sid) const;
};

};
#endif
