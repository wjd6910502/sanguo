
#ifndef __GNET_TRANSAUTHRESULT_HPP
#define __GNET_TRANSAUTHRESULT_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "connection.h"
#include <assert.h>
#include "transclient.hpp"

namespace GNET
{

class TransAuthResult : public GNET::Protocol
{
	#include "transauthresult"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		fprintf(stderr, "TransAuthResult::Process, retcode=%d, server_received_count=%d, do_reset=%d\n", retcode, server_received_count, do_reset);

		assert(((TransClient*)manager)->GetCurSID() == (int)sid);
		Connection::GetInstance().OnTransAuthResult(manager, sid, retcode, server_received_count, do_reset);
	}
};

};

#endif
