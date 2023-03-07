#ifndef _PVP_MANAGER_H_
#define _PVP_MANAGER_H_

#include <string>
#include <map>
#include <set>
#include "gnet_timer.h"
#include "pvpvideo"

namespace GNET
{

enum PVP_CONST
{
	PVP_CONST_CLIENT_FPS		=	30, //30fps
	//PVP_CONST_CLIENT_TICK_MS	=	33, //30fps
	//PVP_CONST_NET_TICK_MS		=	100,
	PVP_CONST_BIG_LAG_MS_MAX	=	500,
	PVP_CONST_BIG_LAG_SAMPLE_COUNT	=	150,
	PVP_CONST_BIG_LAG_COUNT_MAX	=	135,
	PVP_CONST_PAUSE_COUNT_MAX	=	3,
	PVP_CONST_TRIGGER_SEND_INTERVAL	=	3, //ticks
	PVP_CONST_WAIT_PAUSE_RE_TIME	=	10,
	PVP_CONST_NO_OP_TIMEOUT		=	10, //���������˫��������������ʱ��
	PVP_CONST_JIASU_OP_MAX		=	30, //������������Ƽ��ٲ�������
};

enum PVP_ERROR
{
	PVP_ERROR_LOST			=	1, //����
	PVP_ERROR_LATENCY		=	4, //�ӳ�̫��
	PVP_ERROR_NO_PAUSE_RE		=	5, //����Ӧ��ͣ
	//PVP_ERROR_INCONSISTENT		=	6, //��һ��
	PVP_ERROR_JIASU			=	7, //ʹ�ü�����
};

//��������gamed��pvpʵ�ֵ�c++�汾
struct OP
{
	std::string _op;
	int64_t _arrive_time_ms;
};

struct PVPFighter
{
	int64_t _id;
	std::map<int,OP> _ops;
	//int _accumulate_latency; //������ڱ���ս�����ۻ��ӳ�ʱ��(ms)
	//int _delay_count; //������ڱ���ս�����ۻ��ӳٴ���
	int _wait_seconds; //����ս������ס��, ���ڵȴ�����ҵ�op, �Ѿ��ȴ���_wait_seconds��, �����ж�����Ƿ����
	int _pause_count;
	bool _waiting_pause_re;
	bool _have_sin;
	int _jiasu_count; //�յ������Ƽ��ٲ�������

	std::map<int,std::string> _crcs;

public:
	//PVPFighter(int64_t id): _id(id), _accumulate_latency(0), _delay_count(0), _wait_seconds(0) {}
	PVPFighter(int64_t id): _id(id), _wait_seconds(0), _pause_count(0), _waiting_pause_re(false), _have_sin(false), _jiasu_count(0) {}
};

enum PVP_STATUS
{
	PVP_STATUS_NORMAL = 0,
	PVP_STATUS_PAUSE_AND_WAIT_RESP1, //�ȴ��ͻ��˵���ͣ��Ӧ
	PVP_STATUS_PAUSE_AND_WAIT_RESP2, //�ȴ��ͻ�������״̬�ָ�
};

class PVP
{
	friend class PVPManager;

	int _id;
	int _mode;
	PVPFighter _fighter1;
	PVPFighter _fighter2;
	int _fight_start_time;
	int _next_client_tick;
	int _first_tick; //��ʼս���ĵ�1��tick
	//int _latency; //�����ĵ�ǰ�����ӳ�(ms)
	int _typ; //pvp��������0Ϊgamed��1Ϊgcenterd
	std::vector<PvpVideo> _pvp_video;
	Octets _fighter1_pvpinfo;
	Octets _fighter2_pvpinfo;
	int _fighter1_zoneid;
	int _fighter2_zoneid;
	int _robot_flag;
	Octets _exe_ver;
	Octets _data_ver;
	int _pvp_ver;

	char _big_lags[PVP_CONST_BIG_LAG_SAMPLE_COUNT]; //ͳ�����N�����������fighter1���������ӳ���ÿ�μ�1��fighter2�������-1������0
	int _big_lags_index;

	int _status; //��ǰ״̬����������ͣ��
	int _status_timeout;

	int _active_time;

	int _min_client_tick;

	int _match_pvp;

public:
	PVP(int id, int mode, int64_t fighter1, int64_t fighter2, int fight_start_time, int typ, Octets fighter1_pvpinfo, Octets fighter2_pvpinfo, int fighter1_zoneid, int fighter2_zoneid, int robot_flag, const Octets& exe_ver, const Octets& data_ver, int pvp_typ, int match_pvp)
	   : _id(id), _mode(mode), _fighter1(fighter1), _fighter2(fighter2), _fight_start_time(fight_start_time),
	     //_next_client_tick(1), _latency(0), _typ(typ), _fighter1_pvpinfo(fighter1_pvpinfo), _fighter2_pvpinfo(fighter2_pvpinfo), 
	     _next_client_tick(1), _first_tick(_next_client_tick), _typ(typ), _fighter1_pvpinfo(fighter1_pvpinfo), _fighter2_pvpinfo(fighter2_pvpinfo), 
	     _fighter1_zoneid(fighter1_zoneid), _fighter2_zoneid(fighter2_zoneid), _robot_flag(robot_flag), _exe_ver(exe_ver), _data_ver(data_ver),
	     _pvp_ver(pvp_typ), _big_lags_index(0), _status(0), _status_timeout(0), _active_time(0), _min_client_tick(0), _match_pvp(match_pvp)
	{
		time_t now = time(0);
		if(_fight_start_time < now) _fight_start_time = now;
		memset(_big_lags, 0, sizeof(_big_lags));
	}
	~PVP();

	void OnTimer(int tick, int now);
	void OnTimer1s(time_t now);

	void OnPVPOperation(int64_t fighter, int client_tick, const char *op_encoded, int crc_tick, const char *crc_encoded);
	void OnPVPOperationCommit(int64_t fighter);
	void OnPVPPeerLatency(int64_t src_role_id, int latency);
	void PVPSendAutoVoice(int64_t src_role_id, int hero_id, int voice_id);
	
	void SendOperation(int win_flag, int robot_flag, int robot_seed, int robot_type);

	void OnPauseRe(int64_t fighter);

private:
	int CheckFighter(time_t now, PVPFighter& fighter, int big_lag_count);
	int64_t GetShouldArriveTime(int client_tick) const; //�����ĵ�������ʱ��
	bool IsValidOP(int64_t now_ms, int client_tick) const;
};

class PVPManager: public IntervalTimer::Observer
{
	std::map<int, PVP*> _map;
	std::set<int> _will_delete_list;

	PVPManager() {}

public:
	static PVPManager& GetInstance()
	{
		static PVPManager _instance;
		return _instance;
	}

	void Initialize();
	bool Update();

	PVP* Find(int id);

	int Create(int id, int mode, int64_t fighter1, int64_t fighter2, int fight_start_time, int typ, Octets fighter1_pvpinfo, Octets fighter2_pvpinfo, int fighter1_zoneid, int fighter2_zoneid, int robot_flag, const Octets& exe_ver, const Octets& data_ver, int pvp_typ, const Octets& fighter1_key, const Octets& fighter2_key, int match_pvp);
	void Delete(int id);
	void SendOperation(int id, int win_flag, int robot_flag, int robot_seed, int robot_type);
	int GetCurRoomNum();

	void OnPauseRe(int id, int64_t fighter);
};

}

#endif //_PVP_MANAGER_H_