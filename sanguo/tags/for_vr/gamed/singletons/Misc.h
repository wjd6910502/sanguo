#ifndef _MISC_H_
#define _MISC_H_

#include "singletonmanager.h"
#include "structs.h"

using namespace GNET;

namespace CACHE
{

class SGT_Misc: public Singleton, public TransactionBase
{
	bool _in_transaction;
	int _transaction_id;
	std::map<std::string, Octets> _transaction_data;

public:
	MiscData _miscdata;

private:
	SGT_Misc();

public:
	static SGT_Misc& GetInstance()
	{
		static SGT_Misc _instance;
		return _instance;
	}

	virtual const char* GetName() const { return "Misc"; }
	virtual int GetID() const { return 2; }
	virtual const char* GetLockName() const { return "misc"; }

	virtual void BeginTransaction();
	virtual void CommitTransaction();
	virtual void CancelTransaction();

	void backup(const char *name, int transaction_id);
	void restore(int transaction_id);
	void cleanup();

	//手动增加的代码
	void OnTimer(int tick, int now);
	void SendMessage(const std::string& msg, int delay); //FIXME: will delete
	//for DB 
	void Load(Octets &key, Octets &value);
	void Save();
};

}

inline CACHE::SGT_Misc* API_GetLuaMisc(void *r) { return (CACHE::SGT_Misc*)r; }
inline CACHE::SGT_Misc* API_GetLuaMisc() { return (InBigLock() ? &CACHE::SGT_Misc::GetInstance() : 0); }

#endif //_MISC_H_

