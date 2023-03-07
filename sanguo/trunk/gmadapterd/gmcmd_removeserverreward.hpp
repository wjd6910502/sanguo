
#ifndef __GNET_GMCMD_REMOVESERVERREWARD_HPP
#define __GNET_GMCMD_REMOVESERVERREWARD_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_RemoveServerReward : public GNET::Protocol
{
	#include "gmcmd_removeserverreward"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
