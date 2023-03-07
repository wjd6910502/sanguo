
#ifndef __GNET_AUDIENCEOPERATION_HPP
#define __GNET_AUDIENCEOPERATION_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "pvpvideo"

namespace GNET
{

class AudienceOperation : public GNET::Protocol
{
	#include "audienceoperation"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GCenter::AudienceOperation  ...room_id=%d",room_id);
		
		PVPMatch::GetInstance().AddAudienceOperation(room_id, operation);
	}
};

};

#endif
