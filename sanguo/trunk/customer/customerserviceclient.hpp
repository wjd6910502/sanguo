#ifndef __GNET_CUSTOMERSERVICECLIENT_HPP
#define __GNET_CUSTOMERSERVICECLIENT_HPP

#include "protocol.h"
#include "thread.h"

using namespace std;

namespace GNET
{

class CustomerServiceClient : public Protocol::Manager
{
	static CustomerServiceClient instance;
	size_t		accumulate_limit;
	Session::ID	sid;
	bool		conn_state;
	Thread::Mutex	locker_state;
	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
	void OnAbortSession(const SockAddr &sa);
	void OnCheckAddress(SockAddr &) const;
public:
	int typ;
	std::string arg[10];
	
	static CustomerServiceClient *GetInstance() { return &instance; }
	std::string Identification() const { return "CustomerServiceClient"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	CustomerServiceClient() : accumulate_limit(0), conn_state(false), locker_state("CustomerServiceClient::locker_state") { }

	bool SendProtocol(const Protocol &protocol) { return conn_state && Send(sid, protocol); }
	bool SendProtocol(const Protocol *protocol) { return conn_state && Send(sid, protocol); }
};

};
#endif
