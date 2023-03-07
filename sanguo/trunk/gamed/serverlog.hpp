
#ifndef __GNET_SERVERLOG_HPP
#define __GNET_SERVERLOG_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class ServerLog : public GNET::Protocol
{
	#include "serverlog"


	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//GLog::log(LOG_INFO, "ServerLog::Process");

		int64_t roleid = 0;
		//Player *player = PlayerManager::GetInstance().FindByTransSid(sid, true);
		Player *player = PlayerManager::GetInstance().FindByTransSid(sid, false);
		if(player) roleid=player->GetRoleId(); //no lock

		std::string l;
		for(size_t i=0; i<logs.size(); ++i)
		{
			GLog::log(LOG_INFO, "ServerLog(roleid=%lu, sid=%u): %.*s", roleid, sid, (int)logs[i].size(), (char*)logs[i].begin());

			l += "]]]|[[[";
			std::string tl((char*)logs[i].begin(), logs[i].size());
			l += tl;
		}
		//GLog::log(LOG_INFO, "ServerLog(sid=%u): %s", sid, l.c_str());

#if 0
		static FILE *fp = 0;
		static Thread::Mutex2 fp_lock;

		{
			Thread::Mutex2::Scoped keeper(fp_lock);

			if(!fp)
			{
				fp = fopen("./client_logs.txt", "w");
			}
			if(fp)
			{
				fprintf(fp, "roleid=%lu, sid=%u: %s\n", roleid, sid, l.c_str());
				fflush(fp);
			}
		}
#endif
	}
};

};

#endif
