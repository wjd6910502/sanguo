
#ifndef __GNET_AUTHRESULT_HPP
#define __GNET_AUTHRESULT_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class AuthResult : public GNET::Protocol
{
	#include "authresult"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
