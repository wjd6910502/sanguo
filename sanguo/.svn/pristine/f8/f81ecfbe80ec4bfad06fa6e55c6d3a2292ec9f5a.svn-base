#ifndef _SINGLETON_MANAGER_H_
#define _SINGLETON_MANAGER_H_

#include "thread.h"
#include "script_wrapper.h"
#include "commonmacro.h"
#include "transaction.h"

using namespace GNET;

namespace CACHE
{

class Singleton
{
public:
	mutable Thread::Mutex2 _lock;

	Singleton(const char *name): _lock(name) {}
	virtual ~Singleton() {}

	virtual const char* GetName() const = 0;
	virtual int GetID() const = 0;
	virtual const char* GetLockName() const = 0;
};

class SingletonManager
{
	std::map<int,Singleton*> _map; //id=>singleton

	SingletonManager() {}

public:
	static SingletonManager& GetInstance()
	{
		static SingletonManager _instance;
		return _instance;
	}

	void Register(int id, Singleton* sgt);

	void Add2CommandParameter(int cmd, LuaParameter& param);
	void Add2CommandLock(int cmd, std::list<MyScoped>& keeper_list);
	void Add2CommandTransaction(int cmd, std::list<TransactionKeeper>& keeper_list);

	void Add2MessageParameter(int msg, LuaParameter& param);
	void Add2MessageLock(int msg, std::list<MyScoped>& keeper_list);
	void Add2MessageTransaction(int msg, std::list<TransactionKeeper>& keeper_list);
};

}

#endif //_SINGLETON_MANAGER_H_

