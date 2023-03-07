
#ifndef __GNET_UDPKEEPALIVE_HPP
#define __GNET_UDPKEEPALIVE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class UDPKeepAlive : public GNET::Protocol
{
	#include "udpkeepalive"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//printf("UDPKeepAlive::Process\n");
	}
};

};

#endif
