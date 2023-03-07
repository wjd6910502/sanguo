
#ifndef __GNET_GMCMD_DELFORBIDLOGIN_HPP
#define __GNET_GMCMD_DELFORBIDLOGIN_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_DelForbidLogin : public GNET::Protocol
{
	#include "gmcmd_delforbidlogin"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "gamed::GMCmd_DelForbidLogin::Process, roleid=%ld, session_id=%d", 
				roleid, session_id);

		GMCmd_DelForbidLogin_Re resp;

		Int64 key(roleid);
		bool flag = SGT_Misc::GetInstance().Delete_ForbidLogin(key);
		if(flag)
		{
			resp.retcode = 0; 
			resp.session_id = session_id;
			manager->Send(sid, resp);
		}
		else
		{
			GLog::log(LOG_INFO, "gamed::GMCmd_DelForbidLogin::Process, Failure, roleid=%ld, session_id=%d, role not in forbidlogin list", 
				roleid, session_id);

			resp.retcode = -1;
			const char *desc = "role not in forbidlogin list";
			resp.desc = Octets(desc, strlen(desc));
			resp.session_id = session_id;
			manager->Send(sid, resp);
		}
	}
};

};

#endif
