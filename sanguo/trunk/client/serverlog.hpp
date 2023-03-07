
#ifndef __GNET_SERVERLOG_HPP
#define __GNET_SERVERLOG_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class ServerLog : public GNET::Protocol
{
	#include "serverlog"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
