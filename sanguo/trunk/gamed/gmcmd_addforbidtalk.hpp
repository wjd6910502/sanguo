
#ifndef __GNET_GMCMD_ADDFORBIDTALK_HPP
#define __GNET_GMCMD_ADDFORBIDTALK_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_AddForbidTalk : public GNET::Protocol
{
	#include "gmcmd_addforbidtalk"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "gamed::GMCmd_AddForbidTalk::Process, roleid=%ld, forbidtime=%d, desc=%.*s, notifytouser=%.*s, session_id=%d", 
				roleid, forbidtime, (int)desc.size(), (char*)desc.begin(), (int)notifytouser.size(), (char*)notifytouser.begin(), session_id);

		GMCmd_AddForbidTalk_Re resp;

		const Player *player = PlayerManager::GetInstance().FindByRoleId(roleid);
		if(!player)
		{
			GLog::log(LOG_INFO, "gamed::GMCmd_AddForbidTalk::Process, Failure, roleid=%ld, session_id=%d, role not found", 
				roleid, session_id);

			//TODO: noload player
			resp.retcode = -1;
			resp.session_id = session_id;
			const char *errdesc = "role not found";
			resp.desc = Octets(errdesc, strlen(errdesc));
			manager->Send(sid, resp);
			return;
		}

		Int64 key(roleid);
		SGT_Misc::GetInstance().Insert_ForbidTalk(key, forbidtime, std::string((char*)desc.begin(), desc.size()), 
				std::string((char*)notifytouser.begin(), notifytouser.size()));
		
		resp.retcode = 0;
		resp.session_id = session_id;
		manager->Send(sid, resp);
	}
};

};

#endif