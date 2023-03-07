
#ifndef __GNET_UDPINCRESYNCCMD_HPP
#define __GNET_UDPINCRESYNCCMD_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "deletion"
#include "insertion"

namespace GNET
{

class UDPIncreSyncCmd : public GNET::Protocol
{
	#include "udpincresynccmd"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
