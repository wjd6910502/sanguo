
#ifndef __GNET_FORWARDUDPSTUNREQUEST_HPP
#define __GNET_FORWARDUDPSTUNREQUEST_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class ForwardUDPSTUNRequest : public GNET::Protocol
{
	#include "forwardudpstunrequest"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
