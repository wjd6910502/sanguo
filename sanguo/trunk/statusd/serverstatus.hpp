
#ifndef __GNET_SERVERSTATUS_HPP
#define __GNET_SERVERSTATUS_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class ServerStatus : public GNET::Protocol
{
	#include "serverstatus"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
