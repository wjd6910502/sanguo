#include "mafiamanager.h"
#include "playermanager.h"

extern std::map<Octets, Octets> g_save_data_map;

namespace CACHE
{

Mafia::Mafia()
{
	_in_transaction = false;
	_transaction_id = 0;
}

GNET::Marshal::OctetsStream& Mafia::marshal(GNET::Marshal::OctetsStream &os) const
{
	os << _data;
	return os;
}

const GNET::Marshal::OctetsStream& Mafia::unmarshal(const GNET::Marshal::OctetsStream &os)
{
	os >> _data;
	return os;
}

void Mafia::BeginTransaction()
{
	if(_in_transaction) return;
	_in_transaction = true;

	_transaction_id = 0;
	_transaction_data.clear();
}

void Mafia::CommitTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;
}

void Mafia::CancelTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;

	restore(g_transaction_id);
}

void Mafia::backup(const char *name, int transaction_id)
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

void Mafia::restore(int transaction_id)
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

void Mafia::cleanup()
{
	_transaction_id = 0;
	_transaction_data.clear();

	_data.cleanup();
}

void Mafia::OnTimer(int now)
{
	//在这里帮会给自己扔一个消息，去心跳里面处理东西
	char msg[100];
	snprintf(msg, sizeof(msg), "44:%d:",now);
	MessageManager::GetInstance().Put(_data._id, 0, msg, 0);
}

Mafia* MafiaManager::Find(const Int64& k)
{
	Thread::Mutex::Scoped keeper(_lock);
	return _map.Find(k);
}

void MafiaManager::Insert(const Int64& k, const Mafia& v)
{
	Thread::Mutex::Scoped keeper(_lock);
	_map.Insert(k, v);
}

void MafiaManager::Load(Octets &key, Octets &value)
{
	Mafia mafia;
	Marshal::OctetsStream os(value);
	int db_version = 0;
	os >> db_version;
	os._dbversion = db_version;
	mafia.unmarshal(os);
	_map.Insert(mafia._data._id, mafia);
}
void MafiaManager::Save()
{
	GNET::Marshal::OctetsStream value;
	Mafia *mafia;
	for(MafiaMapIter it_manager = _map.SeekToBegin(); (mafia = it_manager.GetValue()); it_manager.Next())
	{
		if(mafia->_data._deleted != 1)
		{
			std::string key_str = "mafia_";
			key_str = key_str + mafia->_data._id.ToStr();
			value.clear();
			int db_version = DB_VERSION;
			value << db_version;
			mafia->marshal(value);
			g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;
		}
	}
}

void MafiaManager::OnTimer(int tick, time_t now)
{
	if(tick%(SERVER_CONST_TICK_PER_SECOND*5) == 0)
	{
		Mafia *mafia;
		for(MafiaMapIter it_manager = _map.SeekToBegin(); (mafia = it_manager.GetValue()); it_manager.Next())
		{
			mafia->OnTimer(now);
		}
	}
}

};

CACHE::Int64 API_Mafia_AllocId()
{
	return CACHE::PlayerManager::GetInstance().AllocMafiaId(); //TODO:
}

void API_Mafia_Insert(const CACHE::Int64& id, const CACHE::MafiaData& data)
{
	CACHE::Mafia mafia;
	mafia._data = data;
	CACHE::MafiaManager::GetInstance().Insert(id, mafia);
}

