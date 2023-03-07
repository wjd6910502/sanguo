
#ifndef __GNET_PVPCENTERCREATE_HPP
#define __GNET_PVPCENTERCREATE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PvpCenterCreate : public GNET::Protocol
{
	#include "pvpcentercreate"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GAMED::PvpCenterCreate, retcode=%d, roleid=%ld", retcode, roleid);

		Octets tmp_out;
		Base64Encoder::Convert(tmp_out, ip);

		if(retcode == 0)
		{
			char msg[256];
			snprintf(msg, sizeof(msg), "10013:%d:%d:%.*s:%d:", retcode, start_time, (int)tmp_out.size(),(char*)tmp_out.begin(), port); //PvpBegin
			MessageManager::GetInstance().Put(roleid, roleid, msg, 0);
		}
		else
		{
			char msg[256];
			snprintf(msg, sizeof(msg), "10016:%d:", retcode); //PvpError
			MessageManager::GetInstance().Put(roleid, roleid, msg, 0);
		}
	}
};

};

#endif
