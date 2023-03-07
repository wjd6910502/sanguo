#ifndef _TRANSACTION_H_
#define _TRANSACTION_H_

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

#endif //_TRANSACTION_H_

