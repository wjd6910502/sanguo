
#ifndef __GNET_STTZONEREGISTER_HPP
#define __GNET_STTZONEREGISTER_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include "sttserver.hpp"

namespace GNET
{

class STTZoneRegister : public GNET::Protocol
{
	#include "sttzoneregister"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "gamed register success... ...");	
		printf("Register SUCCESS\n");
		STTServer::GetInstance()->ZoneRegister(zoneid,sid);
	}
};

};

#endif
