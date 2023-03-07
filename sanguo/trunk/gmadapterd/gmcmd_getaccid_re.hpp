
#ifndef __GNET_GMCMD_GETACCID_RE_HPP
#define __GNET_GMCMD_GETACCID_RE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_GetAccID_Re : public GNET::Protocol
{
	#include "gmcmd_getaccid_re"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO,
		          "gmadapterd::GMCmd_GetAccID_Re::Process, retcode=%d, account=%.*s, roleid=%ld, rolename=%.*s, desc=%.*s, session_id=%d",
		          retcode, (int)account.size(), (char*)account.begin(), roleid, (int)rolename.size(), (char*)rolename.begin(),
		          (int)desc.size(), (char*)desc.begin(), session_id);

		//for PWRD
		char buf[1024];
		if(retcode == 0)
		{
			snprintf(buf, sizeof(buf),
			         "<cmd_command cmd_data=\"GetAccID\" return=\"true\" accid=\"%.*s\" charid=\"%ld\" charname=\"%.*s\"/>",
			         (int)account.size(), (char*)account.begin(), roleid, (int)rolename.size(), (char*)rolename.begin());
		}
		else
		{
			snprintf(buf, sizeof(buf),
			         "<cmd_command cmd_data=\"GetAccID\" return=\"false\" desc=\"%.*s\"/>",
			         (int)desc.size(), (char*)desc.begin());
		}
		PWRD::GetInstance().OnRecvResp(session_id, buf);
	}
};

};

#endif
