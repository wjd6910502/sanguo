
#ifndef __GNET_LAOHU_CHECKTOKEN_RE_HPP
#define __GNET_LAOHU_CHECKTOKEN_RE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "gateserver.hpp"

namespace GNET
{

class Laohu_CheckToken_Re : public GNET::Protocol
{
	#include "laohu_checktoken_re"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "Laohu_CheckToken_Re::Process, retcode=%d, account=%.*s, token=%.*s, client_sid=%d, _key1.size()=%u",
		          retcode, (int)account.size(), (char*)account.begin(), (int)token.size(), (char*)token.begin(), client_sid, (unsigned int)_key1.size());

		Octets server_rand1;
		Octets trans_token;
		if(!GateServer::GetInstance()->FindSessionAndChangeStatus(client_sid, GateServer::SESSION_STATUS_WAITING_CHECKTOKEN_RE, GateServer::SESSION_STATUS_PROCESSING_CHECKTOKEN_RE, server_rand1, trans_token)) return;

		if(retcode != 0)
		{
			AuthResult prot;
			prot.retcode = ERR_CODE_WRONG_ACCOUNT_OR_PASSWORD;
			GateServer::GetInstance()->Send(client_sid, prot);
			return;
		}

		//GateServer::GetInstance()->MapAccount(account, client_sid); //TODO:
		//Auth OK
		CACHE::PlayerManager::GetInstance().OnConnect(account, trans_token, _key1);

		AuthResult prot;
		prot.retcode = 0;
		prot.trans_ip = TransServer::GetInstance()->GetPublicAddress();
		prot.trans_port = 65536-TransServer::GetInstance()->GetPublicPort(); //TODO:
		prot.udp_trans_ip = UDPTransServer::GetInstance()->GetPublicAddress();
		prot.udp_trans_port = 65536-UDPTransServer::GetInstance()->GetPublicPort();
		prot.stund_ip = STUNGameClient::GetInstance()->GetStundPublicAddress();
		prot.stund_port = STUNGameClient::GetInstance()->GetStundPublicPort();
		prot.trans_token = trans_token;

		//sign
		Octets tmp;
		tmp.push_back(&prot.retcode, sizeof(prot.retcode));
		tmp.push_back(prot.trans_ip.begin(), prot.trans_ip.size());
		tmp.push_back(&prot.trans_port, sizeof(prot.trans_port));
		tmp.push_back(prot.udp_trans_ip.begin(), prot.udp_trans_ip.size());
		tmp.push_back(&prot.udp_trans_port, sizeof(prot.udp_trans_port));
		tmp.push_back(prot.stund_ip.begin(), prot.stund_ip.size());
		tmp.push_back(&prot.stund_port, sizeof(prot.stund_port));
		tmp.push_back(prot.trans_token.begin(), prot.trans_token.size());
		prot.signature = UDPSignature(tmp, _key1);

		GateServer::GetInstance()->Send(client_sid, prot);

		GLog::log(LOG_INFO, "Laohu_CheckToken_Re::Process, client_sid=%u, thread=%u, account=%.*s\n",
		          client_sid, (unsigned int)pthread_self(), (int)account.size(), (char*)account.begin());

		GateServer::GetInstance()->FindSessionAndChangeStatus(client_sid, GateServer::SESSION_STATUS_PROCESSING_CHECKTOKEN_RE, GateServer::SESSION_STATUS_OK, server_rand1, trans_token);
	}
};

};

#endif
