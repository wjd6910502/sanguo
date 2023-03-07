
#ifndef __GNET_TRANSRESPONSE_HPP
#define __GNET_TRANSRESPONSE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class TransResponse : public GNET::Protocol
{
	#include "transresponse"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
