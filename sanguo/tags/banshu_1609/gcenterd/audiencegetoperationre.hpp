
#ifndef __GNET_AUDIENCEGETOPERATIONRE_HPP
#define __GNET_AUDIENCEGETOPERATIONRE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class AudienceGetOperationRe : public GNET::Protocol
{
	#include "audiencegetoperationre"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
