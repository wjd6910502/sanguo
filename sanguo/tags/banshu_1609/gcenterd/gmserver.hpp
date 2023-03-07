#ifndef __GNET_GMSERVER_HPP
#define __GNET_GMSERVER_HPP

#include "protocol.h"

namespace GNET
{

class GMServer : public Protocol::Manager
{
	static GMServer instance;
	size_t		accumulate_limit;
	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
	std::map<int,Session::ID> _session_map; //每一次请求都有一个新的ID
	int num;//gm每一次连接center这边，都会给这个数值一次修改

public:
	static GMServer *GetInstance() { return &instance; }
	std::string Identification() const { return "GMServer"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	GMServer() : accumulate_limit(0), num(0) { }
	

	void DispatchProtocol(Session::ID sid,const Protocol& p) { DispatchProtocol(sid,&p); }
	void DispatchProtocol(Session::ID sid,const Protocol* p);

};

};
#endif
