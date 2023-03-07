
#ifndef __GNET_PVPENTERRE_HPP
#define __GNET_PVPENTERRE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "base64.h"

namespace GNET
{

class PvpEnterRe : public GNET::Protocol
{
	#include "pvpenterre"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GAMED::PvpEnterRe, roleid=%ld", roleid);

		Octets role_out, fight_out;

		Base64Encoder::Convert(role_out, pvpinfo);
		Base64Encoder::Convert(fight_out, fight_pvpinfo);
		
		std::string player1 = (char*)role_out.begin();
		std::string player2 = (char*)fight_out.begin();

		char msg[4096];
		snprintf(msg, sizeof(msg), "10012:%.*s:%.*s:%d:%d:",(int)role_out.size(), (char*)role_out.begin(), 
				(int)fight_out.size(),(char*)fight_out.begin(),robot_flag,robot_seed); //PVPEnterRe
		MessageManager::GetInstance().Put(roleid, roleid, msg, 0);
	}
};

};

#endif
