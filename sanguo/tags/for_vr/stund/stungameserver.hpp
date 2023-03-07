#ifndef __GNET_STUNGAMESERVER_HPP
#define __GNET_STUNGAMESERVER_HPP

#include "protocol.h"

namespace GNET
{

class STUNGameServer : public Protocol::Manager
{
	static STUNGameServer instance;
	size_t		accumulate_limit;
	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
public:
	static STUNGameServer *GetInstance() { return &instance; }
	std::string Identification() const { return "STUNGameServer"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	STUNGameServer() : accumulate_limit(0) { }
};

};
#endif
