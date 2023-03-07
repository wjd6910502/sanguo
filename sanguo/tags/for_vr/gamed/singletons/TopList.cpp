#include "TopList.h"
#include "gamedbclient.hpp"
#include "message.h"

extern std::map<Octets, Octets> g_save_data_map;

namespace CACHE
{

SGT_TopList::SGT_TopList()
{
	_in_transaction = false;
	_transaction_id = 0;

	SingletonManager::GetInstance().Register(1, this);
}

void SGT_TopList::BeginTransaction()
{
	if(_in_transaction) return;
	_in_transaction = true;

	_transaction_id = 0;
	_transaction_data.clear();
}

void SGT_TopList::CommitTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;
}

void SGT_TopList::CancelTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;

	restore(g_transaction_id);
}

void SGT_TopList::backup(const char *name, int transaction_id)
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
	else if(strcmp(name, "_top_manager") == 0)
	{
		_top_manager.restore(transaction_id);

		Marshal::OctetsStream os;
		os._for_transaction = true;
		os << _top_manager;
		_transaction_data["_top_manager"] = os;
	}
	else
	{
		abort();
	}
}

void SGT_TopList::restore(int transaction_id)
{
	if(transaction_id == _transaction_id)
	{
		auto it = _transaction_data.end();
		it = _transaction_data.find("_top_manager");
		if(it != _transaction_data.end())
		{
			Marshal::OctetsStream os(it->second);
			os._for_transaction = true;
			os >> _top_manager;
			_top_manager.cleanup();
		}
		else
		{
			_top_manager.restore(transaction_id);
		}
	}
	else
	{
		_top_manager.restore(transaction_id);
	}
	_transaction_id = 0;
	_transaction_data.clear();
}

void SGT_TopList::cleanup()
{
	_transaction_id = 0;
	_transaction_data.clear();

	_top_manager.cleanup();
}

//手动增加的代码
void SGT_TopList::OnTimer(int tick, int now)
{
	if(tick%(SERVER_CONST_TICK_PER_SECOND*5) == 0)
	{
		char msg[100];
		snprintf(msg, sizeof(msg), "10020:");
		MessageManager::GetInstance().Put(0, 0, msg, 0);
	}
}

void SGT_TopList::SendMessageDaily(const Int64& target, const std::string& msgid, const int& mailid, const std::string& arg)
{
	char msg[256];
	snprintf(msg, sizeof(msg), "%s:%d:%s:", msgid.c_str(), mailid, arg.c_str()); //SendMail
	int64_t roleid = target;
	MessageManager::GetInstance().Put(roleid, roleid, msg, 0);
}

void SGT_TopList::SendMessageServerEvent(const int& event_type, const int& end_time)
{
	char msg[256];
	snprintf(msg, sizeof(msg), "10025:%d:%d:", event_type, end_time); //SendServerEvent
	MessageManager::GetInstance().Put(0, 0, msg, 0);
}

//for DB
void SGT_TopList::Load(Octets &key, Octets &value)
{
	std::string str_key  = std::string((char*)key.begin(),key.size());

	TopList top_value;

	Marshal::OctetsStream os(value);
	int db_version = 0;
	os >> db_version;
	os._dbversion = db_version;
	top_value.unmarshal(os);

	if(str_key == "toplist_level")
	{
		_top_manager.Insert(TOPLIST_TYPE_LEVEL, top_value);
	}
	else if(str_key == "toplist_capacity")
	{
		_top_manager.Insert(TOPLIST_TYPE_CAPACITY, top_value);
	}
	else if(str_key == "toplist_ranking")
	{
		_top_manager.Insert(TOPLIST_TYPE_RANKING, top_value);
	}
	else if(str_key == "toplist_pve_arena")
	{
		_top_manager.Insert(TOPLIST_TYPE_PVE_ARENA, top_value);
	}
}

void SGT_TopList::Save()
{
	TopList * toplist = NULL;
	TopManagerMapIter it_manager = _top_manager.SeekToBegin();
	GNET::Marshal::OctetsStream value;

	for(it_manager = _top_manager.SeekToBegin(); (toplist = it_manager.GetValue()); it_manager.Next())
	{
		value.clear();
		if(toplist->_top_list_type == TOPLIST_TYPE_LEVEL)
		{
			std::string key_str = "toplist_level";
			
			//先把version版本号放进去
			int db_version = DB_VERSION;
			value << db_version;
			toplist->marshal(value);
			g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;
		}
		else if(toplist->_top_list_type == TOPLIST_TYPE_CAPACITY)
		{
			std::string key_str = "toplist_capacity";
			
			int db_version = DB_VERSION;
			value << db_version;
			toplist->marshal(value);
			g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;
		}
		else if(toplist->_top_list_type == TOPLIST_TYPE_RANKING)
		{
			std::string key_str = "toplist_ranking";
			
			int db_version = DB_VERSION;
			value << db_version;
			toplist->marshal(value);
			g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;
		}
		else if(toplist->_top_list_type == TOPLIST_TYPE_PVE_ARENA)
		{
			std::string key_str = "toplist_pve_arena";
			
			int db_version = DB_VERSION;
			value << db_version;
			toplist->marshal(value);
			g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;
		}
	}
}

}

