
#ifndef __GNET_GMCMD_DELFORBIDTALK_HPP
#define __GNET_GMCMD_DELFORBIDTALK_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_DelForbidTalk : public GNET::Protocol
{
	#include "gmcmd_delforbidtalk"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "gamed::GMCmd_DelForbidTalk::Process, roleid=%ld, session_id=%d", 
				roleid, session_id);

		GMCmd_DelForbidTalk_Re resp;

		Int64 key(roleid);
		bool flag = SGT_Misc::GetInstance().Delete_ForbidTalk(key);
		if(flag)
		{
			resp.retcode = 0; 
			resp.session_id = session_id;
			manager->Send(sid, resp);
		}
		else
		{
			GLog::log(LOG_INFO, "gamed::GMCmd_DelForbidTalk::Process, Failure, roleid=%ld, session_id=%d, role not in forbidtalk list", 
				roleid, session_id);

			resp.retcode = -1;
			const char *desc = "role not in forbidtalk list";
			resp.desc = Octets(desc, strlen(desc));
			resp.session_id = session_id;
			manager->Send(sid, resp);

		}
	}
};

};

#endif
