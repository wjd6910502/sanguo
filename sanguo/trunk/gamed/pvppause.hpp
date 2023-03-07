
#ifndef __GNET_PVPPAUSE_HPP
#define __GNET_PVPPAUSE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PVPPause : public GNET::Protocol
{
	#include "pvppause"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GAMED::PVPPause, id=%d, fighter=%ld, fighter_cmds.size()=%d, pause_tick=%d, role_id=%ld",
		          id, fighter, (int)fighter_cmds.size(), pause_tick, role_id);

		char buf[100];
		snprintf(buf, sizeof(buf), "%ld", role_id);
		Octets tmp_in(buf, strlen(buf));
		Octets tmp_out;
		Base64Encoder::Convert(tmp_out, tmp_in);

		char header[100];
		snprintf(header, sizeof(header), "10034:%d:%.*s:%d:", pause_tick, (int)tmp_out.size(), (char*)tmp_out.begin(), (int)fighter_cmds.size()); //PVPPause

		std::string msg = header;
		for(auto it=fighter_cmds.begin(); it!=fighter_cmds.end(); ++it)
		{
			//Octets tmp_out;
			Base64Encoder::Convert(tmp_out, *it);
			char cmd[1024];
			snprintf(cmd, sizeof(cmd), "%.*s:", (int)tmp_out.size(), (char*)tmp_out.begin());
			msg += cmd;
		}
		MessageManager::GetInstance().Put(fighter, fighter, msg, 0);
	}
};

};

#endif
