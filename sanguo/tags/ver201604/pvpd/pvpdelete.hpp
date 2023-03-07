
#ifndef __GNET_PVPDELETE_HPP
#define __GNET_PVPDELETE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PVPDelete : public GNET::Protocol
{
	#include "pvpdelete"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "PVPD::PVPDelete::Process, id=%d, video_flag=%d, sid=%u", id, video_flag, sid);

		if(video_flag == 1)
		{
			PVPManager::GetInstance().SendOperation(id, win_flag);
		}
		PVPManager::GetInstance().Delete(id);
	}
};

};

#endif
