
#ifndef __GNET_GMCMD_ADDSERVERREWARD_RE_HPP
#define __GNET_GMCMD_ADDSERVERREWARD_RE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "serverreward"

namespace GNET
{

class GMCmd_AddServerReward_Re : public GNET::Protocol
{
	#include "gmcmd_addserverreward_re"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO,
		          "gmadapterd::GMCmd_AddForbidLogin_Re::Process, retcode=%d, data.id=%d, data.begin_time=%d, data.end_time=%d, data.mail_id=%d, data.level_min=%d, data.lifetime_min=%d, session_id=%d, desc=%.*s",
		          retcode, data.id, data.begin_time, data.end_time, data.mail_id, data.level_min, data.lifetime_min, session_id,
		          (int)desc.size(), (char*)desc.begin());

		//for PWRD
		char buf[1024];
		if(retcode == 0)
		{
			snprintf(buf, sizeof(buf),
			         "<cmd_command cmd_data=\"AddServerReward\" return=\"true\" id=\"%d\"/>",
			         data.id);
		}
		else
		{
			snprintf(buf, sizeof(buf),
			         "<cmd_command cmd_data=\"AddServerReward\" return=\"false\" desc=\"%.*s\"/>",
			         (int)desc.size(), (char*)desc.begin());
		}
		PWRD::GetInstance().OnRecvResp(session_id, buf);
	}
};

};

#endif
