
#ifndef __GNET_PVPDANMU_HPP
#define __GNET_PVPDANMU_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PvpDanMu : public GNET::Protocol
{
	#include "pvpdanmu"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GCenter::PvpDanMu, pvp_id=%d, video_id=%ld, tick=%d, danmu_info=%.*s", pvp_id, video_id, tick, 
				(int)danmu_info.size(), (char*)danmu_info.begin());
		
		PVPMatch::GetInstance().PvpDanMu(role_id, role_name, zone_id, pvp_id, video_id, tick, danmu_info);
	}
};

};

#endif
