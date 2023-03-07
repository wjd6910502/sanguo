
#ifndef __GNET_PVPLEAVERE_HPP
#define __GNET_PVPLEAVERE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PvpLeaveRe : public GNET::Protocol
{
	#include "pvpleavere"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GAMED::PvpLeaveRe, roleid=%ld, result=%d, typ=%d, elo_score=%d", roleid, result, typ, elo_score);
		
		char msg[256];
		snprintf(msg, sizeof(msg), "10014:%d:%d:%d:", result, typ, elo_score); //PvpEnd
		MessageManager::GetInstance().Put(roleid, roleid, msg, 0);
	}
};

};

#endif
