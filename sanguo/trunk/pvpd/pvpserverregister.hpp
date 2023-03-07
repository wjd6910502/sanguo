
#ifndef __GNET_PVPSERVERREGISTER_HPP
#define __GNET_PVPSERVERREGISTER_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PVPServerRegister : public GNET::Protocol
{
	#include "pvpserverregister"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
