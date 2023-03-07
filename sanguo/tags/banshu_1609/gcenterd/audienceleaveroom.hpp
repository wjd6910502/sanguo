
#ifndef __GNET_AUDIENCELEAVEROOM_HPP
#define __GNET_AUDIENCELEAVEROOM_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class AudienceLeaveRoom : public GNET::Protocol
{
	#include "audienceleaveroom"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		PVPMatch::GetInstance().AudienceLeave(roleid, room_id);
	}
};

};

#endif
