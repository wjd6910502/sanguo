
#ifndef __GNET_CENTERCOMMANDRE_HPP
#define __GNET_CENTERCOMMANDRE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include "gmserver.hpp"

namespace GNET
{

class CenterCommandRe : public GNET::Protocol
{
	#include "centercommandre"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GMServer::GetInstance()->DispatchProtocol(this->gmsid,this);
	}
};

};

#endif
