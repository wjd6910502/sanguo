
#ifndef __GNET_KICKOUT_HPP
#define __GNET_KICKOUT_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "connection.h"
#include <assert.h>
#include "transclient.hpp"

namespace GNET
{

class Kickout : public GNET::Protocol
{
	#include "kickout"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		fprintf(stderr, "Kickout::Process, reason=%d\n", reason);

		//assert(((TransClient*)manager)->GetCurSID() == (int)sid);
		if(((TransClient*)manager)->GetCurSID()!=(int)sid) return;
		//Connection::GetInstance().OnKickout(manager, sid, reason);
		((TransClient*)manager)->GetConnection()->OnKickout(manager, sid, reason);
	}
};

};

#endif
