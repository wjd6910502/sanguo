
#ifndef __GNET_GMCMD_ADDFORBIDLOGIN_HPP
#define __GNET_GMCMD_ADDFORBIDLOGIN_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_AddForbidLogin : public GNET::Protocol
{
	#include "gmcmd_addforbidlogin"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
