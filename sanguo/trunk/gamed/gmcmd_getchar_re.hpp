
#ifndef __GNET_GMCMD_GETCHAR_RE_HPP
#define __GNET_GMCMD_GETCHAR_RE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_GetChar_Re : public GNET::Protocol
{
	#include "gmcmd_getchar_re"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
