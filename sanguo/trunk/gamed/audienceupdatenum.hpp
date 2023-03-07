
#ifndef __GNET_AUDIENCEUPDATENUM_HPP
#define __GNET_AUDIENCEUPDATENUM_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class AudienceUpdateNum : public GNET::Protocol
{
	#include "audienceupdatenum"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GAMED::AudienceUpdateNum, roleid=%ld, num=%d", role_id, num);
		char msg[100];
		snprintf(msg, sizeof(msg), "72:%d:", num); //AudienceUpdateNum
		MessageManager::GetInstance().Put(role_id, role_id, msg, 0);
	}
};

};

#endif
