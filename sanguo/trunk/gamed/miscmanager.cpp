#include "miscmanager.h"
#include "gamedbclient.hpp"
#include "message.h"


extern std::map<Octets, Octets> g_save_data_map;
namespace CACHE
{

void MiscManager::BeginTransaction()
{
	if(_in_transaction) return;
	_in_transaction = true;

	_transaction_id = 0;
	_transaction_data.clear();
}

void MiscManager::CommitTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;
}

void MiscManager::CancelTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;

	restore(g_transaction_id);
}

void MiscManager::Load(Octets &key, Octets &value)
{
	std::string str_key  = std::string((char*)key.begin(),key.size());

	Marshal::OctetsStream os(value);
	int db_version = 0;
	os >> db_version;
	os._dbversion = db_version;

	_miscdata.unmarshal(os);
}

void MiscManager::Save()
{
	GNET::Marshal::OctetsStream value;
	std::string key_str = "miscmanager_";

	int db_version = DB_VERSION;
	value << db_version;
	_miscdata.marshal(value);
	g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;
	
}

void MiscManager::OnTimer(int tick, int now)
{
	if(tick%(SERVER_CONST_TICK_PER_SECOND*10) == 0)
	{
		char msg[100];
		snprintf(msg, sizeof(msg), "10028:");
		MessageManager::GetInstance().Put(0, 0, msg, 0);
	}
}

void MiscManager::SendMessage(const std::string& msg, int delay)
{
	MessageManager::GetInstance().Put(0, 0, msg.c_str(), delay);
}

void MiscManager::backup(const char *name, int64_t transaction_id)
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
	else if(strcmp(name, "_miscdata") == 0)
	{
		_miscdata.restore(transaction_id);

		Marshal::OctetsStream os;
		os._for_transaction = true;
		os << _miscdata;
		_transaction_data["_miscdata"] = os;
	}
	else
	{
		abort();
	}
}
void MiscManager::restore(int64_t transaction_id)
{
	if(transaction_id == _transaction_id)
	{
		auto it = _transaction_data.end();
		it = _transaction_data.find("_miscdata");
		if(it != _transaction_data.end())
		{
			Marshal::OctetsStream os(it->second);
			os._for_transaction = true;
			os >> _miscdata;
			_miscdata.cleanup();
		}
		else
		{
			_miscdata.restore(transaction_id);
		}
	}
	else
	{
		_miscdata.restore(transaction_id);
	}
	_transaction_id = 0;
	_transaction_data.clear();
}
void MiscManager::cleanup()
{
	_transaction_id = 0;
	_transaction_data.clear();

	_miscdata.cleanup();
}

};
