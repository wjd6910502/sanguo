
#ifndef __GNET_AUDIENCEFINISHROOM_HPP
#define __GNET_AUDIENCEFINISHROOM_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class AudienceFinishRoom : public GNET::Protocol
{
	#include "audiencefinishroom"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
