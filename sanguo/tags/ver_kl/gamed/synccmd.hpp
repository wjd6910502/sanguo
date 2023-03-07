
#ifndef __GNET_SYNCCMD_HPP
#define __GNET_SYNCCMD_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class SyncCmd : public GNET::Protocol
{
	#include "synccmd"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
