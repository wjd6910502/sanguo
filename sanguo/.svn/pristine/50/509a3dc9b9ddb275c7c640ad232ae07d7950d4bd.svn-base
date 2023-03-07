
#ifndef __GNET_KUAFUZONEREGISTER_HPP
#define __GNET_KUAFUZONEREGISTER_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class KuafuZoneRegister : public GNET::Protocol
{
	#include "kuafuzoneregister"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GCenter::KuafuZoneRegister ...zoneid=%d ...sid=%d",zoneid, sid);
		GCenterServer::GetInstance()->ZoneRegister(zoneid,sid);
	}
};

};

#endif
