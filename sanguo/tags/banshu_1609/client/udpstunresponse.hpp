
#ifndef __GNET_UDPSTUNRESPONSE_HPP
#define __GNET_UDPSTUNRESPONSE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class UDPSTUNResponse : public GNET::Protocol
{
	#include "udpstunresponse"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		fprintf(stderr, "UDPSTUNResponse::Process, magic=%d, client_ip=%.*s, client_port=%d\n",
		        magic, (int)client_ip.size(), (char*)client_ip.begin(), client_port);

		std::string s((char*)client_ip.begin(), client_ip.size());
		Connection::GetInstance().P2P_OnReceivedUDPSTUNResponse(magic, s.c_str(), client_port);
	}
};

};

#endif
