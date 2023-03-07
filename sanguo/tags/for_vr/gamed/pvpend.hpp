
#ifndef __GNET_PVPEND_HPP
#define __GNET_PVPEND_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PVPEnd : public GNET::Protocol
{
	#include "pvpend"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GAMED::PVPEnd, id=%d, fighter1=%ld, fighter2=%ld, reason=%d, sid=%u", id, fighter1, fighter2, reason, sid);

		std::vector<int64_t> extra_roles;
		extra_roles.push_back(fighter1);
		extra_roles.push_back(fighter2);

		char msg[100];
		snprintf(msg, sizeof(msg), "10009:%d:", reason); //PVPEnd
		MessageManager::GetInstance().Put(id, id, msg, 0, &extra_roles);
	}
};

};

#endif
