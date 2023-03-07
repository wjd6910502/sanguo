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
#include "iatomic.h"
#include "base64.h"

using namespace GNET;

namespace CACHE
{

class Player;

class NetworkTime
{
	Player *_player;

	int _id; //防止并行

	int64_t _delay;
	int64_t _offset;
	int _cnt; //每次时间同步序列要发送的sync协议次数

public:
	NetworkTime(Player *player): _player(player), _id(0), _delay(0), _offset(0), _cnt(0) {}
	
	bool NeedSync() const { return (_delay==0); }
	void Reset();
	void EstimateNTP(int id, int64_t delay, int64_t offset);
	void Sync2Client();
	void Send();
};

class Latency
{
	enum
	{
		TIME_MAX = 60,
		TIME_MIN = 30,
		TOP = 10, //percent
	};

	const int _sample_interval_max; //最长多少micro seconds应该有一次Sample

	std::multimap<int, int> _samples; //arrive_time=>latency
	int64_t _prev_add_sample_time; //micro seconds

public:
	Latency(int max_interval_ms): _sample_interval_max(max_interval_ms*1000) { Reset(); }

	void Reset();
	void AddSample(int latency_ms);
	int Get();
};

//客户端发送cmd频率限制
class CommandStat
{
	enum
	{
		N = 300, //统计时段内最多允许cmd数量
		T = 30, //统计时段长度
	};

	time_t _samples[N];
	int _index;

public:
	CommandStat() { Reset(); }

	void Reset();
	void AddSample();
	bool IsTooFast() const;
};

class Player: public GNET::Marshal, public TransactionBase
{
	//基础数据, C++逻辑相关, 与游戏关系不大
	Octets _account;
	int _hash;
	Octets _trans_token;
	Octets _key1;
	bool _can_send_game_protocol;
	bool _can_receive_protocol;
	Octets _last_device_id;
	int _client_received_game_protocol_count;
	unsigned int _trans_sid;
	unsigned int _udp_trans_sid;
	atomic_t _server_received_game_protocol_count;
	bool _disconnected;
	//game protocol cache
	int _first_game_protocol_id;
	std::list<Octets> _game_protocol_history;

	NetworkTime _network_time;

	unsigned short _prev_client_send_time_4_tcp;
	int64_t _prev_client_send_time_4_tcp_local_time;

	unsigned short _prev_client_send_time_4_udp;
	int64_t _prev_client_send_time_4_udp_local_time;

	Latency _latency;
	Latency _udp_latency;
	mutable Thread::Mutex2 _latency_lock;

	CommandStat _command_stat;
	mutable Thread::Mutex2 _command_stat_lock;

	bool _dirty;
	bool _do_cleanup;

	bool _do_save;

	//临时变量
	std::string _l_mafia_name;
	int _l_mafia_flag;

public:
	//for lua
	Role _role;

	mutable Thread::Mutex2 _lock;

private:
	bool _in_transaction;
	int64_t _transaction_id;
	std::map<std::string, GNET::Octets> _transaction_data;
	//std::list<GNET::Octets> _transaction_game_protocols;
	std::list<std::list<GNET::Octets> > _transaction_game_protocols; //FIXME: 这么复杂是为了调整协议顺序方便
	std::list<GNET::Octets> _transaction_udp_game_protocols;
	std::list<Message> _transaction_messages;
	std::list<TransactionFunctionBase*> _transaction_functions;
	std::list<Serialized> _transaction_to_all_role_messages;
	std::list<Serialized> _transaction_to_all_role_commands;

public:
	Player(const Octets& account): _account(account), _can_send_game_protocol(false), _client_received_game_protocol_count(0),
	                               _trans_sid(0), _udp_trans_sid(0), _disconnected(true), _first_game_protocol_id(1),
	                               _network_time(this), _prev_client_send_time_4_tcp(0), _prev_client_send_time_4_tcp_local_time(0),
	                               _prev_client_send_time_4_udp(0), _prev_client_send_time_4_udp_local_time(0), _latency(1100),
	                               _udp_latency(1100), _latency_lock("Player::_latency_lock"), _command_stat_lock("Player::_command_stat_lock"),
#ifdef ENABLE_MUTEX_CONFLICT_DETECT
	                               _dirty(false), _do_cleanup(false), _do_save(false), _l_mafia_flag(0), _role(this), _lock("Player::_lock",100),
#else
	                               _dirty(false), _do_cleanup(false), _do_save(false), _l_mafia_flag(0), _role(this), _lock("Player::_lock"),
#endif
	                               _in_transaction(false), _transaction_id(0)
	{
		_hash = DJBHash(_account);
		_can_receive_protocol = false;
		atomic_set(&_server_received_game_protocol_count, 0);
	}

	const Octets& GetAccount() const { return _account; }
	int GetHash_NOLOCK() const { return _hash; }
	const Octets& GetTransToken() const { return _trans_token; }
	const Octets& GetKey1() const { return _key1; }
	const std::string GetStrKey1() const 
	{
		Octets tmp_key;
		Base64Encoder::Convert(tmp_key, _key1);
		return std::string((char*)tmp_key.begin(), tmp_key.size());
	}
	bool GetCanSendGameProtocol() const { return _can_send_game_protocol; }
	bool GetCanReceiveProtocol() const { return _can_receive_protocol; }
	unsigned int GetTransSid() const { return _trans_sid; }
	unsigned int GetUDPTransSid() const { return _udp_trans_sid; }
	int GetServerReceivedGameProtocolCount() const { return atomic_read(&_server_received_game_protocol_count); }
	bool NeedDoReset(const Octets& device_id, int client_received_count) const;
	int64_t GetRoleId() const { return _role._roledata._base._id; }
	NetworkTime& GetNetworkTime() { return _network_time; }
	unsigned short GetPrevClientSendTime4TCP() const { return _prev_client_send_time_4_tcp; }
	int64_t GetPrevClientSendTime4TCPLocalTime() const { return _prev_client_send_time_4_tcp_local_time; }
	unsigned short GetPrevClientSendTime4UDP() const { return _prev_client_send_time_4_udp; }
	int64_t GetPrevClientSendTime4UDPLocalTime() const { return _prev_client_send_time_4_udp_local_time; }

	void SetTransToken(const Octets& trans_token) { _trans_token = trans_token; }
	void SetKey1(const Octets& key1) { _key1 = key1; }
	void SetCanSendGameProtocol(bool can) { _can_send_game_protocol = can; }
	void SetCanReceiveProtocol(bool can) { _can_receive_protocol=can; }
	void SetLastDeviceId(const Octets& device_id) { _last_device_id = device_id; }
	void SetClientReceivedGameProtocolCount(int c) { _client_received_game_protocol_count = c; }
	void SetTransSid(unsigned int sid) { _trans_sid = sid; }
	void SetUDPTransSid(unsigned int sid) { _udp_trans_sid = sid; }
	void SetDisconnect() { _disconnected = true; }
	void OnContinue(bool reset);
	void UpdateActiveTime_NOLOCK() { _role._last_active_time = NowWithoutOffset(); }
	void UpdateActiveTime(int last_active_time) { _role._last_active_time = last_active_time; }
	void OnReceivedGameProtocol_NOLOCK() { atomic_inc(&_server_received_game_protocol_count); }
	void UpdateUDPInfo(int net_type, const Octets& public_ip, unsigned short public_port, const Octets& local_ip, unsigned short local_port);
	void UpdateDeviceInfo(const Octets& device_id);

	void SendGameProtocol(const Octets& data);
	void SendUDPGameProtocol(const Octets& data);
	void SendProtocol(Protocol& prot);
	void SendUDPProtocol(Protocol& prot);

	void OnTimer1s(time_t now);

	//create role
	bool OnAllocRoleName(Octets name, int create_time);
	//for NTP
	void NetTime_Reset() { _network_time.Reset(); }
	//for latency
	void UpdateLatency(unsigned short client_send_time, unsigned short server_send_time);
	void ResetLatency();
	void UpdateUDPLatency(unsigned short client_send_time, unsigned short server_send_time);
	void ResetUDPLatency();
	//for command stat
	void ResetCommandStat();
	void OnRecvCommand();
	bool IsClientCmdSendTooFast() const;

	//for lua
	void Log(const char *v) const;
	void BILog(const char *v) const;
	void Err(const char *v) const;
	void SendToClient(const std::string& v);
	void SendToClientFirst(const std::string& v);
	void NewSendToClientList();
	void SendUDPToClient(const std::string& v);
	//for lua 处理gm命令
	void GMCmdGetCharReply(const GMCmdGetCharRe resp, int session_id, unsigned int sid);
	void GMCmdMailItemToPlayerReply(int session_id, unsigned int sid);
	void GMCmdMailToPlayerReply(int retcode, int session_id, unsigned int sid);

	void SendMessage(const Int64& target, const std::string& v) { SendMessage(target, v, 0); }
	void SendMessage(const Int64& target, const std::string& v, int delay);
	void SendMessage(const Int64& target, const std::string& v, const Int64List& extra_roles, const Int64List& extra_mafias, const IntList& extra_pvps) { SendMessage(target, v, 0, extra_roles, extra_mafias, extra_pvps); }
	void SendMessage(const Int64& target, const std::string& v, int delay, const Int64List& extra_roles, const Int64List& extra_mafias, const IntList& extra_pvps);

	//真正的广播接口，性能消耗极大，不要随意使用
	void _SendMessageToAllRole(const std::string& v) { _SendMessageToAllRole(v, 0); }
	void _SendMessageToAllRole(const std::string& v, int delay);
	void _SendMessageToAllRole(const std::string& v, const Int64List& extra_roles, const Int64List& extra_mafias, const IntList& extra_pvps) { _SendMessageToAllRole(v, 0, extra_roles, extra_mafias, extra_pvps); }
	void _SendMessageToAllRole(const std::string& v, int delay, const Int64List& extra_roles, const Int64List& extra_mafias, const IntList& extra_pvps);

	//广播替代接口，性能消耗小
	//但这种message有局限性，不能多锁(包括其他玩家/系统)
	void SendMessageToAllRole(const std::string& v, const int checksum);
	void SendCommandToAllRole(const std::string& v, const int checksum);

	void KickoutSelf(int reason);
	const std::string GetStrAccount() const { return std::string((char*)_account.begin(), _account.size()); }
	//create role
	int GetLengthUtf8(char const* str);
	bool IsValidRolename(const std::string& role_name);  
	void AllocRoleName(const char *name, int create_time, const char *errorinfo);
	void AllocRoleChangeName(const char *name);
	//create mafia
	bool IsValidMafianame(const std::string& mafia_name);  
	void AllocMafiaName(const char *name, int create_time);
	void AllocMafiaChangeName(const char *name);
	//for NTP
	bool NetTime_NeedSync() const { return _network_time.NeedSync(); }
	void NetTime_Sync2Client();
	//for latency
	int GetLatency();
	int GetUDPLatency();

	//for lua(from role)
	void SendPVPJoin(int score, char vs_robot, int wait_max_before_vs_robot);
	void SendOperation(int map_id, std::string operation, std::string role_info, int battle_ver);
	void SendPVPEnter(int flag);
	void SendPVPReady();
	void SendPVPLeave(int reason, int typ, int score, int duration);
	void SendPVPCancle();
	void SendPVPSpeed(int speed);
	void SendPVPReset();
	void GetPVPVideo(const std::string& v);
	void DelPVPVideo(const std::string& v);
	void SendSpeechToSTT(std::string dest_id, int chat_type, int channel, std::string speech);
	void SendRoleInfoToRegister(std::string name, int level, int photo);
	void AudienceGetAllList();
	void AudienceGetRoomInfo(int room_id);
	void AudienceLeave(int room_id);
	void SendYueZhanBegin(int room_id);
	void SendPvpDanMu(int pvp_id, std::string video_id, int tick, std::string danmu_info);
	void SendPVPPauseRe(int pvp_id);
	void SendLaohuPayRe(int retcode, const std::string& order, int amount, const std::string& ext, int sid);

	//for lua(from role)
	int GetActiveCodeType(const std::string& code);
	void IsValidActiveCode(const std::string& code);

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

	void restore(int64_t transaction_id);
	void cleanup();

	virtual void BeginTransaction();
	virtual void CommitTransaction();
	virtual void CancelTransaction();

	bool IsDirty() const { return _dirty; }
	void ClearDirty() { _dirty=false; }

	bool NeedDoSave() const { return _do_save; }
	void SetDoSave() { _do_save=true; }
	void DoSave();

private:
	void AddHistory(const Octets& data);
	void __SendMessage(const Int64& target, const std::string& v, int delay, const Int64List& extra_roles, const Int64List& extra_mafias, const IntList& extra_pvps);
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


	//最近活跃玩家
	std::set<Player*> _active_players_history[SERVER_CONST_ACTIVE_PLAYERS_HISTORY_MAX];
	int _active_players_history_index;
	int _cur_min; //TODO: 调整时间会影响吗?
	std::set<Player*> _active_players;
	//std::set<Player*> _local_active_players;

	mutable Thread::RWLock2 _lock;
	mutable Thread::Mutex2 _active_players_lock;

	PlayerManager(): _active_players_history_index(0), _lock("PlayerManager::_lock"), _active_players_lock("PlayerManager::_active_players_lock"), _map_by_role_id_lock("PlayerManager::_map_by_role_id_lock"), _tag(0) { _cur_min = Now()/60; }
	PlayerManager(const PlayerManager& rhs);

	PlayerManager& operator= (const PlayerManager& rhs);
	
	static unsigned int _role_id_stub;
	static unsigned int _mafia_id_stub;
	static Thread::Mutex2 _role_id_stub_lock;
	static Thread::Mutex2 _mafia_id_stub_lock;

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

	int GetRoleCount() const;
	void GetActiveRoles(std::vector<int64_t>& roles) const;
	int GetActiveRoleCount() const;

	void Load(Octets &key, Octets &value);
	void LoadRoleInfo(Octets &key, Octets &value);
	void LoadPlayerInfo(Octets &key, Octets &value);
	void Save();
	void Save2();

	static int64_t AllocRoleId();
	static int64_t AllocMafiaId();

	void OnAllocRoleName(Octets account, Octets name, int create_time);

	bool LoadSystemPlayersFromFile(const char *path);
	bool SaveSystemPlayersToFile(const char *path);
	bool InitSystemPlayers();

	void Shutdown();

	//for lua
private:
	mutable std::map<Int64, Role*> _map_by_role_id;
	mutable Thread::RWLock2 _map_by_role_id_lock;
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

