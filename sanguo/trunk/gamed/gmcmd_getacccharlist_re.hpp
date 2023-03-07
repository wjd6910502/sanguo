
#ifndef __GNET_GMCMD_GETACCCHARLIST_RE_HPP
#define __GNET_GMCMD_GETACCCHARLIST_RE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_GetAccCharList_Re : public GNET::Protocol
{
	#include "gmcmd_getacccharlist_re"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
