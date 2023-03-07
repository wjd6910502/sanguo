
#ifndef __GNET_GMCMD_ADDFORBIDWORD_RE_HPP
#define __GNET_GMCMD_ADDFORBIDWORD_RE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_AddForbidWord_Re : public GNET::Protocol
{
	#include "gmcmd_addforbidword_re"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
