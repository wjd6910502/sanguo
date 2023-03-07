
#ifndef __GNET_AUDIENCEGETLISTRE_HPP
#define __GNET_AUDIENCEGETLISTRE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class AudienceGetListRe : public GNET::Protocol
{
	#include "audiencegetlistre"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
