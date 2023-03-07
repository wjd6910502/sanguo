#ifndef _CONNECTION_H_
#define _CONNECTION_H_

#include "c2sgameprotocol"
#include "gameprotocol.hpp"

using namespace GNET;

class GameClient
{
public:
	virtual ~GameClient() {}

	//服务器维护中而无法登陆，提示玩家info并返回到登陆UI, 此时网络模块已关闭(需要手动调用Open重连)
	virtual void OnServerMaintaining(const Octets& info) = 0;
	//玩家认证失败，提示玩家并返回到登陆UI(接入SDK后需要到SDK再次认证), 此时网络模块已关闭(需要手动调用Open重连)
	virtual void OnAuthFailed() = 0;
	//玩家被踢掉，提示玩家reason并返回到登陆UI, 此时网络模块已关闭(需要手动调用Open重连)
	virtual void OnKickout(int reason) = 0;
	//客户端和服务器状态有差异，重新load吧，是否要reload以及是否让玩家知道客户端自行决定
	virtual void DoReload() = 0;
	//收到lua协议
	virtual void OnRecvGameProtocol(const Octets& lua_prot) = 0;

	//获取客户端当前时间, 起点是1970-1-1 0:0:0
	virtual time_t GetLocalTime() = 0; //单位秒
	virtual int64_t GetLocalTimeInMicroSec() = 0; //单位微秒
	//随机生成一个32bit整数
	virtual int RandomInt() = 0;
	//获取游戏信息
	virtual int64_t GetRoleId() = 0;
	virtual const char* GetPVPDIP() = 0;
	virtual unsigned short GetPVPDPort() = 0;
};

class FastUDPSession
{
	bool _p2p; //工作在p2p模式

	bool _opened; //是否正在工作中
	int _index_stub;
	std::map<int,C2SGameProtocol> _data_map;
	int _received_index; //s2c方向已经收到的最大index, 从1开始
	bool _need_send_ack; //对端在等待ack
	int64_t _prev_real_send_ms; //上次执行sendto的时刻，用来控制包数量

public:
	FastUDPSession(bool p2p): _p2p(p2p), _opened(false), _index_stub(0), _received_index(0), _need_send_ack(false), _prev_real_send_ms(0) {}

	void Open();
	void Reset();
	void Send(const Octets& data, const std::vector<int64_t>& extra_roles, const std::vector<int64_t>& extra_mafias, const std::vector<int>& extra_pvps);
	void OnAck(int index_ack);
	bool IsReceived(int index) const;
	void SetReceived(int index);
	void SendAck();
	void TriggerSend(bool force);
};

enum P2P_NET_TYPE
{
	P2P_NET_TYPE_UNKNOWN = 0,
	P2P_NET_TYPE_UDP_BLOCKED,		//udp blocked
	P2P_NET_TYPE_SYMMETRIC,			//symmetric nat
	P2P_NET_TYPE_FULL_CONE,			//opened/full cone nat
	P2P_NET_TYPE_RESTRICTED_CONE,		//restricted cone nat
	P2P_NET_TYPE_PORT_RESTRICTED_CONE,	//port restricted cone nat
};

class P2PHelper
{
	enum P2P_GET_NET_TYPE_STATUS
	{
		P2P_GET_NET_TYPE_STATUS_NONE = 0,
		P2P_GET_NET_TYPE_STATUS_WAIT_GAMED_1,
		P2P_GET_NET_TYPE_STATUS_WAIT_GAMED_2,
		P2P_GET_NET_TYPE_STATUS_WAIT_STUND_1,
		P2P_GET_NET_TYPE_STATUS_WAIT_GAMED_3,
	};

	enum P2P_MAKE_HOLE_STATUS
	{
		P2P_MAKE_HOLE_STATUS_NONE = 0,
		P2P_MAKE_HOLE_STATUS_DOING,
		P2P_MAKE_HOLE_STATUS_DONE,
	};

	//udp net info
	P2P_NET_TYPE _net_type;
	std::string _public_ip;
	unsigned short _public_port;
	bool _need_report;
	//for get udp net info
	P2P_GET_NET_TYPE_STATUS _get_net_type_status;
	time_t _get_net_type_status_change_time;
	int _get_net_type_magic;
	time_t _prev_update_time;
	//for make hole
	P2P_MAKE_HOLE_STATUS _make_hole_status;
	int _make_hole_magic;
	std::string _make_hole_peer_ip;
	unsigned short _make_hole_peer_port;
	time_t _make_hole_time;

public:
	P2PHelper(): _net_type(P2P_NET_TYPE_UNKNOWN), _public_port(0), _need_report(false), _get_net_type_status(P2P_GET_NET_TYPE_STATUS_NONE),
	             _get_net_type_status_change_time(0), _get_net_type_magic(0), _prev_update_time(0), _make_hole_status(P2P_MAKE_HOLE_STATUS_NONE),
	             _make_hole_magic(0), _make_hole_peer_port(0), _make_hole_time(0)
	{
	}

	bool Update(time_t now);

	P2P_NET_TYPE GetNetType() const { return _net_type; }
	std::string GetPublicIP() const { return _public_ip; }
	unsigned short GetPublicPort() const { return _public_port; }
	bool NeedReport() const { return _need_report; }
	void ClearNeedReport() { _need_report=false; }

	void ClearNetType() { _net_type=P2P_NET_TYPE_UNKNOWN; }
	void TryGetNetType();
	void OnReceivedUDPSTUNResponse(int magic, const char *client_ip, unsigned short client_port);

	void ResetConnection();
	void TryMakeHole(int magic, const char *peer_ip, unsigned short peer_port);
	void OnMakeHole(int magic, const char *src_ip, unsigned short src_port);
	bool IsHoleOK() const;
	bool GetP2PPeer(std::string& peer_ip, unsigned short& peer_port) const;

private:
	void SendTest1ToGamed();
	void SendTest2ToGamed();
	void SendTest3ToGamed();
	void SendTest1ToStund();
	void GetNetType_ChangeStatus(P2P_GET_NET_TYPE_STATUS status);
	void UpdateGetNetType(time_t now);
	void UpdateMakeHole(time_t now);
};

class Latency
{
	enum
	{
		N = 30,
	};

	const int _sample_interval_max; //最长多少micro seconds应该有一次Sample

	int _samples[N]; //历史延迟数据，单位毫秒
	int _index;
	int _sample_max;
	int64_t _prev_add_sample_time; //micro seconds

public:
	Latency(int max_interval_ms): _sample_interval_max(max_interval_ms*1000) { Reset(); }

	void Reset();
	void AddSample(int latency_ms);
	int Get();
};

class Connection: public IntervalTimer::Observer
{
	enum CONN_STATUS
	{
		CONN_STATUS_NONE				=	0,
		//正常状态
		CONN_STATUS_WAIT_CHALLENGE,
		CONN_STATUS_WAIT_AUTH_RESULT,
		CONN_STATUS_WAIT_TRANS_CHALLENGE,
		CONN_STATUS_WAIT_TRANS_AUTH_RESULT,
		CONN_STATUS_ESTABLISHED,
		//异常状态
		CONN_STATUS_WAIT_SERVER_STATUS,

		CONN_STATUS_COUNT,
	};

	enum CONN_STATUS_TIMEOUT
	{
		CONN_STATUS_TIMEOUT_NONE			=	0,
		CONN_STATUS_TIMEOUT_WAIT_CHALLENGE		=	6,
		CONN_STATUS_TIMEOUT_WAIT_AUTH_RESULT		=	6,
		CONN_STATUS_TIMEOUT_WAIT_TRANS_CHALLENGE	=	6,
		CONN_STATUS_TIMEOUT_WAIT_TRANS_AUTH_RESULT	=	6,
		CONN_STATUS_TIMEOUT_ESTABLISHED			=	0,
		CONN_STATUS_TIMEOUT_WAIT_SERVER_STATUS		=	6,
	};

	CONN_STATUS _status;
	bool _can_send_game_protocol;
	int _timeout;

	GameClient *_callback;

	std::string _gate_ip;
	unsigned short _gate_port;
	std::string _account;
	std::string _password;
	std::string _status_ip;
	unsigned short _status_port;

	Octets _key1;
	Security *_enc_sec1;
	Security *_dec_sec1;
	std::string _trans_ip;
	unsigned short _trans_port;
	std::string _udp_trans_ip;
	unsigned short _udp_trans_port;
	std::string _stund_ip;
	unsigned short _stund_port;
	Octets _trans_token;
	Octets _enc_key2;
	Octets _dec_key2;
	int _wait_trans_challenge_timeout_count;

	int _first_game_protocol_id;
	std::list<GameProtocol> _game_protocol_history;

	int _client_received_game_protocol_count;
	int _server_received_game_protocol_count;

	time_t _prev_update_time;

	FastUDPSession _udp_session;

	P2PHelper _p2p_helper;
	FastUDPSession _p2p_udp_session;

	bool _udp_is_init;

	int64_t _server_time_offset;

	unsigned short _prev_server_send_time_4_tcp;
	int64_t _prev_server_send_time_4_tcp_local_time;

	unsigned short _prev_server_send_time_4_pvp;
	int64_t _prev_server_send_time_4_pvp_local_time;

	Latency _latency;
	Latency _pvp_latency;

	static int _status_timeout[CONN_STATUS_COUNT];

	Connection(): _status(CONN_STATUS_NONE), _can_send_game_protocol(false), _timeout(0), _callback(0), _gate_port(0), _status_port(0),
	              _enc_sec1(0), _dec_sec1(0), _trans_port(0), _udp_trans_port(0), _stund_port(0), _wait_trans_challenge_timeout_count(0),
	              _first_game_protocol_id(1), _client_received_game_protocol_count(0), _server_received_game_protocol_count(0), _prev_update_time(0),
	              _udp_session(false), _p2p_udp_session(true), _udp_is_init(false), _server_time_offset(0), _prev_server_send_time_4_tcp(0),
	              _prev_server_send_time_4_tcp_local_time(0), _prev_server_send_time_4_pvp(0), _prev_server_send_time_4_pvp_local_time(0),
	              _latency(1100), _pvp_latency(30)
	{
	}
	~Connection() {}

public:
	void Initialize();

	static Connection& GetInstance()
	{
		static Connection _instance;
		return _instance;
	}

public:
	void Open(GameClient *callback, const char *gate_ip, unsigned short gate_port, const char *account, const char *password,
	          const char *status_ip, unsigned short status_port);
	bool IsEstablished() const { return (_status==CONN_STATUS_ESTABLISHED && _can_send_game_protocol); }
	void Close();

	//for game lua
	void SendGameProtocol(const Octets& data, const std::vector<int64_t>& extra_roles, const std::vector<int64_t>& extra_mafias,
	                      const std::vector<int>& extra_pvps);
	void SendUDPGameProtocol(const Octets& data, const std::vector<int64_t>& extra_roles, const std::vector<int64_t>& extra_mafias,
	                         const std::vector<int>& extra_pvps);

public:
	void SetServerTimeOffset(int64_t off);
	time_t GetServerTime() const; //获取服务器时间，单位秒, 从UTC 1970-1-1 0:0:0起经过的秒数
	int64_t GetServerTimeInMicroSec() const; //获取服务器时间，单位微秒, 从UTC 1970-1-1 0:0:0起经过的微秒数

public:
	void ResetLatency(); //清除历史延迟数据
	void UpdateLatency(unsigned short client_send_time, unsigned short server_send_time);
	int GetLatency() { return _latency.Get(); } //和gamed间的延迟，单位毫秒

	void ResetPVPLatency(); //清除pvp历史延迟数据
	void UpdatePVPLatency(unsigned short client_send_time, unsigned short server_send_time);
	int GetPVPLatency() { return _pvp_latency.Get(); } //和pvpd间的延迟，如果p2p生效，玩家感受到的延迟可能会比这个值小，单位毫秒

public:
	void OnChallenge(Protocol::Manager *manager, int sid, const Octets& server_rand1);
	void OnAuthResult(Protocol::Manager *manager, int sid, int retcode, const Octets& trans_ip, unsigned short trans_port,
	                  const Octets& udp_trans_ip, unsigned short udp_trans_port, const Octets& stund_ip, unsigned short stund_port,
	                  const Octets& trans_token);
	void OnTransChallenge(Protocol::Manager *manager, int sid, const Octets& server_rand2);
	void OnTransAuthResult(Protocol::Manager *manager, int sid, int retcode, int server_received_count, bool do_reset);
	void OnContinue(Protocol::Manager *manager, int sid, bool reset);

	void OnTransLostConnection(Protocol::Manager *manager, int sid);
	void OnKickout(Protocol::Manager *manager, int sid, int reason);

	void OnServerStatus(Protocol::Manager *manager, int sid, const Octets& info);

	void OnReceivedGameProtocol(const Octets& lua_prot);
	void OnReceivedUDPGameProtocol(const Octets& lua_prot);

public:
	bool Update();

public:
	//for udp session
	//for game lua
	void FastSess_Open();
	void FastSess_Reset();
	void FastSess_Send(const Octets& data, const std::vector<int64_t>& extra_roles, const std::vector<int64_t>& extra_mafias, const std::vector<int>& extra_pvps);

	void FastSess_OnAck(int index_ack, bool p2p);
	bool FastSess_IsReceived(int index, bool p2p) const;
	void FastSess_SetReceived(int index, bool p2p);
	void FastSess_SendAck(bool p2p);

public:
	//p2p helper
	//p2p helper仅在Connection IsEstablished为true时有意义
	int P2P_GetNetType() const { return _p2p_helper.GetNetType(); }
	void P2P_ClearNetType() { _p2p_helper.ClearNetType(); }
	void P2P_TryGetNetType() { _p2p_helper.TryGetNetType(); }
	void P2P_OnReceivedUDPSTUNResponse(int magic, const char *client_ip, unsigned short client_port) { _p2p_helper.OnReceivedUDPSTUNResponse(magic, client_ip, client_port); }

	void P2P_ResetConnection() { _p2p_helper.ResetConnection(); }
	void P2P_TryConnect(int magic, const char *peer_ip, unsigned short peer_port);
	void P2P_OnConnect(int magic, const char *src_ip, unsigned short src_port) { _p2p_helper.OnMakeHole(magic, src_ip, src_port); }
	bool P2P_IsEstablished() const { return _p2p_helper.IsHoleOK(); } //established之后如果不尽快使用，可能又会断开
	bool P2P_GetPeerInfo(std::string& ip, unsigned short& port) const { return _p2p_helper.GetP2PPeer(ip, port); }

public:
	const char* GetGateIP() const { return _gate_ip.c_str(); }
	unsigned short GetGatePort() const { return _gate_port; }
	const char* GetStatusIP() const { return _status_ip.c_str(); }
	unsigned short GetStatusPort() const { return _status_port; }
	const char* GetTransIP() const { return _trans_ip.c_str(); }
	unsigned short GetTransPort() const { return _trans_port; }
	const char* GetUDPTransIP() const { return _udp_trans_ip.c_str(); }
	unsigned short GetUDPTransPort() const { return _udp_trans_port; }
	const char* GetStundIP() const { return _stund_ip.c_str(); }
	unsigned short GetStundPort() const { return _stund_port; }
	GameClient* GetGameClient() const { return _callback; }
	unsigned short GetPrevServerSendTime4PVP() const { return _prev_server_send_time_4_pvp; }
	int64_t GetPrevServerSendTime4PVPLocalTime() const { return _prev_server_send_time_4_pvp_local_time; }

private:
	void ChangeStatus(CONN_STATUS status);
	void AddHistory(const GameProtocol& data);
};

#endif //_CONNECTION_H_

