
#ifndef __GNET_GMCMD_DELFORBIDLOGIN_HPP
#define __GNET_GMCMD_DELFORBIDLOGIN_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_DelForbidLogin : public GNET::Protocol
{
	#include "gmcmd_delforbidlogin"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
