
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

		////GLog::log(LOG_INFO, "UDPC2SGameProtocols::Process, account=%.*s, index=%d, protocols.size()=%lu, tv=%ld, index_ack=%d, sid=%u, thread=%u",
		////          (int)account.size(), (char*)account.begin(), index, protocols.size(), (int64_t)tv.tv_sec*1000000+tv.tv_usec, index_ack, sid,
		////          (unsigned int)pthread_self());

		//StatisticManager::GetInstance().IncUDPC2SCmdCount(protocols.size());

		//Player *player = PlayerManager::GetInstance().FindByRoleId(id);
		//if(!player) return;

		////TODO: check sig

		//Thread::Mutex2::Scoped keeper(player->_lock);

		//player->UpdateActiveTime();
		//player->SetUDPTransSid(sid);

		//player->FastSess_OnAck(index_ack);

		//for(auto it=protocols.begin(); it!=protocols.end(); ++it)
		//{
		//	int idx = index+(it-protocols.begin());
		//	if(idx-1>0 && !player->FastSess_IsReceived(idx-1)) return; //正常必然连续的，跳为对端异常
		//	if(player->FastSess_IsReceived(idx)) continue;
		//	player->FastSess_SetReceived(idx);

		//	StatisticManager::GetInstance().IncUDPCmdCount();

		//	GNET::Thread::Pool::_pool.AddSeqTask(player->GetHash()%100,
		//	                                     new CommandTask(player, it->data, it->extra_roles, it->extra_mafias, it->extra_pvps));
		//}
		//if(!protocols.empty()) player->FastSess_SendAck();
	}
};

};

#endif
