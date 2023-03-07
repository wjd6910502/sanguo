
#ifndef __GNET_PVPRESET_HPP
#define __GNET_PVPRESET_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include "gcenterserver.hpp"
#include "pvpresetre.hpp"

namespace GNET
{

class PvpReset : public GNET::Protocol
{
	#include "pvpreset"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GCenter::PvpReset ...roleid=%ld ...index=%d",roleid, index);
		bool flag = PVPMatch::GetInstance().RolePvpReset(roleid, index);
		if(flag == false)
		{
			PvpResetRe pro;
			pro.retcode = 0;
			pro.roleid = roleid;
			GCenterServer::GetInstance()->DispatchProtocolBySid(sid, pro);
		}
	}
};

};

#endif
