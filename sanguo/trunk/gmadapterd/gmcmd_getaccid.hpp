
#ifndef __GNET_GMCMD_GETACCID_HPP
#define __GNET_GMCMD_GETACCID_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_GetAccID : public GNET::Protocol
{
	#include "gmcmd_getaccid"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
