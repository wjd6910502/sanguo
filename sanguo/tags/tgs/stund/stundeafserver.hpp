#ifndef __GNET_STUNDEAFSERVER_HPP
#define __GNET_STUNDEAFSERVER_HPP

#include "protocol.h"

namespace GNET
{

class STUNDeafServer : public Protocol::Manager
{
	static STUNDeafServer instance;
	size_t		accumulate_limit;
	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
public:
	static STUNDeafServer *GetInstance() { return &instance; }
	std::string Identification() const { return "STUNDeafServer"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	STUNDeafServer() : accumulate_limit(0) { }

	void SendTo(const char *dest_ip, unsigned short dest_port, const Protocol& protocol) const;
	void SendTo(const SockAddr dest, const Protocol& protocol) const;
};

};
#endif
