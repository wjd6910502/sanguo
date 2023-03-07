#include "transaction.h"
#include "GlobalMessage.h"

using namespace GNET;
using namespace CACHE;

APISet::APISet()
{
	_in_transaction = false;
}

void APISet::BeginTransaction()
{
	if(_in_transaction) return;
	_in_transaction = true;

	_transaction_to_all_role_messages.clear();
	_transaction_to_all_role_commands.clear();
}

void APISet::CommitTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;

	for(auto it=_transaction_to_all_role_messages.begin(); it!=_transaction_to_all_role_messages.end(); ++it)
	{
		SGT_GlobalMessage::GetInstance().Put_NOLOCK(it->_str.c_str(), it->_checksum);
	}
	_transaction_to_all_role_messages.clear();

	for(auto it=_transaction_to_all_role_commands.begin(); it!=_transaction_to_all_role_commands.end(); ++it)
	{
		SGT_GlobalMessage::GetInstance().PutCmd_NOLOCK(it->_str.c_str(), it->_checksum);
	}
	_transaction_to_all_role_commands.clear();
}

void APISet::CancelTransaction()
{
	if(!_in_transaction) return;
	_in_transaction = false;

	_transaction_to_all_role_messages.clear();
	_transaction_to_all_role_commands.clear();
}

void APISet::SendMessage(const CACHE::Int64& target, const std::string& v, int delay, const CACHE::Int64List& extra_roles,
	                 const CACHE::Int64List& extra_mafias, const CACHE::IntList& extra_pvps)
{
	//TODO:
}

void APISet::_SendMessageToAllRole(const std::string& v, int delay, const CACHE::Int64List& extra_roles, const CACHE::Int64List& extra_mafias,
	                           const CACHE::IntList& extra_pvps)
{
	//TODO:
}

void APISet::SendMessageToAllRole(const std::string& v, const int checksum)
{
	if(_in_transaction)
	{
		Serialized m;
		m._str = v;
		m._checksum = checksum;
		_transaction_to_all_role_messages.push_back(m);
		return;
	}
	SGT_GlobalMessage::GetInstance().Put_NOLOCK(v.c_str(), checksum);
}

void APISet::SendCommandToAllRole(const std::string& v, const int checksum)
{
	if(_in_transaction)
	{
		Serialized c;
		c._str = v;
		c._checksum = checksum;
		_transaction_to_all_role_commands.push_back(c);
		return;
	}
	SGT_GlobalMessage::GetInstance().PutCmd_NOLOCK(v.c_str(), checksum);
}

