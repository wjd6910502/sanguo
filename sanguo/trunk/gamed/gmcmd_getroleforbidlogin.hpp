
#ifndef __GNET_GMCMD_GETROLEFORBIDLOGIN_HPP
#define __GNET_GMCMD_GETROLEFORBIDLOGIN_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_GetRoleForbidLogin : public GNET::Protocol
{
	#include "gmcmd_getroleforbidlogin"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "gamed::GMCmd_GetRoleForbidLogin::Process, roleid=%ld, session_id=%d", 
				roleid, session_id);

		GMCmd_GetRoleForbidLogin_Re resp;

		Int64 key(roleid);
		ForbidRoleInfo forbidinfo;
		bool flag = SGT_Misc::GetInstance().Find_ForbidLogin(key, forbidinfo);
		if(flag)
		{
			time_t t = (time_t)(forbidinfo._begintime);
			struct tm p;
			localtime_r(&t, &p);
			char s[100];
			strftime(s, sizeof(s), "%Y-%m-%d %H:%M:%S", &p);
			std::string begintime = s;

			resp.retcode = 0; 
			resp.begintime = Octets(begintime.c_str(), begintime.size());
			resp.lasttime = forbidinfo._time;
			resp.desc = Octets(forbidinfo._desc.c_str(), forbidinfo._desc.size());
			resp.session_id = session_id;
			manager->Send(sid, resp);
		}
		else
		{
			GLog::log(LOG_INFO, "gamed::GMCmd_GetRoleForbidLogin::Process, Failure, roleid=%ld, session_id=%d, role not in forbidlogin list", 
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
