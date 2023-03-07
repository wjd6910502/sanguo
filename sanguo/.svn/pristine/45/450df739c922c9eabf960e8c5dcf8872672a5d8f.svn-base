#ifndef __GNET_UDPTRANSCLIENT_HPP
#define __GNET_UDPTRANSCLIENT_HPP

#include "protocol.h"
#include "thread.h"

class Connection;

namespace GNET
{

class UDPTransClient: public Protocol::Manager
{
	//static UDPTransClient instance;
	size_t		accumulate_limit;

	unsigned short local_port;
	std::map<unsigned int,SockAddr> sid_2_addr;

	Connection*	_conn;

	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid) {}
	void OnDelSession(Session::ID sid) {}
	void OnSetTransport(SESSION_ID sid, const SockAddr& local, const SockAddr& peer);

public:
	//static UDPTransClient *GetInstance() { return &instance; }
	std::string Identification() const { return "UDPTransClient"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	UDPTransClient() : accumulate_limit(0), local_port(0), _conn(0) { }

	const SockAddr* GetSockAddrBySid(unsigned int sid) const;

	void SetConnection(Connection *c) { _conn=c; }
	Connection* GetConnection() const { return _conn; }

	void SendTo(const char *dest_ip, unsigned short dest_port, const Protocol& protocol);
	void SendTo(const SockAddr& dest, const Protocol& protocol);

	unsigned short GetLocalPort() const { return local_port; }
};

};
#endif
