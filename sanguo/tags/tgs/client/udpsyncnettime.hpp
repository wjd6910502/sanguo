
#ifndef __GNET_UDPSYNCNETTIME_HPP
#define __GNET_UDPSYNCNETTIME_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "udpsyncnettimere.hpp"

extern int64_t g_delay; 
extern int64_t g_offset;

namespace GNET
{

class UDPSyncNetTime : public GNET::Protocol
{
	#include "udpsyncnettime"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//TODO: account=>roleid
		//fprintf(stderr, "UDPSyncNetTime::Process, orignate_time=%ld, offset=%ld, delay=%ld\n", orignate_time, offset, delay);

		//timeval r_time;
		//gettimeofday(&r_time, NULL);
		//
		////计算的精度单位为微妙
		//UDPSyncNetTimeRe prot;
		//const char *a = Connection::GetInstance().GetAccount();
		//prot.account = Octets(a, strlen(a));
		//prot.orignate_time = orignate_time;
		//prot.receive_time  = r_time.tv_sec*1000000 + r_time.tv_usec;
		//prot.transmit_time = prot.receive_time;
		//			
		//if(delay!=0 && offset!=0)
		//{
		//	g_delay = delay;
		//	g_offset = offset;
		//}
		//manager->Send(sid, &prot);
	}
};

};

#endif
