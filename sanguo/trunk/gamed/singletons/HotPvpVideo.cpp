#include "message.h"
#include "HotPvpVideo.h"

namespace CACHE
{

SGT_HotPvpVideo::SGT_HotPvpVideo(): Singleton("SGT_HotPvpVideo")
{
	_in_transaction = false;
	_transaction_id = 0;

	SingletonManager::GetInstance().Register(14, this);
}

void SGT_HotPvpVideo::BeginTransaction()
{
	if(_in_transaction) return;
	_in_transaction = true;

	_transaction_id = 0;
	_transaction_data.clear();
}

void SGT_HotPvpVideo::CommitTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;
}

void SGT_HotPvpVideo::CancelTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;

	restore(g_transaction_id);
}

void SGT_HotPvpVideo::backup(const char *name, int64_t transaction_id)
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

void SGT_HotPvpVideo::restore(int64_t transaction_id)
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

void SGT_HotPvpVideo::cleanup()
{
	_transaction_id = 0;
	_transaction_data.clear();

	_data.cleanup();
}

void SGT_HotPvpVideo::OnTimer(int tick, int now)
{
	if(tick%(SERVER_CONST_TICK_PER_SECOND*10) == 0)
	{
		char msg[100];
		snprintf(msg, sizeof(msg), "10221:"); //HotPvpVideoHeartBeat
		MessageManager::GetInstance().Put(0, 0, msg, 0);
	}
}

}

