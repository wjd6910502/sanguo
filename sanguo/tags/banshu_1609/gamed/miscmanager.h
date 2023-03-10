#ifndef _MIST_MANAGER_H_
#define _MIST_MANAGER_H_

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
//这个里面的东西都是全局的
class MiscManager: public TransactionBase
{
private:
	bool _in_transaction;
	int _transaction_id;
	std::map<std::string, GNET::Octets> _transaction_data;
public:
	mutable Thread::Mutex _lock;
	MiscData _miscdata;

	MiscManager()
	{
	}

	static MiscManager* GetInstance()
	{
		static MiscManager _instance;
		return &_instance;
	}
	virtual void BeginTransaction();
	virtual void CommitTransaction();
	virtual void CancelTransaction();
	void OnTimer(int tick, int now);

	void SendMessage(const std::string& msg, int delay);

	//for DB 
	void Load(Octets &key, Octets &value);
	void Save();

	void backup(const char *name, int transaction_id);
	void restore(int transaction_id);
	void cleanup();
};
}

inline CACHE::MiscManager * API_GetLuaMiscManager(void *r) { return (CACHE::MiscManager*)r; }
inline CACHE::MiscManager * API_GetLuaMiscManager() { return CACHE::MiscManager::GetInstance(); } //TODO: big检查

#endif //_MIST_MANAGER_H_ 
