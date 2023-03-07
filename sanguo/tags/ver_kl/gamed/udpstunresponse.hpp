
#ifndef __GNET_UDPSTUNRESPONSE_HPP
#define __GNET_UDPSTUNRESPONSE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class UDPSTUNResponse : public GNET::Protocol
{
	#include "udpstunresponse"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
