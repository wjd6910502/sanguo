
#ifndef __GNET_GMCMD_BULL_RE_HPP
#define __GNET_GMCMD_BULL_RE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_Bull_Re : public GNET::Protocol
{
	#include "gmcmd_bull_re"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO,
		          "gmadapterd::GMCmd_Bull_Re::Process, retcode=%d, desc=%.*s, session_id=%d",
		          retcode, (int)desc.size(), (char*)desc.begin(), session_id);

		//for PWRD
		char buf[1024];
		if(retcode == 0)
		{
			snprintf(buf, sizeof(buf),
			         "<cmd_command cmd_data=\"Bull\" return=\"true\"/>");
		}
		else
		{
			snprintf(buf, sizeof(buf),
			         "<cmd_command cmd_data=\"Bull\" return=\"false\" desc=\"%.*s\"/>",
			         (int)desc.size(), (char*)desc.begin());
		}
		PWRD::GetInstance().OnRecvResp(session_id, buf);
	}
};

};

#endif
