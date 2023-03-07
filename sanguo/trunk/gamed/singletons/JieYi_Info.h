#ifndef _JIEYI_INFO_H_
#define _JIEYI_INFO_H_

#include "singletonmanager.h"
#include "structs.h"

using namespace GNET;

namespace CACHE
{

class SGT_JieYi_Info: public Singleton, public TransactionBase
{
	bool _in_transaction;
	int64_t _transaction_id;
	std::map<std::string, Octets> _transaction_data;

public:
	JieYi_InfoData _data;

private:
	SGT_JieYi_Info();

public:
	static SGT_JieYi_Info& GetInstance()
	{
		static SGT_JieYi_Info _instance;
		return _instance;
	}

	virtual const char* GetName() const { return "JieYi_Info"; }
	virtual int GetID() const { return 8; }
	virtual const char* GetLockName() const { return "jieyi_info"; }

	virtual void BeginTransaction();
	virtual void CommitTransaction();
	virtual void CancelTransaction();

	void backup(const char *name, int64_t transaction_id);
	void restore(int64_t transaction_id);
	void cleanup();
	//for DB
	void Load(Octets &key, Octets &value);
	void Save();
};

}

inline CACHE::SGT_JieYi_Info* API_GetLuaJieYi_Info(void *r) { return (CACHE::SGT_JieYi_Info*)r; }
inline CACHE::SGT_JieYi_Info* API_GetLuaJieYi_Info() { return (InBigLock() ? &CACHE::SGT_JieYi_Info::GetInstance() : 0); }

#endif //_JIEYI_INFO_H_

