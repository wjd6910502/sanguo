
#ifndef __GNET_UDPKEEPALIVE_HPP
#define __GNET_UDPKEEPALIVE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class UDPKeepAlive : public GNET::Protocol
{
	#include "udpkeepalive"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//GLog::log(LOG_INFO, "UDPKeepAlive::Process, account=%.*s", (int)account.size(), (char*)account.begin());

		Player *player = PlayerManager::GetInstance().FindByRoleId(id);
		if(!player) return;

		Thread::Mutex2::Scoped keeper(player->_lock);

		//player->UpdateActiveTime_NOLOCK();
		//player->SetUDPTransSid(sid);
		player->UpdateUDPLatency(client_send_time, server_send_time);

		int64_t now_micro = NowUS();
		server_send_time = (now_micro/1000)&0xffff;

		manager->Send(sid, this);
	}
};

};

#endif
