
#ifndef __GNET_UDPSYNCNETTIMERE_HPP
#define __GNET_UDPSYNCNETTIMERE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class UDPSyncNetTimeRe : public GNET::Protocol
{
	#include "udpsyncnettimere"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
