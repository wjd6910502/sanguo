
#ifndef __GNET_SYNCNETIMERE_HPP
#define __GNET_SYNCNETIMERE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

namespace GNET
{

class SyncNetimeRe : public GNET::Protocol
{
	#include "syncnetimere"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//GLog::log(LOG_INFO, "SyncNetTimeRe::Process, sid=%u, orignate_time=%ld, receive_time=%ld, transmit_time=%ld, thread=%u",
		//          sid, orignate_time, receive_time, transmit_time, (unsigned int)pthread_self());

		//Player *player = PlayerManager::GetInstance().FindByTransSid(sid, true);
		Player *player = PlayerManager::GetInstance().FindByTransSid(sid, false);
		if(!player) return;

		Thread::Mutex2::Scoped keeper(player->_lock);

		GLog::log(LOG_INFO, "SyncNetTimeRe::Process, roleid=%ld, orignate_time=%ld, receive_time=%ld, transmit_time=%ld, thread=%u",
		          (int64_t)player->_role._roledata._base._id, orignate_time, receive_time, transmit_time, (unsigned int)pthread_self());

		player->UpdateLatency(client_send_time, server_send_time);
		
		int64_t reference_time = NowUS();
		int64_t delay = (reference_time - orignate_time) - (transmit_time - receive_time); //网络延时
		int64_t offset = ((receive_time - orignate_time) + (transmit_time - reference_time))/2; //客户端与服务器时间差

		player->GetNetworkTime().EstimateNTP(id, delay, offset);
	}
};

};

#endif
