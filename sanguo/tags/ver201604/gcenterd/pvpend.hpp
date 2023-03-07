
#ifndef __GNET_PVPEND_HPP
#define __GNET_PVPEND_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PVPEnd : public GNET::Protocol
{
	#include "pvpend"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GCenter::PvpEnd ...id=%d ...fighter1=%ld ...fighter2=%ld ...reason=%d",id, fighter1, fighter2, reason);
		PVPMatch::GetInstance().PvpdPvpEnd(id, fighter1, fighter2, reason);
	}
};

};

#endif
