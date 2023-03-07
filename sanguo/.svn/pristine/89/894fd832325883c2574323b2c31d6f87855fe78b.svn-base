#include "pvpmanager.h"
#include "commonmacro.h"
#include "playermanager.h"
#include "pvpend.hpp"
#include "pvpgameclient.hpp"
#include "glog.h"
#include "pvpcenterclient.hpp"
#include "pvpoperation.hpp"

namespace GNET
{

PVP::~PVP()
{
	GLog::log(LOG_INFO, "PVPD::PVP::~PVP, id=%d, fighter1=%ld, fighter2=%ld", _id, _fighter1._id, _fighter2._id);
	PlayerManager::GetInstance().Delete(_fighter1._id);
	PlayerManager::GetInstance().Delete(_fighter2._id);
}

void PVP::OnTimer(int tick, int now)
{
	if(_mode == 1)
	{
		if(tick%2 == _id%2) //per 20ms
		{
			//PVPTriggerSend
			Player *player1 = PlayerManager::GetInstance().Find(_fighter1._id);
			Player *player2 = PlayerManager::GetInstance().Find(_fighter2._id);
			if(!player1 || !player2)
			{
				//TODO: 这怎么可能?
				return;
			}
			player1->FastSess_TriggerSend();
			player2->FastSess_TriggerSend();
		}
	}
}

int PVP::CheckFighter(time_t now, PVPFighter& fighter, int big_lag_count)
{
	if(now < _fight_start_time) return 0;

	//断线检查
	auto it = fighter._ops.find(_next_client_tick);
	if(it == fighter._ops.end())
	{
		fighter._wait_seconds++;
		if(fighter._wait_seconds > 3) return 1; //玩家已掉线
	}
	//网络状态差?
	//if(fighter._accumulate_latency > 15000) return 2;
	//if(fighter._delay_count > 1000) return 3;
	if(big_lag_count > PVP_CONST_BIG_LAG_COUNT_MAX) return 4;

	return 0;
}

void PVP::OnTimer1s(time_t now)
{
	if(_robot_flag == 1)
	{
		if(_mode == 1)
		{
			//这里只需要判断fighter1。因为fighter2是机器人
			//PVPHeartbeat
			int ret = CheckFighter(now, _fighter1, 0); //TODO: sum==0会被用来标识机器人?
			if(ret)
			{
				GLog::log(LOG_INFO, "PVPD::PVP::OnTimer1s, robot, pvp=%d, fighter1=%ld, ret=%d, _wait_seconds=%d, sum=0",
				          _id, _fighter1._id, ret, _fighter1._wait_seconds);
				PVPEnd prot;
				prot.id = _id;
				prot.fighter1 = _fighter1._id;
				prot.fighter2 = _fighter2._id;
				prot.reason = ret;
				if(_typ == 0)
				{
					PVPGameClient::GetInstance()->SendProtocol(prot);
				}
				else if(_typ == 1)
				{
					PVPCenterClient::GetInstance()->SendProtocol(prot);
				}
				else
				{
					//记录错误日志
					GLog::log(LOG_ERR, "PVPD::PVP::OnTimer1s, typ=%d", _typ);

				}
				PVPManager::GetInstance().Delete(_id);
				return;
			}
		}
	}
	else
	{
		if(_mode == 1)
		{
			//PVPHeartbeat
			int sum = 0;
			for(auto i=0; i<PVP_CONST_BIG_LAG_SAMPLE_COUNT; i++)
			{
				sum += _big_lags[i];
			}

			int ret = CheckFighter(now, _fighter1, sum);
			if(ret)
			{
				GLog::log(LOG_INFO, "PVPD::PVP::OnTimer1s, pvp=%d, fighter1=%ld, ret=%d, _wait_seconds=%d, sum=%d",
				          _id, _fighter1._id, ret, _fighter1._wait_seconds, sum);
				PVPEnd prot;
				prot.id = _id;
				prot.fighter1 = _fighter1._id;
				prot.fighter2 = _fighter2._id;
				prot.reason = ret;
				if(_typ == 0)
				{
					PVPGameClient::GetInstance()->SendProtocol(prot);
				}
				else if(_typ == 1)
				{
					PVPCenterClient::GetInstance()->SendProtocol(prot);
				}
				else
				{
					//记录错误日志
					GLog::log(LOG_ERR, "PVPD::PVP::OnTimer1s, typ=%d", _typ);

				}
				PVPManager::GetInstance().Delete(_id);
				return;
			}
			ret = CheckFighter(now, _fighter2, -sum);
			if(ret)
			{
				GLog::log(LOG_INFO, "PVPD::PVP::OnTimer1s, pvp=%d, fighter2=%ld, ret=%d, _wait_seconds=%d, sum=%d",
				          _id, _fighter2._id, ret, _fighter2._wait_seconds, sum);
				PVPEnd prot;
				prot.id = _id;
				prot.fighter1 = _fighter1._id;
				prot.fighter2 = _fighter2._id;
				prot.reason = 100+ret;
				if(_typ == 0)
				{
					PVPGameClient::GetInstance()->SendProtocol(prot);
				}
				else if(_typ == 1)
				{
					PVPCenterClient::GetInstance()->SendProtocol(prot);
				}
				else
				{
					//记录错误日志
					GLog::log(LOG_ERR, "PVPD::PVP::OnTimer1s, typ=%d", _typ);

				}
				PVPManager::GetInstance().Delete(_id);
				return;
			}
		}
	}
}

//int64_t PVP::GetShouldArriveTime(int client_tick) const
//{
//	//PVP_CONST_CLIENT_TICK_MS略加一点, 不要限制太死
//	return _fight_start_time*(int64_t)1000 + client_tick*(PVP_CONST_CLIENT_TICK_MS+2) + PVP_CONST_NET_TICK_MS/2 + _latency;
//}

void PVP::OnPVPOpeartion(int64_t fighter, int client_tick, const char *op_encoded, const char *crc_encoded)
{
	if(_robot_flag == 1)
	{
		if(_mode == 1)
		{
			if(client_tick < _next_client_tick) return; //客户端重发包, 不理会

			PVPFighter *ft = 0;
			if(fighter == _fighter1._id)
			{
				ft = &_fighter1;
			}
			if(!ft) return;

			timeval tv;
			gettimeofday(&tv, 0);
			int64_t now_ms = tv.tv_sec*(int64_t)1000+tv.tv_usec/1000;

			auto it = ft->_ops.find(client_tick);
			if(it != ft->_ops.end()) return; //操作已发出后不能修改
			ft->_ops[client_tick]._op = op_encoded; //不用解码, 因为并不需要理解
			ft->_ops[client_tick]._arrive_time_ms = now_ms;

			if(client_tick==_next_client_tick) ft->_wait_seconds=0;

			//int64_t l = now_ms-GetShouldArriveTime(client_tick);
			//if(l > 0)
			//{
			//	ft->_accumulate_latency += (int)l;
			//	ft->_delay_count += 1;
			//}

			Player *player1 = PlayerManager::GetInstance().Find(_fighter1._id);
			if(!player1)
			{
				//TODO: 这怎么可能?
				return;
			}
			//是否已经收集齐?
			while(true)
			{
				auto it1 = _fighter1._ops.find(_next_client_tick);
				if(it1 == _fighter1._ops.end()) break;

				OP& op1 = it1->second;

				_big_lags[_big_lags_index%PVP_CONST_BIG_LAG_SAMPLE_COUNT] = 0;
				_big_lags_index++;

				char buf[1024];
				snprintf(buf, sizeof(buf)-1, "10307:%d:%s:%s:", _next_client_tick, op1._op.c_str(), ""); //PVPOperationSet
				player1->FastSess_Send(buf);

				PvpVideo tmp;
				tmp.tick = _next_client_tick;
				tmp.first_operation = Octets((void*)op1._op.c_str(), op1._op.size());
				_pvp_video.push_back(tmp);

				_fighter1._ops.erase(it1);
	
				//int64_t l = now_ms - (_fight_start_time*(int64_t)1000 + _next_client_tick*(PVP_CONST_CLIENT_TICK_MS+2) + PVP_CONST_NET_TICK_MS/2);
				//if(l > 0) _latency = (int)l;
	
				_next_client_tick++;
			}
		}
	}
	else
	{
		if(_mode == 1)
		{
			if(client_tick < _next_client_tick) return; //客户端重发包, 不理会

			PVPFighter *ft = 0;
			if(fighter == _fighter1._id)
			{
				ft = &_fighter1;
			}
			else if(fighter == _fighter2._id)
			{
				ft = &_fighter2;
			}
			if(!ft) return;

			timeval tv;
			gettimeofday(&tv, 0);
			int64_t now_ms = tv.tv_sec*(int64_t)1000+tv.tv_usec/1000;

			auto it = ft->_ops.find(client_tick);
			if(it != ft->_ops.end()) return; //操作已发出后不能修改
			ft->_ops[client_tick]._op = op_encoded; //不用解码, 因为并不需要理解
			ft->_ops[client_tick]._arrive_time_ms = now_ms;
			//{
			//timeval tv;
			//gettimeofday(&tv, 0);
			//GLog::log(LOG_INFO, "%d%03d: OP, fighter=%ld, client_tick=%d, op_encoded=%s", (int)tv.tv_sec, (int)tv.tv_usec/1000, fighter, client_tick, op_encoded);
			//}

			if(client_tick==_next_client_tick) ft->_wait_seconds=0;

			//int64_t l = now_ms-GetShouldArriveTime(client_tick);
			//if(l > 0)
			//{
			////GLog::log(LOG_INFO, "PVPD::PVP::OnPVPOpeartion, fighter=%ld, _accumulate_latency=%d, l=%ld, now_ms=%ld, client_tick=%d, should=%ld, _latency=%d", fighter, ft->_accumulate_latency, l, now_ms, client_tick, GetShouldArriveTime(client_tick), _latency);
			//	ft->_accumulate_latency += (int)l;
			//	ft->_delay_count += 1;
			//}

			Player *player1 = PlayerManager::GetInstance().Find(_fighter1._id);
			Player *player2 = PlayerManager::GetInstance().Find(_fighter2._id);
			if(!player1 || !player2)
			{
				//TODO: 这怎么可能?
				return;
			}
			//是否已经收集齐?
			while(true)
			{
				auto it1 = _fighter1._ops.find(_next_client_tick);
				if(it1 == _fighter1._ops.end()) break;
				auto it2 = _fighter2._ops.find(_next_client_tick);
				if(it2 == _fighter2._ops.end()) break;

				OP& op1 = it1->second;
				OP& op2 = it2->second;

				if(op1._arrive_time_ms-op2._arrive_time_ms> PVP_CONST_BIG_LAG_MS_MAX)
				{
					_big_lags[_big_lags_index%PVP_CONST_BIG_LAG_SAMPLE_COUNT] = 1;
				}
				else if(op2._arrive_time_ms-op1._arrive_time_ms> PVP_CONST_BIG_LAG_MS_MAX)
				{
					_big_lags[_big_lags_index%PVP_CONST_BIG_LAG_SAMPLE_COUNT] = -1;
				}
				else
				{
					_big_lags[_big_lags_index%PVP_CONST_BIG_LAG_SAMPLE_COUNT] = 0;
				}
				_big_lags_index++;

				char buf[1024];
				snprintf(buf, sizeof(buf)-1, "10307:%d:%s:%s:", _next_client_tick, op1._op.c_str(), op2._op.c_str()); //PVPOperationSet
				player1->FastSess_Send(buf);
				player2->FastSess_Send(buf);

				PvpVideo tmp;
				tmp.tick = _next_client_tick;
				tmp.first_operation = Octets((void*)op1._op.c_str(), op1._op.size());
				tmp.second_operation = Octets((void*)op2._op.c_str(), op2._op.size());
				_pvp_video.push_back(tmp);
				//{
				//timeval tv;
				//gettimeofday(&tv, 0);
				//GLog::log(LOG_INFO, "%d-%d: OPSET, _next_client_tick=%d", (int)tv.tv_sec, (int)tv.tv_usec/1000, _next_client_tick);
				//}

				_fighter1._ops.erase(it1);
				_fighter2._ops.erase(it2);
	
				//int64_t l = now_ms - (_fight_start_time*(int64_t)1000 + _next_client_tick*(PVP_CONST_CLIENT_TICK_MS+2) + PVP_CONST_NET_TICK_MS/2);
				//if(l > 0) _latency = (int)l;
	
				_next_client_tick++;
			}
		}
		else if(_mode == 2)
		{
			//int64_t opponent = 0;
			//if(fighter == _fighter1._id)
			//{
			//	if(_fighter2._status == 2) return;
			//	opponent = _fighter2._id;
			//}
			//else if(fighter == _fighter2._id)
			//{
			//	if(_fighter1._status == 2) return;
			//	opponent = _fighter1._id;
			//}
			//if(opponent)
			//{
			//	char buf[1024];
			//	snprintf(buf, sizeof(buf)-1, "10306:%lu:%d:%s:%s:", fighter, client_tick, op_encoded, crc_encoded);
	
			//	Player *oplayer = PlayerManager::GetInstance().Find(opponent);
			//	if(oplayer) oplayer->SendUDPGameProtocol(buf);
			//}
		}
	}
}

void PVP::OnPVPPeerLatency(int64_t src_role_id, int latency)
{
	{
	timeval tv;
	gettimeofday(&tv, 0);
	GLog::log(LOG_INFO, "%d-%d: PVP Latency, role_id=%ld, latency=%d", (int)tv.tv_sec, (int)tv.tv_usec/1000, src_role_id, latency);
	}

	int64_t opponent = 0;
	if(src_role_id == _fighter1._id)
	{
		opponent = _fighter2._id;
	}
	else if(src_role_id == _fighter2._id)
	{
		opponent = _fighter1._id;
	}
	if(opponent)
	{
		char buf[1024];
		snprintf(buf, sizeof(buf)-1, "10310:%d:", latency);

		Player *oplayer = PlayerManager::GetInstance().Find(opponent);
		if(oplayer) oplayer->SendUDPGameProtocol(buf);
	}
}

void PVP::SendOperation(int win_flag, int robot_flag, int robot_seed)
{
	PvpOperation prot;
	prot.first = _fighter1._id;
	prot.second = _fighter2._id;
	prot.first_pvpinfo = _fighter1_pvpinfo;
	prot.second_pvpinfo = _fighter2_pvpinfo;
	prot.operation = _pvp_video;
	prot.first_zoneid = _fighter1_zoneid;
	prot.second_zoneid = _fighter2_zoneid;
	prot.win_flag = win_flag;
	prot.robot_flag = robot_flag;
	prot.robot_seed = robot_seed;
	prot.exe_ver = _exe_ver;
	prot.data_ver = _data_ver;
	if(_typ == 1)
	{
		PVPCenterClient::GetInstance()->SendProtocol(prot);
	}
}

void PVPManager::Initialize()
{
	IntervalTimer::Attach(this, (10000)/IntervalTimer::Resolution());
}

bool PVPManager::Update()
{
	static int _tick = 0;

	_tick++;
	time_t now = time(0);

	for(auto it=_will_delete_list.begin(); it!=_will_delete_list.end(); ++it)
	{
		auto im = _map.find(*it);
		if(im != _map.end())
		{
			delete im->second;
			_map.erase(im);
		}
	}
	_will_delete_list.clear();

	for(auto it=_map.begin(); it!=_map.end(); ++it)
	{
		PVP *pvp = it->second;
		pvp->OnTimer(_tick, now);
		if(_tick%SERVER_CONST_TICK_PER_SECOND == pvp->_id%SERVER_CONST_TICK_PER_SECOND) pvp->OnTimer1s(now);
	}

	return true;
}

PVP* PVPManager::Find(int id)
{
	if(_will_delete_list.find(id) != _will_delete_list.end()) return 0;

	auto it = _map.find(id);
	if(it == _map.end()) return 0;
	return it->second;
}

int PVPManager::Create(int id, int mode, int64_t fighter1, int64_t fighter2, int fight_start_time, int typ, Octets fighter1_pvpinfo, Octets fighter2_pvpinfo, int fighter1_zoneid, int fighter2_zoneid, int robot_flag, Octets exe_ver, Octets data_ver)
{
	if(_map.find(id) != _map.end()) return -1;
	if(PlayerManager::GetInstance().Find(fighter1)) return -2;
	if(PlayerManager::GetInstance().Find(fighter2)) return -3;

	_map[id] = new PVP(id, mode, fighter1, fighter2, fight_start_time, typ, fighter1_pvpinfo, fighter2_pvpinfo, 
	                   fighter1_zoneid, fighter2_zoneid, robot_flag, exe_ver, data_ver);

	PlayerManager::GetInstance().Add(fighter1, id);
	PlayerManager::GetInstance().Add(fighter2, id);

	return 0;
}

void PVPManager::Delete(int id)
{
	_will_delete_list.insert(id);
}

void PVPManager::SendOperation(int id, int win_flag, int robot_flag, int robot_seed)
{
	if(_will_delete_list.find(id) != _will_delete_list.end()) return;

	auto it = _map.find(id);
	if(it == _map.end()) return;

	it->second->SendOperation(win_flag, robot_flag, robot_seed);
}

int PVPManager::GetCurRoomNum()
{
	return _map.size() - _will_delete_list.size();
}


}

