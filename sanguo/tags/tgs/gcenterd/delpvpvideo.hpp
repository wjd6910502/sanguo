
#ifndef __GNET_DELPVPVIDEO_HPP
#define __GNET_DELPVPVIDEO_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class DelPvpVideo : public GNET::Protocol
{
	#include "delpvpvideo"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GCenter::DelPvpVideo ...roleid=%ld ...videoid=%.*s",roleid, (int)video_id.size(), (char*)video_id.begin());
		
		PVPMatch::GetInstance().RoleDelPvpVideo(roleid, video_id);
	}
};

};

#endif
