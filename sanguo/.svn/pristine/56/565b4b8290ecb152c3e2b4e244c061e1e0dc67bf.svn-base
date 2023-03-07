#ifndef _PVP_MATCH_H_
#define _PVP_MATCH_H_

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include <string>
#include <map>
#include <vector>
#include <time.h>
#include <stdlib.h>

#include "gnet_timer.h"
#include "itimer.h"
#include "commonmacro.h"
#include "glog.h"
//#include "pvpvideo"
#include "common_var.h"

using namespace GNET;

namespace GNET
{
#define SUCCESS 		1 	//胜利
#define FAIL			0 	//失败

#define TYP_COMMON		0	//胜利，失败
#define TYP_ALL			1	//完胜，完败
#define TYP_SURRENDER		2	//投降
#define TYP_DROP		3	//掉线
#define TYP_DOUBLE		4	//双方都说自己胜利
#define TYP_OVERTIME		5	//战斗超时

struct pvp_data_key
{
	int64_t role_id;
	int score;
	int star;
};

struct CmpByKeyInfo
{
	bool operator()(const pvp_data_key &b1, const pvp_data_key &b2)
	{
		if(b1.score > b2.score)
		{
			return true;
		}
		else if(b1.score == b2.score)
		{
			if(b1.role_id > b2.role_id)
			{
				return true;
			}
		}
		return false;
	}
};

struct pvp_data
{
	int64_t role_id;
	int zoneid;
	Octets pvpinfo;
	int begin_time;
	bool match_flag;
	Octets exe_ver;
	Octets data_ver;
	Octets key;
	pvp_data()
	{
		role_id = 0;
		zoneid = 0;
		begin_time = 0;
		match_flag = false;
	}
};

struct robot_pvp_data
{
	int64_t role_id;
	int zoneid;
	int score;
	int star;
	Octets pvpinfo;
	robot_pvp_data()
	{
		role_id = 0;
		zoneid = 0;
		score = 0;
		star = 0;
	}
};

struct pvp_match_data
{
	int64_t fight1_id;
	int64_t fight2_id;
	int fight1_zoneid;
	int fight2_zoneid;
	Octets fight1_pvpinfo;
	Octets fight2_pvpinfo;
	int fight1_flag;
	int fight2_flag;
	int fight1_ready;
	int fight2_ready;
	int fight1_elo_score;
	int fight2_elo_score;

	int fight_robot;//机器人标志,如果存在机器人的话一定是fight2是机器人
	int robot_seed;//机器人的战斗种子
	int begin_time; //这个是用来控制副本结束的。
	int64_t winner; 
	int end_time; //这个是收到了第一个玩家结束的消息，然后几秒以后，把副本结束掉
	int typ;

	int ready_time;
	int enter_time;
	std::string ip;
	int ip_port;
	int pvp_sid;
	
	Octets exe_ver;
	Octets data_ver;

	Octets fight1_key;
	Octets fight2_key;
public:
	pvp_match_data(): fight1_id(0), fight2_id(0), fight1_zoneid(0),fight2_zoneid(0),fight1_flag(0), fight2_flag(0),fight1_ready(0),fight2_ready(0),fight1_elo_score(0),fight2_elo_score(0),fight_robot(0),begin_time(0),winner(0),end_time(0),typ(0),ready_time(0),enter_time(0),ip_port(0),pvp_sid(0) {}
};

struct pvp_server_data
{
	std::string _ip;
	unsigned short _port;
	unsigned int _sid;
	time_t _last_active_time;
	int _load;

public:
      pvp_server_data(): _port(0), _sid(0), _last_active_time(0), _load(0) {}
};

class PVPMatch: public IntervalTimer::Observer
{
private:
	//这是进行匹配的队列	
	std::map<pvp_data_key, pvp_data*, CmpByKeyInfo> _data;
	std::map<int64_t, pvp_data*> _role_data;
	//匹配成功的队列
	std::map<int, pvp_match_data> _match_data;

	//这个是管理所有的PVPd服务器的链接
	std::vector<pvp_server_data> _pvpds;

	//机器人的信息，在这里放一个机器人的队列，当需要机器人的时候，就从这个队列中随机一个出来
	std::map<int64_t, int> _robot_flag;
	std::vector<robot_pvp_data> _robot_info;

	static int pvp_index;
	static int robot_index;

	//每一个玩家都计算一次。
	int CalEloScore(int selfscore, int fightscore, int win_flag);
public:
	PVPMatch();
	static PVPMatch& GetInstance()
	{
		static PVPMatch _instance;
		return _instance;
	}

	//PVPD的接口
	void AddPVPServer(const char *ip, unsigned short port, unsigned int sid);
	void UpdatePVPServerLoad(unsigned int sid, int load);
	const pvp_server_data* AllocPVPServer() const;
	void PvpdPvpEnd(int index, int64_t fight1, int64_t fight2, int reason);
	void PvpdDelInfo(int index);
	void PvpOperation(int64_t fight1, int64_t fight2, Octets fight1_pvpinfo, Octets fight2_pvpinfo, 
			int fight1_zoneid, int fight2_zoneid, std::vector<PvpVideo> &pvp_video, int win_flag, 
			int robot_flag, int robot_seed, Octets exe_ver, Octets data_ver);

	bool Initialize();
	bool Update();
	
	//GAMED那边使用的接口
	int AddPVPData(pvp_data_key roleid, pvp_data data);
	int RolePvpCancle(int64_t roleid);
	
	int RolePvpEnter(int64_t roleid, int index, int flag);
	void RolePvpReady(int64_t roleid, int index);
	int RolePvpLeave(int64_t roleid, int index, int reason, int typ);
	void RolePvpSpeed(int64_t roleid, int index, int speed);
	bool RolePvpReset(int64_t roleid, int index);
	void RoleGetPvpVideo(int64_t roleid, int zoneid, Octets video_id);
	void RoleDelPvpVideo(int64_t roleid, Octets video_id);

	pvp_match_data * GetPvpMatchData(int key);
};


};
#endif
