
#ifndef __GNET_CUSTOMERREQUEST_RE_HPP
#define __GNET_CUSTOMERREQUEST_RE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "item"

namespace GNET
{

class CustomerRequest_Re : public GNET::Protocol
{
	#include "customerrequest_re"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
