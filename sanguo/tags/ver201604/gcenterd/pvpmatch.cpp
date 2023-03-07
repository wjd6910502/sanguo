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

	_data[data_key] = p_data;
	_role_data[data_key.role_id] = p_data;
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
		//��������ж��ֵ�ƥ��
		std::map<pvp_data_key, pvp_data*>::iterator it = _data.begin();
		while (it != _data.end())
		{
			//��ʼ��it����ļ�����ֵ������ɸѡ
			if(it->second->match_flag == false)
			{
				std::map<pvp_data_key, pvp_data*>::iterator tmp_it = it;
				tmp_it++;
				int match_count = 0;
				std::vector<pvp_data_key> tmp_vector;
				tmp_vector.clear();
				while(match_count < 7 && tmp_it != _data.end())
				{
					//10������֮�ڵ���һ����ƥ��
					if((it->first.star - tmp_it->first.star) <= 100)
					{
						tmp_vector.push_back(tmp_it->first);
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
						pvp_index++;
						_match_data[pvp_index] = tmp;

						//����������ҷ���ƥ��ɹ�����Ϣ
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
						//�ߵ�����϶��ǳ������صĴ����ˡ�
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
		if( it->second.enter_time != 0 && (Now() - it->second.enter_time) > 60)
		{
			//��������˫����һ������˫��һֱ��������������׼���õ���Ϣ
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
			//����������˫����Ready��һ��һֱ�޷����͹���
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
			//�Ѿ�����5���ӣ��϶��ǿͻ�������������⣬ֱ����˫����ʧ�ܾͿ����ˡ�
			PvpLeaveRe pro;
			pro.roleid = it->second.fight1_id;
			pro.typ = TYP_OVERTIME;
			pro.result = FAIL;
			pro.elo_score = CalEloScore(it->second.fight1_elo_score, it->second.fight2_elo_score, pro.result==SUCCESS?1:0);
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

			pro.roleid = it->second.fight2_id;
			pro.elo_score = CalEloScore(it->second.fight2_elo_score, it->second.fight1_elo_score, pro.result==SUCCESS?1:0);
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight2_zoneid, pro);
			
			//֪ͨPVPD������ɾ��
			PVPDelete prot;
			prot.id = it->first;
			prot.video_flag = 0;
			PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
			
			//ɾ���������
			_match_data.erase(it++);
		}
		else if(it->second.end_time != 0 && (Now() - it->second.end_time) > 10)
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
			PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
			
			//ɾ���������
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
		if(it->second.fight2_flag == 1 && it->second.fight1_flag == 1)
		{
			//����ҷ�����Ϣ�����Ұ���Ҵӵ�ǰ�Ķ�����ɾ��
			PvpEnterRe pro;
			pro.roleid = it->second.fight1_id;
			pro.pvpinfo = it->second.fight1_pvpinfo;
			pro.fight_pvpinfo = it->second.fight2_pvpinfo;
			
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
	//reason =  1- ʤ��  0-ʧ��
	//type = 0 - ����ʤ��/ʧ��   1-��ʤ/���   2-Ͷ�� 3-����  4-˫����˵�Լ�ʤ��
	std::map<int, pvp_match_data>::iterator it = _match_data.find(index);
	if(it != _match_data.end())
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
						PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
						
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
					PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
					
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
				PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
				
				//ɾ���������
				_match_data.erase(it);

				return 0;
			}
			//������Ϊ���ж��Ƿ�������Ҷ������˽�����Ϣ��
			if(it->second.end_time == 0)
			{
				it->second.end_time = Now();
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
					if(pro.result == SUCCESS)
						prot.win_flag = 0;
					else
						prot.win_flag = 1;
					PVPGameServer::GetInstance()->Send(it->second.pvp_sid, prot);
					
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
			
			//ɾ���������
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
		if(it->second.fight1_ready == 1 && it->second.fight2_ready == 1)
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

				GCenterServer::GetInstance()->DispatchProtocol(it->second.fight1_zoneid, pro);

				pro.roleid = it->second.fight2_id;
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
			arg.fighter1_pvpinfo = it->second.fight1_pvpinfo;
			arg.fighter2_pvpinfo = it->second.fight2_pvpinfo;
			arg.fighter1_zoneid = it->second.fight1_zoneid;
			arg.fighter2_zoneid = it->second.fight2_zoneid;

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
			PvpSpeedRe pro;
			pro.roleid = it->second.fight2_id;
			pro.speed = speed;
			GCenterServer::GetInstance()->DispatchProtocol(it->second.fight2_zoneid, pro);
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

void PVPMatch::PvpOperation(int64_t fight1, int64_t fight2, Octets fight1_pvpinfo, Octets fight2_pvpinfo,
		int fight1_zoneid, int fight2_zoneid, std::vector<PvpVideo> &pvp_video, int win_flag)
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

	Marshal::OctetsStream os;
	data.marshal(os);
	
	Octets value_data = os;
	value = std::string((char*)value_data.begin(), value_data.size());

	//��ʼ�洢¼��
	char msg[128];
	snprintf(msg, sizeof(msg), "videoid_%ld", video_id);

	string video_key = msg;
	g_db->Put(leveldb::WriteOptions(), video_key, value);
	
	//memset(msg, 0, sizeof(msg));
	//snprintf(msg, sizeof(msg), "videoid_%ld_%ld", fight2,video_id);
	//video_key = msg;
	//g_db->Put(leveldb::WriteOptions(), video_key, value);

	//�����¼��ı�ţ�����ÿһ����ң����������Ǳ������Լ��ķ������ġ�
	SendPvpVideoID pro;
	pro.roleid = fight1;
	pro.video_id = video_id;
	pro.first_pvpinfo = fight1_pvpinfo;
	pro.second_pvpinfo = fight2_pvpinfo;
	pro.win_flag = win_flag;

	GCenterServer::GetInstance()->DispatchProtocol(fight1_zoneid, pro);

	pro.roleid = fight2;
	GCenterServer::GetInstance()->DispatchProtocol(fight2_zoneid, pro);
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
	//������ֱ��ɾ���Ϳ����ˣ���û�б�Ҫ�ٷ���gamed��Ϣ�ˣ���Ϊû���κε�����
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