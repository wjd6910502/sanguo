
#ifndef __GNET_UDPGAMEPROTOCOL_HPP
#define __GNET_UDPGAMEPROTOCOL_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "connection.h"

namespace GNET
{

class UDPGameProtocol : public GNET::Protocol
{
	#include "udpgameprotocol"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//fprintf(stderr, "UDPGameProtocol::Process, data=%s\n", B16EncodeOctets(data).c_str());
		//fprintf(stderr, "UDPGameProtocol::Process, data=%.*s\n", (int)data.size(), (char*)data.begin());
		//printf("UDPGameProtocol::Process, data=%.*s\n", (int)data.size(), (char*)data.begin());

		Connection::GetInstance().OnReceivedUDPGameProtocol(data);
	}
};

};

#endif
