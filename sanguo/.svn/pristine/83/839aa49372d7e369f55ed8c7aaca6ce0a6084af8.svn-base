
#ifndef __GNET_UDPP2PMAKEHOLE_HPP
#define __GNET_UDPP2PMAKEHOLE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include "udptransclient.hpp"

namespace GNET
{

class UDPP2PMakeHole : public GNET::Protocol
{
	#include "udpp2pmakehole"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		printf("UDPP2PMakeHole::Process, magic=%d, request=%d, sid=%u\n", magic, request, sid);

		//const SockAddr *client_addr = UDPTransClient::GetInstance()->GetSockAddrBySid(sid);
		const SockAddr *client_addr = ((UDPTransClient*)manager)->GetSockAddrBySid(sid);
		if(!client_addr) return;

		const struct sockaddr_in *si = (const struct sockaddr_in*)*client_addr;

		char client_ip[128];
		inet_ntop(AF_INET, &si->sin_addr, client_ip, sizeof(client_ip));

		Connection *conn = ((UDPTransClient*)manager)->GetConnection();

		//Connection::GetInstance().P2P_OnConnect(magic, client_ip, ntohs(si->sin_port));
		conn->P2P_OnConnect(magic, client_ip, ntohs(si->sin_port));

		if(request)
		{
			UDPP2PMakeHole prot;
			prot.magic = magic;
			prot.request = 0;
			manager->Send(sid, prot);
		}
	}
};

};

#endif
