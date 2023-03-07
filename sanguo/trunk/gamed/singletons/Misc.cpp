#include "Misc.h"
#include "commonmacro.h"
#include "message.h"

extern std::map<Octets, Octets> g_save_data_map;

namespace CACHE
{

SGT_Misc::SGT_Misc(): Singleton("SGT_Misc")
{
	_in_transaction = false;
	_transaction_id = 0;

	SingletonManager::GetInstance().Register(2, this);
}

void SGT_Misc::BeginTransaction()
{
	if(_in_transaction) return;
	_in_transaction = true;

	_transaction_id = 0;
	_transaction_data.clear();
}

void SGT_Misc::CommitTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;
}

void SGT_Misc::CancelTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;

	restore(g_transaction_id);
}

void SGT_Misc::backup(const char *name, int64_t transaction_id)
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

void SGT_Misc::restore(int64_t transaction_id)
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

void SGT_Misc::cleanup()
{
	_transaction_id = 0;
	_transaction_data.clear();

	_miscdata.cleanup();
}

void SGT_Misc::OnTimer(int tick, int now)
{
	if(tick%(SERVER_CONST_TICK_PER_SECOND*10) == 0)
	{
		char msg[100];
		snprintf(msg, sizeof(msg), "10028:");
		MessageManager::GetInstance().Put(0, 0, msg, 0);
	}
}

void SGT_Misc::SendMessage(const std::string& msg, int delay)
{
	MessageManager::GetInstance().Put(0, 0, msg.c_str(), delay);
}

void SGT_Misc::Load(Octets &key, Octets &value)
{
	std::string str_key  = std::string((char*)key.begin(),key.size());

	Thread::Mutex2::Scoped keeper(_lock);

	Marshal::OctetsStream os(value);
	int db_version = 0;
	os >> db_version;
	os._dbversion = db_version;

	_miscdata.unmarshal(os);
}

void SGT_Misc::Save()
{
	GNET::Marshal::OctetsStream value;
	std::string key_str = "miscmanager_";

	int db_version = DB_VERSION;
	value << db_version;
	_miscdata.marshal(value);
	g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;
}

void SGT_Misc::Insert_ForbidLogin(Int64 roleid, int time, std::string desc, std::string notifytouser)
{
	Thread::Mutex2::Scoped keeper(_lock);

	ForbidRoleInfo* forbidinfo = _miscdata._forbidlogin_role_map.Find(roleid);
	if(forbidinfo)
	{
		forbidinfo->_begintime = Now();
		forbidinfo->_time = time;
		forbidinfo->_desc = desc;
		forbidinfo->_notifytouser = notifytouser;
	}
	else
	{
		ForbidRoleInfo info;
		info._roleid = roleid;
		info._begintime = Now();
		info._time = time;
		info._desc = desc;
		info._notifytouser = notifytouser;

		_miscdata._forbidlogin_role_map.Insert(roleid, info);
	}
}

void SGT_Misc::Insert_ForbidTalk(Int64 roleid, int time, std::string desc, std::string notifytouser)
{
	Thread::Mutex2::Scoped keeper(_lock);

	ForbidRoleInfo* forbidinfo = _miscdata._forbidtalk_role_map.Find(roleid);
	if(forbidinfo)
	{
		forbidinfo->_begintime = Now();
		forbidinfo->_time = time;
		forbidinfo->_desc = desc;
		forbidinfo->_notifytouser = notifytouser;
	}
	else
	{
		ForbidRoleInfo info;
		info._roleid = roleid;
		info._begintime = Now();
		info._time = time;
		info._desc = desc;
		info._notifytouser = notifytouser;

		_miscdata._forbidtalk_role_map.Insert(roleid, info);
	}
}

bool SGT_Misc::Delete_ForbidLogin(Int64 roleid)
{
	Thread::Mutex2::Scoped keeper(_lock);

	ForbidRoleInfo* forbidinfo = _miscdata._forbidlogin_role_map.Find(roleid);
	if(forbidinfo)
		_miscdata._forbidlogin_role_map.Delete(roleid);
	else
		return false;
	
	return true;
}

bool SGT_Misc::Delete_ForbidTalk(Int64 roleid)
{
	Thread::Mutex2::Scoped keeper(_lock);

	ForbidRoleInfo* forbidinfo = _miscdata._forbidtalk_role_map.Find(roleid);
	if(forbidinfo)
		_miscdata._forbidtalk_role_map.Delete(roleid);
	else
		return false;
	
	return true;
}

bool SGT_Misc::Find_ForbidLogin(Int64 roleid, ForbidRoleInfo &forbidinfo)
{
	Thread::Mutex2::Scoped keeper(_lock);

	ForbidRoleInfo* info = _miscdata._forbidlogin_role_map.Find(roleid);
	if(info)
		forbidinfo = *info;
	else
		return false;
	
	return true;
}

bool SGT_Misc::Find_ForbidTalk(Int64 roleid, ForbidRoleInfo &forbidinfo)
{
	Thread::Mutex2::Scoped keeper(_lock);

	ForbidRoleInfo* info = _miscdata._forbidtalk_role_map.Find(roleid);
	if(info)
		forbidinfo = *info;
	else
		return false;
	
	return true;
}

}

