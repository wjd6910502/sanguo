
#ifndef __GNET_FORWARDUDPSTUNREQUEST_HPP
#define __GNET_FORWARDUDPSTUNREQUEST_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include "stunserver.hpp"
#include "stundeafserver.hpp"

namespace GNET
{

class ForwardUDPSTUNRequest : public GNET::Protocol
{
	#include "forwardudpstunrequest"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "STUND::ForwardUDPSTUNRequest::Process, magic=%d, client_ip=%.*s, client_port=%d",
		          magic, (int)client_ip.size(), (char*)client_ip.begin(), client_port);

		UDPSTUNResponse prot;
		prot.magic = magic;
		prot.client_ip = client_ip;
		prot.client_port = client_port;
		
		std::string s((char*)client_ip.begin(), client_ip.size());
		STUNDeafServer::GetInstance()->SendTo(s.c_str(), client_port, prot);
	}
};

};

#endif
