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
	//PVP_CONST_CLIENT_TICK_MS	=	33, //30fps
	//PVP_CONST_NET_TICK_MS		=	100,
	PVP_CONST_BIG_LAG_MS_MAX	=	500,
	PVP_CONST_BIG_LAG_SAMPLE_COUNT	=	150,
	PVP_CONST_BIG_LAG_COUNT_MAX	=	120,
};

//以下算是gamed中pvp实现的c++版本
struct OP
{
	std::string _op;
	int64_t _arrive_time_ms;
};

struct PVPFighter
{
	int64_t _id;
	std::map<int,OP> _ops;
	//int _accumulate_latency; //该玩家在本次战斗中累积延迟时间(ms)
	//int _delay_count; //该玩家在本次战斗中累积延迟次数
	int _wait_seconds; //本次战斗被卡住了, 正在等待此玩家的op, 已经等待了_wait_seconds秒, 用来判断玩家是否掉线

public:
	//PVPFighter(int64_t id): _id(id), _accumulate_latency(0), _delay_count(0), _wait_seconds(0) {}
	PVPFighter(int64_t id): _id(id), _wait_seconds(0) {}
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
	//int _latency; //比赛的当前整体延迟(ms)
	int _typ;
	std::vector<PvpVideo> _pvp_video;
	Octets _fighter1_pvpinfo;
	Octets _fighter2_pvpinfo;
	int _fighter1_zoneid;
	int _fighter2_zoneid;
	int _robot_flag;
	Octets _exe_ver;
	Octets _data_ver;

	char _big_lags[PVP_CONST_BIG_LAG_SAMPLE_COUNT]; //统计最近N个操作，如果fighter1发生严重延迟则每次记1，fighter2发生则记-1，否则0
	int _big_lags_index;

public:
	PVP(int id, int mode, int64_t fighter1, int64_t fighter2, int fight_start_time, int typ, Octets fighter1_pvpinfo, Octets fighter2_pvpinfo, int fighter1_zoneid, int fighter2_zoneid, int robot_flag, const Octets& exe_ver, const Octets& data_ver)
	   : _id(id), _mode(mode), _fighter1(fighter1), _fighter2(fighter2), _fight_start_time(fight_start_time),
	     //_next_client_tick(1), _latency(0), _typ(typ), _fighter1_pvpinfo(fighter1_pvpinfo), _fighter2_pvpinfo(fighter2_pvpinfo), 
	     _next_client_tick(1), _typ(typ), _fighter1_pvpinfo(fighter1_pvpinfo), _fighter2_pvpinfo(fighter2_pvpinfo), 
	     _fighter1_zoneid(fighter1_zoneid), _fighter2_zoneid(fighter2_zoneid), _robot_flag(robot_flag), _exe_ver(exe_ver), _data_ver(data_ver),
	     _big_lags_index(0)
	{
		time_t now = time(0);
		if(_fight_start_time < now) _fight_start_time = now;
		memset(_big_lags, 0, sizeof(_big_lags));
	}
	~PVP();

	void OnTimer(int tick, int now);
	void OnTimer1s(time_t now);

	void OnPVPOpeartion(int64_t fighter, int client_tick, const char *op_encoded, const char *crc_encoded);
	void OnPVPPeerLatency(int64_t src_role_id, int latency);
	
	void SendOperation(int win_flag, int robot_flag, int robot_seed);

private:
	int CheckFighter(time_t now, PVPFighter& fighter, int big_lag_count);
	//int64_t GetShouldArriveTime(int client_tick) const;
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

	int Create(int id, int mode, int64_t fighter1, int64_t fighter2, int fight_start_time, int typ, Octets fighter1_pvpinfo, Octets fighter2_pvpinfo, int fighter1_zoneid, int fighter2_zoneid, int robot_flag, const Octets& exe_ver, const Octets& data_ver, const Octets& fighter1_key, const Octets& fighter2_key);
	void Delete(int id);
	void SendOperation(int id, int win_flag, int robot_flag, int robot_seed);
	int GetCurRoomNum();
};

}

#endif //_PVP_MANAGER_H_
