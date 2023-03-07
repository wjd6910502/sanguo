
#ifndef __GNET_REGISTER_HPP
#define __GNET_REGISTER_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include "verificationgameserver.hpp"

namespace GNET
{

class Register : public GNET::Protocol
{
	#include "register"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "Register, sid=%d, battle_ver=%d", sid, battle_ver);
		VerificationGameServer::GetInstance()->SetSid(sid, battle_ver);
	}
};

};

#endif
