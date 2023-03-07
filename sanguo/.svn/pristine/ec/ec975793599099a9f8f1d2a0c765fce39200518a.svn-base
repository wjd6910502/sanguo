
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
		//GLog::log(LOG_INFO, "UDPGameProtocol::Process, id=%ld, data=%.*s, signature=%d, sid=%u, thread=%u",
		//          id, (int)data.size(), (char*)data.begin(), signature, sid, (unsigned int)pthread_self());

		StatisticManager::GetInstance().IncUDPCmdCount();

		Player *player = PlayerManager::GetInstance().FindByRoleId(id);
		if(!player) return;

		Thread::Mutex::Scoped keeper(player->_lock);

		//check sig
		Octets tmp;
		tmp.push_back(&id, sizeof(id));
		tmp.push_back(data.begin(), data.size());
		if(signature != UDPSignature(tmp, player->GetKey1()))
		{
			GLog::log(LOG_ERR, "UDPGameProtocol::Process, signature error, id=%ld, data=%.*s, signature=%d, sid=%u, thread=%u",
			          id, (int)data.size(), (char*)data.begin(), signature, sid, (unsigned int)pthread_self());
			return;
		}

		player->UpdateActiveTime();
		player->SetUDPTransSid(sid);

		GNET::Thread::Pool::_pool.AddSeqTask(player->GetHash()%100, new CommandTask(player, data));
	}
};

};

#endif
