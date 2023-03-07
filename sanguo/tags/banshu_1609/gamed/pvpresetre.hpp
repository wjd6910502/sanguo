
#ifndef __GNET_PVPRESETRE_HPP
#define __GNET_PVPRESETRE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PvpResetRe : public GNET::Protocol
{
	#include "pvpresetre"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GAMED::PvpResetRe, roleid=%ld, retcode=%d", roleid, retcode);
		
		char msg[100];
		snprintf(msg, sizeof(msg), "10018:%d:", retcode); //PvpReset
		MessageManager::GetInstance().Put(roleid, roleid, msg, 0);
	}
};

};

#endif
