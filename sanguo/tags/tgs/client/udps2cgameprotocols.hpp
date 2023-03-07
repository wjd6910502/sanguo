
#ifndef __GNET_UDPS2CGAMEPROTOCOLS_HPP
#define __GNET_UDPS2CGAMEPROTOCOLS_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "commonmacro.h"
#include "connection.h"
#include "script_wrapper.h"
#include <lua.hpp>

extern lua_State *g_L;

namespace GNET
{

class UDPS2CGameProtocols : public GNET::Protocol
{
	#include "udps2cgameprotocols"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//printf("UDPS2CGameProtocols::Process, index=%d, protocols.size()=%lu, index_ack=%d\n", index, protocols.size(), index_ack);

		//check sig
		Octets tmp;
		tmp.push_back(&index, sizeof(index));
		for(auto it=protocols.begin(); it!=protocols.end(); ++it)
		{
			tmp.push_back(it->begin(), it->size());
		}
		tmp.push_back(&index_ack, sizeof(index_ack));
		tmp.push_back(&client_send_time, sizeof(client_send_time));
		tmp.push_back(&server_send_time, sizeof(server_send_time));
		if(signature != UDPSignature(tmp, Connection::GetInstance().GetKey1()))
		{
			//printf("UDPGameProtocol::Process, signature error, id=%ld, data=%.*s, signature=%d\n", id, (int)data.size(), (char*)data.begin(), signature);
			return;
		}

		Connection::GetInstance().UpdatePVPLatency(client_send_time, server_send_time);
		Connection::GetInstance().FastSess_OnAck(index_ack, false);

		for(auto it=protocols.begin(); it!=protocols.end(); ++it)
		{
			int idx = index+(it-protocols.begin());
			if(Connection::GetInstance().FastSess_IsReceived(idx, false)) continue;
			Connection::GetInstance().FastSess_SetReceived(idx, false);

			const Octets& data = *it;
			Connection::GetInstance().OnReceivedUDPGameProtocol(data);
		}
		if(!protocols.empty()) Connection::GetInstance().FastSess_SendAck(false);
	}
};

};

#endif
