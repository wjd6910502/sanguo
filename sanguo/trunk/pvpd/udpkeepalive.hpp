
#ifndef __GNET_UDPKEEPALIVE_HPP
#define __GNET_UDPKEEPALIVE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include "playermanager.h"


namespace GNET
{

class UDPKeepAlive : public GNET::Protocol
{
	#include "udpkeepalive"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//GLog::log(LOG_INFO, "PVPD::UDPKeepAlive::Process, id=%ld, sid=%u", id, sid);
		//
		//Player *player = PlayerManager::GetInstance().Find(id);
		//if(!player) return;
		//
		////TODO: check sig
		//
		//player->SetUDPTransSid(sid);
		//
		//manager->Send(sid, this);
	}
};

};

#endif
