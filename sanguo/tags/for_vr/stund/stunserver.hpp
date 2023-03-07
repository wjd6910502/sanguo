#ifndef __GNET_STUNSERVER_HPP
#define __GNET_STUNSERVER_HPP

#include "protocol.h"

namespace GNET
{

class STUNServer : public Protocol::Manager
{
	static STUNServer instance;
	size_t		accumulate_limit;

	Octets		public_address;
	unsigned short  public_port;

	std::map<unsigned int,SockAddr> sid_2_addr;

	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
	void OnSetTransport(SESSION_ID sid, const SockAddr& local, const SockAddr& peer);

public:
	static STUNServer *GetInstance() { return &instance; }
	std::string Identification() const { return "STUNServer"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	STUNServer() : accumulate_limit(0) { }

	void SetPublicAddress(const char *addr) { public_address = Octets(addr, strlen(addr)); }
	void SetPublicPort(unsigned short p) { public_port = p; }

	const Octets& GetPublicAddress() const { return public_address; }
	unsigned short GetPublicPort() const { return public_port; }

	const SockAddr* GetSockAddrBySid(unsigned int sid) const;

	void SendTo(const char *dest_ip, unsigned short dest_port, const Protocol& protocol) const;
	void SendTo(const SockAddr dest, const Protocol& protocol) const;
};

};
#endif
