
#ifndef __GNET_UDPGAMEPROTOCOL_HPP
#define __GNET_UDPGAMEPROTOCOL_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class UDPGameProtocol : public GNET::Protocol
{
	#include "udpgameprotocol"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//GLog::log(LOG_INFO, "UDPGameProtocol::Process, data=%.*s, extra_roles.size()=%lu, extra_mafias.size()=%lu, extra_pvps.size()=%lu, sid=%u, thread=%u",
		//          (int)data.size(), (char*)data.begin(), extra_roles.size(), extra_mafias.size(), extra_pvps.size(), sid, (unsigned int)pthread_self());

		StatisticManager::GetInstance().IncUDPCmdCount();

		Player *player = PlayerManager::GetInstance().FindByRoleId(id);
		if(!player) return;

		//TODO: check sig

		Thread::Mutex::Scoped keeper(player->_lock);

		player->UpdateActiveTime();
		player->SetUDPTransSid(sid);

		GNET::Thread::Pool::_pool.AddSeqTask(player->GetHash()%100, new CommandTask(player, data, extra_roles, extra_mafias, extra_pvps));
	}
};

};

#endif
