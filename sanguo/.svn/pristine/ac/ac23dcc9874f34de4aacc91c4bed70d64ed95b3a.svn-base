#ifndef _YUEZHAN_INFO_H_
#define _YUEZHAN_INFO_H_

#include "singletonmanager.h"
#include "structs.h"

using namespace GNET;

namespace CACHE
{

class SGT_YueZhan_Info: public Singleton, public TransactionBase
{
	bool _in_transaction;
	int64_t _transaction_id;
	std::map<std::string, Octets> _transaction_data;

public:
	YueZhan_InfoData _data;

private:
	SGT_YueZhan_Info();

public:
	static SGT_YueZhan_Info& GetInstance()
	{
		static SGT_YueZhan_Info _instance;
		return _instance;
	}

	virtual const char* GetName() const { return "YueZhan_Info"; }
	virtual int GetID() const { return 9; }
	virtual const char* GetLockName() const { return "yuezhan_info"; }

	virtual void BeginTransaction();
	virtual void CommitTransaction();
	virtual void CancelTransaction();

	void backup(const char *name, int64_t transaction_id);
	void restore(int64_t transaction_id);
	void cleanup();

	bool GetRoomInfo(int room_id, YueZhanData *&info);
};

}

inline CACHE::SGT_YueZhan_Info* API_GetLuaYueZhan_Info(void *r) { return (CACHE::SGT_YueZhan_Info*)r; }
inline CACHE::SGT_YueZhan_Info* API_GetLuaYueZhan_Info() { return (InBigLock() ? &CACHE::SGT_YueZhan_Info::GetInstance() : 0); }

#endif //_YUEZHAN_INFO_H_

