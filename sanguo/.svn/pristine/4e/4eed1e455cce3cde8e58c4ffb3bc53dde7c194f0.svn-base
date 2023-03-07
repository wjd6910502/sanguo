
#ifndef __GNET_PVPCONTINUE_HPP
#define __GNET_PVPCONTINUE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "pvpmatch.h"

namespace GNET
{

class PVPContinue : public GNET::Protocol
{
	#include "pvpcontinue"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GCenter::PVPContinue, id=%d, fighter=%ld, continue_time=%d",
		          id, fighter, continue_time);

		PVPMatch::GetInstance().PvpdPvpContinue(this);
	}
};

};

#endif
