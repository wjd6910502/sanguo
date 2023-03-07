
#ifndef __GNET_PVPMATCHSUCCESS_HPP
#define __GNET_PVPMATCHSUCCESS_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PvpMatchSuccess : public GNET::Protocol
{
	#include "pvpmatchsuccess"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GAMED::PvpMatchSuccess, roleid=%ld, retcode=%d", roleid, retcode);
		
		char msg[100];
		snprintf(msg, sizeof(msg), "10010:%d:%d:%d:", retcode, index, time); //PVPMatchSuccess
		MessageManager::GetInstance().Put(roleid, roleid, msg, 0);
	}
};

};

#endif
