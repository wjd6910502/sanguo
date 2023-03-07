
#ifndef __GNET_AUDIENCEGETOPERATION_HPP
#define __GNET_AUDIENCEGETOPERATION_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class AudienceGetOperation : public GNET::Protocol
{
	#include "audiencegetoperation"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		PVPMatch::GetInstance().AudienceGetRoomInfo(roleid, zoneid, room_id);
	}
};

};

#endif
