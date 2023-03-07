
#ifndef __GNET_UDPSYNCNETTIME_HPP
#define __GNET_UDPSYNCNETTIME_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class UDPSyncNetTime : public GNET::Protocol
{
	#include "udpsyncnettime"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
