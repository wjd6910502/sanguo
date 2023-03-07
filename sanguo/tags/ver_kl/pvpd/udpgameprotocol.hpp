
#ifndef __GNET_UDPGAMEPROTOCOL_HPP
#define __GNET_UDPGAMEPROTOCOL_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include "glog.h"

namespace GNET
{

class UDPGameProtocol : public GNET::Protocol
{
	#include "udpgameprotocol"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "PVPD::UDPGameProtocol::Process, id=%ld, data=%.*s, sid=%u", id, (int)data.size(), (char*)data.begin(), sid);

		//StatisticManager::GetInstance().IncUDPCmdCount();
		
		Player *player = PlayerManager::GetInstance().Find(id);
		if(!player) return;
		
		//TODO: check sig
		
		player->SetUDPTransSid(sid);
		
		//data来自于客户端，必须严格检查
		if(data.size() < 2)
		{
			GLog::log(LOG_ERR, "PVPD::UDPGameProtocol::Process, wrong data length\n");
			return;
		}
		for(size_t i=0; i<data.size(); ++i)
		{
			int c = ((char*)data.begin())[i];
			if(!isupper(c) && !islower(c) && !isdigit(c) && c!='+' && c!='/' && c!='=' && c!=':' && c!='.')
			{
				GLog::log(LOG_ERR, "PVPD::UDPGameProtocol::Process, wrong char(%d)\n", c);
				return;
			}
		}
		std::string s((const char*)data.begin(), data.size());
		int cmd = atoi(s.c_str());
		if(cmd <= 0)
		{
			GLog::log(LOG_ERR, "PVPD::UDPGameProtocol::Process, wrong cmd(%d)\n", cmd);
			return;
		}

		player->OnCmd(s.c_str());
	}
};

};

#endif
