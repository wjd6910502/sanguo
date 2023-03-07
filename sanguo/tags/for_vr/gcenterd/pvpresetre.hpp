
#ifndef __GNET_PVPRESETRE_HPP
#define __GNET_PVPRESETRE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PvpResetRe : public GNET::Protocol
{
	#include "pvpresetre"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
