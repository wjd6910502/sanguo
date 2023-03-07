#ifndef _TRANSACTION_H_
#define _TRANSACTION_H_

#include <list>
#include <string>
#include "structs.h"

class TransactionBase
{
public:
	virtual ~TransactionBase() {}
	virtual void BeginTransaction() = 0;
	virtual void CommitTransaction() = 0;
	virtual void CancelTransaction() = 0;
};

class TransactionKeeper
{
	TransactionBase *_obj;
	bool _canceled;

public:
	explicit TransactionKeeper(TransactionBase *obj): _obj(obj), _canceled(false)
	{
		_obj->BeginTransaction();
	}
	TransactionKeeper(const TransactionKeeper& rhs)
	{
		if(this == &rhs) return;
		this->_obj = rhs._obj;
		this->_canceled = rhs._canceled;
		((TransactionKeeper&)rhs)._obj = 0; //FIXME:
	}
	~TransactionKeeper()
	{
		if(!_obj) return;
		if(!_canceled)
		{
			_obj->CommitTransaction();
		}
		else
		{
			_obj->CancelTransaction();
		}
	}

	TransactionKeeper& operator= (const TransactionKeeper& rhs)
	{
		if(this == &rhs) return *this;
		this->_obj = rhs._obj;
		this->_canceled = rhs._canceled;
		((TransactionKeeper&)rhs)._obj = 0; //FIXME:
		return *this;
	}

	void SetCancel() { _canceled=true; }
};

class TransactionFunctionBase
{
public:
	virtual ~TransactionFunctionBase() {}
	virtual void OnCancel() = 0;
	virtual void OnCommit() = 0;
};

class APISet: public TransactionBase
{
	bool _in_transaction;

	std::list<CACHE::Serialized> _transaction_to_all_role_messages;
	std::list<CACHE::Serialized> _transaction_to_all_role_commands;

public:
	APISet();
	virtual ~APISet() {}
	virtual void BeginTransaction();
	virtual void CommitTransaction();
	virtual void CancelTransaction();

	void SendMessage(const CACHE::Int64& target, const std::string& v, int delay, const CACHE::Int64List& extra_roles,
	                 const CACHE::Int64List& extra_mafias, const CACHE::IntList& extra_pvps);
	void _SendMessageToAllRole(const std::string& v, int delay, const CACHE::Int64List& extra_roles, const CACHE::Int64List& extra_mafias,
	                           const CACHE::IntList& extra_pvps);
	void SendMessageToAllRole(const std::string& v, const int checksum);
	void SendCommandToAllRole(const std::string& v, const int checksum);
};

inline APISet* API_GetLuaAPISet(void *p) { return (APISet*)p; }

#endif //_TRANSACTION_H_

