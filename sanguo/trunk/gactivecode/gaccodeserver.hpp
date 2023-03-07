#ifndef __GNET_GACCODESERVER_HPP
#define __GNET_GACCODESERVER_HPP

#include "protocol.h"

namespace GNET
{

class GACCodeServer : public Protocol::Manager
{
	std::map<int,Session::ID> _zone_map;
	static GACCodeServer instance;
	size_t		accumulate_limit;
	const Session::State *GetInitState() const;
	bool OnCheckAccumulate(size_t size) const { return accumulate_limit == 0 || size < accumulate_limit; }
	void OnAddSession(Session::ID sid);
	void OnDelSession(Session::ID sid);
public:
	static GACCodeServer *GetInstance() { return &instance; }
	std::string Identification() const { return "GACCodeServer"; }
	void SetAccumulate(size_t size) { accumulate_limit = size; }
	GACCodeServer() : accumulate_limit(0) { }

	void ZoneRegister(int zoneid, int sid)
	{
		_zone_map[zoneid] = sid;
	}
	

};

};
#endif
