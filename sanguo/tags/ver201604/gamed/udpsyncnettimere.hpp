
#ifndef __GNET_UDPSYNCNETTIMERE_HPP
#define __GNET_UDPSYNCNETTIMERE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class UDPSyncNetTimeRe : public GNET::Protocol
{
	#include "udpsyncnettimere"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//GLog::log(LOG_INFO, "UDPSyncNetTimeRe::Process, orignate_time=%ld, receive_time=%ld, transmit_time=%ld, account=%.*s, thread=%u",
		//          orignate_time, receive_time, transmit_time, (int)account.size(), (char*)account.begin(), (unsigned int)pthread_self());

		Player *player = PlayerManager::GetInstance().FindByRoleId(id);
		if(!player) return;

		//TODO: check sig

		Thread::Mutex::Scoped keeper(player->_lock);
		
		timeval ref_time;
		gettimeofday(&ref_time, NULL); //TODO:
		int64_t reference_time = ref_time.tv_sec*1000000 + ref_time.tv_usec;
		int64_t delay = (reference_time - orignate_time) - (transmit_time - receive_time); //网络延时
		int64_t offset = ((receive_time - orignate_time) + (transmit_time - reference_time))/2; //客户端与服务器时间差

		player->GetNetworkTime().EstimateNTP(delay, offset);
	}
};

};

#endif
