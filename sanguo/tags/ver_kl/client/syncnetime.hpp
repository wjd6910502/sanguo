
#ifndef __GNET_SYNCNETIME_HPP
#define __GNET_SYNCNETIME_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include <sstream>
#include <string>

#include "syncnetimere.hpp"

//extern int64_t g_delay;
//extern int64_t g_offset;


namespace GNET
{

class SyncNetime : public GNET::Protocol
{
	#include "syncnetime"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		assert(((TransClient*)manager)->GetCurSID() == (int)sid);
		//timeval r_time;
		//gettimeofday(&r_time, NULL);

		//计算的精度单位为微妙
		SyncNetimeRe prot;
		prot.orignate_time = orignate_time;
		//prot.receive_time  = r_time.tv_sec*1000000 + r_time.tv_usec;
		GameClient *gc = Connection::GetInstance().GetGameClient();
		prot.receive_time = gc->GetLocalTimeInMicroSec();
		prot.transmit_time = prot.receive_time;

		if(delay != 0 && offset != 0)
		{
			//g_delay = delay;
			//g_offset = offset;
			//fprintf(stderr,"--------------------------------------delay = %ld, offset = %ld\n", g_delay, g_offset);
			Connection::GetInstance().SetServerTimeOffset(offset);
		}
		manager->Send(sid, &prot);
	}
};

};

#endif
