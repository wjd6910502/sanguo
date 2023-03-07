
#ifndef __GNET_CENTERCOMMAND_HPP
#define __GNET_CENTERCOMMAND_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class CenterCommand : public GNET::Protocol
{
	#include "centercommand"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
