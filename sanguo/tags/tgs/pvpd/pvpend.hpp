
#ifndef __GNET_PVPEND_HPP
#define __GNET_PVPEND_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PVPEnd : public GNET::Protocol
{
	#include "pvpend"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
