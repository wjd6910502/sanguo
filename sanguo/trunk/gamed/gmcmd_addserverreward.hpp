
#ifndef __GNET_GMCMD_ADDSERVERREWARD_HPP
#define __GNET_GMCMD_ADDSERVERREWARD_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "serverreward"
#include "ServerReward.h"
#include "gmcmd_addserverreward_re.hpp"

namespace GNET
{

class GMCmd_AddServerReward : public GNET::Protocol
{
	#include "gmcmd_addserverreward"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO,
		          "GMCmd_AddServerReward::Process, data.id=%d, data.begin_time=%d, data.end_time=%d, data.mail_id=%d, data.level_min=%d, data.lifetime_min=%d, session_id=%d\n",
		          data.id, data.begin_time, data.end_time, data.mail_id, data.level_min, data.lifetime_min, session_id);

		GMCmd_AddServerReward_Re resp;
		resp.retcode = 0;
		resp.data = data;
		resp.data.id = CACHE::SGT_ServerReward::GetInstance().Add(data);
		resp.session_id = session_id;
		manager->Send(sid, resp);
	}
};

};

#endif
