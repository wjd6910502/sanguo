
#ifndef __GNET_SENDPVPVIDEOID_HPP
#define __GNET_SENDPVPVIDEOID_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class SendPvpVideoID : public GNET::Protocol
{
	#include "sendpvpvideoid"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
