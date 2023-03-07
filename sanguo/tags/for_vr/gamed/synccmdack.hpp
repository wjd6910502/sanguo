
#ifndef __GNET_SYNCCMDACK_HPP
#define __GNET_SYNCCMDACK_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class SyncCmdAck : public GNET::Protocol
{
	#include "synccmdack"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//GLog::log(LOG_INFO, "SyncCmdAck::Process, command=%.*s, version=%d, sid=%u, thread=%u",
		//          (int)command.size(), (char*)command.begin(), version, sid, (unsigned int)pthread_self());

		//Player *player = PlayerManager::GetInstance().FindByTransSid(sid, true);
		//if(!player) return;

		//Thread::Mutex::Scoped keeper(player->_lock);

		//player->UpdateActiveTime();

		//std::string cmd((char*)command.begin(), command.size());
		//Int ver;
		//ver._value = version;
		//player->_role._synced_version.Insert(cmd, ver);
	}
};

};

#endif
