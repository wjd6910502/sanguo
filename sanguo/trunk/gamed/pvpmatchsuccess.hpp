
#ifndef __GNET_PVPMATCHSUCCESS_HPP
#define __GNET_PVPMATCHSUCCESS_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PvpMatchSuccess : public GNET::Protocol
{
	#include "pvpmatchsuccess"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GAMED::PvpMatchSuccess, roleid=%ld, retcode=%d, index=%d, time=%d, room_id=%d", 
				roleid, retcode, index, time, room_id);
		
		char msg[100];
		snprintf(msg, sizeof(msg), "10010:%d:%d:%d:%d:", retcode, index, time, room_id); //PVPMatchSuccess
		MessageManager::GetInstance().Put(roleid, roleid, msg, 0);
		if(room_id != 0)
		{
			std::string result;
			memset(msg, 0, sizeof(msg));
			snprintf(msg, sizeof(msg), "%d", index);
			std::string index_info = msg;
			Octets index_out;

			memset(msg, 0, sizeof(msg));
			snprintf(msg, sizeof(msg), "66:%d:%d:", 3, room_id); 

			result = msg;
			Base64Encoder::Convert(index_out, Octets((void*)index_info.c_str(), index_info.size()));
			result += std::string((char*)index_out.begin(), index_out.size());
			result += ":";
			MessageManager::GetInstance().Put(0, 0, result.c_str(), 0);
		}
	}
};

};

#endif
