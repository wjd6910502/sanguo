
#ifndef __GNET_AUDIENCESENDOPERATION_HPP
#define __GNET_AUDIENCESENDOPERATION_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class AudienceSendOperation : public GNET::Protocol
{
	#include "audiencesendoperation"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GAMED::AudienceSendOperation, roleid=%ld", roleid);

		Octets result_operation;
		Base64Encoder::Convert(result_operation, operation);

		string msg;
		char win_flag[1024];
		snprintf(win_flag, sizeof(win_flag), "53:%d:", room_id);
		msg = win_flag;
		msg += std::string((char*)result_operation.begin(), result_operation.size());
		msg += ":";

		MessageManager::GetInstance().Put(roleid, roleid, msg.c_str(), 0);
	}
};

};

#endif
