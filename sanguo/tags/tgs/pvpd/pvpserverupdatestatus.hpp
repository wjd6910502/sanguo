
#ifndef __GNET_PVPSERVERUPDATESTATUS_HPP
#define __GNET_PVPSERVERUPDATESTATUS_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PVPServerUpdateStatus : public GNET::Protocol
{
	#include "pvpserverupdatestatus"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
