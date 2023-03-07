
#ifndef __GNET_ACZONEREGISTER_HPP
#define __GNET_ACZONEREGISTER_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include "gaccodeserver.hpp"
#include "glog.h"

namespace GNET
{

class ACZoneRegister : public GNET::Protocol
{
	#include "aczoneregister"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "gamed register success... ...");	
		printf("Register SUCCESS\n");
		GACCodeServer::GetInstance()->ZoneRegister(zoneid,sid);

	}
};

};

#endif
