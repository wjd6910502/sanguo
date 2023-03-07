
#ifndef __GNET_GMCMD_ADDSERVERREWARD_HPP
#define __GNET_GMCMD_ADDSERVERREWARD_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "serverreward"

namespace GNET
{

class GMCmd_AddServerReward : public GNET::Protocol
{
	#include "gmcmd_addserverreward"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
