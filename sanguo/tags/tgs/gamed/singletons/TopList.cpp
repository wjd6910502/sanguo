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
	else if(strcmp(name, "_data") == 0)
	{
		_data.restore(transaction_id);

		Marshal::OctetsStream os;
		os._for_transaction = true;
		os << _data;
		_transaction_data["_data"] = os;
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
		it = _transaction_data.find("_data");
		if(it != _transaction_data.end())
		{
			Marshal::OctetsStream os(it->second);
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

void SGT_TopList::cleanup()
{
	_transaction_id = 0;
	_transaction_data.clear();

	_data.cleanup();
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

	if(str_key == "toplist_all_num")
	{
		Marshal::OctetsStream os(value);
		int db_version = 0;
		os >> db_version;
		os >> _data._top_list_type;
	}
	else
	{
		TopList top_value;

		Marshal::OctetsStream os(value);
		int db_version = 0;
		os >> db_version;
		os._dbversion = db_version;
		top_value.unmarshal(os);

		if(str_key == "toplist_level")
		{
			_data._top_data.Insert(TOPLIST_TYPE_LEVEL, top_value);
		}
		else if(str_key == "toplist_capacity")
		{
			_data._top_data.Insert(TOPLIST_TYPE_CAPACITY, top_value);
		}
		else if(str_key == "toplist_ranking")
		{
			_data._top_data.Insert(TOPLIST_TYPE_RANKING, top_value);
		}
		else if(str_key == "toplist_pve_arena")
		{
			_data._top_data.Insert(TOPLIST_TYPE_PVE_ARENA, top_value);
		}
		else if(str_key == "toplist_weapon")
		{
			_data._top_data.Insert(TOPLIST_TYPE_WEAPON, top_value);
		}
		else if(str_key == "toplist_hero")
		{
			_data._top_data.Insert(TOPLIST_TYPE_HERO, top_value);
		}
		else if(str_key == "toplist_mashu")
		{
			_data._top_data.Insert(TOPLIST_TYPE_MASHU, top_value);
		}
		else
		{
			//服务器自动添加的排行榜
			string result_key = str_key.substr(8);
			int result = atoi(result_key.data());
			if(result >= TOPLIST_AUTO_CREATE)
			{
				_data._top_data.Insert(result, top_value);
			}
		}
	}
}

void SGT_TopList::Save()
{
	TopList * toplist = NULL;
	TopManagerMapIter it_manager = _data._top_data.SeekToBegin();
	GNET::Marshal::OctetsStream value;
	int db_version = DB_VERSION;

	//注意这里的名字不可以有toplist_数字这种形式的，因为数字的都被自动生成的占用了
	for(it_manager = _data._top_data.SeekToBegin(); (toplist = it_manager.GetValue()); it_manager.Next())
	{
		value.clear();
		if(toplist->_top_list_type == TOPLIST_TYPE_LEVEL)
		{
			std::string key_str = "toplist_level";
			
			//先把version版本号放进去
			value << db_version;
			toplist->marshal(value);
			g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;
		}
		else if(toplist->_top_list_type == TOPLIST_TYPE_CAPACITY)
		{
			std::string key_str = "toplist_capacity";
			
			value << db_version;
			toplist->marshal(value);
			g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;
		}
		else if(toplist->_top_list_type == TOPLIST_TYPE_RANKING)
		{
			std::string key_str = "toplist_ranking";
			
			value << db_version;
			toplist->marshal(value);
			g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;
		}
		else if(toplist->_top_list_type == TOPLIST_TYPE_PVE_ARENA)
		{
			std::string key_str = "toplist_pve_arena";
			
			value << db_version;
			toplist->marshal(value);
			g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;
		}
		else if(toplist->_top_list_type == TOPLIST_TYPE_WEAPON)
		{
			std::string key_str = "toplist_weapon";
			
			value << db_version;
			toplist->marshal(value);
			g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;
		}
		else if(toplist->_top_list_type == TOPLIST_TYPE_HERO)
		{
			std::string key_str = "toplist_hero";
			
			value << db_version;
			toplist->marshal(value);
			g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;
		}
		else if(toplist->_top_list_type == TOPLIST_TYPE_MASHU)
		{
			std::string key_str = "toplist_mashu";
			
			value << db_version;
			toplist->marshal(value);
			g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;
		}
		else if(toplist->_top_list_type >= TOPLIST_AUTO_CREATE)
		{
			char msg[100];
			snprintf(msg, sizeof(msg), "toplist_%d", toplist->_top_list_type);
			
			std::string key_str = msg;
			
			value << db_version;
			toplist->marshal(value);
			g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;
		}
	}
	
	//把当前有多少个排行榜了，存储起来。
	std::string key_str = "toplist_all_num";
	value.clear();
	value << db_version;
	value << _data._top_list_type;

	g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;
}

}

