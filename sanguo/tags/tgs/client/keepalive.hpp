
#ifndef __GNET_KEEPALIVE_HPP
#define __GNET_KEEPALIVE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "connection.h"
#include "transclient.hpp"

namespace GNET
{

class KeepAlive : public GNET::Protocol
{
	#include "keepalive"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		assert(((TransClient*)manager)->GetCurSID() == (int)sid);
		Connection::GetInstance().UpdateLatency(client_send_time, server_send_time);
	}
};

};

#endif
