
#ifndef __GNET_PVPCONTINUE_HPP
#define __GNET_PVPCONTINUE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PVPContinue : public GNET::Protocol
{
	#include "pvpcontinue"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GAMED::PVPContinue, id=%d, fighter=%ld, continue_time=%d",
		          id, fighter, continue_time);

		char msg[100];
		snprintf(msg, sizeof(msg), "10035:%d:", continue_time); //PVPContinue
		MessageManager::GetInstance().Put(fighter, fighter, msg, 0);
	}
};

};

#endif
