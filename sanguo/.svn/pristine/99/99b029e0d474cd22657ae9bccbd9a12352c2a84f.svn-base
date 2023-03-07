#include <string>
#include <map>
#include <set>

#include "singletonmanager.h"

extern std::map<std::string,std::set<int> > g_lock_cmd_set_map; //lock=>cmd_set
extern std::map<std::string,std::set<int> > g_lock_msg_set_map; //lock=>msg_set

namespace CACHE
{

void SingletonManager::Register(int id, Singleton* sgt)
{
	_map[id] = sgt;
}

void SingletonManager::Add2CommandParameter(int cmd, LuaParameter& param)
{
	for(auto it=_map.begin(); it!=_map.end(); ++it)
	{
		auto *sgt = it->second;
		auto it2 = g_lock_cmd_set_map.find(sgt->GetLockName()); //g_lock_cmd_set_map: lock=>cmd_set
		if(it2 == g_lock_cmd_set_map.end())
		{
			param.AddParameter((void*)0);
			continue;
		}
		auto cmd_set = it2->second;
		if(cmd_set.find(cmd) == cmd_set.end())
		{
			param.AddParameter((void*)0);
			continue;
		}
		param.AddParameter(sgt);
	}
}

void SingletonManager::Add2CommandLock(int cmd, std::list<MyScoped>& keeper_list)
{
	for(auto it=_map.begin(); it!=_map.end(); ++it)
	{
		auto *sgt = it->second;
		auto it2 = g_lock_cmd_set_map.find(sgt->GetLockName()); //g_lock_cmd_set_map: lock=>cmd_set
		if(it2 == g_lock_cmd_set_map.end())
		{
			continue;
		}
		auto cmd_set = it2->second;
		if(cmd_set.find(cmd) == cmd_set.end())
		{
			continue;
		}
		keeper_list.push_back(MyScoped(sgt->_lock));
	}
}

void SingletonManager::Add2CommandTransaction(int cmd, std::list<TransactionKeeper>& keeper_list)
{
	for(auto it=_map.begin(); it!=_map.end(); ++it)
	{
		auto *sgt = it->second;
		auto it2 = g_lock_cmd_set_map.find(sgt->GetLockName()); //g_lock_cmd_set_map: lock=>cmd_set
		if(it2 == g_lock_cmd_set_map.end())
		{
			continue;
		}
		auto cmd_set = it2->second;
		if(cmd_set.find(cmd) == cmd_set.end())
		{
			continue;
		}
		keeper_list.push_back(TransactionKeeper((TransactionBase*)sgt));
	}
}

void SingletonManager::Add2MessageParameter(int msg, LuaParameter& param)
{
	for(auto it=_map.begin(); it!=_map.end(); ++it)
	{
		auto *sgt = it->second;
		auto it2 = g_lock_msg_set_map.find(sgt->GetLockName()); //g_lock_msg_set_map: lock=>msg_set
		if(it2 == g_lock_msg_set_map.end())
		{
			param.AddParameter((void*)0);
			continue;
		}
		auto msg_set = it2->second;
		if(msg_set.find(msg) == msg_set.end())
		{
			param.AddParameter((void*)0);
			continue;
		}
		param.AddParameter(sgt);
	}
}

void SingletonManager::Add2MessageLock(int msg, std::list<MyScoped>& keeper_list)
{
	for(auto it=_map.begin(); it!=_map.end(); ++it)
	{
		auto *sgt = it->second;
		auto it2 = g_lock_msg_set_map.find(sgt->GetLockName()); //g_lock_msg_set_map: lock=>msg_set
		if(it2 == g_lock_msg_set_map.end())
		{
			continue;
		}
		auto msg_set = it2->second;
		if(msg_set.find(msg) == msg_set.end())
		{
			continue;
		}
		keeper_list.push_back(MyScoped(sgt->_lock));
	}
}

void SingletonManager::Add2MessageTransaction(int msg, std::list<TransactionKeeper>& keeper_list)
{
	for(auto it=_map.begin(); it!=_map.end(); ++it)
	{
		auto *sgt = it->second;
		auto it2 = g_lock_msg_set_map.find(sgt->GetLockName()); //g_lock_msg_set_map: lock=>msg_set
		if(it2 == g_lock_msg_set_map.end())
		{
			continue;
		}
		auto msg_set = it2->second;
		if(msg_set.find(msg) == msg_set.end())
		{
			continue;
		}
		keeper_list.push_back(TransactionKeeper((TransactionBase*)sgt));
	}
}

};
