
#ifndef __GNET_GMCMD_MAILITEMTOPLAYER_HPP
#define __GNET_GMCMD_MAILITEMTOPLAYER_HPP

#include <iconv.h>
#include <stdio.h>
#include <sstream>
#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include "gmadapterserver.hpp"


namespace GNET
{

class GMCmd_MailItemToPlayer : public GNET::Protocol
{
	#include "gmcmd_mailitemtoplayer"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "gamed::GMCmd_MailItemToPlayer::Process, roleid=%ld, mailtitle=%.*s, mailcontent=%.*s, session_id=%d", 
				roleid, (int)mailtitle.size(), (char*)mailtitle.begin(), (int)mailcontent.size(), (char*)mailcontent.begin(), session_id);

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
				
		std::string str_mailtitle = std::string((char*)mailtitle.begin(), mailtitle.size());
		GMAdapterServer::GetInstance()->ConvertToUtf8(str_mailtitle);
		char *title = new char[str_mailtitle.size()*2];
		base64_encode((unsigned char*)str_mailtitle.c_str(), str_mailtitle.size(), title);

		std::string str_mailcontent = std::string((char*)mailcontent.begin(), mailcontent.size());
		GMAdapterServer::GetInstance()->ConvertToUtf8(str_mailcontent);
		char *content = new char[str_mailcontent.size()*2];
		base64_encode((unsigned char*)str_mailcontent.c_str(), str_mailcontent.size(), content);

		char msg[100];
		snprintf(msg, sizeof(msg), "11001:%s:%s:%d:%u:",
				title, content, session_id, sid);
		MessageManager::GetInstance().Put(roleid, roleid, msg, 0);
		delete title;
		delete content;
	}
};

};

#endif
