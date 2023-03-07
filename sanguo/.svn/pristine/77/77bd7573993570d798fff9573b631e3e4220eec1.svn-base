
#ifndef __GNET_GMCMD_REMOVESERVERREWARD_HPP
#define __GNET_GMCMD_REMOVESERVERREWARD_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "ServerReward.h"
#include "gmcmd_removeserverreward_re.hpp"

namespace GNET
{

class GMCmd_RemoveServerReward : public GNET::Protocol
{
	#include "gmcmd_removeserverreward"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GMCmd_RemoveServerReward::Process, id=%d, session_id=%d\n", id, session_id);

		CACHE::SGT_ServerReward::GetInstance().Remove(id);

		GMCmd_RemoveServerReward_Re resp;
		resp.retcode = 0;
		resp.id = id;
		resp.session_id = session_id;
		manager->Send(sid, resp);
	}
};

};

#endif
