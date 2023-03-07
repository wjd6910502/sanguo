#include "RoleNameCache.h"

namespace CACHE
{

SGT_RoleNameCache::SGT_RoleNameCache(): Singleton("SGT_RoleNameCache")
{
	_in_transaction = false;
	_transaction_id = 0;

	SingletonManager::GetInstance().Register(12, this);
}

void SGT_RoleNameCache::BeginTransaction()
{
	if(_in_transaction) return;
	_in_transaction = true;

	_transaction_id = 0;
	_transaction_data.clear();
}

void SGT_RoleNameCache::CommitTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;
}

void SGT_RoleNameCache::CancelTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;

	restore(g_transaction_id);
}

void SGT_RoleNameCache::backup(const char *name, int64_t transaction_id)
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

void SGT_RoleNameCache::restore(int64_t transaction_id)
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

void SGT_RoleNameCache::cleanup()
{
	_transaction_id = 0;
	_transaction_data.clear();

	_data.cleanup();
}

void SGT_RoleNameCache::Insert(const RoleBrief& brief)
{
	std::vector<std::string> nameword;
	std::string strchar;
	std::string name = brief._name;
	int size;

	size = name.size();
	//对utf-8编码的处理
	for(int i = 0; i < size; )
	{
		char chr = name[i];
		if((chr & 0x80)==0)
		{
			strchar = name.substr(i, 1);
			nameword.push_back(strchar);
			++i;
		}
		else if((chr & 0xF8)==0xF8)
		{
			strchar = name.substr(i, 5);
			nameword.push_back(strchar);
			i+=5;
		}
		else if((chr & 0xF0)==0xF0)
		{
			strchar = name.substr(i, 4);
			nameword.push_back(strchar);
			i+=4;
		}
		else if((chr & 0xE0)==0xE0)
		{
			strchar = name.substr(i, 3);
			nameword.push_back(strchar);
			i+=3;
		}
		else if((chr & 0xC0)==0xC0)
		{
			strchar = name.substr(i, 2);
			nameword.push_back(strchar);
			i+=2;
		}
	}

	size = nameword.size();
	RoleBriefInfo role;
	role._brief = brief;
	role._size = size;
	std::vector<std::string> patterns;
	for(int i = 1; i <= size; i++)
	{
		for(int j = 0; j <= size-i; j++)
		{
			std::string pattern;
			for(int k = 0; k < i; k++)
			{
				pattern += nameword[k+j];
			}

			int have_flag = 0;
			for(unsigned int k = 0; k < patterns.size(); k++)
			{
				if(patterns[k] == pattern)
				{
					have_flag = 1;
					break;
				}
			}
			if(have_flag == 1)
			{
				continue;
			}
			else
			{
				patterns.push_back(pattern);
			}

			it = _map_pattern_to_roles.find(pattern);
			if(it == _map_pattern_to_roles.end())
			{
				std::list<RoleBriefInfo> roles;
				roles.push_back(role);
				_map_pattern_to_roles.insert(std::pair<std::string, std::list<RoleBriefInfo> >(pattern, roles));
			}
			else
			{
				int insert_flag = 1;
				std::list<RoleBriefInfo>::iterator roles_it;
				for(roles_it = it->second.begin(); roles_it != it->second.end(); roles_it++)
				{
					if(roles_it->_size > size)
					{
						it->second.insert(roles_it, role);
						insert_flag = 0;
						break;
					}
				}
				if(insert_flag == 1 && it->second.size() < 5)
				{
					it->second.push_back(role);
				}
				else
				{
					if(it->second.size()>5)
					{
						it->second.pop_back();
					}
				}
			}
		}
	}

	//对玩家id，去除zoneid，存入map
	unsigned int tmp_id = (unsigned int)brief._id;
	char buf[32];
	snprintf(buf, sizeof(buf), "%u", tmp_id);
	std::string id = buf;

	role._size = 0;

	it = _map_pattern_to_roles.find(id);
	if(it == _map_pattern_to_roles.end())
	{
		std::list<RoleBriefInfo> roles;
		roles.push_back(role);
		_map_pattern_to_roles.insert(std::pair<std::string, std::list<RoleBriefInfo> >(id, roles));
	}
	else
	{
		it->second.push_front(role);
		if(it->second.size()>5)
		{
			it->second.pop_back();
		}
	}
}

void SGT_RoleNameCache::Update(const RoleBrief& brief)
{
	std::vector<std::string> nameword;
	std::string strchar;
	std::string name = brief._name;
	int size;

	size = name.size();
	//对utf-8编码的处理
	for(int i = 0; i < size; )
	{
		char chr = name[i];
		if((chr & 0x80)==0)
		{
			strchar = name.substr(i, 1);
			nameword.push_back(strchar);
			++i;
		}
		else if((chr & 0xF8)==0xF8)
		{
			strchar = name.substr(i, 5);
			nameword.push_back(strchar);
			i+=5;
		}
		else if((chr & 0xF0)==0xF0)
		{
			strchar = name.substr(i, 4);
			nameword.push_back(strchar);
			i+=4;
		}
		else if((chr & 0xE0)==0xE0)
		{
			strchar = name.substr(i, 3);
			nameword.push_back(strchar);
			i+=3;
		}
		else if((chr & 0xC0)==0xC0)
		{
			strchar = name.substr(i, 2);
			nameword.push_back(strchar);
			i+=2;
		}
	}

	size = nameword.size();
	RoleBriefInfo role;
	role._brief = brief;
	role._size = size;
	std::vector<std::string> patterns;
	for(int i = 1; i <= size; i++)
	{
		for(int j = 0; j <= size-i; j++)
		{
			std::string pattern;
			for(int k = 0; k < i; k++)
			{
				pattern += nameword[k+j];
			}

			int have_flag = 0;
			for(unsigned int k = 0; k < patterns.size(); k++)
			{
				if(patterns[k] == pattern)
				{
					have_flag = 1;
					break;
				}
			}
			if(have_flag == 1)
			{
				continue;
			}
			else
			{
				patterns.push_back(pattern);
			}

			it = _map_pattern_to_roles.find(pattern);
			std::list<RoleBriefInfo>::iterator roles_it;
			for(roles_it = it->second.begin(); roles_it != it->second.end(); roles_it++)
			{
				if(roles_it->_brief._id == brief._id)
				{
					roles_it->_brief = brief;
					break;
				}
			}
		}
	}

	//对玩家id，去除zoneid，存入map
	unsigned int tmp_id = (unsigned int)brief._id;
	char buf[32];
	snprintf(buf, sizeof(buf), "%u", tmp_id);
	std::string id = buf;

	role._size = 0;

	it = _map_pattern_to_roles.find(id);
	it->second.front()._brief = brief;
}

RoleNameQueryResults* SGT_RoleNameCache::Query(const std::string& pattern)
{
	//TODO: 
	RoleNameQueryResults *rets = new RoleNameQueryResults();

	it = _map_pattern_to_roles.find(pattern);
	if(it != _map_pattern_to_roles.end())
	{
		std::list<RoleBriefInfo>::iterator roles_it;
		for(roles_it = it->second.begin(); roles_it != it->second.end(); roles_it++)
		{
			rets->PushBack(roles_it->_brief);
		}
	}

	return rets;
}

RoleNameQueryResults* SGT_RoleNameCache::Query_NoLock(const std::string& pattern)
{
	Thread::Mutex2::Scoped keeper(_lock);

	RoleNameQueryResults *rets = new RoleNameQueryResults();

	it = _map_pattern_to_roles.find(pattern);
	if(it != _map_pattern_to_roles.end())
	{
		std::list<RoleBriefInfo>::iterator roles_it;
		for(roles_it = it->second.begin(); roles_it != it->second.end(); roles_it++)
		{
			rets->PushBack(roles_it->_brief);
		}
	}

	return rets;
}

}

