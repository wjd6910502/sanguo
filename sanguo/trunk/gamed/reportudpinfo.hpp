
#ifndef __GNET_REPORTUDPINFO_HPP
#define __GNET_REPORTUDPINFO_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class ReportUDPInfo : public GNET::Protocol
{
	#include "reportudpinfo"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//GLog::log(LOG_INFO, "ReportUDPInfo::Process, net_type=%d, public_ip=%.*s, public_port=%d, local_ip=%.*s, local_port=%d, sid=%u, thread=%u",
		//          net_type, (int)public_ip.size(), (char*)public_ip.begin(), public_port, (int)local_ip.size(), (char*)local_ip.begin(), local_port,
		//          sid, (unsigned int)pthread_self());

		//Player *player = PlayerManager::GetInstance().FindByTransSid(sid, true);
		Player *player = PlayerManager::GetInstance().FindByTransSid(sid, false);
		if(!player) return;

		Thread::Mutex2::Scoped keeper(player->_lock);

		GLog::log(LOG_INFO, "ReportUDPInfo::Process, account=%.*s, net_type=%d, public_ip=%.*s, public_port=%d, local_ip=%.*s, local_port=%d, sid=%u, thread=%u",
		          (int)player->GetAccount().size(), (char*)player->GetAccount().begin(), net_type, (int)public_ip.size(), (char*)public_ip.begin(),
		          public_port, (int)local_ip.size(), (char*)local_ip.begin(), local_port, sid, (unsigned int)pthread_self());

		player->UpdateUDPInfo(net_type, public_ip, public_port, local_ip, local_port);
	}
};

};

#endif
