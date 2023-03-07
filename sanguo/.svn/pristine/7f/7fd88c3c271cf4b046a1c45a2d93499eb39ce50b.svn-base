
#ifndef __GNET_UDPC2SGAMEPROTOCOLS_HPP
#define __GNET_UDPC2SGAMEPROTOCOLS_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "c2sgameprotocol"

namespace GNET
{

class UDPC2SGameProtocols : public GNET::Protocol
{
	#include "udpc2sgameprotocols"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//timeval tv;
		//gettimeofday(&tv, 0);
		//GLog::log(LOG_INFO, "PVPD::UDPC2SGameProtocols::Process, id=%ld, index=%d, protocols.size()=%lu, index_ack=%d, tv=%ld, sid=%u",
		//          id, index, protocols.size(), index_ack, (int64_t)tv.tv_sec*1000000+tv.tv_usec, sid);

		//StatisticManager::GetInstance().IncUDPC2SCmdCount(protocols.size());
		
		Player *player = PlayerManager::GetInstance().Find(id);
		if(!player) return;
		
		//TODO: check sig
		
		player->SetUDPTransSid(sid);
		
		player->FastSess_OnAck(index_ack);
		
		for(auto it=protocols.begin(); it!=protocols.end(); ++it)
		{
		        int idx = index+(it-protocols.begin());
		        if(idx-1>0 && !player->FastSess_IsReceived(idx-1)) return; //正常必然连续的，跳为对端异常
		        if(player->FastSess_IsReceived(idx)) continue;
		        player->FastSess_SetReceived(idx);
		
		        //StatisticManager::GetInstance().IncUDPCmdCount();
		
			C2SGameProtocol prot = *it;
			//data来自于客户端，必须严格检查
			if(prot.data.size() < 2)
			{
				GLog::log(LOG_ERR, "PVPD::UDPC2SGameProtocols::Process, wrong data length, idx=%d\n", idx);
				return;
			}
			for(size_t i=0; i<prot.data.size(); ++i)
			{
				int c = ((char*)prot.data.begin())[i];
				if(!isupper(c) && !islower(c) && !isdigit(c) && c!='+' && c!='/' && c!='=' && c!=':' && c!='.')
				{
					GLog::log(LOG_ERR, "PVPD::UDPGameProtocol::Process, wrong char(%d), idx=%d\n", c, idx);
					return;
				}
			}
			std::string s((const char*)prot.data.begin(), prot.data.size());
			int cmd = atoi(s.c_str());
			if(cmd <= 0)
			{
				GLog::log(LOG_ERR, "PVPD::UDPGameProtocol::Process, wrong cmd(%d), idx=%d\n", cmd, idx);
				return;
			}

			player->OnCmd(s.c_str());
		}
		if(!protocols.empty()) player->FastSess_SendAck();
	}
};

};

#endif
