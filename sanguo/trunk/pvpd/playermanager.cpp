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
	if(type == 10306) //PVPOperation
	{
		if(parts.size() != 5) return;

		PVP *pvp = PVPManager::GetInstance().Find(_pvp_id);
		if(!pvp) return;
		pvp->OnPVPOperation(_role_id, atoi(parts[1].c_str()), parts[2].c_str(), atoi(parts[3].c_str()), parts[4].c_str());
	}
	else if(type == 10310) //PVPPeerLatency
	{
		if(parts.size() != 2) return;

		PVP *pvp = PVPManager::GetInstance().Find(_pvp_id);
		if(!pvp) return;
		pvp->OnPVPPeerLatency(_role_id, atoi(parts[1].c_str()));
	}
	else if(type == 10314) //PVPSendAutoVoice
	{
		if(parts.size() != 3) return;

		PVP *pvp = PVPManager::GetInstance().Find(_pvp_id);
		if(!pvp) return;
		pvp->PVPSendAutoVoice(_role_id, atoi(parts[1].c_str()), atoi(parts[2].c_str()));
	}
	else if(type == 10317) //PVPOperationCommit
	{
		PVP *pvp = PVPManager::GetInstance().Find(_pvp_id);
		if(!pvp) return;
		pvp->OnPVPOperationCommit(_role_id);
	}
}

void Player::SendUDPGameProtocol(const char *cmd)
{
	//if(!_udp_trans_sid) GLog::log(LOG_INFO, "PVPD::Player::SendUDPGameProtocol, _udp_trans_sid==0,_role_id=%ld", _role_id);

	UDPGameProtocol prot;
	prot.id = _role_id;
	prot.data = Octets(cmd, strlen(cmd));

	Octets tmp;
	tmp.push_back(&prot.id, sizeof(prot.id));
	tmp.push_back(prot.data.begin(), prot.data.size());
	prot.signature = UDPSignature(tmp, _key);

	prot.reserved1 = 0;
	prot.reserved2 = 0;
	
	//GLog::log(LOG_INFO, "PVPD::Player::SendUDPGameProtocol, _udp_trans_sid=%u,_role_id=%ld,cmd=%s", _udp_trans_sid,_role_id,cmd);
	PVPUDPTransServer::GetInstance()->Send(_udp_trans_sid, prot);
}

void Player::SendUDPProtocol(Protocol& prot)
{
	//GLog::log(LOG_INFO, "PVPD::Player::SendUDPProtocol, _udp_trans_sid=%u,_role_id=%ld", _udp_trans_sid,_role_id);
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

void Player::FastSess_Send(const std::string& data, bool force)
{
	Octets os((void*)data.c_str(), data.size());
	_fast_udp_session.Send(os, force);
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
	int rt = _pvp_latency.Get4ReSend();
	if(rt<0 || rt>200) rt=200;
	rt = rt/33*33;
	_fast_udp_session.TriggerSend(rt);
}

void Player::FastSess_Dump(std::vector<Octets>& datas)
{
	_fast_udp_session.Dump(datas);
}

void Player::FastSess_Clear()
{
	_fast_udp_session.Clear();
}

void Player::UpdateLatency(unsigned short client_send_time, unsigned short server_send_time)
{
        timeval tv;
        gettimeofday(&tv,NULL);

        _prev_client_send_time_4_pvp = client_send_time;
        _prev_client_send_time_4_pvp_local_time = tv.tv_sec*1000000+tv.tv_usec;

	if(server_send_time==0) return;

	unsigned int now_ms = (_prev_client_send_time_4_pvp_local_time/1000)&0xffff;
	if(now_ms < server_send_time)
	{
		now_ms += 0x10000;
	}
	_pvp_latency.AddSample(now_ms-server_send_time);
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

void Latency::Reset()
{
	memset(_samples, 0, sizeof(_samples));
	_index = 0;
}

void Latency::AddSample(int latency_ms)
{
	if(latency_ms>65000) return;

	_samples[_index%N] = latency_ms;
	_index++;
}

int Latency::Get4ReSend()
{
	if(_index==0) return -1; //no data

	std::set<int> maxM;
	for(int i=0; i<_index && i<N; i++)
	{
		if(maxM.size() < M)
		{
			maxM.insert(_samples[i]);
		}
		else
		{
			if(_samples[i] > *maxM.begin())
			{
				maxM.erase(maxM.begin());
				maxM.insert(_samples[i]);
			}
		}
	}
	return *maxM.begin();
}

}

