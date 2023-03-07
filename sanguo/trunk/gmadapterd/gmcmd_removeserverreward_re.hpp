
#ifndef __GNET_GMCMD_REMOVESERVERREWARD_RE_HPP
#define __GNET_GMCMD_REMOVESERVERREWARD_RE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_RemoveServerReward_Re : public GNET::Protocol
{
	#include "gmcmd_removeserverreward_re"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO,
		          "gmadapterd::GMCmd_RemoveServerReward_Re::Process, retcode=%d, id=%d, session_id=%d, desc=%.*s",
		          retcode, id, session_id, (int)desc.size(), (char*)desc.begin());

		//for PWRD
		char buf[1024];
		if(retcode == 0)
		{
			snprintf(buf, sizeof(buf),
			         "<cmd_command cmd_data=\"RemoveServerReward\" return=\"true\"/>");
		}
		else
		{
			snprintf(buf, sizeof(buf),
			         "<cmd_command cmd_data=\"RemoveServerReward\" return=\"false\" desc=\"%.*s\"/>",
			         (int)desc.size(), (char*)desc.begin());
		}
		PWRD::GetInstance().OnRecvResp(session_id, buf);
	}
};

};

#endif
