
#ifndef __GNET_KEEPALIVE_HPP
#define __GNET_KEEPALIVE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class KeepAlive : public GNET::Protocol
{
	#include "keepalive"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//GLog::log(LOG_INFO, "KeepAlive::Process");

		Player *player = PlayerManager::GetInstance().FindByTransSid(sid, true);
		if(!player) return;

		//Thread::Mutex2::Scoped keeper(player->_lock);

		player->UpdateLatency(client_send_time, server_send_time);
		player->UpdateActiveTime_NOLOCK();

		server_send_time = (NowUS()/1000)&0xffff;
		server_received_count = player->GetServerReceivedGameProtocolCount();

		manager->Send(sid, this);
	}
};

};

#endif
