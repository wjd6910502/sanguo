
#ifndef __GNET_YUEZHANEND_HPP
#define __GNET_YUEZHANEND_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class YueZhanEnd : public GNET::Protocol
{
	#include "yuezhanend"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//约战结束的信息
		GLog::log(LOG_INFO, "GAMED::YueZhanEnd, room_id=%d, video_id=%ld", room_id, video_id);

		char msg[100];
		std::string result, index_info;
		Octets video;
		snprintf(msg, sizeof(msg), "%ld", video_id);
		index_info = msg;

		memset(msg, 0, sizeof(msg));
		snprintf(msg, sizeof(msg), "66:%d:%d:", 5, room_id);
		
		result = msg;
		Base64Encoder::Convert(video, Octets((void*)index_info.c_str(), index_info.size()));
		result += std::string((char*)video.begin(), video.size());
		result += ":";
		MessageManager::GetInstance().Put(0, 0, result.c_str(), 1);

	}
};

};

#endif
