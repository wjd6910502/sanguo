#include "topmanager.h"
#include "gamedbclient.hpp"
#include "message.h"

extern std::map<Octets, Octets> g_save_data_map;
namespace CACHE
{
void TopManager::BeginTransaction()
{
	if(_in_transaction) return;
	_in_transaction = true;

	_transaction_id = 0;
	_transaction_data.clear();
}

void TopManager::CommitTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;
}

void TopManager::CancelTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;

	restore(g_transaction_id);
}

//void TopManager::OnChanged()
//{
//	_top_manager.OnChanged();
//}
//
//int TopManager::Tag() const
//{
//	return _top_manager.Tag();
//}
//
//std::map<int, TopList>::iterator  TopManager::End()
//{
//	return _top_manager.End();
//}

//for lua
//int TopManager::Size() const
//{
//	return _top_manager.Size();
//}

//TopList* TopManager::Find(const int& k)
//{
//	return _top_manager.Find(k);
//}

//void Insert(const Int64& k, const TopList& v);
//void Delete(const int& k);

//TopManagerMapIter TopManager::SeekToBegin()
//{
//	return _top_manager.SeekToBegin();
//}
//
//TopManagerMapIter TopManager::Seek(const int& k)
//{
//	return _top_manager.Seek(k);
//}

void TopManager::Load(Octets &key, Octets &value)
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

void TopManager::Save()
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

void TopManager::OnTimer(int tick, int now)
{
	if(tick%(SERVER_CONST_TICK_PER_SECOND*5) == 0)
	{
		char msg[100];
		snprintf(msg, sizeof(msg), "10020:");
		MessageManager::GetInstance().Put(0, 0, msg, 0);
	}
}

//void TopManager::SaveTest()
//{
//	TopList top_level;
//	TopList top_capacity;
//	TopListData tmp_data;
//	for(int64_t i = 1; i <= 1; i++)
//	{
//		tmp_data._name = "an1";
//		tmp_data._photo = i;
//		tmp_data._id = i*1000;
//		tmp_data.data = i*10;
//		top_level._new_top_list_by_id.Insert(tmp_data._id, tmp_data);
//		top_level._new_top_list_by_data.Insert(tmp_data.data, tmp_data);
//	}
//	for(int64_t i = 1; i <= 1; i++)
//	{
//		tmp_data._name = "an2";
//		tmp_data._photo = i;
//		tmp_data._id = i*500;
//		tmp_data.data = i*5;
//		top_level._old_top_list.Insert(tmp_data.data, tmp_data);
//	}
//	for(int64_t i = 1; i <= 1; i++)
//	{
//		tmp_data._name = "an3";
//		tmp_data._photo = i;
//		tmp_data._id = i*1000;
//		tmp_data.data = i*10;
//		top_capacity._new_top_list_by_id.Insert(tmp_data._id, tmp_data);
//		top_capacity._new_top_list_by_data.Insert(tmp_data.data, tmp_data);
//	}
//	for(int64_t i = 1; i <= 1; i++)
//	{
//		tmp_data._name = "an4";
//		tmp_data._photo = i;
//		tmp_data._id = i*500;
//		tmp_data.data = i*5;
//		top_capacity._old_top_list.Insert(tmp_data.data, tmp_data);
//	}
//	top_level._top_list_type = TOPLIST_TYPE_LEVEL;
//	top_capacity._top_list_type = TOPLIST_TYPE_CAPACITY;
//     	_top_manager.Insert(TOPLIST_TYPE_LEVEL, top_level);
//	_top_manager.Insert(TOPLIST_TYPE_CAPACITY, top_capacity);
//}

void TopManager::SendMessageDaily(const Int64& target, const std::string& msgid, const int& mailid, const std::string& arg)
{
	char msg[256];
	snprintf(msg, sizeof(msg), "%s:%d:%s:", msgid.c_str(), mailid, arg.c_str()); //SendMail
	int64_t roleid = target;
	MessageManager::GetInstance().Put(roleid, roleid, msg, 0);
}

void TopManager::SendMessageServerEvent(const int& event_type, const int& end_time)
{
	char msg[256];
	snprintf(msg, sizeof(msg), "10025:%d:%d:", event_type, end_time); //SendServerEvent
	MessageManager::GetInstance().Put(0, 0, msg, 0);
}

void TopManager::restore(int transaction_id)
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

void TopManager::cleanup()
{
	_transaction_id = 0;
	_transaction_data.clear();

	_top_manager.cleanup();
}

void TopManager::backup(const char *name, int transaction_id)
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

};
