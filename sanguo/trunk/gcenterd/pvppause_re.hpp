
#ifndef __GNET_PVPPAUSE_RE_HPP
#define __GNET_PVPPAUSE_RE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PVPPause_Re : public GNET::Protocol
{
	#include "pvppause_re"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GCenter::PVPPause_Re, id=%d, fighter=%ld", id, fighter);
		
		PVPMatch::GetInstance().PvpdPvpPauseRe(id, fighter);
	}
};

};

#endif
