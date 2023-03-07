#ifndef _PLAYER_MANAGER_H_
#define _PLAYER_MANAGER_H_

#include <string>
#include <map>
#include <set>
#include "gnet_timer.h"
#include "fastudpsession.h"
#include "protocol.h"
#include "udps2cgameprotocols.hpp"

namespace GNET
{

class Player
{
	friend class PlayerManager;

	int64_t _role_id;
	int _pvp_id;
	Octets _key;
	int _udp_trans_sid;
	FastUDPSession _fast_udp_session;

	unsigned short _prev_client_send_time_4_pvp;
	int64_t _prev_client_send_time_4_pvp_local_time;

#ifdef DELAY_MODE
	std::map<int64_t, std::list<UDPS2CGameProtocols*> > _pending_prot_map;
#endif

public:
	Player(int64_t role_id, int pvp_id, const Octets& key): _role_id(role_id), _pvp_id(pvp_id), _key(key), _udp_trans_sid(0), _fast_udp_session(this),
	                                                        _prev_client_send_time_4_pvp(0), _prev_client_send_time_4_pvp_local_time(0)
	{
	}

	int64_t GetRoleId() const { return _role_id; }
	int GetPVPId() const { return _pvp_id; }
	const Octets& GetKey() const { return _key; }
	unsigned int GetUDPTransSid() const { return _udp_trans_sid; }

	void SetUDPTransSid(unsigned int sid) { _udp_trans_sid = sid; }

	void OnCmd(const char *cmd);
	void SendUDPGameProtocol(const char *cmd);
	void SendUDPProtocol(Protocol& prot);
#ifdef DELAY_MODE
	void SendUDPProtocol(UDPS2CGameProtocols *prot, int delay_ms);
	void SendPendingProtocol();
#endif

	void FastSess_Reset();
	void FastSess_Send(const std::string& data);
	void FastSess_OnAck(int index_ack);
	bool FastSess_IsReceived(int index) const;
	void FastSess_SetReceived(int index);
	void FastSess_SendAck();
	void FastSess_TriggerSend();

	//for latency
	void UpdateLatency(unsigned short client_send_time, unsigned short server_send_time);

	unsigned short GetPrevClientSendTime4PVP() const { return _prev_client_send_time_4_pvp; }
	int64_t GetPrevClientSendTime4PVPLocalTime() const { return _prev_client_send_time_4_pvp_local_time; }
};

class PlayerManager
{
	std::map<int64_t, Player*> _map;

public:
	static PlayerManager& GetInstance()
	{
		static PlayerManager _instance;
		return _instance;
	}

	void Add(int64_t role_id, int pvp_id, const Octets& key);
	Player* Find(int64_t role_id);
	void Delete(int64_t role_id);

#ifdef DELAY_MODE
	void SendPendingProtocol();
#endif
};

}

#endif //_PLAYER_MANAGER_H_

