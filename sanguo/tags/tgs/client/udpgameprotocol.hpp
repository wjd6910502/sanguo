
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
		//printf("UDPGameProtocol::Process, id=%ld, data=%.*s, signature=%d\n", id, (int)data.size(), (char*)data.begin(), signature);

		//check sig
		Octets tmp;
		tmp.push_back(&id, sizeof(id));
		tmp.push_back(data.begin(), data.size());
		if(signature != UDPSignature(tmp, Connection::GetInstance().GetKey1()))
		{
			printf("UDPGameProtocol::Process, signature error, id=%ld, data=%.*s, signature=%d\n", id, (int)data.size(), (char*)data.begin(), signature);
			return;
		}

		Connection::GetInstance().OnReceivedUDPGameProtocol(data);
	}
};

};

#endif
