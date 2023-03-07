
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

		//TODO: check sig

		Thread::Mutex::Scoped keeper(player->_lock);

		player->UpdateActiveTime();
		player->SetUDPTransSid(sid);

		manager->Send(sid, this);
	}
};

};

#endif
