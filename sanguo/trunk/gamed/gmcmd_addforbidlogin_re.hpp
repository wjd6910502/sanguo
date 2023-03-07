
#ifndef __GNET_GMCMD_ADDFORBIDLOGIN_RE_HPP
#define __GNET_GMCMD_ADDFORBIDLOGIN_RE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_AddForbidLogin_Re : public GNET::Protocol
{
	#include "gmcmd_addforbidlogin_re"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
