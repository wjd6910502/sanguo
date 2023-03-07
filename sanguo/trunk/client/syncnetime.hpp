
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
		//assert(((TransClient*)manager)->GetCurSID() == (int)sid);
		if(((TransClient*)manager)->GetCurSID()!=(int)sid) return;

		//timeval r_time;
		//gettimeofday(&r_time, NULL);

		Connection *conn = ((TransClient*)manager)->GetConnection();

		//计算的精度单位为微妙
		SyncNetimeRe prot;
		//GameClient *gc = Connection::GetInstance().GetGameClient();
		GameClient *gc = conn->GetGameClient();
		prot.id = gc->GetRoleId();
		prot.orignate_time = orignate_time;
		//prot.receive_time  = r_time.tv_sec*1000000 + r_time.tv_usec;
		int64_t localTime = gc->GetLocalTimeInMicroSec();
		prot.receive_time = localTime;
		prot.transmit_time = localTime;
		prot.client_send_time = (unsigned short)((localTime/1000)&0xffff);
		//unsigned short t = Connection::GetInstance().GetPrevServerSendTime4TCP();
		unsigned short t = conn->GetPrevServerSendTime4TCP();
		if(t==0)
		{
			prot.server_send_time = 0;
		}
		else
		{
			//prot.server_send_time = (unsigned short)(t + (localTime-Connection::GetInstance().GetPrevServerSendTime4TCPLocalTime())/1000);
			prot.server_send_time = (unsigned short)(t + (localTime-conn->GetPrevServerSendTime4TCPLocalTime())/1000);
		}

		if(delay != 0 && offset != 0)
		{
			//g_delay = delay;
			//g_offset = offset;
			//fprintf(stderr,"--------------------------------------delay = %ld, offset = %ld\n", g_delay, g_offset);
			//Connection::GetInstance().SetServerTimeOffset(offset);
			conn->SetServerTimeOffset(offset);
		}
		manager->Send(sid, &prot);
	}
};

};

#endif
