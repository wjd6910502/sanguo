
#ifndef __GNET_UDPS2CGAMEPROTOCOLS_HPP
#define __GNET_UDPS2CGAMEPROTOCOLS_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class UDPS2CGameProtocols : public GNET::Protocol
{
	#include "udps2cgameprotocols"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
