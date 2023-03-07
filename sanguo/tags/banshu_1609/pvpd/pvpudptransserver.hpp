#ifndef __GNET_PVPUDPTRANSSERVER_HPP
#define __GNET_PVPUDPTRANSSERVER_HPP

#include "protocol.h"

namespace GNET
{

class PVPUDPTransServer : public Protocol::Manager
{
	static PVPUDPTransServer instance;
	size_t		accumulate_limit;

	Octets		public_address;
	unsigned short  public_port;

	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
public:
	static PVPUDPTransServer *GetInstance() { return &instance; }
	std::string Identification() const { return "PVPUDPTransServer"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	PVPUDPTransServer() : accumulate_limit(0), public_port(0) { }

	void SetPublicAddress(const char *addr) { public_address = Octets(addr, strlen(addr)); }
	void SetPublicPort(unsigned short p) { public_port = p; }

	const Octets& GetPublicAddress() const { return public_address; }
	unsigned short GetPublicPort() const { return public_port; }
};

};
#endif
