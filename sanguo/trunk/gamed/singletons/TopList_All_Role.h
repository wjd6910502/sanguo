#ifndef _TOPLIST_ALL_ROLE_H_
#define _TOPLIST_ALL_ROLE_H_

#include "singletonmanager.h"
#include "structs.h"

using namespace GNET;
#define TOPLIST_ALL_ROLE_MASHU		1
#define TOPLIST_ALL_ROLE_TOWER      2
#define TOPLIST_ALL_ROLE_TOWER_BIG  3

namespace CACHE
{

class SGT_TopList_All_Role: public Singleton, public TransactionBase
{
	bool _in_transaction;
	int64_t _transaction_id;
	std::map<std::string, Octets> _transaction_data;

public:
	TopList_All_RoleData _data;

private:
	SGT_TopList_All_Role();

public:
	static SGT_TopList_All_Role& GetInstance()
	{
		static SGT_TopList_All_Role _instance;
		return _instance;
	}

	virtual const char* GetName() const { return "TopList_All_Role"; }
	virtual int GetID() const { return 6; }
	virtual const char* GetLockName() const { return "toplist_all_role"; }

	virtual void BeginTransaction();
	virtual void CommitTransaction();
	virtual void CancelTransaction();

	void backup(const char *name, int64_t transaction_id);
	void restore(int64_t transaction_id);
	void cleanup();
	void OnTimer(int tick, int now);
	//for DB
	void Load(Octets &key, Octets &value);
	void Save();
};

}

inline CACHE::SGT_TopList_All_Role* API_GetLuaTopList_All_Role(void *r) { return (CACHE::SGT_TopList_All_Role*)r; }
inline CACHE::SGT_TopList_All_Role* API_GetLuaTopList_All_Role() { return (InBigLock() ? &CACHE::SGT_TopList_All_Role::GetInstance() : 0); }

#endif //_TOPLIST_ALL_ROLE_H_

