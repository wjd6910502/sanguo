
#ifndef __GNET_PVPENTER_HPP
#define __GNET_PVPENTER_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PvpEnter : public GNET::Protocol
{
	#include "pvpenter"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
