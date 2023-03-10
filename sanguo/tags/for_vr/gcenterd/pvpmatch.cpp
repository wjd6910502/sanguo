#include "pvpmatch.h"
#include "gcenterserver.hpp"
#include "pvpmatchsuccess.hpp"
#include "pvpenterre.hpp"
#include "pvpcreate.hrp"
#include "pvpgameserver.hpp"
#include "pvpleavere.hpp"
#include "pvpdelete.hpp"
#include "pvpcentercreate.hpp"
#include "pvpspeedre.hpp"
#include "pvpresetre.hpp"
#include "pvpvideodata"
#include "sendpvpvideoid.hpp"
#include "getpvpvideore.hpp"

extern leveldb::DB* g_db;

namespace GNET
{

int PVPMatch::pvp_index = 1000000;
int PVPMatch::robot_index = 1000000;

PVPMatch::PVPMatch()
{
	Initialize();
}

void PVPMatch::AddPVPServer(const char *ip, unsigned short port, unsigned int sid)
{
	for(auto it=_pvpds.begin(); it!=_pvpds.end(); ++it)
	{
		if(it->_ip==ip && it->_port==port)
		{
	                it->_sid = sid;
	                it->_last_active_time = Now();
	                it->_load = 0;
	                return;
	        }
	}
	pvp_server_data pvpd;
	pvpd._ip = ip;
	pvpd._port = port;
	pvpd._sid = sid;
	pvpd._last_active_time = Now();
	pvpd._load = 0;
	_pvpds.push_back(pvpd);
}

void PVPMatch::UpdatePVPServerLoad(unsigned int sid, int load)
{
	for(auto it=_pvpds.begin(); it!=_pvpds.end(); ++it)
	{
		if(it->_sid == sid)
		{
			it->_last_active_time = Now();
			it->_load = load;
			return;
		}
	}
}

const pvp_server_data* PVPMatch::AllocPVPServer() const
{
	if(_pvpds.empty()) return 0;
	
	time_t now = Now();
	int cur_num = 0;
	int index = 0;
	int flag = 0;
	for(auto it=_pvpds.begin(); it!=_pvpds.end(); ++it,++flag)
	{
		if(cur_num > it->_load && now-it->_last_active_time<10)
		{
			cur_num = it->_load;
			index = flag;
		}
	}
	return &_pvpds[index];
}

int PVPMatch::AddPVPData(pvp_data_key data_key, pvp_data data)
{
	//首先查找这个玩家是否已经在进行匹配了
	std::map<int64_t, pvp_data*>::iterator it = _role_data.find(data_key.role_id);
	if(it != _role_data.end())
	{
		return 1;
	}

	pvp_data *p_data = new pvp_data();
	p_data->role_id = data.role_id;
	p_data->zoneid = data.zoneid;
	p_data->pvpinfo = data.pvpinfo;
	p_data->begin_time = data.begin_time;

	_data[data_key] = p_data;
	_role_data[data_key.role_id] = p_data;

	std::map<int64_t, int>::iterator robot_it = _robot_flag.find(data_key.role_id);
	if(robot_it == _robot_flag.end())
	{
		_robot_flag[data_key.role_id] = 1;
		robot_pvp_data tmp_robot_pvp_data;
		tmp_robot_pvp_data.role_id = data_key.role_id;
		tmp_robot_pvp_data.zoneid = data.zoneid;
		tmp_robot_pvp_data.score = data_key.score;
		tmp_robot_pvp_data.star = data_key.star;
		tmp_robot_pvp_data.pvpinfo = data.pvpinfo;
		_robot_info.push_back(tmp_robot_pvp_data);
	}
	return 0;
}

bool PVPMatch::Initialize()
{
	IntervalTimer::Attach(this, (1000000) / IntervalTimer::Resolution());
	return true;
}

bool PVPMatch::Update()
{
	{
		//在这里进行对手的匹配
		std::map<pvp_data_key, pvp_data*>::iterator it = _data.begin();
		while (it != _data.end())
		{
			//开始找it后面的几个数值来进行筛选
			if(it->second->match_flag == false)
			{
				//在这里加入机器人的匹配
				if(Now() - it->second->begin_time >= 30)
				{
					int cur_time = Now();
					int time1;
					pvp_match_data tmp;
					tmp.fight1_id = it->second->role_id;
					tmp.fight1_zoneid = it->second->zoneid;
					tmp.fight1_pvpinfo = it->second->pvpinfo;
					tmp.fight1_elo_score = it->first.score;
					time1 = cur_time - it->second->begin_time;
					
					if (_robot_info.size() > 0)
					{
						srand(time(0));
						int robot_info_index = rand()%_robot_info.size();
						if(_robot_info[robot_info_index].role_id != it->second->role_id)
						{
							robot_index++;

							//在这里随机一个机器人出来
							tmp.fight2_id = robot_index;
							tmp.fight2_zoneid = _robot_info[robot_info_index].zoneid;
							tmp.fight2_pvpinfo = _robot_info[robot_info_index].pvpinfo;
							tmp.fight2_elo_score = _robot_info[robot_info_index].score;
							
							tmp.enter_time = cur_time;
							tmp.fight_robot = 1;
							tmp.robot_seed = rand()%10 + 1;

							tmp.exe_ver = it->second->exe_ver;
							tmp.data_ver = it->second->data_ver;
							pvp_index++;
							_match_data[pvp_index] = tmp;

							//单独给这个玩家发送匹配成功的消息
							PvpMatchSuccess pro;
							pro.retcode = 0;
							pro.index = pvp_index;
							pro.roleid = tmp.fight1_id;
							pro.time = time1;
							GCenterServer::GetInstance()->DispatchProtocol(tmp.fight1_zoneid, pro);
							it->second->match_flag = true;
						}
					}
				}
				else
				{
					std::map<pvp_data_key, pvp_data*>::iterator tmp_it = it;
					tmp_it++;
					int match_count = 0;
					std::vector<pvp_data_key> tmp_vector;
					tmp_vector.clear();
					while(match_count < 7 && tmp_it != _data.end())
					{
						//10个星星之内的玩家会进行匹配
						if( ((it->first.star - tmp_it->first.star) <= 100) && 
								(it->second->exe_ver == tmp_it->second->exe_ver) && 
								it->second->data_ver == tmp_it->second->data_ver)
						{
							tmp_vector.push_back(tmp_it->first);
						}
						else
						{
							//因为这个是有序的只要有一个不符合这个星星的要求了，后面的就已经不需要进行任何的判断了
							break;
						}
						match_count++;
						tmp_it++;
					}
					if(tmp_vector.size() > 0)
					{
						//在这里随机一个玩家出来作为匹配对手
						int role_count = tmp_vector.size();
						srand(time(0));
						int select_role = rand()%role_count;
						std::map<pvp_data_key, pvp_data*>::iterator select_it = _data.find(tmp_vector[select_role]);
						if(select_it != _data.end())
						{
							int time1, time2;
							pvp_match_data tmp;
							tmp.fight1_id = it->second->role_id;
							tmp.fight1_zoneid = it->second->zoneid;
							tmp.fight1_pvpinfo = it->second->pvpinfo;
							tmp.fight1_elo_score = it->first.score;
							time1 = Now() - it->second->begin_time;
							it->second->match_flag = true;

							tmp.fight2_id = select_it->second->role_id;
							tmp.fight2_zoneid = select_it->second->zoneid;
							tmp.fight2_pvpinfo = select_it->second->pvpinfo;
							tmp.fight2_elo_score = select_it->first.score;
							time2 = Now() - select_it->second->begin_time;
							select_it->second->match_flag = true;
							
							tmp.enter_time = Now();
							tmp.exe_ver = it->second->exe_ver;
							tmp.data_ver = it->second->data_ver;
							pvp_index++;
							_match_data[pvp_index] = tmp;

							//给这两个玩家发送匹配成功的消息
							PvpMatchSuccess pro;
							pro.retcode = 0;
							pro.index = pvp_index;
							pro.roleid = tmp.fight1_id;
							pro.time = time1;
							GCenterServer::GetInstance()->DispatchProtocol(tmp.fight1_zoneid, pro);
							pro.roleid = tmp.fight2_id;
							pro.time = time2;
							GCenterServer::GetInstance()->DispatchProtocol(tmp.fight2_zoneid, pro);
						}
						else
						{
							//走到这里肯定是出了严重的错误了。
						}
					}
				}

			}
			it++;
		}
	}
	
	{
		//在这里把已经进行了匹配的玩家进行删除
		std::map<pvp_data_key, pvp_data*>::iterator it = _data.begin();
		while(it != _data.end())
		{
			if(it->second->match_flag)
			{
				std::map<int64_t, pvp_data*>::iterator role_it = _role_data.find(it->first.role_id);
				if(role_it != _role_data.end())
				{
					delete role_it->second;
					role_it->second = NULL;
					_role_data.erase(role_it);
				}
				_data.erase(it++);
			}
			else
			{
				it++;
			}
		}
	}

	//开始判断是否可以通知玩家双方都已经同意，告诉他们可以开始准备进入了
	std::map<int, pvp_match_data>::iterator it = _match_data.begin();
	while(it != _match_data.end())
	{
		if( it->second.enter_time != 0 && (Now() - it->second.enter_time) > 60)
		{
			//这是由于双方有一方或者双方一直不给服务器发送准备好的消息
			PvpCenterCreate pro;
			pro.roleid = it->second.fight1_id;
			pro.retcode = 103;

			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

			pro.roleid = it->second.fight2_id;
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

			_match_data.erase(it++);
		}
		else if( it->second.ready_time != 0 && (Now() - it->second.ready_time) > 60)
		{
			//这里是由于双方的Ready有一方一直无法发送过来
			PvpCenterCreate pro;
			pro.roleid = it->second.fight1_id;
			pro.retcode = 101;

			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

			pro.roleid = it->second.fight2_id;
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

			_match_data.erase(it++);
		}
		else if(it->second.begin_time != 0 && (Now() - it->second.begin_time) > 600)
		{
			//已经打了5分钟，肯定是客户端哪里出了问题，直接让双方都失败就可以了。
			PvpLeaveRe pro;
			pro.roleid = it->second.fight1_id;
			pro.typ = TYP_OVERTIME;
			pro.result = FAIL;
			pro.elo_score = CalEloScore(it->second.fight1_elo_score, it->second.fight2_elo_score, pro.result==SUCCESS?1:0);
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

			pro.roleid = it->second.fight2_id;
			pro.elo_score = CalEloScore(it->second.fight2_elo_score, it->second.fight1_elo_score, pro.result==SUCCESS?1:0);
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight2_zoneid, pro);
			
			//通知PVPD服务器删除
			PVPDelete prot;
			prot.id = it->first;
			prot.video_flag = 0;
			prot.robot_flag = it->second.fight_robot;
			prot.robot_seed = it->second.robot_seed;
			PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
			
			//删除这个房间
			_match_data.erase(it++);
		}
		else if(it->second.end_time != 0 && (Now() - it->second.end_time) > 10)
		{
			//首先需要注意，只要进到这里肯定是有一个玩家已经发了过来的。
			//直接按照当前服务器知道的信息来判断胜负
			PvpLeaveRe pro;
			pro.roleid = it->second.fight1_id;
			if(it->second.fight1_id == it->second.winner)
			{
				pro.result = SUCCESS;
				pro.typ = it->second.typ;
			}
			else
			{
				pro.result = FAIL;
				pro.typ = it->second.typ;
			}
			pro.elo_score = CalEloScore(it->second.fight1_elo_score, it->second.fight2_elo_score, pro.result==SUCCESS?1:0);
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

			pro.roleid = it->second.fight2_id;
			if(it->second.fight2_id == it->second.winner)
			{
				pro.result = SUCCESS;
				pro.typ = it->second.typ;
			}
			else
			{
				pro.result = FAIL;
				pro.typ = it->second.typ;
			}
			pro.elo_score = CalEloScore(it->second.fight2_elo_score, it->second.fight1_elo_score, pro.result==SUCCESS?1:0);
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight2_zoneid, pro);
			
			//通知PVPD服务器删除
			PVPDelete prot;
			prot.id = it->first;
			prot.video_flag = 0;
			prot.robot_flag = it->second.fight_robot;
			prot.robot_seed = it->second.robot_seed;
			PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
			
			//删除这个房间
			_match_data.erase(it++);
		}
		else
		{
			it++;
		}
	}
	return true;
}

int PVPMatch::RolePvpEnter(int64_t roleid, int index, int flag)
{
	std::map<int, pvp_match_data>::iterator it = _match_data.find(index);
	if(it != _match_data.end())
	{
		if(roleid == it->second.fight1_id)
		{
			it->second.fight1_flag = 1;
		}
		else if(roleid == it->second.fight2_id)
		{
			it->second.fight2_flag = 1;
		}
		else
		{
			return 2;
		}
		if(it->second.fight1_flag == 1 && it->second.fight_robot == 1)
		{
			//给玩家发送消息，并且把玩家从当前的队列中删除
			PvpEnterRe pro;
			pro.roleid = it->second.fight1_id;
			pro.pvpinfo = it->second.fight1_pvpinfo;
			pro.fight_pvpinfo = it->second.fight2_pvpinfo;
			pro.robot_flag = 1;
			pro.robot_seed = it->second.robot_seed;
			
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

			it->second.enter_time = 0;
			it->second.ready_time = Now();
		}
		else if(it->second.fight2_flag == 1 && it->second.fight1_flag == 1)
		{
			//给玩家发送消息，并且把玩家从当前的队列中删除
			PvpEnterRe pro;
			pro.roleid = it->second.fight1_id;
			pro.pvpinfo = it->second.fight1_pvpinfo;
			pro.fight_pvpinfo = it->second.fight2_pvpinfo;
			pro.robot_flag = 0;
			
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

			pro.roleid = it->second.fight2_id;
			pro.pvpinfo = it->second.fight1_pvpinfo;
			pro.fight_pvpinfo = it->second.fight2_pvpinfo;
			
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight2_zoneid, pro);
			it->second.enter_time = 0;
			it->second.ready_time = Now();
		}
	}
	else
	{
		return 1;
	}

	return 0;
}

pvp_match_data * PVPMatch::GetPvpMatchData(int key)
{
	std::map<int, pvp_match_data>::iterator it = _match_data.find(key);
	if(it != _match_data.end())
	{
		return &it->second;
	}
	else
	{
		return NULL;
	}
}

int PVPMatch::RolePvpLeave(int64_t roleid, int index, int reason, int typ)
{
	//reason =  1- 胜利  0-失败
	//type = 0 - 正常胜利/失败   1-完胜/完败   2-投降 3-掉线  4-双方都说自己胜利
	std::map<int, pvp_match_data>::iterator it = _match_data.find(index);
	if(it != _match_data.end())
	{
		if(it->second.fight_robot == 1)
		{
			//开始查看这个玩家是否在这个房间里面
			if(it->second.fight1_id != roleid)
				return 0;
			//这个是为了判断出来谁是获胜的人。
			if(reason == 1)
			{
				it->second.typ = typ;
				it->second.winner = roleid;
			}
			else if(reason == 0)
			{
				it->second.typ = typ;
				it->second.winner = it->second.fight2_id;
			}
			
			if(typ == TYP_SURRENDER)
			{
				PvpLeaveRe pro;
				pro.roleid = it->second.fight1_id;
				if(it->second.fight1_id == it->second.winner)
					pro.result = SUCCESS;
				else
					pro.result = FAIL;
				pro.typ = typ;
				pro.elo_score = CalEloScore(it->second.fight1_elo_score, it->second.fight2_elo_score, pro.result==SUCCESS?1:0);
				GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

				//通知PVPD服务器删除
				PVPDelete prot;
				prot.id = index;
				prot.video_flag = 0;
				prot.robot_flag = it->second.fight_robot;
				prot.robot_seed = it->second.robot_seed;
				PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
				
				//删除这个房间
				_match_data.erase(it);

				return 0;
			}
			
			//在这里就可以给玩家回去消息，然后通知PVPD来进行副本删除
			PvpLeaveRe pro;
			pro.roleid = it->second.fight1_id;
			if(it->second.fight1_id == it->second.winner)
				pro.result = SUCCESS;
			else
				pro.result = FAIL;
			pro.typ = typ;
			pro.elo_score = CalEloScore(it->second.fight1_elo_score, it->second.fight2_elo_score, pro.result==SUCCESS?1:0);
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

			//通知PVPD服务器删除
			PVPDelete prot;
			prot.id = index;
			prot.video_flag = 1;
			prot.robot_flag = it->second.fight_robot;
			prot.robot_seed = it->second.robot_seed;
			if(pro.result == SUCCESS)
				prot.win_flag = 1;
			else
				prot.win_flag = 0;
			PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
			
			//删除这个房间
			_match_data.erase(it);

			return 0;
		}
		else
		{
			//开始查看这个玩家是否在这个房间里面
			if(it->second.fight1_id == roleid || it->second.fight2_id == roleid)
			{
				//这个是为了判断出来谁是获胜的人。
				if(reason == 1)
				{
					if(it->second.winner != 0)
					{
						if(it->second.winner != roleid)
						{
							//在这里就存在问题了。为什么两个人发来的信息不一致呢。目前先按照两个玩家都是输了来进行处理
							PvpLeaveRe pro;
							pro.roleid = it->second.fight1_id;
							pro.result = FAIL;
							pro.typ = TYP_DOUBLE;
							pro.elo_score = CalEloScore(it->second.fight1_elo_score, it->second.fight2_elo_score, pro.result==SUCCESS?1:0);
							GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

							pro.roleid = it->second.fight2_id;
							pro.result = FAIL;
							pro.typ = TYP_DOUBLE;
							pro.elo_score = CalEloScore(it->second.fight2_elo_score, it->second.fight1_elo_score, pro.result==SUCCESS?1:0);
							GCenterServer::GetInstance()->DispatchProtocol(it->second.fight2_zoneid, pro);
							
							//通知PVPD服务器删除
							PVPDelete prot;
							prot.id = index;
							prot.video_flag = 0;
							prot.robot_flag = it->second.fight_robot;
							prot.robot_seed = it->second.robot_seed;
							PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
							
							//删除这个房间
							_match_data.erase(it);

							return 0;
						}
					}
					else
					{
						it->second.winner = roleid;
						it->second.typ = typ;
					}
				}
				else if(reason == 0)
				{
					if(it->second.winner == roleid)
					{
						//既然双方都说自己输了，那就输了吧
						PvpLeaveRe pro;
						pro.roleid = it->second.fight1_id;
						pro.result = FAIL;
						pro.typ = TYP_COMMON;
						pro.elo_score = CalEloScore(it->second.fight1_elo_score, it->second.fight2_elo_score, pro.result==SUCCESS?1:0);
						GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

						pro.roleid = it->second.fight2_id;
						pro.result = FAIL;
						pro.typ = TYP_COMMON;
						pro.elo_score = CalEloScore(it->second.fight2_elo_score, it->second.fight1_elo_score, pro.result==SUCCESS?1:0);
						GCenterServer::GetInstance()->DispatchProtocol(it->second.fight2_zoneid, pro);
						
						//通知PVPD服务器删除
						PVPDelete prot;
						prot.id = index;
						prot.video_flag = 0;
						prot.robot_flag = it->second.fight_robot;
						prot.robot_seed = it->second.robot_seed;
						PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
						
						//删除这个房间
						_match_data.erase(it);

						return 0;
					}
					else
					{
						it->second.typ = typ;
						if(it->second.fight1_id == roleid)
						{
							it->second.winner = it->second.fight2_id;
						}
						else
						{
							it->second.winner = it->second.fight1_id;
						}
					}
				}
			
				if(typ == TYP_SURRENDER)
				{
					PvpLeaveRe pro;
					pro.roleid = it->second.fight1_id;
					if(it->second.fight1_id == it->second.winner)
						pro.result = SUCCESS;
					else
						pro.result = FAIL;
					pro.typ = typ;
					pro.elo_score = CalEloScore(it->second.fight1_elo_score, it->second.fight2_elo_score, pro.result==SUCCESS?1:0);
					GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

					pro.roleid = it->second.fight2_id;
					if(it->second.fight2_id == it->second.winner)
						pro.result = SUCCESS;
					else
						pro.result = FAIL;
					pro.typ = typ;
					pro.elo_score = CalEloScore(it->second.fight2_elo_score, it->second.fight1_elo_score, pro.result==SUCCESS?1:0);
					GCenterServer::GetInstance()->DispatchProtocol(it->second.fight2_zoneid, pro);
					
					//通知PVPD服务器删除
					PVPDelete prot;
					prot.id = index;
					prot.video_flag = 0;
					prot.robot_flag = it->second.fight_robot;
					prot.robot_seed = it->second.robot_seed;
					PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
					
					//删除这个房间
					_match_data.erase(it);

					return 0;
				}
				//这里是为了判断是否两个玩家都发来了结束消息的
				if(it->second.end_time == 0)
				{
					it->second.end_time = Now();
				}
				else
				{
					if(typ == it->second.typ)
					{
						//在这里就可以给玩家回去消息，然后通知PVPD来进行副本删除
						PvpLeaveRe pro;
						pro.roleid = it->second.fight1_id;
						if(it->second.fight1_id == it->second.winner)
							pro.result = SUCCESS;
						else
							pro.result = FAIL;
						pro.typ = typ;
						pro.elo_score = CalEloScore(it->second.fight1_elo_score, it->second.fight2_elo_score, pro.result==SUCCESS?1:0);
						GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

						pro.roleid = it->second.fight2_id;
						if(it->second.fight2_id == it->second.winner)
							pro.result = SUCCESS;
						else
							pro.result = FAIL;
						pro.typ = typ;
						pro.elo_score = CalEloScore(it->second.fight2_elo_score, it->second.fight1_elo_score, pro.result==SUCCESS?1:0);
						GCenterServer::GetInstance()->DispatchProtocol(it->second.fight2_zoneid, pro);
						
						//通知PVPD服务器删除
						PVPDelete prot;
						prot.id = index;
						prot.video_flag = 1;
						prot.robot_flag = it->second.fight_robot;
						prot.robot_seed = it->second.robot_seed;
						if(pro.result == SUCCESS)
							prot.win_flag = 0;
						else
							prot.win_flag = 1;
						PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
						
						//删除这个房间
						_match_data.erase(it);

						return 0;
					}
					else
					{
					}
				}
			}
		}
	}
	return 0;
}

void PVPMatch::PvpdPvpEnd(int index, int64_t fight1, int64_t fight2, int reason)
{
	std::map<int, pvp_match_data>::iterator it = _match_data.find(index);

	if(it != _match_data.end())
	{
		//验证信息
		if((fight1 == it->second.fight1_id || fight1 == it->second.fight2_id) && (fight2 == it->second.fight1_id || fight2 == it->second.fight2_id))
		{
			int64_t winner = 0;
			if(it->second.winner != 0)
			{
				winner = it->second.winner;
			}
			else
			{
				if(reason > 100)
				{
					winner = fight1;
				}
				else
				{
					winner = fight2;
				}
			}
			
			PvpLeaveRe pro;
			pro.roleid = it->second.fight1_id;
			if(it->second.fight1_id == winner)
			{
				pro.result = SUCCESS;
				if(it->second.winner != 0)
					pro.typ = it->second.typ;
				else
					pro.typ = TYP_DROP;
			}
			else
			{
				pro.result = FAIL;
				if(it->second.winner != 0)
					pro.typ = it->second.typ;
				else
					pro.typ = TYP_DROP;
			}
			pro.elo_score = CalEloScore(it->second.fight1_elo_score, it->second.fight2_elo_score, pro.result==SUCCESS?1:0);
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

			pro.roleid = it->second.fight2_id;
			if(it->second.fight2_id == winner)
			{
				pro.result = SUCCESS;
				if(it->second.winner != 0)
					pro.typ = it->second.typ;
				else
					pro.typ = TYP_DROP;
			}
			else
			{
				pro.result = FAIL;
				if(it->second.winner != 0)
					pro.typ = it->second.typ;
				else
					pro.typ = TYP_DROP;
			}
			pro.elo_score = CalEloScore(it->second.fight2_elo_score, it->second.fight1_elo_score, pro.result==SUCCESS?1:0);
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight2_zoneid, pro);
			
			//删除这个房间
			_match_data.erase(it);
		}
	}
}

void PVPMatch::RolePvpReady(int64_t roleid, int index)
{
	std::map<int, pvp_match_data>::iterator it = _match_data.find(index);
	if(it != _match_data.end())
	{
		if(roleid == it->second.fight1_id)
		{
			it->second.fight1_ready = 1;
			//if(it->second.ready_time == 0)
			//{
			//	it->second.ready_time = Now();
			//}
		}
		else if(roleid == it->second.fight2_id)
		{
			it->second.fight2_ready = 1;
			//if(it->second.ready_time == 0)
			//{
			//	it->second.ready_time = Now();
			//}
		}
		if(it->second.fight1_ready == 1 && it->second.fight_robot == 1)
		{
			//在这里通知PVPD服务器,相应的信息
			it->second.ready_time = 0;
			const pvp_server_data* pvpd = AllocPVPServer();
			if(!pvpd)
			{
				GLog::log(LOG_ERR, "GAMED::PVPD_Create, AllocPVPServer error");
				//在这里需要给客户端错误，不能让客户端一直卡在界面上
				PvpCenterCreate pro;
				pro.roleid = it->second.fight1_id;
				pro.retcode = 102;

				GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

				_match_data.erase(it++);
				return;
			}
				
			int begin_time = Now() + 5;
			it->second.ip = pvpd->_ip;
			it->second.ip_port = pvpd->_port;
			it->second.pvp_sid = pvpd->_sid;
			it->second.begin_time = begin_time;
						 
			PVPCreateArg arg;
			arg.id = it->first;
			arg.mode = 1;
			arg.fighter1 = it->second.fight1_id;
			arg.fighter2 = it->second.fight2_id;
			arg.start_time = begin_time;
			arg.typ = 1;
			arg.robot_flag = 1;
			arg.fighter1_pvpinfo = it->second.fight1_pvpinfo;
			arg.fighter2_pvpinfo = it->second.fight2_pvpinfo;
			arg.fighter1_zoneid = it->second.fight1_zoneid;
			arg.fighter2_zoneid = it->second.fight2_zoneid;
			arg.exe_ver = it->second.exe_ver;
			arg.data_ver = it->second.data_ver;

			PVPCreate *rpc = (PVPCreate*)Rpc::Call(RPC_PVPCREATE, arg);
			PVPGameServer::GetInstance()->Send(pvpd->_sid, rpc);
			it++;
		}
		else if(it->second.fight1_ready == 1 && it->second.fight2_ready == 1)
		{
			//在这里通知PVPD服务器,相应的信息
			it->second.ready_time = 0;
			const pvp_server_data* pvpd = AllocPVPServer();
			if(!pvpd)
			{
				GLog::log(LOG_ERR, "GAMED::PVPD_Create, AllocPVPServer error");
				//在这里需要给客户端错误，不能让客户端一直卡在界面上
				PvpCenterCreate pro;
				pro.roleid = it->second.fight1_id;
				pro.retcode = 102;

				GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

				pro.roleid = it->second.fight2_id;
				GCenterServer::GetInstance()->DispatchProtocol(it->second.fight2_zoneid, pro);

				_match_data.erase(it++);
				return;
			}
				
			int begin_time = Now() + 5;
			it->second.ip = pvpd->_ip;
			it->second.ip_port = pvpd->_port;
			it->second.pvp_sid = pvpd->_sid;
			it->second.begin_time = begin_time;
						 
			PVPCreateArg arg;
			arg.id = it->first;
			arg.mode = 1;
			arg.fighter1 = it->second.fight1_id;
			arg.fighter2 = it->second.fight2_id;
			arg.start_time = begin_time;
			arg.typ = 1;
			arg.robot_flag = 0;
			arg.fighter1_pvpinfo = it->second.fight1_pvpinfo;
			arg.fighter2_pvpinfo = it->second.fight2_pvpinfo;
			arg.fighter1_zoneid = it->second.fight1_zoneid;
			arg.fighter2_zoneid = it->second.fight2_zoneid;
			arg.exe_ver = it->second.exe_ver;
			arg.data_ver = it->second.data_ver;

			PVPCreate *rpc = (PVPCreate*)Rpc::Call(RPC_PVPCREATE, arg);
			PVPGameServer::GetInstance()->Send(pvpd->_sid, rpc);
			it++;
		}
	}
	return;
}

int PVPMatch::RolePvpCancle(int64_t roleid)
{
	std::map<int64_t, pvp_data*>::iterator it = _role_data.find(roleid);
	if(it != _role_data.end())
	{
		_role_data.erase(roleid);
		
		std::map<pvp_data_key, pvp_data*>::iterator tmp_it = _data.begin();
		while(tmp_it != _data.end())
		{
			if(tmp_it->first.role_id == roleid)
			{
				delete tmp_it->second;
				tmp_it->second = NULL;
				_data.erase(tmp_it);
				return 0;
			}
			tmp_it++;
		}

		return 0;
	}
	else
	{
		return 1;
	}
}
void PVPMatch::PvpdDelInfo(int index)
{
	std::map<int, pvp_match_data>::iterator it = _match_data.find(index);
	if(it != _match_data.end())
	{
		//通知PVPD服务器删除
		PVPDelete prot;
		prot.id = it->first;
		prot.video_flag = 0;
		prot.robot_flag = it->second.fight_robot;
		prot.robot_seed = it->second.robot_seed;
		PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
		
		//删除这个房间
		_match_data.erase(it++);
	}
}

void PVPMatch::RolePvpSpeed(int64_t roleid, int index, int speed)
{
	std::map<int, pvp_match_data>::iterator it = _match_data.find(index);
	if(it != _match_data.end())
	{
		if(roleid == it->second.fight1_id)
		{
			if(it->second.fight_robot == 0)
			{
				PvpSpeedRe pro;
				pro.roleid = it->second.fight2_id;
				pro.speed = speed;
				GCenterServer::GetInstance()->DispatchProtocol(it->second.fight2_zoneid, pro);
			}
		}
		else if(roleid == it->second.fight2_id)
		{
			PvpSpeedRe pro;
			pro.roleid = it->second.fight1_id;
			pro.speed = speed;
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);
		}
	}
	return;
}

bool PVPMatch::RolePvpReset(int64_t roleid, int index)
{
	std::map<int, pvp_match_data>::iterator it = _match_data.find(index);
	if(it != _match_data.end())
	{
		if(roleid == it->second.fight1_id)
		{
			//谁发起的给谁返回去0,另一个返回去1
			PvpResetRe pro;
			pro.retcode = 0;
			pro.roleid = it->second.fight1_id;
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);
			
			pro.retcode = 1;
			pro.roleid = it->second.fight2_id;
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight2_zoneid, pro);
			
			_match_data.erase(it++);
			return true;
		}
		else if(roleid == it->second.fight2_id)
		{
			PvpResetRe pro;
			pro.retcode = 1;
			pro.roleid = it->second.fight1_id;
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);
			
			pro.retcode = 0;
			pro.roleid = it->second.fight2_id;
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight2_zoneid, pro);
			
			_match_data.erase(it++);
			return true;
		}
		return false;
	}
	return false;
}

int PVPMatch::CalEloScore(int selfscore, int fightscore, int win_flag)
{
	int diff_score = fightscore - selfscore;
	float per = 0;
	if(diff_score > 0)
	{
		per = 1/(1 + 10.0*diff_score/400);
	}
	else if(diff_score == 0)
	{
		per = 0.5;
	}
	else
	{

		per = 1/(1 + 400/(10.0*-diff_score));
	}
	return 16*(win_flag - per);
}

void PVPMatch::PvpOperation(int64_t fight1, int64_t fight2, Octets fight1_pvpinfo, Octets fight2_pvpinfo,
		int fight1_zoneid, int fight2_zoneid, std::vector<PvpVideo> &pvp_video, int win_flag, 
		int robot_flag, int robot_seed, Octets exe_ver, Octets data_ver)
{
	string pvp_operation = SerializeManager::SerializePvpOperation(pvp_video);

	//开始进行数据库的存储
	std::string find_key = "pvp_operation";
	std::string value;
	leveldb::Status status = g_db->Get(leveldb::ReadOptions(),find_key,&value);

	int64_t video_id = 1;
	
	if(!status.ok())
	{
		//代表没有找到，那么就直接赋值初始化，然后存进去
		char msg[128];
		snprintf(msg, sizeof(msg), "%ld", video_id);
		value = msg;

		g_db->Put(leveldb::WriteOptions(), find_key, value);
	}
	else
	{
		video_id = atoll(value.c_str());
		video_id++;
		
		char msg[128];
		snprintf(msg, sizeof(msg), "%ld", video_id);
		value = msg;
		
		g_db->Put(leveldb::WriteOptions(), find_key, value);
	}
	PvpVideoData data;
	data.first = fight1;
	data.second = fight2;
	data.first_pvpinfo = fight1_pvpinfo;
	data.second_pvpinfo = fight2_pvpinfo;
	data.operation = Octets((void*)pvp_operation.c_str(), pvp_operation.size());
	data.win_flag = win_flag;
	data.del_flag = 0;
	data.robot_flag = robot_flag;
	data.robot_seed = robot_seed;
	data.exe_ver = exe_ver;
	data.data_ver = data_ver;

	Marshal::OctetsStream os;
	data.marshal(os);
	
	Octets value_data = os;
	value = std::string((char*)value_data.begin(), value_data.size());

	//开始存储录像
	char msg[128];
	snprintf(msg, sizeof(msg), "videoid_%ld", video_id);

	string video_key = msg;
	g_db->Put(leveldb::WriteOptions(), video_key, value);
	
	//memset(msg, 0, sizeof(msg));
	//snprintf(msg, sizeof(msg), "videoid_%ld_%ld", fight2,video_id);
	//video_key = msg;
	//g_db->Put(leveldb::WriteOptions(), video_key, value);

	//把这个录像的编号，发给每一个玩家，这个房间号是保存在自己的服务器的。
	SendPvpVideoID pro;
	pro.roleid = fight1;
	pro.video_id = video_id;
	pro.first_pvpinfo = fight1_pvpinfo;
	pro.second_pvpinfo = fight2_pvpinfo;
	pro.win_flag = win_flag;

	GCenterServer::GetInstance()->DispatchProtocol(fight1_zoneid, pro);

	if(robot_flag == 0)
	{
		pro.roleid = fight2;
		GCenterServer::GetInstance()->DispatchProtocol(fight2_zoneid, pro);
	}
}

void PVPMatch::RoleGetPvpVideo(int64_t roleid, int zoneid, Octets video_id)
{

	string video_tmp = std::string((char*)video_id.begin(), video_id.size());
	//char msg[128];
	//snprintf(msg, sizeof(msg), "videoid_", );
	string video_key = "videoid_";
	video_key += video_tmp;
	std::string value;
	leveldb::Status status = g_db->Get(leveldb::ReadOptions(), video_key, &value);

	GetPvpVideoRe pro;
	if(!status.ok())
	{
		pro.retcode = 1;
		pro.roleid = roleid;
		GCenterServer::GetInstance()->DispatchProtocol(zoneid, pro);
	}
	else
	{
		Octets value_data = Octets((void*)value.c_str(), value.size());
	
		pro.retcode = 0;
		pro.roleid = roleid;
		pro.video = value_data;
		GCenterServer::GetInstance()->DispatchProtocol(zoneid, pro);
	}
}

void PVPMatch::RoleDelPvpVideo(int64_t roleid, Octets video_id)
{
	//在这里直接删除就可以了，就没有必要再返回gamed消息了，因为没有任何的意义
	string video_tmp = std::string((char*)video_id.begin(), video_id.size());
	char msg[128];
	snprintf(msg, sizeof(msg), "videoid_%ld_", roleid);
	string video_key = "videoid_";
	video_key += video_tmp;
	std::string value;
	leveldb::Status status = g_db->Get(leveldb::ReadOptions(), video_key, &value);

	if(status.ok())
	{
		Octets video = Octets((void*)value.c_str(), value.size());
		Marshal::OctetsStream os(video);
		PvpVideoData data;
		
		data.unmarshal(os);

		if(data.del_flag >= 1)
		{
			leveldb::Status status = g_db->Delete(leveldb::WriteOptions(), video_key);
		}
		else
		{
			data.del_flag = 1;
			Marshal::OctetsStream os;
			data.marshal(os);
			
			Octets value_data = os;
			value = std::string((char*)value_data.begin(), value_data.size());

			g_db->Put(leveldb::WriteOptions(), video_key, value);
		}
	}
}

};
