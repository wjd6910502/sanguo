
#ifndef __GNET_GMCMD_GETROLEFORBIDLOGIN_RE_HPP
#define __GNET_GMCMD_GETROLEFORBIDLOGIN_RE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_GetRoleForbidLogin_Re : public GNET::Protocol
{
	#include "gmcmd_getroleforbidlogin_re"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
