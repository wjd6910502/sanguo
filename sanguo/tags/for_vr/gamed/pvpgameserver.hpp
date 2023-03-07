#ifndef __GNET_PVPGAMESERVER_HPP
#define __GNET_PVPGAMESERVER_HPP

#include "protocol.h"

namespace GNET
{

class PVPGameServer : public Protocol::Manager
{
	static PVPGameServer instance;
	size_t		accumulate_limit;
	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
public:
	static PVPGameServer *GetInstance() { return &instance; }
	std::string Identification() const { return "PVPGameServer"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	PVPGameServer() : accumulate_limit(0) { }
};

};
#endif
