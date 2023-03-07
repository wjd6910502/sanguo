
#ifndef __GNET_GMCMD_LISTSERVERREWARD_RE_HPP
#define __GNET_GMCMD_LISTSERVERREWARD_RE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "serverreward"

namespace GNET
{

class GMCmd_ListServerReward_Re : public GNET::Protocol
{
	#include "gmcmd_listserverreward_re"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO,
		          "gmadapterd::GMCmd_ListServerReward_Re::Process, retcode=%d, session_id=%d, datas.size()=%d, desc=%.*s",
		          retcode, session_id, (int)datas.size(), (int)desc.size(), (char*)desc.begin());

		//for PWRD
		if(retcode == 0)
		{
			std::string str = "<cmd_command cmd_data=\"ListServerReward\" return=\"true\" ";
			int idx = 0;
			for(auto it=datas.begin(); it!=datas.end(); ++it)
			{
				idx++;

				const ServerReward& gsr = *it;
				char buf[1024];
				snprintf(buf, sizeof(buf),
				         "id%d=\"%d\" begin_time%d=\"%d\" end_time%d=\"%d\" mail_id%d=\"%d\" level_min%d=\"%d\" lifetime_min%d=\"%d\" ",
				         idx, gsr.id, idx, gsr.begin_time, idx, gsr.end_time, idx, gsr.mail_id, idx, gsr.level_min, idx, gsr.lifetime_min);
				str += buf;
			}
			str += "/>",
			PWRD::GetInstance().OnRecvResp(session_id, str.c_str());
		}
		else
		{
			char buf[1024];
			snprintf(buf, sizeof(buf),
			         "<cmd_command cmd_data=\"ListServerReward\" return=\"false\" desc=\"%.*s\"/>",
			         (int)desc.size(), (char*)desc.begin());
			PWRD::GetInstance().OnRecvResp(session_id, buf);
		}
	}
};

};

#endif
