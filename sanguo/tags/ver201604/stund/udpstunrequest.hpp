
#ifndef __GNET_UDPSTUNREQUEST_HPP
#define __GNET_UDPSTUNREQUEST_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include "stunserver.hpp"

namespace GNET
{

class UDPSTUNRequest : public GNET::Protocol
{
	#include "udpstunrequest"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "STUND::UDPSTUNRequest::Process, magic=%d, change_ip=%d, change_port=%d, sid=%u",
		          magic, change_ip, change_port, sid);

		//StatisticManager::GetInstance().IncUDPCmdCount();

		if(change_ip || change_port)
		{
			GLog::log(LOG_ERR, "STUND::UDPSTUNRequest::Process, magic=%d, change_ip=%d, change_port=%d, sid=%u",
			          magic, change_ip, change_port, sid);
			return;
		}

		const SockAddr *client_addr = STUNServer::GetInstance()->GetSockAddrBySid(sid);
		if(!client_addr) return;

		const struct sockaddr_in *si = (const struct sockaddr_in*)*client_addr;

		char client_ip[128];
		inet_ntop(AF_INET, &si->sin_addr, client_ip, sizeof(client_ip));

		UDPSTUNResponse prot;
		prot.magic = magic;
		prot.client_ip = Octets(client_ip, strlen(client_ip));
		prot.client_port = ntohs(si->sin_port);
		
		manager->Send(sid, prot);
	}
};

};

#endif
