
#ifndef __GNET_CONTINUE_HPP
#define __GNET_CONTINUE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include "glog.h"


namespace GNET
{

class Continue : public GNET::Protocol
{
	#include "continue"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "Continue::Process, reset=%d, sid=%u thread=%u", reset, sid, (unsigned int)pthread_self());

		Octets _server_rand2;
		if(!TransServer::GetInstance()->FindSessionAndChangeStatus(sid, TransServer::SESSION_STATUS_WAITING_CONTINUE, TransServer::SESSION_STATUS_PROCESSING_CONTINUE, _server_rand2)) return;

		manager->Send(sid, *this); //send back

		auto player = CACHE::PlayerManager::GetInstance().FindByTransSid(sid, false);
		if(!player) return;

		Thread::Mutex2::Scoped keeper(player->_lock);
		player->OnContinue(reset);

		TransServer::GetInstance()->FindSessionAndChangeStatus(sid, TransServer::SESSION_STATUS_PROCESSING_CONTINUE, TransServer::SESSION_STATUS_OK, _server_rand2);
	}
};

};

#endif
