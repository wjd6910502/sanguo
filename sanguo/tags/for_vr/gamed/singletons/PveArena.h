#ifndef _PVEARENA_H_
#define _PVEARENA_H_

#include "singletonmanager.h"
#include "structs.h"

using namespace GNET;

namespace CACHE
{

class SGT_PveArena: public Singleton, TransactionBase
{
	bool _in_transaction;
	int _transaction_id;
	std::map<std::string, Octets> _transaction_data;

public:
	PveArenaDataMapData _data;

private:
	SGT_PveArena();

public:
	static SGT_PveArena& GetInstance()
	{
		static SGT_PveArena _instance;
		return _instance;
	}

	virtual const char* GetName() const { return "PveArena"; }
	virtual int GetID() const { return 3; }
	virtual const char* GetLockName() const { return "pvearena"; }

	virtual void BeginTransaction();
	virtual void CommitTransaction();
	virtual void CancelTransaction();

	void backup(const char *name, int transaction_id);
	void restore(int transaction_id);
	void cleanup();
	void Load(Octets &key, Octets &value);
	void Save();
	void OnTimer(int tick, int now);
};

}

inline CACHE::SGT_PveArena* API_GetLuaPveArena(void *r) { return (CACHE::SGT_PveArena*)r; }
inline CACHE::SGT_PveArena* API_GetLuaPveArena() { return (InBigLock() ? &CACHE::SGT_PveArena::GetInstance() : 0); }

#endif //_PVEARENA_H_

