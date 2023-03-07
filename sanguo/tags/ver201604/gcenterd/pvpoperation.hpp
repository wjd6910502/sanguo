
#ifndef __GNET_PVPOPERATION_HPP
#define __GNET_PVPOPERATION_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "pvpvideo"

namespace GNET
{

class PvpOperation : public GNET::Protocol
{
	#include "pvpoperation"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GCenter::PvpOperation  ...fighter1=%ld ...fighter2=%ld ...size()=%d",first, second, (int)operation.size());

		PVPMatch::GetInstance().PvpOperation(first, second, first_pvpinfo, second_pvpinfo, first_zoneid, second_zoneid, operation, win_flag);
	}
};

};

#endif
