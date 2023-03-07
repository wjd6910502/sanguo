
#ifndef __GNET_AUDIENCEFINISHROOM_HPP
#define __GNET_AUDIENCEFINISHROOM_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class AudienceFinishRoom : public GNET::Protocol
{
	#include "audiencefinishroom"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GAMED::AudienceFinishRoom, roleid=%ld, room_id=%d, win_flag=%d, reason=%d", roleid, room_id, win_flag, reason);

		Octets result_operation;
		Base64Encoder::Convert(result_operation, operation);

		string msg;
		char char_msg[1024];
		snprintf(char_msg, sizeof(char_msg), "54:%d:%d:%d:", room_id, win_flag, reason);
		msg = char_msg;
		msg += std::string((char*)result_operation.begin(), result_operation.size());
		msg += ":";

		MessageManager::GetInstance().Put(roleid, roleid, msg.c_str(), 0);
	}
};

};

#endif
