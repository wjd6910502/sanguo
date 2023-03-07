
#ifndef __GNET_UDPSTUNREQUEST_HPP
#define __GNET_UDPSTUNREQUEST_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class UDPSTUNRequest : public GNET::Protocol
{
	#include "udpstunrequest"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
