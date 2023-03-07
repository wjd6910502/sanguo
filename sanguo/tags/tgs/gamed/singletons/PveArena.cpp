#include "PveArena.h"
#include "commonmacro.h"
#include "message.h"

extern std::map<Octets, Octets> g_save_data_map;

namespace CACHE
{

SGT_PveArena::SGT_PveArena()
{
	_in_transaction = false;
	_transaction_id = 0;

	SingletonManager::GetInstance().Register(3, this);
}

void SGT_PveArena::BeginTransaction()
{
	if(_in_transaction) return;
	_in_transaction = true;

	_transaction_id = 0;
	_transaction_data.clear();
}

void SGT_PveArena::CommitTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;
}

void SGT_PveArena::CancelTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;

	restore(g_transaction_id);
}

void SGT_PveArena::backup(const char *name, int transaction_id)
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

void SGT_PveArena::restore(int transaction_id)
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

void SGT_PveArena::cleanup()
{
	_transaction_id = 0;
	_transaction_data.clear();

	_data.cleanup();
}

void SGT_PveArena::OnTimer(int tick, int now)
{
	if(tick%(SERVER_CONST_TICK_PER_SECOND*10) == 0)
	{
		char msg[100];
		snprintf(msg, sizeof(msg), "13:");
		MessageManager::GetInstance().Put(0, 0, msg, 0);
	}
}

void SGT_PveArena::Load(Octets &key, Octets &value)
{
	std::string str_key  = std::string((char*)key.begin(),key.size());

	Marshal::OctetsStream os(value);
	int db_version = 0;
	os >> db_version;
	os._dbversion = db_version;

	_data.unmarshal(os);
}

void SGT_PveArena::Save()
{
	GNET::Marshal::OctetsStream value;
	std::string key_str = "pvearena_";

	int db_version = DB_VERSION;
	value << db_version;
	_data.marshal(value);
	g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;
}

}

