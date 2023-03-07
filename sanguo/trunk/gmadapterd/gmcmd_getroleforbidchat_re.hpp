
#ifndef __GNET_GMCMD_GETROLEFORBIDCHAT_RE_HPP
#define __GNET_GMCMD_GETROLEFORBIDCHAT_RE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_GetRoleForbidChat_Re : public GNET::Protocol
{
	#include "gmcmd_getroleforbidchat_re"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO,
		          "gmadapterd::GMCmd_GetRoleForbidChat_Re::Process, retcode=%d, begintime=%.*s, lasttime=%d, desc=%.*s",
		          retcode, (int)begintime.size(), (char*)begintime.begin(), lasttime, (int)desc.size(), (char*)desc.begin());

		//for PWRD
		char buf[1024];
		if(retcode == 0)
		{
			snprintf(buf, sizeof(buf),
			         "<cmd_command cmd_data=\"GetRoleForbidChat\" return=\"true\" begintime=\"%.*s\" lasttime=\"%d\" desc=\"%.*s\"/>",
					 (int)begintime.size(), (char*)begintime.begin(), lasttime, (int)desc.size(), (char*)desc.begin());
		}
		else
		{
			snprintf(buf, sizeof(buf),
			         "<cmd_command cmd_data=\"GetRoleForbidChat\" return=\"false\" desc=\"%.*s\"/>",
			         (int)desc.size(), (char*)desc.begin());
		}
		PWRD::GetInstance().OnRecvResp(session_id, buf);
	}
};

};

#endif
