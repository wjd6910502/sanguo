
#ifndef __GNET_PVPREADY_HPP
#define __GNET_PVPREADY_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PvpReady : public GNET::Protocol
{
	#include "pvpready"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GCenter::PvpReady ...roleid=%ld ...index=%d",roleid, index);
		PVPMatch::GetInstance().RolePvpReady(roleid, index);
	}
};

};

#endif
