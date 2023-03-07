#include "GlobalMessage.h"

namespace CACHE
{

SGT_GlobalMessage::SGT_GlobalMessage(): Singleton("SGT_GlobalMessage"), _index(0), _index2(0)
{
	_in_transaction = false;
	_transaction_id = 0;

	SingletonManager::GetInstance().Register(13, this);
}

void SGT_GlobalMessage::BeginTransaction()
{
	if(_in_transaction) return;
	_in_transaction = true;

	_transaction_id = 0;
	_transaction_data.clear();

	_index2 = _index;
}

void SGT_GlobalMessage::CommitTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;

	_index = _index2;
}

void SGT_GlobalMessage::CancelTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;

	restore(g_transaction_id);
}

void SGT_GlobalMessage::backup(const char *name, int64_t transaction_id)
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

void SGT_GlobalMessage::restore(int64_t transaction_id)
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

void SGT_GlobalMessage::cleanup()
{
	_transaction_id = 0;
	_transaction_data.clear();

	_data.cleanup();
}

void SGT_GlobalMessage::_Put(int type, const char *msg, int checksum)
{
	//assert(lock);

	if(strlen(msg) >= SERVER_CONST_GLOBAL_MESSAGE_LENGTH_MAX)
	{
		//log err
		return;
	}

	unsigned int i = _index2%SERVER_CONST_GLOBAL_MESSAGE_COUNT;
	_node_t *nd = &_msgs[i];
	nd->_put_time = Now();
	nd->_type = type;
	strcpy(nd->_msg, msg);
	nd->_checksum = checksum;
	_index2++;
}

void SGT_GlobalMessage::_Put_NOLOCK(int type, const char *msg, int checksum)
{
	Thread::Mutex2::Scoped keeper(_lock);

	if(strlen(msg) >= SERVER_CONST_GLOBAL_MESSAGE_LENGTH_MAX)
	{
		//log err
		return;
	}

	unsigned int i = _index%SERVER_CONST_GLOBAL_MESSAGE_COUNT;
	_node_t *nd = &_msgs[i];
	nd->_put_time = Now();
	nd->_type = type;
	strcpy(nd->_msg, msg);
	nd->_checksum = checksum;

	_index++;
}

GlobalMessageGetResult* SGT_GlobalMessage::Get_NOLOCK(int login_time, int prev_index)
{
	//FIXME: 不用考虑index回绕，概率太小，如果真出现了就换int64_t
	if(prev_index>=_index) return 0;

	if(_index>prev_index+10) prev_index=_index-10;

	GlobalMessageGetResult *ret = new GlobalMessageGetResult();
	ret->_index = _index;
	for(int i=prev_index; i<_index; i++)
	{
		_node_t *nd = &_msgs[i%SERVER_CONST_GLOBAL_MESSAGE_COUNT];
		if(login_time>nd->_put_time) continue;
		if(nd->_type == 0)
		{
			Serialized m;
			m._str = nd->_msg;
			m._checksum = nd->_checksum;
			ret->_msgs.PushBack(m);
		}
		else if(nd->_type == 1)
		{
			Serialized m;
			m._str = nd->_msg;
			m._checksum = nd->_checksum;
			ret->_cmds.PushBack(m);
		}
	}
	if(ret->_msgs.Size()==0 && ret->_cmds.Size()==0)
	{
		delete ret;
		return 0;
	}
	return ret;
}

}

