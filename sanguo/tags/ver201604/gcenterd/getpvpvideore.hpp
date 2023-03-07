
#ifndef __GNET_GETPVPVIDEORE_HPP
#define __GNET_GETPVPVIDEORE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GetPvpVideoRe : public GNET::Protocol
{
	#include "getpvpvideore"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
