
#ifndef __GNET_UDPC2SGAMEPROTOCOLS_HPP
#define __GNET_UDPC2SGAMEPROTOCOLS_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "c2sgameprotocol"
#include "commonmacro.h"
#include "connection.h"
#include "script_wrapper.h"
#include <lua.hpp>

namespace GNET
{

class UDPC2SGameProtocols : public GNET::Protocol
{
	#include "udpc2sgameprotocols"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//printf("UDPC2SGameProtocols::Process, id=%ld, index=%d, protocols.size()=%lu, index_ack=%d\n", id, index, protocols.size(), index_ack);

		Connection *conn = ((UDPTransClient*)manager)->GetConnection();

		//Connection::GetInstance().FastSess_OnAck(index_ack, true);
		conn->FastSess_OnAck(index_ack, true);

		for(auto it=protocols.begin(); it!=protocols.end(); ++it)
		{
			int idx = index+(it-protocols.begin());
			//if(idx-1>0 && !Connection::GetInstance().FastSess_IsReceived(idx-1, true)) return; //正常必然连续的，跳为对端异常
			//if(Connection::GetInstance().FastSess_IsReceived(idx, true)) continue;
			//Connection::GetInstance().FastSess_SetReceived(idx, true);
			if(idx-1>0 && !conn->FastSess_IsReceived(idx-1, true)) return; //正常必然连续的，跳为对端异常
			if(conn->FastSess_IsReceived(idx, true)) continue;
			conn->FastSess_SetReceived(idx, true);

			const Octets& data = it->data;
			//Connection::GetInstance().OnReceivedUDPGameProtocol(data);
			conn->OnReceivedUDPGameProtocol(data);
		}
		//if(!protocols.empty()) Connection::GetInstance().FastSess_SendAck(true);
		if(!protocols.empty()) conn->FastSess_SendAck(true);
	}
};

};

#endif
