
#ifndef __GNET_UPDATEDANMUINFO_HPP
#define __GNET_UPDATEDANMUINFO_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class UpdateDanMuInfo : public GNET::Protocol
{
	#include "updatedanmuinfo"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//µ¯Ä»ÐÅÏ¢
		GLog::log(LOG_INFO, "GAMED::UpdateDanMuInfo, id=%ld, roleid=%ld", id, role_id);

		Octets name, danmu, role_id_in, role_id_out;
		Base64Encoder::Convert(name, role_name);
		Base64Encoder::Convert(danmu, danmu_info);
		
		std::string msg = "64:";
		
		char tick_info[1024];
		snprintf(tick_info, sizeof(tick_info), "%ld", role_id);
		std::string tick_str = tick_info;
		role_id_in = Octets((void*)tick_str.c_str(), tick_str.size());
		Base64Encoder::Convert(role_id_out, role_id_in);

		msg += std::string((char*)role_id_out.begin(), role_id_out.size());
		msg += ":";

		msg += std::string((char*)name.begin(), name.size());
		msg += ":";

		memset(tick_info, 0, sizeof(tick_info));
		snprintf(tick_info, sizeof(tick_info), "%d:", tick);
		msg += tick_info;

		msg += std::string((char*)danmu.begin(), danmu.size());
		msg += ":";

		MessageManager::GetInstance().Put(id, id, msg.c_str(), 0);
	}
};

};

#endif
