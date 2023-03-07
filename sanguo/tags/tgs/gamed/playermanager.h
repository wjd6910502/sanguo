#ifndef _PLAYER_MANAGER_H_
#define _PLAYER_MANAGER_H_

#include <string>
#include <map>
#include <list>
#include <set>

#include "octets.h"
#include "forlua.h"
#include "itimer.h"
#include "thread.h"
#include "mutex.h"
#include "role.h"
#include "commonmacro.h"
#include "message.h"
#include "transaction.h"

using namespace GNET;

namespace CACHE
{

class Player;

class FastUDPSession
{
	Player *_player;

	int _index_stub;
	std::map<int,Octets> _data_map;
	int _received_index; //c2s�����Ѿ��յ������index
	bool _need_send_ack;

public:
	FastUDPSession(Player *player): _player(player), _index_stub(0), _received_index(0), _need_send_ack(false) {}

	void Reset();
	void Send(const Octets& data);
	void OnAck(int index_ack);
	bool IsReceived(int index) const;
	void SetReceived(int index);
	void SendAck();
	void TriggerSend();
};

class NetworkTime
{
	Player *_player;

	int64_t _delay;
	int64_t _offset;
	int _cnt; //ÿ��ʱ��ͬ������Ҫ���͵�syncЭ�����

public:
	NetworkTime(Player *player): _player(player), _delay(0), _offset(0), _cnt(0) {}
	
	bool NeedSync() const { return (_delay==0); }
	void Reset();
	void EstimateNTP(int64_t delay, int64_t offset);
	void Sync2Client();
	void Send();
};

class Latency
{
	enum
	{
		N = 50,
		M = 5,
	};

	const int _sample_interval_max; //�����micro secondsӦ����һ��Sample

	int _samples[N]; //��ʷ�ӳ����ݣ���λ����
	int _index;
	int64_t _prev_add_sample_time; //micro seconds

public:
	Latency(int max_interval_ms): _sample_interval_max(max_interval_ms*1000) { Reset(); }

	void Reset();
	void AddSample(int latency_ms);
	int Get();
};

class Player: public GNET::Marshal, public TransactionBase
{
	//��������, C++�߼����, ����Ϸ��ϵ����
	Octets _account;
	int _hash;
	Octets _trans_token;
	Octets _key1;
	bool _can_send_game_protocol;
	Octets _last_device_id;
	int _client_received_game_protocol_count;
	unsigned int _trans_sid;
	unsigned int _udp_trans_sid;
	int _server_received_game_protocol_count;
	bool _disconnected;
	//game protocol cache
	int _first_game_protocol_id;
	std::list<Octets> _game_protocol_history;

	FastUDPSession _udp_session;
	NetworkTime _network_time;

	unsigned short _prev_client_send_time_4_tcp;
	int64_t _prev_client_send_time_4_tcp_local_time;

	Latency _latency;

	//��ʱ����
	std::string _l_mafia_name;
	int _l_mafia_flag;

	
public:
	//for lua
	Role _role;

	mutable Thread::Mutex _lock;

private:
	bool _in_transaction;
	int _transaction_id;
	std::map<std::string, GNET::Octets> _transaction_data;
	std::list<GNET::Octets> _transaction_game_protocols;
	std::list<Message> _transaction_messages;

public:
	Player(const Octets& account): _account(account), _can_send_game_protocol(false), _client_received_game_protocol_count(0), _trans_sid(0),
	                               _udp_trans_sid(0), _server_received_game_protocol_count(0), _disconnected(true), _first_game_protocol_id(1),
	                               _udp_session(this), _network_time(this), _prev_client_send_time_4_tcp(0), _prev_client_send_time_4_tcp_local_time(0),
	                               _latency(1100), _l_mafia_flag(0), _role(this), _in_transaction(false), _transaction_id(0)
	{
		_hash = DJBHash(_account);
	}

	const Octets& GetAccount() const { return _account; }
	int GetHash() const { return _hash; }
	const Octets& GetTransToken() const { return _trans_token; }
	const Octets& GetKey1() const { return _key1; }
	bool GetCanSendGameProtocol() const { return _can_send_game_protocol; }
	unsigned int GetTransSid() const { return _trans_sid; }
	unsigned int GetUDPTransSid() const { return _udp_trans_sid; }
	int GetServerReceivedGameProtocolCount() const { return _server_received_game_protocol_count; }
	bool NeedDoReset(const Octets& device_id, int client_received_count) const;
	int64_t GetRoleId() const { return _role._roledata._base._id; }
	NetworkTime& GetNetworkTime() { return _network_time; }

	void SetTransToken(const Octets& trans_token) { _trans_token = trans_token; }
	void SetKey1(const Octets& key1) { _key1 = key1; }
	void SetCanSendGameProtocol(bool can) { _can_send_game_protocol = can; }
	void SetLastDeviceId(const Octets& device_id) { _last_device_id = device_id; }
	void SetClientReceivedGameProtocolCount(int c) { _client_received_game_protocol_count = c; }
	void SetTransSid(unsigned int sid) { _trans_sid = sid; }
	void SetUDPTransSid(unsigned int sid) { _udp_trans_sid = sid; }
	void SetDisconnect() { _disconnected = true; }
	void OnContinue(bool reset);
	void UpdateActiveTime() { _role._last_active_time = Now(); }
	void UpdateActiveTime(int last_active_time) { _role._last_active_time = last_active_time; }
	void OnReceivedGameProtocol() { _server_received_game_protocol_count++; }
	void UpdateUDPInfo(int net_type, const Octets& public_ip, unsigned short public_port, const Octets& local_ip, unsigned short local_port);

	void SendGameProtocol(const Octets& data);
	void SendUDPGameProtocol(const Octets& data);
	void SendProtocol(Protocol& prot);
	void SendUDPProtocol(Protocol& prot);

	void OnTimer1s(time_t now);

	//for lua
	void Log(const char *v) const;
	void Err(const char *v) const;
	void SendToClient(const std::string& v);
	void SendUDPToClient(const std::string& v);
	void SendMessage(const Int64& target, const std::string& v) { SendMessage(target, v, 0); }
	void SendMessage(const Int64& target, const std::string& v, int delay);
	void SendMessage(const Int64& target, const std::string& v, const Int64List& extra_roles, const Int64List& extra_mafias, const IntList& extra_pvps) { SendMessage(target, v, 0, extra_roles, extra_mafias, extra_pvps); }
	void SendMessage(const Int64& target, const std::string& v, int delay, const Int64List& extra_roles, const Int64List& extra_mafias, const IntList& extra_pvps);
	void SendMessageToAllRole(const std::string& v) { SendMessageToAllRole(v, 0); }
	void SendMessageToAllRole(const std::string& v, int delay);
	void SendMessageToAllRole(const std::string& v, const Int64List& extra_roles, const Int64List& extra_mafias, const IntList& extra_pvps) { SendMessageToAllRole(v, 0, extra_roles, extra_mafias, extra_pvps); }
	void SendMessageToAllRole(const std::string& v, int delay, const Int64List& extra_roles, const Int64List& extra_mafias, const IntList& extra_pvps);
	void KickoutSelf(int reason);
	const std::string GetStrAccount() const { return std::string((char*)_account.begin(), _account.size()); }
	//create role
	bool IsValidRolename(const std::string& role_name);  
	void AllocRoleName(const char *name, int create_time, const char *errorinfo);
	bool OnAllocRoleName(Octets name, int create_time);
	//create mafia
	bool IsValidMafianame(const std::string& mafia_name);  
	void AllocMafiaName(const char *name, int create_time);
	//for udp session
	void FastSess_Reset();
	void FastSess_Send(const std::string& data);
	void FastSess_OnAck(int index_ack);
	bool FastSess_IsReceived(int index) const;
	void FastSess_SetReceived(int index);
	void FastSess_SendAck();
	void FastSess_TriggerSend();
	//for NTP
	bool NetTime_NeedSync() const { return _network_time.NeedSync(); }
	void NetTime_Sync2Client();
	void NetTime_Reset() { _network_time.Reset(); }
	//for latency
	void UpdateLatency(unsigned short client_send_time, unsigned short server_send_time);
	void ResetLatency() { _latency.Reset(); }
	int GetLatency() { return _latency.Get(); }

	virtual OctetsStream& marshal(OctetsStream &os) const
	{
		os << _role;
		return os;
	}
	virtual const OctetsStream& unmarshal(const OctetsStream &os)
	{
		os >> _role;
		return os;
	}

	void restore(int transaction_id);
	void cleanup();

	virtual void BeginTransaction();
	virtual void CommitTransaction();
	virtual void CancelTransaction();

private:
	void AddHistory(const Octets& data);

};

class PlayerManager;
class RoleIter
{
	std::map<Int64, Role*>::iterator _it;
	PlayerManager *_map;
	int _saved_tag;

public:
	RoleIter(std::map<Int64, Role*>::iterator it, PlayerManager* map, int tag): _it(it), _map(map), _saved_tag(tag) {}

	void Next();
	void Prev();
	Role* GetValue();
};

class PlayerManager
{
	std::map<Octets, Player*> _map;
	std::map<Octets, Player*> _map_by_trans_token;
	std::map<unsigned int, Player*> _map_by_trans_sid;


	//�����Ծ���
	std::set<Player*> _active_players_history[SERVER_CONST_ACTIVE_PLAYERS_HISTORY_MAX];
	int _cur_min; //TODO: ����ʱ���Ӱ����?
	std::set<Player*> _active_players;

	mutable Thread::Mutex _lock;

	PlayerManager(): _tag(0) { _cur_min = Now()/60; }
	PlayerManager(const PlayerManager& rhs);

	PlayerManager& operator= (const PlayerManager& rhs);
	
	static unsigned int _role_id_stub;
	static unsigned int _mafia_id_stub;
	static Thread::Mutex _role_id_stub_lock;
	static Thread::Mutex _mafia_id_stub_lock;

public:
	static PlayerManager& GetInstance()
	{
		static PlayerManager _instance;
		return _instance;
	}

	void OnTimer(int tick, time_t now);

	Player* FindByAccount(const Octets& account);
	const Player* FindByAccount(const Octets& account) const;
	Player* FindByTransToken(const Octets& trans_token, bool active);
	const Player* FindByTransToken(const Octets& trans_token) const;
	Player* FindByTransSid(unsigned int sid, bool active);
	const Player* FindByTransSid(unsigned int sid) const;
	Player* FindByRoleId(int64_t id);
	const Player* FindByRoleId(int64_t id) const;

	void OnConnect(const Octets& account, const Octets& trans_token, const Octets& key1);
	void OnTransConnect(Player *player, const Octets& device_id, int client_received_game_protocol_count, unsigned int sid);
	void OnDisconnect(const Octets& account);

	void GetActiveRoles(std::vector<int64_t>& roles) const;
	void Load(Octets &key, Octets &value);
	void LoadRoleInfo(Octets &key, Octets &value);
	void LoadPlayerInfo(Octets &key, Octets &value);
	void Save();
	static int64_t AllocRoleId();
	static int64_t AllocMafiaId();

	void OnAllocRoleName(Octets account, Octets name, int create_time);

	bool LoadSystemPlayersFromFile(const char *path);
	bool SaveSystemPlayersToFile(const char *path);
	bool InitSystemPlayers();

	//for lua
private:
	mutable std::map<Int64, Role*> _map_by_role_id;
	int _tag;

public:
	void OnChanged() { _tag++; }
	int Tag() const { return _tag; }
	std::map<Int64, Role*>::iterator Begin() { return _map_by_role_id.begin(); }
	std::map<Int64, Role*>::iterator End() { return _map_by_role_id.end(); }

	int Size() const { return _map_by_role_id.size(); }

	Role* Find(const Int64& k);

	RoleIter SeekToBegin() const { return RoleIter(_map_by_role_id.begin(), (PlayerManager*)this, _tag); }
	RoleIter Seek(const Int64& k) const { return RoleIter(_map_by_role_id.find(k), (PlayerManager*)this, _tag); }
	RoleIter SeekToLast() const
	{ 
		if (_map_by_role_id.size() == 0)
			return RoleIter(_map_by_role_id.begin(), (PlayerManager*)this, _tag);
		else
			return RoleIter(--_map_by_role_id.end(), (PlayerManager*)this, _tag); 
	}
};

};

inline CACHE::Player* API_GetLuaPlayer(void *p) { return (CACHE::Player*)p; }
inline CACHE::Role* API_GetLuaRole(void *p) { return (p ? &(((CACHE::Player*)p)->_role) : 0); }

#endif //_PLAYER_MANAGER_H_
