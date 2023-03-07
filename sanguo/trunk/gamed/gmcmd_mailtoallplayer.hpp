
#ifndef __GNET_GMCMD_MAILTOALLPLAYER_HPP
#define __GNET_GMCMD_MAILTOALLPLAYER_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_MailToAllPlayer : public GNET::Protocol
{
	#include "gmcmd_mailtoallplayer"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "gamed::GMCmd_MailItemToPlayer::Process, mailtitle=%.*s, mailcontent=%.*s, session_id=%d", 
				(int)mailtitle.size(), (char*)mailtitle.begin(), (int)mailcontent.size(), (char*)mailcontent.begin(), session_id);

		GMCmd_MailToAllPlayer_Re resp;
				
		//TODO:新增加接口处理，不用下面这个
		/*char msg[100];
		snprintf(msg, sizeof(msg), "11001:%s:%.*s:%.*s:%d:%u:true:", 
				msgitem.c_str(), (int)mailtitle.size(), (char*)mailtitle.begin(), (int)mailcontent.size(), (char*)mailcontent.begin(), session_id, sid);
		MessageManager::GetInstance().Put(-1, -1, msg, 0);*/

		resp.retcode = 0;
		resp.session_id = session_id;
		manager->Send(sid, resp);
	}
};

};

#endif
