#ifndef _PACKAGE_MANAGER_H_
#define _PACKAGE_MANAGER_H_

#include <string> 
#include <map>
#include <list>
#include <set>
	  
#include "octets.h"
#include "forlua.h"
#include "itimer.h"
#include "thread.h"
#include "mutex.h"
#include "role.h"
#include "commonmacro.h"
#include "glog.h"
#include "structs.h"
#include "transaction.h"


using namespace GNET;

namespace CACHE
{

class PackagManager: public TransactionBase
{
private:
	CompensateMap compensate_map;
public:
	mutable Thread::Mutex2 _lock; //TODO:
	static PackagManager GetInstance()
	{
		static PackagManager _instance;
		return _instance;
	}

	virtual void BeginTransaction();
	virtual void CommitTransaction();
	virtual void CancelTransaction();

	void OnChanged();
	int Tag() const;
	std::map<int, Compensate>::iterator End();

	int Size() const;
	Compensate* Find(const int& k);
	void Insert(const int& k, const Compensate& v);
	CompensateMapIter SeekToBegin();
	CompensateMapIter Seek(const int& k);
	void Clear();
	void Delete(int type);

	void Load(Octets &value);
	void Save();


	//用来清理一些已经过期失效的礼包
	void Update();
};

};

#endif //_PACKAGE_MANAGER_H_
