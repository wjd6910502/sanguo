
#ifndef __GNET_PVPLEAVERE_HPP
#define __GNET_PVPLEAVERE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PvpLeaveRe : public GNET::Protocol
{
	#include "pvpleavere"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GAMED::PvpLeaveRe, roleid=%ld, result=%d, typ=%d, elo_score=%d, room_typ=%d, room_id=%d, video_flag=%d", 
				roleid, result, typ, elo_score, room_typ, room_id, video_flag);
		
		if(room_typ == 0)
		{
			char msg[256];
			snprintf(msg, sizeof(msg), "10014:%d:%d:%d:", result, typ, elo_score); //PvpEnd
			MessageManager::GetInstance().Put(roleid, roleid, msg, 0);
		}
		else if(room_typ == 1)
		{
			char msg[256];
			snprintf(msg, sizeof(msg), "63:%d:%d:%d:%d:", result, typ, room_id, video_flag); //YueZhanEnd
			MessageManager::GetInstance().Put(roleid, roleid, msg, 0);
		}
	}
};

};

#endif
