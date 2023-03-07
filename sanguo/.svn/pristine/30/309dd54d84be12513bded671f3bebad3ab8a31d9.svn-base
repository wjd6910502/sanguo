
#ifndef __GNET_GMCMD_LISTSERVERREWARD_HPP
#define __GNET_GMCMD_LISTSERVERREWARD_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "ServerReward.h"
#include "gmcmd_listserverreward_re.hpp"

namespace GNET
{

class GMCmd_ListServerReward : public GNET::Protocol
{
	#include "gmcmd_listserverreward"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GMCmd_ListServerReward::Process, session_id=%d\n", session_id);

		GMCmd_ListServerReward_Re resp;
		resp.retcode = 0;
		resp.session_id = session_id;
		CACHE::SGT_ServerReward::GetInstance().List(resp.datas);
		manager->Send(sid, resp);
	}
};

};

#endif
