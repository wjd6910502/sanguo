#ifndef _HOTPVPVIDEO_H_
#define _HOTPVPVIDEO_H_

#include "singletonmanager.h"
#include "structs.h"

using namespace GNET;

namespace CACHE
{

class SGT_HotPvpVideo: public Singleton, public TransactionBase
{
	bool _in_transaction;
	int64_t _transaction_id;
	std::map<std::string, Octets> _transaction_data;

public:
	HotPvpVideoData _data;

private:
	SGT_HotPvpVideo();

public:
	static SGT_HotPvpVideo& GetInstance()
	{
		static SGT_HotPvpVideo _instance;
		return _instance;
	}

	virtual const char* GetName() const { return "HotPvpVideo"; }
	virtual int GetID() const { return 14; }
	virtual const char* GetLockName() const { return "hot_pvp_video"; }

	virtual void BeginTransaction();
	virtual void CommitTransaction();
	virtual void CancelTransaction();

	void backup(const char *name, int64_t transaction_id);
	void restore(int64_t transaction_id);
	void cleanup();

	//手动增加的代码
	void OnTimer(int tick, int now);
};

}

inline CACHE::SGT_HotPvpVideo* API_GetLuaHotPvpVideo(void *r) { return (CACHE::SGT_HotPvpVideo*)r; }
inline CACHE::SGT_HotPvpVideo* API_GetLuaHotPvpVideo() { return (InBigLock() ? &CACHE::SGT_HotPvpVideo::GetInstance() : 0); }

#endif //_HOTPVPVIDEO_H_

