#ifndef _MAFIA_INFO_H_
#define _MAFIA_INFO_H_

#include "singletonmanager.h"
#include "structs.h"

using namespace GNET;

namespace CACHE
{

class SGT_Mafia_Info: public Singleton, TransactionBase
{
	bool _in_transaction;
	int _transaction_id;
	std::map<std::string, Octets> _transaction_data;

public:
	Mafia_InfoData _data;

private:
	SGT_Mafia_Info();

public:
	static SGT_Mafia_Info& GetInstance()
	{
		static SGT_Mafia_Info _instance;
		return _instance;
	}

	virtual const char* GetName() const { return "Mafia_Info"; }
	virtual int GetID() const { return 7; }
	virtual const char* GetLockName() const { return "mafia_info"; }

	virtual void BeginTransaction();
	virtual void CommitTransaction();
	virtual void CancelTransaction();

	void backup(const char *name, int transaction_id);
	void restore(int transaction_id);
	void cleanup();
};

}

inline CACHE::SGT_Mafia_Info* API_GetLuaMafia_Info(void *r) { return (CACHE::SGT_Mafia_Info*)r; }
inline CACHE::SGT_Mafia_Info* API_GetLuaMafia_Info() { return (InBigLock() ? &CACHE::SGT_Mafia_Info::GetInstance() : 0); }

#endif //_MAFIA_INFO_H_

