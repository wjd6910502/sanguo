
#ifndef __GNET_GMCMD_GETROLEFORBIDLOGIN_HPP
#define __GNET_GMCMD_GETROLEFORBIDLOGIN_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_GetRoleForbidLogin : public GNET::Protocol
{
	#include "gmcmd_getroleforbidlogin"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
