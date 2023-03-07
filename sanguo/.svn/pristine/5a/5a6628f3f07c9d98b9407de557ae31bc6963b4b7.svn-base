
#ifndef __GNET_GMCMD_ADDFORBIDLOGIN_RE_HPP
#define __GNET_GMCMD_ADDFORBIDLOGIN_RE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_AddForbidLogin_Re : public GNET::Protocol
{
	#include "gmcmd_addforbidlogin_re"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO,
		          "gmadapterd::GMCmd_AddForbidLogin_Re::Process, retcode=%d, desc=%.*s",
		          retcode, (int)desc.size(), (char*)desc.begin());

		//for PWRD
		char buf[1024];
		if(retcode == 0)
		{
			snprintf(buf, sizeof(buf),
			         "<cmd_command cmd_data=\"AddForbidLogin\" return=\"true\"/>");
		}
		else
		{
			snprintf(buf, sizeof(buf),
			         "<cmd_command cmd_data=\"AddForbidLogin\" return=\"false\" desc=\"%.*s\"/>",
			         (int)desc.size(), (char*)desc.begin());
		}
		PWRD::GetInstance().OnRecvResp(session_id, buf);
	}
};

};

#endif
