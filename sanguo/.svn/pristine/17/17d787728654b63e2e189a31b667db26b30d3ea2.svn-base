
#ifndef __GNET_AUDIENCEGETOPERATIONRE_HPP
#define __GNET_AUDIENCEGETOPERATIONRE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class AudienceGetOperationRe : public GNET::Protocol
{
	#include "audiencegetoperationre"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GAMED::AudienceGetOperationRe, retcode=%d, roleid=%ld", retcode, roleid);

		Octets result_fight1, result_fight2, result_operation;
		Base64Encoder::Convert(result_fight1, fight1_pvpinfo);
		Base64Encoder::Convert(result_fight2, fight2_pvpinfo);
		Base64Encoder::Convert(result_operation, operation);
		
		string msg;

		char win_flag[1024];
		snprintf(win_flag, sizeof(win_flag), "52:%d:%d:%d:%d:", retcode, room_id, fight_robot, robot_seed);
		msg = win_flag;
		msg += std::string((char*)result_fight1.begin(), result_fight1.size());
		msg += ":";
		msg += std::string((char*)result_fight2.begin(), result_fight2.size());
		msg += ":";
		msg += std::string((char*)result_operation.begin(), result_operation.size());
		msg += ":";
		MessageManager::GetInstance().Put(roleid, roleid, msg.c_str(), 0);
	}
};

};

#endif
