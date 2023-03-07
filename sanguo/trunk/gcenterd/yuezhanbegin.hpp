
#ifndef __GNET_YUEZHANBEGIN_HPP
#define __GNET_YUEZHANBEGIN_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "pvpmatch.h"

namespace GNET
{

class YueZhanBegin : public GNET::Protocol
{
	#include "yuezhanbegin"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GCenter::YueZhanBegin, create_id=%ld, join_id=%ld, room_id=%d", create_roleid, join_roleid, room_id);
		PVPMatch::GetInstance().YueZhanMatchSuccess(create_roleid, create_pvpinfo, create_key, join_roleid, 
				join_pvpinfo, join_key, zoneid, room_id, exe_version, data_version, pvp_ver);
	}
};

};

#endif
