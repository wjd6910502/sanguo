#ifndef __GNET_CUSTOMERSERVIVESERVER_HPP
#define __GNET_CUSTOMERSERVIVESERVER_HPP

#include "protocol.h"

namespace GNET
{

class CustomerServiveServer : public Protocol::Manager
{
	static CustomerServiveServer instance;
	size_t		accumulate_limit;
	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
	std::map<int,Session::ID> _session_map; //每一次请求都有一个新的ID
	int num;//客服每次连接，都会修改一次
public:
	static CustomerServiveServer *GetInstance() { return &instance; }
	std::string Identification() const { return "CustomerServiveServer"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	CustomerServiveServer() : accumulate_limit(0) { }
	
	void DispatchProtocol(Session::ID sid,const Protocol& p) { DispatchProtocol(sid,&p); }
	void DispatchProtocol(Session::ID sid,const Protocol* p);

	void CloseServer(Session::ID sid = 0);
};

};
#endif
