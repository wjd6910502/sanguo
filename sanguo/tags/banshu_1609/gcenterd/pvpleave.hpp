
#ifndef __GNET_PVPLEAVE_HPP
#define __GNET_PVPLEAVE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PvpLeave : public GNET::Protocol
{
	#include "pvpleave"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GCenter::PvpLeave ...roleid=%ld ...index=%d ...reason=%d ...typ=%d",roleid, index, reason, typ);
		
		PVPMatch::GetInstance().RolePvpLeave(roleid, index, reason, typ);
	}
};

};

#endif
