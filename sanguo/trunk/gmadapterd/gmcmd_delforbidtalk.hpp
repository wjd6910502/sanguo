
#ifndef __GNET_GMCMD_DELFORBIDTALK_HPP
#define __GNET_GMCMD_DELFORBIDTALK_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_DelForbidTalk : public GNET::Protocol
{
	#include "gmcmd_delforbidtalk"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
