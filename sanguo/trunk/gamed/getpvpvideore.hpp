
#ifndef __GNET_GETPVPVIDEORE_HPP
#define __GNET_GETPVPVIDEORE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include <sstream>

#include "pvpvideodata"

namespace GNET
{

class GetPvpVideoRe : public GNET::Protocol
{
	#include "getpvpvideore"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GAMED::GetPvpVideoRe, retcode=%d, roleid=%ld, video=%d", retcode, roleid, (int)video.size());

		if(retcode == 0)
		{
			Marshal::OctetsStream os(video);
			PvpVideoData data;

			data.unmarshal(os);
				
			Octets first, second, first_pvpinfo, second_pvpinfo, operation, danmu;
			Octets exe_ver, data_ver, video_info;

			//Base64Encoder::Convert(first, data.first);
			//Base64Encoder::Convert(second, data.second);
			Base64Encoder::Convert(first_pvpinfo, data.first_pvpinfo);
			Base64Encoder::Convert(second_pvpinfo, data.second_pvpinfo);
			Base64Encoder::Convert(operation, data.operation);
			Base64Encoder::Convert(exe_ver, data.exe_ver);
			Base64Encoder::Convert(data_ver, data.data_ver);
			Base64Encoder::Convert(danmu, danmu_info);
			Base64Encoder::Convert(video_info, video_id);
			//danmu = danmu_info;
				
			char win_flag[1024];
			string msg = "10023:";
			std::stringstream tmp_stream;
			tmp_stream << data.first << ":" << data.second << ":";
			string tmp;
			tmp_stream >> tmp;
			msg += tmp;
			//msg += std::string((char*)first.begin(), first.size());
			//msg += ":";
			//msg += std::string((char*)second.begin(), second.size());
			//msg += ":";
			msg += std::string((char*)first_pvpinfo.begin(), first_pvpinfo.size());
			msg += ":";
			msg += std::string((char*)second_pvpinfo.begin(), second_pvpinfo.size());
			msg += ":";
			msg += std::string((char*)operation.begin(), operation.size());
			msg += ":";
			snprintf(win_flag, sizeof(win_flag), "%d:%d:%d:%d:%d:", data.win_flag, data.robot_flag, data.robot_seed, data.robot_type, data.pvp_ver);
			msg += win_flag;
			msg += std::string((char*)exe_ver.begin(), exe_ver.size());
			msg += ":";
			msg += std::string((char*)data_ver.begin(), data_ver.size());
			msg += ":";
			msg += std::string((char*)danmu.begin(), danmu.size());
			msg += ":";
			msg += std::string((char*)video_info.begin(), video_info.size());
			msg += ":";
			MessageManager::GetInstance().Put(roleid, roleid, msg.c_str(), 0);
		}
		else
		{
			char msg[128];
			snprintf(msg, sizeof(msg), "10022:%d:", retcode); //PvpGetVideoErr
			MessageManager::GetInstance().Put(roleid, roleid, msg, 0);
		}

	}
};

};

#endif
