
#ifndef __GNET_GETPVPVIDEO_HPP
#define __GNET_GETPVPVIDEO_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GetPvpVideo : public GNET::Protocol
{
	#include "getpvpvideo"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GCenter::GetPvpVideo ...roleid=%ld ...videoid=%.*s",roleid, (int)video_id.size(), (char*)video_id.begin());

		PVPMatch::GetInstance().RoleGetPvpVideo(roleid, zoneid, video_id);
	}
};

};

#endif
