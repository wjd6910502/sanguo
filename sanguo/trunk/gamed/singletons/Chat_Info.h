#ifndef _CHAT_INFO_H_
#define _CHAT_INFO_H_

#include "singletonmanager.h"
#include "structs.h"

using namespace GNET;

namespace CACHE
{

class SGT_Chat_Info: public Singleton, public TransactionBase
{
	bool _in_transaction;
	int64_t _transaction_id;
	std::map<std::string, Octets> _transaction_data;

public:
	Chat_InfoData _data;

private:
	SGT_Chat_Info();

public:
	static SGT_Chat_Info& GetInstance()
	{
		static SGT_Chat_Info _instance;
		return _instance;
	}

	virtual const char* GetName() const { return "Chat_Info"; }
	virtual int GetID() const { return 11; }
	virtual const char* GetLockName() const { return "chat_info"; }

	virtual void BeginTransaction();
	virtual void CommitTransaction();
	virtual void CancelTransaction();

	void backup(const char *name, int64_t transaction_id);
	void restore(int64_t transaction_id);
	void cleanup();
};

}

inline CACHE::SGT_Chat_Info* API_GetLuaChat_Info(void *r) { return (CACHE::SGT_Chat_Info*)r; }
inline CACHE::SGT_Chat_Info* API_GetLuaChat_Info() { return (InBigLock() ? &CACHE::SGT_Chat_Info::GetInstance() : 0); }

#endif //_CHAT_INFO_H_

