#include "NoLoadPlayer.h"

#include "gamedbclient.hpp"
#include "dbloadroledata.hrp"

namespace CACHE
{

SGT_NoLoadPlayer::SGT_NoLoadPlayer(): Singleton("SGT_NoLoadPlayer")
{
	_in_transaction = false;
	_transaction_id = 0;

	SingletonManager::GetInstance().Register(4, this);
}

void SGT_NoLoadPlayer::BeginTransaction()
{
	if(_in_transaction) return;
	_in_transaction = true;

	_transaction_id = 0;
	_transaction_data.clear();
}

void SGT_NoLoadPlayer::CommitTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;
}

void SGT_NoLoadPlayer::CancelTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;

	restore(g_transaction_id);
}

void SGT_NoLoadPlayer::backup(const char *name, int64_t transaction_id)
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

void SGT_NoLoadPlayer::restore(int64_t transaction_id)
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

void SGT_NoLoadPlayer::cleanup()
{
	_transaction_id = 0;
	_transaction_data.clear();

	_data.cleanup();
}

void SGT_NoLoadPlayer::InsertData(std::string account, Int64 roleid)
{
	Thread::Mutex2::Scoped keeper(_lock);

	NoLoadPlayerInfoData data;
	data._role_id = roleid;
	_data._player_info.Insert(account, data);

	Str str;
	str._value = account;
	_data._player_info_roleid.Insert(roleid, str);
}

void SGT_NoLoadPlayer::GetRoleInfo(const std::string account)
{
	//TODO: transaction
	std::string key = "roleinfo_";
	key += account;
	DBLoadRoleDataArg arg;
	arg.key = Octets((void*)key.c_str(), key.size());

	DBLoadRoleData *rpc = (DBLoadRoleData*)Rpc::Call(RPC_DBLOADROLEDATA, arg);
	GameDBClient::GetInstance()->SendProtocol(rpc);
	
}

std::string SGT_NoLoadPlayer::HaveLoadPlayer(Int64 roleid)
{
	Str* it = _data._player_info_roleid.Find(roleid);
	if(it != NULL)
	{
		return (*it)._value;
	}
	else
	{
		return "";
	}
}

}

