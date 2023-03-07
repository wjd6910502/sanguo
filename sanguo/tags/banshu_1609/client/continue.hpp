
#ifndef __GNET_CONTINUE_HPP
#define __GNET_CONTINUE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "connection.h"
#include <assert.h>
#include "transclient.hpp"

namespace GNET
{

class Continue : public GNET::Protocol
{
	#include "continue"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		fprintf(stderr, "Continue::Process, reset=%d\n", reset);

		assert(((TransClient*)manager)->GetCurSID() == (int)sid);
		Connection::GetInstance().OnContinue(manager, sid, reset);
	}
};

};

#endif
