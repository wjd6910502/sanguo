
#ifndef __GNET_CUSTOMERREQUEST_HPP
#define __GNET_CUSTOMERREQUEST_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "item"

namespace GNET
{

class CustomerRequest : public GNET::Protocol
{
	#include "customerrequest"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
