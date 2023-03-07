
#ifndef __GNET_PVPENTERRE_HPP
#define __GNET_PVPENTERRE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PvpEnterRe : public GNET::Protocol
{
	#include "pvpenterre"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
