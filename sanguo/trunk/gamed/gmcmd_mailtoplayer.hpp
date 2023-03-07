
#ifndef __GNET_GMCMD_MAILTOPLAYER_HPP
#define __GNET_GMCMD_MAILTOPLAYER_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_MailToPlayer : public GNET::Protocol
{
	#include "gmcmd_mailtoplayer"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "gamed::GMCmd_MailItemToPlayer::Process, roleid=%ld, mailid=%d, session_id=%d", 
				roleid, mailid, session_id);

		GMCmd_MailItemToPlayer_Re resp;

		const Player *player = PlayerManager::GetInstance().FindByRoleId(roleid);
		if(!player)
		{
			GLog::log(LOG_INFO, "gamed::GMCmd_MailItemToPlayer::Process, Failure, roleid=%ld, session_id=%d, player not found", 
				roleid, session_id);

			//TODO: noload player
			resp.retcode = -1;
			resp.session_id = session_id;
			const char *desc = "player not found";
			resp.desc = Octets(desc, strlen(desc));
			manager->Send(sid, resp);
			return;
		}

		char msg[100];
		snprintf(msg, sizeof(msg), "11004:%d:%d:%u:",
				mailid, session_id, sid);
		MessageManager::GetInstance().Put(roleid, roleid, msg, 0);
	}
};

};

#endif
