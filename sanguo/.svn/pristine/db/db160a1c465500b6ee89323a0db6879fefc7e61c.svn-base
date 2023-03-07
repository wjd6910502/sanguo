
#ifndef __GNET_AUDIENCEGETLIST_HPP
#define __GNET_AUDIENCEGETLIST_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class AudienceGetList : public GNET::Protocol
{
	#include "audiencegetlist"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GCenter::AudienceGetList, roleid=%ld, zoneid=%d",roleid, zoneid);
		
		PVPMatch::GetInstance().AudienceGetAllList(roleid, zoneid);
	}
};

};

#endif
