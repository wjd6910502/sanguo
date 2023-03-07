
#ifndef __GNET_GMCMD_ADDSERVERREWARD_RE_HPP
#define __GNET_GMCMD_ADDSERVERREWARD_RE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "serverreward"

namespace GNET
{

class GMCmd_AddServerReward_Re : public GNET::Protocol
{
	#include "gmcmd_addserverreward_re"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
