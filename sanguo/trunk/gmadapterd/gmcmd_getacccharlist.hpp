
#ifndef __GNET_GMCMD_GETACCCHARLIST_HPP
#define __GNET_GMCMD_GETACCCHARLIST_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_GetAccCharList : public GNET::Protocol
{
	#include "gmcmd_getacccharlist"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
