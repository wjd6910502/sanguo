
#ifndef __GNET_GMCMD_ADDFORBIDTALK_HPP
#define __GNET_GMCMD_ADDFORBIDTALK_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_AddForbidTalk : public GNET::Protocol
{
	#include "gmcmd_addforbidtalk"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
