
#ifndef __GNET_GMCMD_GETACCCHARLIST_RE_HPP
#define __GNET_GMCMD_GETACCCHARLIST_RE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include "pwrd.h"
#include "glog.h"

namespace GNET
{

class GMCmd_GetAccCharList_Re : public GNET::Protocol
{
	#include "gmcmd_getacccharlist_re"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO,
		          "gmadapterd::GMCmd_GetAccCharList_Re::Process, retcode=%d, account=%.*s, session_id=%d, roleid=%ld, rolename=%.*s, level=%d, desc=%.*s",
		          retcode, (int)account.size(), (char*)account.begin(), session_id, roleid, (int)rolename.size(), (char*)rolename.begin(), level,
		          (int)desc.size(), (char*)desc.begin());

		//for PWRD
		char buf[1024];
		if(retcode == 0)
		{
			snprintf(buf, sizeof(buf),
			         "<cmd_command cmd_data=\"GetAccCharList\" accid=\"%.*s\" return=\"true\" char1=\"%ld|%.*s|%d\" char2=\"\" char3=\"\" char4=\"\" char5=\"\"/>",
			         (int)account.size(), (char*)account.begin(), roleid, (int)rolename.size(), (char*)rolename.begin(), level);
		}
		else
		{
			snprintf(buf, sizeof(buf),
			         "<cmd_command cmd_data=\"GetAccCharList\" accid=\"%.*s\" return=\"false\" desc=\"%.*s\"/>",
			         (int)account.size(), (char*)account.begin(), (int)desc.size(), (char*)desc.begin());
		}
		PWRD::GetInstance().OnRecvResp(session_id, buf);
	}
};

};

#endif
