
#ifndef __GNET_PVPSPEED_HPP
#define __GNET_PVPSPEED_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PvpSpeed : public GNET::Protocol
{
	#include "pvpspeed"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
