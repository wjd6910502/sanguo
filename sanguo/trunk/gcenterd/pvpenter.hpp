
#ifndef __GNET_PVPENTER_HPP
#define __GNET_PVPENTER_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "pvpmatch.h"

namespace GNET
{

class PvpEnter : public GNET::Protocol
{
	#include "pvpenter"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GCenter::PvpEnter, roleid=%ld, index=%d, flag=%d",roleid, index, flag);
		PVPMatch::GetInstance().RolePvpEnter(roleid, index, flag);
	}
};

};

#endif
