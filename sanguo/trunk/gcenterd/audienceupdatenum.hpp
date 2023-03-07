
#ifndef __GNET_AUDIENCEUPDATENUM_HPP
#define __GNET_AUDIENCEUPDATENUM_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class AudienceUpdateNum : public GNET::Protocol
{
	#include "audienceupdatenum"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
