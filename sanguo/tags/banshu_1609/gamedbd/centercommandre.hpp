
#ifndef __GNET_CENTERCOMMANDRE_HPP
#define __GNET_CENTERCOMMANDRE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class CenterCommandRe : public GNET::Protocol
{
	#include "centercommandre"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
