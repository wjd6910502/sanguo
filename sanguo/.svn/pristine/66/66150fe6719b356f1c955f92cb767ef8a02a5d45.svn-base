#ifndef __GNET_LAOHUPROXYSERVER_HPP
#define __GNET_LAOHUPROXYSERVER_HPP

#include "protocol.h"
#include <string>

namespace GNET
{

class LaohuProxyServer : public Protocol::Manager
{
	static LaohuProxyServer instance;
	size_t		accumulate_limit;
	Session::ID sid;
	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
public:
	static LaohuProxyServer *GetInstance() { return &instance; }
	std::string Identification() const { return "LaohuProxyServer"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	LaohuProxyServer() : accumulate_limit(0) { }
	void SendContent(std::string content,std::string account);
	bool SendProtocol(const Protocol &protocol) { return  Send(sid, protocol); }
	bool SendProtocol(const Protocol *protocol) { return  Send(sid, protocol); }

};

};
#endif
