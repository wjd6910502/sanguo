
#ifndef __GNET_TRANSCHALLENGE_HPP
#define __GNET_TRANSCHALLENGE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "connection.h"
#include <assert.h>
#include "transclient.hpp"

namespace GNET
{

class TransChallenge : public GNET::Protocol
{
	#include "transchallenge"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		fprintf(stderr, "TransChallenge::Process, server_rand2=%s\n", B16EncodeOctets(server_rand2).c_str());

		//assert(((TransClient*)manager)->GetCurSID() == (int)sid);
		if(((TransClient*)manager)->GetCurSID()!=(int)sid) return;

		((TransClient*)manager)->GetConnection()->OnTransChallenge(manager, sid, server_rand2);
	}
};

};

#endif
