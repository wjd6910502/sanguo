
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

		Thread::Mutex::Scoped keeper(player->_lock);

		player->UpdateLatency(client_send_time, server_send_time);
		player->UpdateActiveTime();

		timeval tv;
		gettimeofday(&tv,NULL);
		int64_t now_micro = tv.tv_sec*1000000+tv.tv_usec;
		server_send_time = (now_micro/1000)&0xffff;

		manager->Send(sid, this);
	}
};

};

#endif
