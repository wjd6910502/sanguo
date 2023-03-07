
#ifndef __GNET_GMCMD_ADDFORBIDWORD_HPP
#define __GNET_GMCMD_ADDFORBIDWORD_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_AddForbidWord : public GNET::Protocol
{
	#include "gmcmd_addforbidword"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
