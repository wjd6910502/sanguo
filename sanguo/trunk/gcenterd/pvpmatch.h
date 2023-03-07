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
#include "../common/commonmacro.h"
#include "glog.h"
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

#define PVP_TIME_MAX		900	//pvp最长持续时间，包括pause等

#define LOSE_COUNT		(-100)	//失败几次以后就开始匹配机器人

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

struct pvp_data //参加匹配的玩家
{
	int64_t role_id;
	int zoneid;
	Octets pvpinfo;
	int begin_time; //开始匹配的时间
	bool match_flag; //是否已经匹配到
	int pvp_ver;
	int win_count;
	int wait_time; //等待多久后给匹配机器人
	Octets exe_ver;
	Octets data_ver;
	Octets key; //数据加密用，不必管
	char vs_robot; //是否指定匹配到机器人
	int wait_max_before_vs_robot; //久匹配不到玩家时才会匹配到机器人

	pvp_data()
	{
		role_id = 0;
		zoneid = 0;
		begin_time = 0;
		match_flag = false;
		pvp_ver = 0;
		win_count = 0;
		wait_time = 0;
		vs_robot = 0;
		wait_max_before_vs_robot = 0;
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

struct pvp_match_data //匹配结果，生命周期从匹配成功一直到战斗结束
{
	int64_t fight1_id;
	int64_t fight2_id;
	int fight1_zoneid;
	int fight2_zoneid;
	Octets fight1_pvpinfo;
	Octets fight2_pvpinfo;
	int fight1_flag; //==1:收到PvpEnter了
	int fight2_flag;
	int fight1_ready; //==1:收到PvpReady了
	int fight2_ready;
	int fight1_elo_score;
	int fight2_elo_score;

	int fight_robot;//机器人标志,如果存在机器人的话一定是fight2是机器人
	int robot_seed;//机器人的战斗种子
	int robot_type;
	int begin_time; //这个是用来控制副本结束的。          用的是pvp战斗第1帧的时间
	int64_t winner; 
	int end_time; //这个是收到了第一个玩家结束的消息(PvpLeave)，然后几秒以后，把副本结束掉
	int typ; //TYP_COMMON/TYP_...

	int ready_time; //开始等待PvpReady的时刻，即收到两个PvpEnter
	int enter_time; //开始等待PvpEnter的时刻，即匹配成功
	std::string ip; //分配到的pvpd信息
	int ip_port;
	int pvp_sid;
	
	Octets exe_ver;
	Octets data_ver;
	int pvp_ver;

	Octets fight1_key;
	Octets fight2_key;

	//这个匹配的类型，0代表跨服匹配，1代表约战
	int match_pvp;
	int room_id;		//在约战的时候代表在gamed上的房间号
public:
	pvp_match_data(): fight1_id(0), fight2_id(0), fight1_zoneid(0),fight2_zoneid(0),fight1_flag(0), fight2_flag(0),fight1_ready(0),fight2_ready(0),
	fight1_elo_score(0),fight2_elo_score(0),fight_robot(0),begin_time(0),winner(0),end_time(0),typ(0),ready_time(0),enter_time(0),ip_port(0),
	pvp_sid(0),pvp_ver(0),match_pvp(0),room_id(0) {}
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

struct audience_data
{
	int64_t audience_id;
	//std::string audience_name;
	int audience_zoneid;

public:
      audience_data(): audience_id(0), audience_zoneid(0) {}
};

struct audience_room
{
	//战斗两个人的信息
	int64_t fight1_id;
	int64_t fight2_id;
	int fight1_zoneid;
	int fight2_zoneid;
	Octets fight1_pvpinfo;
	Octets fight2_pvpinfo;
	int fight_robot;//机器人标志,如果存在机器人的话一定是fight2是机器人
	int robot_seed;//机器人的战斗种子
	int robot_type;
	
	//操作的信息
	std::vector<PvpVideo> _all_operations;	//所有的操作
	std::vector<PvpVideo> _cur_operations;	//当前一定帧数的操作
	
	//弹幕的信息
	std::vector<DanMuInfo> danmu_info;

	//观众的信息
	std::map<int64_t, audience_data> audiences;

	//这个房间最后的录像存储的ID，为了防止弹幕发送的时候出现丢失，所以添加这个变量进行一下保存
	int64_t video_id;
	int see_flag;

	int begin_time;	//一个房间的存在时间是6分钟，超过6分钟就删除掉。
	
	//这个匹配的类型，0代表跨服匹配，1代表约战
	int match_pvp;
	int room_id;		//在约战的时候代表在gamed上的房间号

	//正常结束后发过来的比赛信息，因为这时只有_audience_data存在，所以就放在这了
	int _score;
	int _duration;

public:
	audience_room():fight1_id(0), fight2_id(0), fight1_zoneid(0), fight2_zoneid(0), fight_robot(0), robot_seed(0), robot_type(0), video_id(0), see_flag(1), begin_time(0), match_pvp(0), room_id(0), _score(0), _duration(0) {}
};


class PVPMatch: public IntervalTimer::Observer
{
private:
	//这是进行匹配的队列	
	std::map<pvp_data_key, pvp_data*, CmpByKeyInfo> _data;
	std::map<int64_t, pvp_data*> _role_data;
	//匹配成功的队列
	std::map<int, pvp_match_data> _match_data;
	//观看房间的信息
	std::map<int, audience_room> _audience_data; //key和_match_data是一致的

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

	void DelAudienceRoom(int index, int win_flag, int reason);

	//PVPD的接口
	void AddPVPServer(const char *ip, unsigned short port, unsigned int sid);
	void UpdatePVPServerLoad(unsigned int sid, int load);
	const pvp_server_data* AllocPVPServer() const;
	void PvpdPvpEnd(int index, int64_t fight1, int64_t fight2, int reason);
	void PvpdPvpPause(void *p/* PVPPause* */);
	void PvpdPvpPauseRe(int index, int64_t fighter);
	void PvpdPvpContinue(void *p/* PVPContinue* */);
	void PvpdDelInfo(int index);
	void PvpOperation(int index, int64_t fight1, int64_t fight2, Octets fight1_pvpinfo, Octets fight2_pvpinfo, 
			int fight1_zoneid, int fight2_zoneid, std::vector<PvpVideo> &pvp_video, int win_flag, 
			int robot_flag, int robot_seed, int robot_type, Octets exe_ver, Octets data_ver, int pvp_ver, int match_pvp);

	void AddAudienceRoom(int index);
	void AddAudienceOperation(int index, PvpVideo operation);
	bool Initialize();
	bool Update();
	
	//GAMED那边使用的接口
	int AddPVPData(pvp_data_key roleid, pvp_data data);
	int RolePvpCancle(int64_t roleid);
	
	int RolePvpEnter(int64_t roleid, int index, int flag);
	void RolePvpReady(int64_t roleid, int index);
	int RolePvpLeave(int64_t roleid, int index, int reason, int typ, int score, int duration);
	void RolePvpSpeed(int64_t roleid, int index, int speed);
	bool RolePvpReset(int64_t roleid, int index);
	void RoleGetPvpVideo(int64_t roleid, int zoneid, Octets video_id);
	void RoleDelPvpVideo(int64_t roleid, Octets video_id);

	pvp_match_data * GetPvpMatchData(int key);

	void AudienceGetAllList(int64_t roleid, int zoneid);
	void AudienceGetRoomInfo(int64_t roleid, int zoneid, int room_id);
	void AudienceLeave(int64_t roleid, int room_id);
	void YueZhanMatchSuccess(int64_t create_id, Octets create_pvpinfo, Octets create_key, int64_t join_id, 
	Octets join_pvpinfo, Octets join_key, int zoneid, int room_id, Octets exe_version, Octets data_version, int pvp_ver);
	void PvpDanMu(int64_t role_id, Octets role_name, int zone_id, int pvp_id, int64_t video_id, int tick, Octets danmu_info);
};


};
#endif
