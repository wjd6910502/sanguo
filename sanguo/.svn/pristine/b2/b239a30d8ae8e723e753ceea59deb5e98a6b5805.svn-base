
#ifndef __GNET_UDPKEEPALIVE_HPP
#define __GNET_UDPKEEPALIVE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class UDPKeepAlive : public GNET::Protocol
{
	#include "udpkeepalive"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//printf("UDPKeepAlive::Process\n");
		Connection *conn = ((UDPTransClient*)manager)->GetConnection();

		//Connection::GetInstance().UpdateUDPLatency(client_send_time, server_send_time);
		conn->UpdateUDPLatency(client_send_time, server_send_time);
	}
};

};

#endif
