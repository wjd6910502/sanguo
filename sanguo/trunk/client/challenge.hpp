
#ifndef __GNET_CHALLENGE_HPP
#define __GNET_CHALLENGE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "commonmacro.h"
#include "connection.h"
#include <assert.h>
#include "gateclient.hpp"

namespace GNET
{

class Challenge : public GNET::Protocol
{
	#include "challenge"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		fprintf(stderr, "Challenge::Process, server_rand1=%s\n", B16EncodeOctets(server_rand1).c_str());

		//assert(((GateClient*)manager)->GetCurSID() == (int)sid); //FIXME: 客户端不要assert，直接丢弃即可
		if(((GateClient*)manager)->GetCurSID()!=(int)sid) return;

		//Connection::GetInstance().OnChallenge(manager, sid, server_rand1);
		((GateClient*)manager)->GetConnection()->OnChallenge(manager, sid, server_rand1);
	}
};

};

#endif
