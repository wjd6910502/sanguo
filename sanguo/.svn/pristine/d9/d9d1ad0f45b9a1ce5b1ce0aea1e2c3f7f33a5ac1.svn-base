
#include "pvpmanager.h"
#include "pvpgameserver.hpp"
#include "pvpcreate.hrp"
#include "pvpdelete.hpp"

namespace CACHE
{

void PVP::backup(const char *name, int64_t transaction_id)
{
	if(transaction_id != _transaction_id)
	{
		_transaction_id = transaction_id;
		_transaction_data.clear();
	}
	else if(_transaction_data.find(name) != _transaction_data.end())
	{
		return;
	}

	if(false)
	{
	}
	else if(strcmp(name, "_data") == 0)
	{
		_data.restore(transaction_id);

		OctetsStream os;
		os._for_transaction = true;
		os << _data;
		_transaction_data["_data"] = os;
	}
	else
	{
		abort();
	}
}

void PVP::restore(int64_t transaction_id)
{
	if(transaction_id == _transaction_id)
	{
		auto it = _transaction_data.end();
		it = _transaction_data.find("_data");
		if(it != _transaction_data.end())
		{
			OctetsStream os(it->second);
			os._for_transaction = true;
			os >> _data;
			_data.cleanup();
		}
		else
		{
			_data.restore(transaction_id);
		}
	}
	else
	{
		_data.restore(transaction_id);
	}

	_transaction_id = 0;
	_transaction_data.clear();
}

void PVP::cleanup()
{
	_transaction_id = 0;
	_transaction_data.clear();

	_data.cleanup();
}

void PVP::PVPD_Create()
{
	const PVPD* pvpd = PVPManager::GetInstance().AllocPVPServer();
	if(!pvpd)
	{
		GLog::log(LOG_ERR, "GAMED::PVPD_Create, AllocPVPServer error");
		return;
	}

	//_pvpd_ip = pvpd->_ip;
	//_pvpd_port = pvpd->_port;
	_data._pvpd_ip = pvpd->_ip;
	_data._pvpd_port = pvpd->_port;

	PVPCreateArg arg;
	arg.id = _data._id;
	arg.mode = _data._mode;
	arg.fighter1 = _data._fighter1._id;
	arg.fighter2 = _data._fighter2._id;
	arg.start_time = _data._fight_start_time;
	arg.typ = 0;
	PVPCreate *rpc = (PVPCreate*)Rpc::Call(RPC_PVPCREATE, arg);
	PVPGameServer::GetInstance()->Send(pvpd->_sid, rpc);
}

void PVP::PVPD_Delete()
{
	//const PVPD* pvpd = PVPManager::GetInstance().FindPVPServer(_pvpd_ip.c_str(), _pvpd_port);
	const PVPD* pvpd = PVPManager::GetInstance().FindPVPServer(_data._pvpd_ip.c_str(), _data._pvpd_port);
	if(!pvpd)
	{
		GLog::log(LOG_ERR, "GAMED::PVPD_Delete, FindPVPServer error");
		return;
	}

	PVPDelete prot;
	prot.id = _data._id;
	PVPGameServer::GetInstance()->Send(pvpd->_sid, prot);
}

void PVP::BeginTransaction()
{
	if(_in_transaction) return;
	_in_transaction = true;

	_transaction_id = 0;
	_transaction_data.clear();
}

void PVP::CommitTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;
}

void PVP::CancelTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;

	restore(g_transaction_id);
}

//void PVP::OnTimer(int tick, int now)
//{
//	//NO LOCK
//	if(_data._status != 1) return;
//
//	if(tick%5 == 0) //TODO
//	{
//		std::vector<int64_t> extra_roles;
//		extra_roles.push_back((int64_t)_data._fighter1._id);
//		extra_roles.push_back((int64_t)_data._fighter2._id);
//
//		char msg[100];
//		snprintf(msg, sizeof(msg), "10005:"); //PVPTriggerSend
//		MessageManager::GetInstance().Put(_data._id, _data._id, msg, 0, &extra_roles);
//	}
//}

void PVP::OnTimer1s(time_t now)
{
	//NO LOCK
	std::vector<int64_t> extra_roles;
	extra_roles.push_back((int64_t)_data._fighter1._id);
	extra_roles.push_back((int64_t)_data._fighter2._id);

	char msg[100];
	snprintf(msg, sizeof(msg), "10004:%lu:", now); //PVPHeartbeat
	MessageManager::GetInstance().Put(_data._id, _data._id, msg, 0, &extra_roles);
}

void PVPManager::OnTimer(int tick, int now)
{
	Thread::Mutex2::Scoped keeper(_lock);

	for(auto it=_map.begin(); it!=_map.end(); ++it)
	{
		if(_will_delete_list.find(it->first)!=_will_delete_list.end()) continue; //TODO: do delete

		PVP *pvp = it->second;
		//pvp->OnTimer(tick, now);
		if(tick%SERVER_CONST_TICK_PER_SECOND == pvp->_data._id%SERVER_CONST_TICK_PER_SECOND) pvp->OnTimer1s(now);
	}
}

PVP* PVPManager::Find(int id)
{
	Thread::Mutex2::Scoped keeper(_lock);

	if(_will_delete_list.find(id)!=_will_delete_list.end()) return 0;

	auto it = _map.find(id);
	if(it == _map.end()) return 0;
	return it->second;
}

int PVPManager::LUA_Create(int mode, const Int64& fighter1, const Int64& fighter2)
{
	Thread::Mutex2::Scoped keeper(_lock);

	_id_stub++;
	PVP *pvp = new PVP(_id_stub, mode, fighter1, fighter2);
	_map[_id_stub] = pvp;
	return _id_stub;
}

void PVPManager::LUA_Delete(int id)
{
	Thread::Mutex2::Scoped keeper(_lock);

	_will_delete_list.insert(id);
}

void PVPManager::AddPVPServer(const char *ip, unsigned short port, unsigned int sid)
{
	Thread::Mutex2::Scoped keeper(_lock);

	for(auto it=_pvpds.begin(); it!=_pvpds.end(); ++it)
	{
		if(it->_ip==ip && it->_port==port)
		{
			it->_sid = sid;
			it->_last_active_time = Now();
			it->_load = 100;
			return;
		}
	}
	PVPD pvpd;
	pvpd._ip = ip;
	pvpd._port = port;
	pvpd._sid = sid;
	pvpd._last_active_time = Now();
	pvpd._load = 100;
	_pvpds.push_back(pvpd);
}

void PVPManager::UpdatePVPServerLoad(unsigned int sid, int load)
{
	Thread::Mutex2::Scoped keeper(_lock);

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

const PVPD* PVPManager::AllocPVPServer() const
{
	Thread::Mutex2::Scoped keeper(_lock);

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

const PVPD* PVPManager::FindPVPServer(const char *ip, unsigned short port) const
{
	Thread::Mutex2::Scoped keeper(_lock);

	for(auto it=_pvpds.begin(); it!=_pvpds.end(); ++it)
	{
		if(it->_ip==ip && it->_port==port) return &*it;
	}
	return 0;
}

};

