#include "YueZhan_Info.h"

namespace CACHE
{

SGT_YueZhan_Info::SGT_YueZhan_Info(): Singleton("SGT_YueZhan_Info")
{
	_in_transaction = false;
	_transaction_id = 0;

	SingletonManager::GetInstance().Register(9, this);
}

void SGT_YueZhan_Info::BeginTransaction()
{
	if(_in_transaction) return;
	_in_transaction = true;

	_transaction_id = 0;
	_transaction_data.clear();
}

void SGT_YueZhan_Info::CommitTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;
}

void SGT_YueZhan_Info::CancelTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;

	restore(g_transaction_id);
}

void SGT_YueZhan_Info::backup(const char *name, int64_t transaction_id)
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

void SGT_YueZhan_Info::restore(int64_t transaction_id)
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

void SGT_YueZhan_Info::cleanup()
{
	_transaction_id = 0;
	_transaction_data.clear();

	_data.cleanup();
}

bool SGT_YueZhan_Info::GetRoomInfo(int room_id, YueZhanData * &info)
{
	info = _data._yuezhan_info.Find(room_id);
	if(info != NULL)
	{
		return true;
	}
	return false;
}

}

