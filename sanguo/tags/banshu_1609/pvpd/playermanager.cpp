#include "playermanager.h"
#include "udpgameprotocol.hpp"
#include "pvpudptransserver.hpp"
#include "pvpmanager.h"
#include "commonmacro.h"

namespace GNET
{

void SplitLuaCmd(const char *cmd, std::vector<std::string>& parts)
{
	const char *b = cmd;
	while(b && *b!='\0')
	{
		const char *e = strchr(b, ':');
		if(!e) return;
		std::string p(b, e-b);
		parts.push_back(p);
		b = e+1;
	}
};

void Player::OnCmd(const char *cmd)
{
	std::vector<std::string> parts;
	SplitLuaCmd(cmd, parts);
	if(parts.empty()) return;

	int type = atoi(parts[0].c_str());
	if(type == 10306) //PVPOpeartion
	{
		if(parts.size() != 4) return;

		PVP *pvp = PVPManager::GetInstance().Find(_pvp_id);
		if(!pvp) return;
		pvp->OnPVPOpeartion(_role_id, atoi(parts[1].c_str()), parts[2].c_str(), parts[3].c_str());
	}
	else if(type == 10310) //PVPPeerLatency
	{
		if(parts.size() != 2) return;

		PVP *pvp = PVPManager::GetInstance().Find(_pvp_id);
		if(!pvp) return;
		pvp->OnPVPPeerLatency(_role_id, atoi(parts[1].c_str()));
	}
}

void Player::SendUDPGameProtocol(const char *cmd)
{
	if(!_udp_trans_sid) GLog::log(LOG_ERR, "PVPD::Player::SendUDPGameProtocol, _udp_trans_sid==0,_role_id=%ld", _role_id);

	UDPGameProtocol prot;
	prot.id = _role_id;
	prot.data = Octets(cmd, strlen(cmd));

	Octets tmp;
	tmp.push_back(&prot.id, sizeof(prot.id));
	tmp.push_back(prot.data.begin(), prot.data.size());
	prot.signature = UDPSignature(tmp, _key);

	prot.reserved1 = 0;
	prot.reserved2 = 0;
	
	PVPUDPTransServer::GetInstance()->Send(_udp_trans_sid, prot);
}

void Player::SendUDPProtocol(Protocol& prot)
{
        PVPUDPTransServer::GetInstance()->Send(_udp_trans_sid, prot);
}

#ifdef DELAY_MODE
void Player::SendUDPProtocol(UDPS2CGameProtocols *prot, int delay_ms)
{
	timeval tv;
	gettimeofday(&tv, 0);
	int64_t ms = tv.tv_sec*1000+tv.tv_usec/1000+delay_ms;
	_pending_prot_map[ms].push_back(prot);
}

void Player::SendPendingProtocol()
{
	timeval tv;
	gettimeofday(&tv, 0);
	int64_t now_ms = tv.tv_sec*1000+tv.tv_usec/1000;

	auto it = _pending_prot_map.begin();
	auto it_bak = _pending_prot_map.end();
	while(it != _pending_prot_map.end())
	{
		int64_t ms = it->first;
		if(now_ms >= ms)
		{
			std::list<UDPS2CGameProtocols*> ls;
			ls.swap(it->second);
			for(auto it2=ls.begin(); it2!=ls.end(); ++it2)
			{
        			PVPUDPTransServer::GetInstance()->Send(_udp_trans_sid, **it2);
				delete *it2;
			}
			it_bak = it;
		}
		++it;
	}
	if(it_bak != _pending_prot_map.end())
	{
		_pending_prot_map.erase(_pending_prot_map.begin(), it_bak);
	}
}
#endif

void Player::FastSess_Reset()
{
	_fast_udp_session.Reset();
}

void Player::FastSess_Send(const std::string& data)
{
	Octets os((void*)data.c_str(), data.size());
	_fast_udp_session.Send(os);
}

void Player::FastSess_OnAck(int index_ack)
{
	_fast_udp_session.OnAck(index_ack);
}

bool Player::FastSess_IsReceived(int index) const
{
	return _fast_udp_session.IsReceived(index); 
}

void Player::FastSess_SetReceived(int index)
{
	_fast_udp_session.SetReceived(index);
}

void Player::FastSess_SendAck()
{
	_fast_udp_session.SendAck();
}

void Player::FastSess_TriggerSend()
{
	_fast_udp_session.TriggerSend();
}

void Player::UpdateLatency(unsigned short client_send_time, unsigned short server_send_time)
{
        timeval tv;
        gettimeofday(&tv,NULL);

        _prev_client_send_time_4_pvp = client_send_time;
        _prev_client_send_time_4_pvp_local_time = tv.tv_sec*1000000+tv.tv_usec;
}

void PlayerManager::Add(int64_t role_id, int pvp_id, const Octets& key)
{
	auto it = _map.find(role_id);
	if(it != _map.end()) return;

	_map[role_id] = new Player(role_id, pvp_id, key);
}

Player* PlayerManager::Find(int64_t role_id)
{
	auto it = _map.find(role_id);
	if(it == _map.end()) return 0;
	return it->second;
}

void PlayerManager::Delete(int64_t role_id)
{
	auto it = _map.find(role_id);
	if(it != _map.end())
	{
		delete it->second;
		_map.erase(it);
	}
}

#ifdef DELAY_MODE
void PlayerManager::SendPendingProtocol()
{
	for(auto it=_map.begin(); it!=_map.end(); ++it)
	{
		Player *p = it->second; 
		p->SendPendingProtocol();
	}
}
#endif

}

