
#ifndef __GNET_GMCMD_BULL_HPP
#define __GNET_GMCMD_BULL_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_Bull : public GNET::Protocol
{
	#include "gmcmd_bull"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "gamed::GMCmd_Bull::Process, text=%.*s, session_id=%d", (int)text.size(), (char*)text.begin(), session_id);

		GMCmd_Bull_Re resp;

		std::string str_text = std::string((char*)text.begin(), text.size());
		GMAdapterServer::GetInstance()->ConvertToUtf8(str_text);
		char *gm_text = new char[str_text.size()*2];
		base64_encode((unsigned char*)str_text.c_str(), str_text.size(), gm_text);

		char msg[1024];
		snprintf(msg, sizeof(msg), "11002:%s:", gm_text);
		MessageManager::GetInstance().Put(-1, -1, msg, 0);
		
		resp.retcode = 0;
		resp.session_id = session_id;

		manager->Send(sid, resp);

	}
};

};

#endif
