
#ifndef __GNET_CUSTOMERREQUEST_HPP
#define __GNET_CUSTOMERREQUEST_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "item"

#include "customerserviveserver.hpp"

namespace GNET
{

class CustomerRequest : public GNET::Protocol
{
	#include "customerrequest"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		std::cout << "CustomerRequest   sid=" << sid << std::endl;
		if(typ == 1)
		{
			CustomerServiveServer::GetInstance()->CloseServer(sid);
		}
	}
};

};

#endif
