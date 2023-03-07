
#ifndef __GNET_AUTHRESULT_HPP
#define __GNET_AUTHRESULT_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "connection.h"
#include <assert.h>
#include "gateclient.hpp"

namespace GNET
{

class AuthResult : public GNET::Protocol
{
	#include "authresult"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		fprintf(stderr, "AuthResult::Process, retcode=%d, trans_ip=%.*s, trans_port=%d, udp_trans_ip=%.*s, udp_trans_port=%d, stund_ip=%.*s, stund_port=%d, trans_token=%s\n",
		        retcode, (int)trans_ip.size(), (char*)trans_ip.begin(), trans_port, (int)udp_trans_ip.size(), (char*)udp_trans_ip.begin(), udp_trans_port,
		        (int)stund_ip.size(), (char*)stund_ip.begin(), stund_port, B16EncodeOctets(trans_token).c_str());

		assert(((GateClient*)manager)->GetCurSID() == (int)sid);
		Connection::GetInstance().OnAuthResult(manager, sid, retcode, trans_ip, trans_port, udp_trans_ip, udp_trans_port, stund_ip,
		                                       stund_port, trans_token);
	}
};

};

#endif
