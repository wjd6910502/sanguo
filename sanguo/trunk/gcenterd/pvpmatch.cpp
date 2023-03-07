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
#include "audiencegetlistre.hpp"
#include "audiencegetoperationre.hpp"
#include "audiencesendoperation.hpp"
#include "audiencefinishroom.hpp"
#include "updatedanmuinfo.hpp"
#include "yuezhanend.hpp"
#include "pvppause.hpp"
#include "pvppause_re.hpp"
#include "pvpcontinue.hpp"
#include "audienceupdatenum.hpp"

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
		if(cur_num >= it->_load && now-it->_last_active_time<10)
		{
			cur_num = it->_load;
			index = flag;
		}
	}

	return &_pvpds[index];
}

int PVPMatch::AddPVPData(pvp_data_key data_key, pvp_data data)
{
	//���Ȳ����������Ƿ��Ѿ��ڽ���ƥ����
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
	p_data->key = data.key;
	p_data->pvp_ver = data.pvp_ver;
	p_data->wait_time = data.wait_time;
	p_data->win_count = data.win_count;
	p_data->exe_ver = data.exe_ver;
	p_data->data_ver = data.data_ver;
	p_data->vs_robot = data.vs_robot;
	p_data->wait_max_before_vs_robot = data.wait_max_before_vs_robot;

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
	int cur_time = Now();
	{
		//��������ж��ֵ�ƥ��
		std::map<pvp_data_key, pvp_data*>::iterator it = _data.begin();
		while (it != _data.end())
		{
			//��ʼ��it����ļ�����ֵ������ɸѡ
			if(it->second->match_flag == false)
			{
				if(it->second->vs_robot)
				{
					//ָ��ƥ������˵�
					if(cur_time-it->second->begin_time >= rand()%10+3)
					{
						int time1;
						pvp_match_data tmp;
						tmp.fight1_id = it->second->role_id;
						tmp.fight1_zoneid = it->second->zoneid;
						tmp.fight1_pvpinfo = it->second->pvpinfo;
						tmp.fight1_elo_score = it->first.score;
						tmp.fight1_key = it->second->key;
						time1 = cur_time - it->second->begin_time;
						
						if (_robot_info.size() > 0)
						{
							srand(time(0));
							int robot_info_index = rand()%_robot_info.size();
							if(_robot_info[robot_info_index].role_id != it->second->role_id)
							{
								robot_index++;

								//���������һ�������˳���
								tmp.fight2_id = robot_index;
								tmp.fight2_zoneid = _robot_info[robot_info_index].zoneid;
								tmp.fight2_pvpinfo = _robot_info[robot_info_index].pvpinfo;
								tmp.fight2_elo_score = _robot_info[robot_info_index].score;
								
								tmp.enter_time = cur_time;
								tmp.fight_robot = 1;
								tmp.robot_seed = rand()%10 + 1;
								tmp.robot_type = 1;

								tmp.exe_ver = it->second->exe_ver;
								tmp.data_ver = it->second->data_ver;
								tmp.pvp_ver = it->second->pvp_ver;
								pvp_index++;
								_match_data[pvp_index] = tmp;

								//�����������ҷ���ƥ��ɹ�����Ϣ
								PvpMatchSuccess pro;
								pro.retcode = 0;
								pro.index = pvp_index;
								pro.roleid = tmp.fight1_id;
								pro.time = time1;
								pro.room_id = 0;
								GCenterServer::GetInstance()->DispatchProtocol(tmp.fight1_zoneid, pro);
								it->second->match_flag = true;
							}
							else
							{
								//�����Ƿ񷵻���ʾ ��ǰ���˽���ƥ��
								PvpMatchSuccess pro;
								pro.retcode = 1;
								GCenterServer::GetInstance()->DispatchProtocol(tmp.fight1_zoneid, pro);
							}
						}
						else
						{
						   // �����ܳ��� һ���������Լ���
						}
					}
				}
				//�������������˵�ƥ��
				//����һ�����������������ܳ���3��
				//else if(cur_time - it->second->begin_time >= it->second->wait_time)
				else if(cur_time - it->second->begin_time >= rand()%10+it->second->wait_max_before_vs_robot)
				{
					int time1;
					pvp_match_data tmp;
					tmp.fight1_id = it->second->role_id;
					tmp.fight1_zoneid = it->second->zoneid;
					tmp.fight1_pvpinfo = it->second->pvpinfo;
					tmp.fight1_elo_score = it->first.score;
					tmp.fight1_key = it->second->key;
					time1 = cur_time - it->second->begin_time;
					
					if (_robot_info.size() > 0)
					{
						srand(time(0));
						int robot_info_index = rand()%_robot_info.size();
						if(_robot_info[robot_info_index].role_id != it->second->role_id)
						{
							robot_index++;

							//���������һ�������˳���
							tmp.fight2_id = robot_index;
							tmp.fight2_zoneid = _robot_info[robot_info_index].zoneid;
							tmp.fight2_pvpinfo = _robot_info[robot_info_index].pvpinfo;
							tmp.fight2_elo_score = _robot_info[robot_info_index].score;
							
							tmp.enter_time = cur_time;
							tmp.fight_robot = 1;
							tmp.robot_seed = rand()%10 + 1;
							tmp.robot_type = 2;

							tmp.exe_ver = it->second->exe_ver;
							tmp.data_ver = it->second->data_ver;
							tmp.pvp_ver = it->second->pvp_ver;
							pvp_index++;
							_match_data[pvp_index] = tmp;

							//�����������ҷ���ƥ��ɹ�����Ϣ
							PvpMatchSuccess pro;
							pro.retcode = 0;
							pro.index = pvp_index;
							pro.roleid = tmp.fight1_id;
							pro.time = time1;
							pro.room_id = 0;
							GCenterServer::GetInstance()->DispatchProtocol(tmp.fight1_zoneid, pro);
							it->second->match_flag = true;
						}
						else
						{
							//�����Ƿ񷵻���ʾ ��ǰ���˽���ƥ��
							PvpMatchSuccess pro;
							pro.retcode = 1;
							GCenterServer::GetInstance()->DispatchProtocol(tmp.fight1_zoneid, pro);
						}
					}
					else
					{
					   // �����ܳ��� һ���������Լ���
					}
				}
				else if(it->second->win_count > LOSE_COUNT)
				{
					std::map<pvp_data_key, pvp_data*>::iterator tmp_it = it;
					tmp_it++;
					int match_count = 0;
					std::vector<pvp_data_key> tmp_vector;
					tmp_vector.clear();
					while(match_count < 7 && tmp_it != _data.end())
					{
						//10������֮�ڵ���һ����ƥ��
						if( ((it->first.star - tmp_it->first.star) <= 100) && 
								(it->second->pvp_ver == tmp_it->second->pvp_ver) &&
								tmp_it->second->match_flag == false )
						{
							if(tmp_it->second->win_count >= LOSE_COUNT && !tmp_it->second->vs_robot)
							{
								tmp_vector.push_back(tmp_it->first);
							}
						}
						else
						{
							//��Ϊ����������ֻҪ��һ��������������ǵ�Ҫ���ˣ�����ľ��Ѿ�����Ҫ�����κε��ж���
							break;
						}
						match_count++;
						tmp_it++;
					}
					if(tmp_vector.size() > 0)
					{
						//���������һ����ҳ�����Ϊƥ�����
						int role_count = tmp_vector.size();
						srand(time(0)); //FIXME: ?
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
							tmp.fight1_key = it->second->key;
							time1 = cur_time - it->second->begin_time;
							it->second->match_flag = true;

							tmp.fight2_id = select_it->second->role_id;
							tmp.fight2_zoneid = select_it->second->zoneid;
							tmp.fight2_pvpinfo = select_it->second->pvpinfo;
							tmp.fight2_elo_score = select_it->first.score;
							tmp.fight2_key = select_it->second->key;
							time2 = cur_time - select_it->second->begin_time;
							select_it->second->match_flag = true;
							
							tmp.enter_time = cur_time;
							tmp.exe_ver = it->second->exe_ver;
							tmp.data_ver = it->second->data_ver;
							tmp.pvp_ver = it->second->pvp_ver;
							pvp_index++;
							_match_data[pvp_index] = tmp;

							//����������ҷ���ƥ��ɹ�����Ϣ
							PvpMatchSuccess pro;
							pro.retcode = 0;
							pro.index = pvp_index;
							pro.roleid = tmp.fight1_id;
							pro.time = time1;
							pro.room_id = 0;
							GCenterServer::GetInstance()->DispatchProtocol(tmp.fight1_zoneid, pro);
							pro.roleid = tmp.fight2_id;
							pro.time = time2;
							GCenterServer::GetInstance()->DispatchProtocol(tmp.fight2_zoneid, pro);
						}
						else
						{
							//�ߵ�����϶��ǳ������صĴ����ˡ�
						}
					}
				}

			}
			it++;
		}
	}
	
	{
		//��������Ѿ�������ƥ�����ҽ���ɾ��
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

	//��ʼ�ж��Ƿ����֪ͨ���˫�����Ѿ�ͬ�⣬�������ǿ��Կ�ʼ׼��������
	std::map<int, pvp_match_data>::iterator it = _match_data.begin();
	while(it != _match_data.end())
	{
		if( it->second.enter_time != 0 && (cur_time - it->second.enter_time) > 60)
		{
			//��������˫����һ������˫��һֱ��������������׼���õ���Ϣ
			PvpCenterCreate pro;
			pro.roleid = it->second.fight1_id;
			pro.retcode = 103;
			pro.room_id = it->second.room_id;

			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

			pro.roleid = it->second.fight2_id;
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

			_match_data.erase(it++);
		}
		else if( it->second.ready_time != 0 && (cur_time - it->second.ready_time) > 60)
		{
			//����������˫����Ready��һ��һֱ�޷����͹���
			PvpCenterCreate pro;
			pro.roleid = it->second.fight1_id;
			pro.retcode = 101;
			pro.room_id = it->second.room_id;

			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

			pro.roleid = it->second.fight2_id;
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

			_match_data.erase(it++);
		}
		else if(it->second.begin_time != 0 && (cur_time - it->second.begin_time) > PVP_TIME_MAX)
		{
			//�Ѿ�����5���ӣ��϶��ǿͻ�������������⣬ֱ����˫����ʧ�ܾͿ����ˡ�
			PvpLeaveRe pro;
			pro.roleid = it->second.fight1_id;
			pro.typ = TYP_OVERTIME;
			pro.result = FAIL;
			pro.room_typ = it->second.match_pvp;
			pro.room_id = it->second.room_id;
			pro.video_flag = 0;
			pro.elo_score = CalEloScore(it->second.fight1_elo_score, it->second.fight2_elo_score, pro.result==SUCCESS?1:0);
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

			pro.roleid = it->second.fight2_id;
			pro.elo_score = CalEloScore(it->second.fight2_elo_score, it->second.fight1_elo_score, pro.result==SUCCESS?1:0);
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight2_zoneid, pro);
			
			//֪ͨPVPD������ɾ��
			PVPDelete prot;
			prot.id = it->first;
			prot.video_flag = 0;
			prot.robot_flag = it->second.fight_robot;
			prot.robot_seed = it->second.robot_seed;
			prot.robot_type = it->second.robot_type;
			PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
			DelAudienceRoom(prot.id, pro.result, pro.typ);
			
			//ɾ���������
			_match_data.erase(it++);
		}
		else if(it->second.end_time != 0 && (cur_time - it->second.end_time) > 10)
		{
			//������Ҫע�⣬ֻҪ��������϶�����һ������Ѿ����˹����ġ�
			//ֱ�Ӱ��յ�ǰ������֪������Ϣ���ж�ʤ��
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
			pro.room_typ = it->second.match_pvp;
			pro.room_id = it->second.room_id;
			pro.video_flag = 0;
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
			
			//֪ͨPVPD������ɾ��
			PVPDelete prot;
			prot.id = it->first;
			prot.video_flag = 0;
			prot.robot_flag = it->second.fight_robot;
			prot.robot_seed = it->second.robot_seed;
			prot.robot_type = it->second.robot_type;
			PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
			DelAudienceRoom(prot.id, !pro.result, pro.typ);
			
			//ɾ���������
			_match_data.erase(it++);
		}
		else
		{
			it++;
		}
	}
	{
		//ɾ�����ڷ���
		std::map<int, audience_room>::iterator it = _audience_data.begin();
		for(; it != _audience_data.end();)
		{
			if(cur_time - it->second.begin_time >= PVP_TIME_MAX)
			{
				_audience_data.erase(it++);
			}
			else
			{
				it++;
			}
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
			//����ҷ�����Ϣ�����Ұ���Ҵӵ�ǰ�Ķ�����ɾ��
			PvpEnterRe pro;
			pro.roleid = it->second.fight1_id;
			pro.pvpinfo = it->second.fight1_pvpinfo;
			pro.fight_pvpinfo = it->second.fight2_pvpinfo;
			pro.robot_flag = 1;
			pro.robot_seed = it->second.robot_seed;
			pro.robot_type = it->second.robot_type;
			
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

			it->second.enter_time = 0;
			it->second.ready_time = Now();
		}
		else if(it->second.fight2_flag == 1 && it->second.fight1_flag == 1)
		{
			//����ҷ�����Ϣ�����Ұ���Ҵӵ�ǰ�Ķ�����ɾ��
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

int PVPMatch::RolePvpLeave(int64_t roleid, int index, int reason, int typ, int score, int duration)
{
	//reason =  1- ʤ��  0-ʧ��
	//type = 0 - ����ʤ��/ʧ��   1-��ʤ/���   2-Ͷ�� 3-����  4-˫����˵�Լ�ʤ��
	std::map<int, pvp_match_data>::iterator it = _match_data.find(index);
	if(it != _match_data.end())
	{
		if(it->second.fight_robot == 1)
		{
			//��ʼ�鿴�������Ƿ��������������
			if(it->second.fight1_id != roleid)
				return 0;
			//�����Ϊ���жϳ���˭�ǻ�ʤ���ˡ�
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
				pro.room_typ = it->second.match_pvp;
				pro.room_id = it->second.room_id;
				pro.video_flag = 0;
				pro.elo_score = CalEloScore(it->second.fight1_elo_score, it->second.fight2_elo_score, pro.result==SUCCESS?1:0);
				GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

				//֪ͨPVPD������ɾ��
				PVPDelete prot;
				prot.id = index;
				prot.video_flag = 0;
				prot.robot_flag = it->second.fight_robot;
				prot.robot_seed = it->second.robot_seed;
				prot.robot_type = it->second.robot_type;
				PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
				DelAudienceRoom(prot.id, pro.result, pro.typ);
				
				//ɾ���������
				_match_data.erase(it);

				return 0;
			}
			
			//������Ϳ��Ը���һ�ȥ��Ϣ��Ȼ��֪ͨPVPD�����и���ɾ��
			PvpLeaveRe pro;
			pro.roleid = it->second.fight1_id;
			if(it->second.fight1_id == it->second.winner)
				pro.result = SUCCESS;
			else
				pro.result = FAIL;
			pro.typ = typ;
			pro.room_typ = it->second.match_pvp;
			pro.room_id = it->second.room_id;
			pro.video_flag = 0;
			pro.elo_score = CalEloScore(it->second.fight1_elo_score, it->second.fight2_elo_score, pro.result==SUCCESS?1:0);
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

			//֪ͨPVPD������ɾ��
			PVPDelete prot;
			prot.id = index;
			prot.video_flag = 1;
			prot.robot_flag = it->second.fight_robot;
			prot.robot_seed = it->second.robot_seed;
			prot.robot_type = it->second.robot_type;
			if(pro.result == SUCCESS)
				prot.win_flag = 1;
			else
				prot.win_flag = 0;
			PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
			DelAudienceRoom(prot.id, pro.result, pro.typ);
			
			//ɾ���������
			_match_data.erase(it);

			return 0;
		}
		else
		{
			//��ʼ�鿴�������Ƿ��������������
			if(it->second.fight1_id == roleid || it->second.fight2_id == roleid)
			{
				//�����Ϊ���жϳ���˭�ǻ�ʤ���ˡ�
				if(reason == 1)
				{
					if(it->second.winner != 0)
					{
						if(it->second.winner != roleid)
						{
							//������ʹ��������ˡ�Ϊʲô�����˷�������Ϣ��һ���ء�Ŀǰ�Ȱ���������Ҷ������������д���
							PvpLeaveRe pro;
							pro.roleid = it->second.fight1_id;
							pro.result = FAIL;
							pro.typ = TYP_DOUBLE;
							pro.room_typ = it->second.match_pvp;
							pro.room_id = it->second.room_id;
							pro.video_flag = 0;
							pro.elo_score = CalEloScore(it->second.fight1_elo_score, it->second.fight2_elo_score, pro.result==SUCCESS?1:0);
							GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

							pro.roleid = it->second.fight2_id;
							pro.result = FAIL;
							pro.typ = TYP_DOUBLE;
							pro.elo_score = CalEloScore(it->second.fight2_elo_score, it->second.fight1_elo_score, pro.result==SUCCESS?1:0);
							GCenterServer::GetInstance()->DispatchProtocol(it->second.fight2_zoneid, pro);
							
							//֪ͨPVPD������ɾ��
							PVPDelete prot;
							prot.id = index;
							prot.video_flag = 0;
							prot.robot_flag = it->second.fight_robot;
							prot.robot_seed = it->second.robot_seed;
							prot.robot_type = it->second.robot_type;
							PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
							DelAudienceRoom(prot.id, pro.result, pro.typ);
							
							//ɾ���������
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
						//��Ȼ˫����˵�Լ����ˣ��Ǿ����˰�
						PvpLeaveRe pro;
						pro.roleid = it->second.fight1_id;
						pro.result = FAIL;
						pro.typ = TYP_COMMON;
						pro.room_typ = it->second.match_pvp;
						pro.room_id = it->second.room_id;
						pro.video_flag = 0;
						pro.elo_score = CalEloScore(it->second.fight1_elo_score, it->second.fight2_elo_score, pro.result==SUCCESS?1:0);
						GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

						pro.roleid = it->second.fight2_id;
						pro.result = FAIL;
						pro.typ = TYP_COMMON;
						pro.elo_score = CalEloScore(it->second.fight2_elo_score, it->second.fight1_elo_score, pro.result==SUCCESS?1:0);
						GCenterServer::GetInstance()->DispatchProtocol(it->second.fight2_zoneid, pro);
						
						//֪ͨPVPD������ɾ��
						PVPDelete prot;
						prot.id = index;
						prot.video_flag = 0;
						prot.robot_flag = it->second.fight_robot;
						prot.robot_seed = it->second.robot_seed;
						prot.robot_type = it->second.robot_type;
						PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
						DelAudienceRoom(prot.id, pro.result, pro.typ);
						
						//ɾ���������
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
					pro.room_typ = it->second.match_pvp;
					pro.room_id = it->second.room_id;
					pro.video_flag = 0;
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
					
					//֪ͨPVPD������ɾ��
					PVPDelete prot;
					prot.id = index;
					prot.video_flag = 0;
					prot.robot_flag = it->second.fight_robot;
					prot.robot_seed = it->second.robot_seed;
					prot.robot_type = it->second.robot_type;
					PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
					DelAudienceRoom(prot.id, !pro.result, pro.typ);
					
					//ɾ���������
					_match_data.erase(it);

					return 0;
				}
				//������Ϊ���ж��Ƿ�������Ҷ������˽�����Ϣ��
				if(it->second.end_time == 0)
				{
					it->second.end_time = Now();

					std::map<int, audience_room>::iterator find_info = _audience_data.find(index);
					if(find_info != _audience_data.end())
					{
						find_info->second._score = score;
						find_info->second._duration = duration;
					}
				}
				else
				{
					if(typ == it->second.typ)
					{
						//������Ϳ��Ը���һ�ȥ��Ϣ��Ȼ��֪ͨPVPD�����и���ɾ��
						PvpLeaveRe pro;
						pro.roleid = it->second.fight1_id;
						if(it->second.fight1_id == it->second.winner)
							pro.result = SUCCESS;
						else
							pro.result = FAIL;
						pro.typ = typ;
						pro.room_typ = it->second.match_pvp;
						pro.room_id = it->second.room_id;
						pro.video_flag = 1;
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
						
						//֪ͨPVPD������ɾ��
						PVPDelete prot;
						prot.id = index;
						prot.video_flag = 1;
						prot.robot_flag = it->second.fight_robot;
						prot.robot_seed = it->second.robot_seed;
						prot.robot_type = it->second.robot_type;
						if(pro.result == SUCCESS)
							prot.win_flag = 0;
						else
							prot.win_flag = 1;
						PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
						DelAudienceRoom(prot.id, !pro.result, pro.typ);
						
						//ɾ���������
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
		//��֤��Ϣ
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
			pro.room_typ = it->second.match_pvp;
			pro.room_id = it->second.room_id;
			pro.video_flag = 0;
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
			
			DelAudienceRoom(index, !pro.result, pro.typ);
			//ɾ���������
			_match_data.erase(it);
		}
	}
}

void PVPMatch::PvpdPvpPause(void *p/* PVPPause* */)
{
	PVPPause *prot = (PVPPause*)p;

	std::map<int, pvp_match_data>::iterator it = _match_data.find(prot->id);
	if(it != _match_data.end())
	{
		if(prot->fighter == it->second.fight1_id)
		{
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, prot);
		}
		else if(prot->fighter == it->second.fight2_id)
		{
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight2_zoneid, prot);
		}
	}
}

void PVPMatch::PvpdPvpPauseRe(int index, int64_t fighter)
{
	std::map<int, pvp_match_data>::iterator it = _match_data.find(index);
	if(it != _match_data.end())
	{
		PVPPause_Re prot;
		prot.id = index;
		prot.fighter = fighter;
		PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
	}
}

void PVPMatch::PvpdPvpContinue(void *p/* PVPContinue* */)
{
	PVPContinue *prot = (PVPContinue*)p;

	std::map<int, pvp_match_data>::iterator it = _match_data.find(prot->id);
	if(it != _match_data.end())
	{
		if(prot->fighter == it->second.fight1_id)
		{
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, prot);
		}
		else if(prot->fighter == it->second.fight2_id)
		{
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight2_zoneid, prot);
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
			//������֪ͨPVPD������,��Ӧ����Ϣ
			it->second.ready_time = 0;
			const pvp_server_data* pvpd = AllocPVPServer();
			if(!pvpd)
			{
				GLog::log(LOG_ERR, "GAMED::PVPD_Create, AllocPVPServer error");
				//��������Ҫ���ͻ��˴��󣬲����ÿͻ���һֱ���ڽ�����
				PvpCenterCreate pro;
				pro.roleid = it->second.fight1_id;
				pro.retcode = 102;
				pro.room_id = it->second.room_id;

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
			arg.pvp_ver = it->second.pvp_ver;
			arg.fighter1_key = it->second.fight1_key;
			arg.fighter2_key = it->second.fight2_key;
			arg.match_pvp = it->second.match_pvp;

			PVPCreate *rpc = (PVPCreate*)Rpc::Call(RPC_PVPCREATE, arg);
			PVPGameServer::GetInstance()->Send(pvpd->_sid, rpc);
			it++;
		}
		else if(it->second.fight1_ready == 1 && it->second.fight2_ready == 1)
		{
			//������֪ͨPVPD������,��Ӧ����Ϣ
			it->second.ready_time = 0;
			const pvp_server_data* pvpd = AllocPVPServer();
			if(!pvpd)
			{
				GLog::log(LOG_ERR, "GAMED::PVPD_Create, AllocPVPServer error");
				//��������Ҫ���ͻ��˴��󣬲����ÿͻ���һֱ���ڽ�����
				PvpCenterCreate pro;
				pro.roleid = it->second.fight1_id;
				pro.retcode = 102;
				pro.room_id = it->second.room_id;

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
			arg.pvp_ver = it->second.pvp_ver;
			arg.fighter1_key = it->second.fight1_key;
			arg.fighter2_key = it->second.fight2_key;
			arg.match_pvp = it->second.match_pvp;

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
		//֪ͨPVPD������ɾ��
		PVPDelete prot;
		prot.id = it->first;
		prot.video_flag = 0;
		prot.robot_flag = it->second.fight_robot;
		prot.robot_seed = it->second.robot_seed;
		prot.robot_type = it->second.robot_type;
		PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
		
		//ɾ���������
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
			else
			{
				PvpSpeedRe pro;
				pro.roleid = it->second.fight1_id;
				pro.speed = speed;
				GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);
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
			//˭����ĸ�˭����ȥ0,��һ������ȥ1
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

void PVPMatch::PvpOperation(int index, int64_t fight1, int64_t fight2, Octets fight1_pvpinfo, Octets fight2_pvpinfo,
		int fight1_zoneid, int fight2_zoneid, std::vector<PvpVideo> &pvp_video, int win_flag, 
		int robot_flag, int robot_seed, int robot_type, Octets exe_ver, Octets data_ver, int pvp_ver, int match_pvp)
{
	string pvp_operation = SerializeManager::SerializePvpOperation(pvp_video);

	//��ʼ�������ݿ�Ĵ洢
	std::string find_key = "pvp_operation";
	std::string value;
	leveldb::Status status = g_db->Get(leveldb::ReadOptions(),find_key,&value);

	int64_t video_id = 1;
	
	if(!status.ok())
	{
		//����û���ҵ�����ô��ֱ�Ӹ�ֵ��ʼ����Ȼ����ȥ
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
	data.robot_type = robot_type;
	data.exe_ver = exe_ver;
	data.data_ver = data_ver;
	data.pvp_ver = pvp_ver;
	
	//��ʼ����������ȥ����Ӧ�ĵ�Ļ
	std::map<int, audience_room>::iterator find_info = _audience_data.find(index);
	if(find_info != _audience_data.end())
	{
		data.danmu_info = find_info->second.danmu_info;
		find_info->second.video_id = video_id;

		//Ȼ����������㲥���Բ鿴¼����
		if(find_info->second.match_pvp == 1)
		{
			YueZhanEnd pro;
			pro.room_id = find_info->second.room_id;
			pro.video_id = video_id;
			if(find_info->second.fight1_zoneid == find_info->second.fight2_zoneid)
				GCenterServer::GetInstance()->DispatchProtocol(find_info->second.fight1_zoneid, pro);
			else
			{
				GCenterServer::GetInstance()->DispatchProtocol(find_info->second.fight1_zoneid, pro);
				GCenterServer::GetInstance()->DispatchProtocol(find_info->second.fight2_zoneid, pro);
			}
		}
	}

	Marshal::OctetsStream os;
	data.marshal(os);
	
	Octets value_data = os;
	value = std::string((char*)value_data.begin(), value_data.size());

	//��ʼ�洢¼��
	char msg[128];
	snprintf(msg, sizeof(msg), "videoid_%ld", video_id);

	string video_key = msg;
	g_db->Put(leveldb::WriteOptions(), video_key, value);

	//�����¼��ı�ţ�����ÿһ����ң����������Ǳ������Լ��ķ������ġ�
	SendPvpVideoID pro;
	pro.roleid = fight1;
	pro.video_id = video_id;
	pro.first_pvpinfo = fight1_pvpinfo;
	pro.second_pvpinfo = fight2_pvpinfo;
	pro.win_flag = win_flag;
	pro.match_pvp = match_pvp;
	pro.score = 0;
	pro.duration = 0;
	pro.robot_flag = robot_flag;
	if(find_info != _audience_data.end())
	{
		pro.score = find_info->second._score;
		pro.duration = find_info->second._duration;
	}

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
	string video_key = "videoid_";
	video_key += video_tmp;
	std::string value;
	leveldb::Status status = g_db->Get(leveldb::ReadOptions(), video_key, &value);

	GetPvpVideoRe pro;
	pro.video_id = video_id;
	pro.roleid = roleid;
	if(!status.ok())
	{
		pro.retcode = 1;
		GCenterServer::GetInstance()->DispatchProtocol(zoneid, pro);
	}
	else
	{
		Octets value_data = Octets((void*)value.c_str(), value.size());
	
		//������ѵ�Ļ�����ó�������Ϊ��Ҫ�ѵ�Ļ��Ϣ�����ݽṹ�޸�һ�²ſ��Դ���gamed�������޷����д���
		Marshal::OctetsStream os(value_data);
		PvpVideoData data;
		data.unmarshal(os);
		std::string danmu_info = SerializeManager::SerializeDanMuInfo(data.danmu_info);
		
		pro.retcode = 0;
		pro.video = value_data;
		pro.danmu_info = Octets((void*)danmu_info.c_str(), danmu_info.size());
		GCenterServer::GetInstance()->DispatchProtocol(zoneid, pro);
	}
}

void PVPMatch::RoleDelPvpVideo(int64_t roleid, Octets video_id)
{
	//������ֱ��ɾ���Ϳ����ˣ���û�б�Ҫ�ٷ���gamed��Ϣ�ˣ���Ϊû���κε�����
	string video_tmp = std::string((char*)video_id.begin(), video_id.size());
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

void PVPMatch::AddAudienceRoom(int index)
{
	//������Խ���һ���жϣ������һ���ǻ����˾Ͳ����б�����
	if (_audience_data.find(index) != _audience_data.end())
		return;

	std::map<int, pvp_match_data>::iterator it = _match_data.find(index);
	if(it != _match_data.end())
	{
		audience_room room_info;
		room_info.fight1_id = it->second.fight1_id;
		room_info.fight2_id = it->second.fight2_id;
		room_info.fight1_zoneid = it->second.fight1_zoneid;
		room_info.fight2_zoneid = it->second.fight2_zoneid;
		room_info.fight1_pvpinfo = it->second.fight1_pvpinfo;
		room_info.fight2_pvpinfo = it->second.fight2_pvpinfo;
		room_info.fight_robot = it->second.fight_robot;
		room_info.robot_seed = it->second.robot_seed;
		room_info.robot_type = it->second.robot_type;
		room_info.begin_time = Now();
		room_info.match_pvp = it->second.match_pvp;
		room_info.room_id = it->second.room_id;

		_audience_data[index] = room_info;
	}
}

void PVPMatch::AddAudienceOperation(int index, PvpVideo operation)
{
	std::map<int, audience_room>::iterator it = _audience_data.find(index);
	if(it != _audience_data.end())
	{
		it->second._cur_operations.push_back(operation);
		if(it->second._cur_operations.size() >= 60)
		{
			it->second._all_operations.insert(it->second._all_operations.end(), 
				it->second._cur_operations.begin(), it->second._cur_operations.end());

			//�Ѳ�����ÿһ�����ڷ���ȥ
			AudienceSendOperation pro;
			string operation = SerializeManager::SerializePvpOperation(it->second._cur_operations);
			pro.operation = Octets((void*)operation.data(), operation.size());
			pro.room_id = index;
			
			//TODO: �ϲ�һ�£���Ҫͬһ����Ҳ�ظ���
			std::map<int64_t, audience_data>::iterator audience_it = it->second.audiences.begin();
			for(; audience_it != it->second.audiences.end(); audience_it++)
			{
				pro.roleid = audience_it->second.audience_id;
				GCenterServer::GetInstance()->DispatchProtocol(audience_it->second.audience_zoneid, pro);
			}
			it->second._cur_operations.clear();
		}
	}
	else
	{
		GLog::log(LOG_INFO, "AddAudienceOperation    AddAudienceOperation, index=%d", index);
	}
}

void PVPMatch::AudienceGetAllList(int64_t roleid, int zoneid)
{
	std::map<int, audience_room>::iterator it = _audience_data.begin();
	std::vector<FightInfo> tmp;
	for(; it != _audience_data.end(); it++ )
	{
		if(it->second.see_flag == 1)
		{
			FightInfo tmp_fight_info;
			tmp_fight_info.room_id = it->first;
			tmp_fight_info.fight1_info = it->second.fight1_pvpinfo;
			tmp_fight_info.fight2_info = it->second.fight2_pvpinfo;
			tmp.push_back(tmp_fight_info);
		}
	}

	std::string result = SerializeManager::SerializeFightInfo(tmp);
	AudienceGetListRe pro;
	pro.retcode = 0;
	pro.roleid = roleid;
	pro.fight_info = Octets((void*)result.data(), result.size());
	GCenterServer::GetInstance()->DispatchProtocol(zoneid, pro);
}

//�ۿ��ı���������
void PVPMatch::DelAudienceRoom(int index, int win_flag, int reason)
{
	std::map<int, audience_room>::iterator it = _audience_data.find(index);
	if(it != _audience_data.end())
	{
		GLog::log(LOG_INFO, "DelAudienceRoom, index=%d", index);
		//��ÿһ�����ڷ�������Э��
		AudienceFinishRoom pro;
		pro.room_id = index;
		pro.win_flag = win_flag;
		pro.reason = reason;
		string operation = SerializeManager::SerializePvpOperation(it->second._cur_operations);
		pro.operation = Octets((void*)operation.data(), operation.size());
		
		std::map<int64_t, audience_data>::iterator audience_it = it->second.audiences.begin();
		for(; audience_it != it->second.audiences.end(); audience_it++)
		{
			GLog::log(LOG_INFO, "DelAudienceRoom, DelAudienceRoom  DelAudienceRoom  index=%d", index);
			pro.roleid = audience_it->second.audience_id;
			GCenterServer::GetInstance()->DispatchProtocol(audience_it->second.audience_zoneid, pro);
		}

		//������������óɲ��ɼ���
		it->second.see_flag = 0;
	}
}

void PVPMatch::AudienceGetRoomInfo(int64_t roleid, int zoneid, int room_id)
{
	std::map<int, audience_room>::iterator it = _audience_data.find(room_id);
	
	AudienceGetOperationRe pro;
	pro.roleid = roleid;
	pro.room_id = room_id;

	if(it != _audience_data.end())
	{
		if(it->second.see_flag == 1)
		{
			pro.fight1_pvpinfo = it->second.fight1_pvpinfo;
			pro.fight2_pvpinfo = it->second.fight2_pvpinfo;
			pro.fight_robot = it->second.fight_robot;
			pro.robot_seed = it->second.robot_seed;
			pro.robot_type = it->second.robot_type;
			string operation = SerializeManager::SerializePvpOperation(it->second._all_operations);
			pro.operation = Octets((void*)operation.data(), operation.size());
			pro.retcode = 0;

			//�������Ҽ��뵽�����б�����ȥ
			audience_data insert_audience_data;
			insert_audience_data.audience_id = roleid;
			insert_audience_data.audience_zoneid = zoneid;
			it->second.audiences[roleid] = insert_audience_data;
			
			AudienceUpdateNum prot;
			prot.role_id = it->second.fight2_id;
			prot.num = it->second.audiences.size();
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight2_zoneid, prot);
			
			prot.role_id = it->second.fight1_id;
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, prot);
			
			std::map<int64_t, audience_data>::iterator audience_it = it->second.audiences.begin();
			for(; audience_it != it->second.audiences.end(); audience_it++)
			{
				prot.role_id = audience_it->second.audience_id;
				GCenterServer::GetInstance()->DispatchProtocol(audience_it->second.audience_zoneid, prot);
			}
		}
		else
		{
			pro.retcode = 2;
		}
	}
	else
	{
		pro.retcode = 1;
	}
	GCenterServer::GetInstance()->DispatchProtocol(zoneid, pro);
}

void PVPMatch::AudienceLeave(int64_t roleid, int room_id)
{
	std::map<int, audience_room>::iterator it = _audience_data.find(room_id);
	if(it != _audience_data.end())
	{
		it->second.audiences.erase(roleid);
		
		AudienceUpdateNum prot;
		prot.role_id = it->second.fight2_id;
		prot.num = it->second.audiences.size();
		GCenterServer::GetInstance()->DispatchProtocol(it->second.fight2_zoneid, prot);
		
		prot.role_id = it->second.fight1_id;
		GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, prot);

		std::map<int64_t, audience_data>::iterator audience_it = it->second.audiences.begin();
		for(; audience_it != it->second.audiences.end(); audience_it++)
		{
			prot.role_id = audience_it->second.audience_id;
			GCenterServer::GetInstance()->DispatchProtocol(audience_it->second.audience_zoneid, prot);
		}
	}
}

void PVPMatch::YueZhanMatchSuccess(int64_t create_id, Octets create_pvpinfo, Octets create_key, int64_t join_id, 
			Octets join_pvpinfo, Octets join_key, int zoneid, int room_id, Octets exe_version, Octets data_version, int pvp_ver)
{
	pvp_match_data tmp;
	tmp.fight1_id = create_id;
	tmp.fight1_zoneid = zoneid;
	tmp.fight1_pvpinfo = create_pvpinfo;
	tmp.fight1_elo_score = 0;
	tmp.fight1_key = create_key;

	tmp.fight2_id = join_id;
	tmp.fight2_zoneid = zoneid;
	tmp.fight2_pvpinfo = join_pvpinfo;
	tmp.fight2_elo_score = 0;
	tmp.fight2_key = join_key;
	
	tmp.enter_time = Now();
	tmp.exe_ver = exe_version;
	tmp.data_ver = data_version;
	tmp.match_pvp = 1;
	tmp.pvp_ver = pvp_ver;
	tmp.room_id = room_id;
	pvp_index++;
	_match_data[pvp_index] = tmp;

	//����������ҷ���ƥ��ɹ�����Ϣ
	PvpMatchSuccess pro;
	pro.retcode = 0;
	pro.index = pvp_index;
	pro.roleid = tmp.fight1_id;
	pro.time = 0;
	pro.room_id = room_id;
	GCenterServer::GetInstance()->DispatchProtocol(tmp.fight1_zoneid, pro);
	pro.roleid = tmp.fight2_id;
	pro.time = 0;
	GCenterServer::GetInstance()->DispatchProtocol(tmp.fight2_zoneid, pro);
}

void PVPMatch::PvpDanMu(int64_t role_id, Octets role_name, int zone_id, int pvp_id, int64_t video_id, int tick, Octets danmu_info)
{
	//��������Ҫ֪������ǿ�ֱ����ʱ�򷢵ĵ�Ļ���ǿ�¼���ʱ�򷢵ĵ�Ļ
	bool pro_flag = true;
	if(pvp_id != 0)
	{
		std::map<int, audience_room>::iterator it = _audience_data.find(pvp_id);
		if(it != _audience_data.end())
		{
			DanMuInfo tmp_danmu;
			tmp_danmu.role_id = role_id;
			tmp_danmu.role_name = role_name;
			tmp_danmu.tick = tick;
			tmp_danmu.danmu = danmu_info;
			it->second.danmu_info.push_back(tmp_danmu);
			//������ѵ�Ļ����Ϣ���͸����еĹ���
			UpdateDanMuInfo pro;
			pro.role_id = role_id;
			pro.role_name = role_name;
			pro.tick = tick;
			pro.danmu_info = danmu_info;

			std::map<int64_t, audience_data>::iterator audience_it = it->second.audiences.begin();
			for(;audience_it != it->second.audiences.end(); audience_it++)
			{
				pro.id = audience_it->second.audience_id;
				GCenterServer::GetInstance()->DispatchProtocol(audience_it->second.audience_zoneid, pro);
			}
			if(it->second.video_id != 0)
			{
				video_id = it->second.video_id;
				pro_flag = false;
			}
			else
			{
				return;
			}
		}
	}
	if(video_id != 0)
	{
		char video_tmp[1024];
		snprintf(video_tmp, sizeof(video_tmp), "%ld", video_id);
		string video_key = "videoid_";
		video_key += video_tmp;
		std::string value;
		leveldb::Status status = g_db->Get(leveldb::ReadOptions(), video_key, &value);

		if(status.ok())
		{
			DanMuInfo tmp_danmu;
			tmp_danmu.role_id = role_id;
			tmp_danmu.role_name = role_name;
			tmp_danmu.tick = tick;
			tmp_danmu.danmu = danmu_info;
			
			Octets value_data = Octets((void*)value.c_str(), value.size());
			Marshal::OctetsStream os(value_data);

			PvpVideoData data;
			data.unmarshal(os);
			data.danmu_info.push_back(tmp_danmu);
	
			Marshal::OctetsStream in_os;
			data.marshal(in_os);
			
			value_data = in_os;
			std::string value = std::string((char*)value_data.begin(), value_data.size());

			//��ʼ�洢¼��
			char msg[128];
			snprintf(msg, sizeof(msg), "videoid_%ld", video_id);

			std::string video_key = msg;
			g_db->Put(leveldb::WriteOptions(), video_key, value);
		}
		if(pro_flag)
		{
			UpdateDanMuInfo pro;
			pro.role_id = role_id;
			pro.role_name = role_name;
			pro.tick = tick;
			pro.danmu_info = danmu_info;

			pro.id = role_id;
			GCenterServer::GetInstance()->DispatchProtocol(zone_id, pro);
		}
	}
}

};