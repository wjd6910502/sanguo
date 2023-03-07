
#ifndef __GNET_PVPPAUSE_HPP
#define __GNET_PVPPAUSE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "pvpmatch.h"

namespace GNET
{

class PVPPause : public GNET::Protocol
{
	#include "pvppause"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GCenter::PVPPause, id=%d, fighter=%ld, fighter_cmds.size()=%d, pause_tick=%d, role_id=%ld",
		          id, fighter, (int)fighter_cmds.size(), pause_tick, role_id);

		PVPMatch::GetInstance().PvpdPvpPause(this);
	}
};

};

#endif
