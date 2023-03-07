#ifndef _TOPLIST_H_
#define _TOPLIST_H_

#include "singletonmanager.h"
#include "structs.h"

using namespace GNET;

namespace CACHE
{

#define TOPLIST_TYPE_LEVEL 	1  //等级榜
#define TOPLIST_TYPE_CAPACITY	2  //战力榜
#define TOPLIST_TYPE_RANKING	3  //pvp积分
#define TOPLIST_TYPE_PVE_ARENA	4  //竞技场排行榜
#define TOPLIST_TYPE_WEAPON	5  //玩家的武器排行榜
#define TOPLIST_TYPE_HERO	6  //玩家的武将排行榜
#define TOPLIST_TYPE_MASHU	7  //玩家的马术大赛积分榜
#define TOPLIST_TYPE_MAFIA_MASHU	8  //帮会的马术大赛积分榜
#define TOPLIST_TYPE_FLOWERGIFT 9 //送花排行榜
#define TOPLIST_TYPE_TOWER 10 //爬塔排行榜
#define TOPLIST_TYPE_TOWER_BIG 11 //爬塔排行榜大于40级的
#define TOPLIST_TYPE_DATI 12 //答题排行榜
	
#define TOPLIST_TIME_NOW 	1  //实时榜
#define TOPLIST_TIME_HISTORY 	2  //历史榜


#define TOPLIST_ITEM_TYPE_WEAPON	1	//排行榜上的武器类型
#define TOPLIST_ITEM_TYPE_HERO		2	//排行榜上的武将类型


//注意排行榜从1000开始就是自动生成的排行榜了
#define TOPLIST_AUTO_CREATE		1001
class SGT_TopList: public Singleton, public TransactionBase
{
	bool _in_transaction;
	int64_t _transaction_id;
	std::map<std::string, Octets> _transaction_data;

public:
	//TopListData _data;
	TopManagerData _data;

private:
	SGT_TopList();

public:
	static SGT_TopList& GetInstance()
	{
		static SGT_TopList _instance;
		return _instance;
	}

	virtual const char* GetName() const { return "TopList"; }
	virtual int GetID() const { return 1; }
	virtual const char* GetLockName() const { return "toplist"; }

	virtual void BeginTransaction();
	virtual void CommitTransaction();
	virtual void CancelTransaction();

	void backup(const char *name, int64_t transaction_id);
	void restore(int64_t transaction_id);
	void cleanup();

	//手动增加的代码
	void OnTimer(int tick, int now);
	//for DB
	void Load(Octets &key, Octets &value);
	void Save();
};

}

inline CACHE::SGT_TopList* API_GetLuaTopList(void *r) { return (CACHE::SGT_TopList*)r; }
inline CACHE::SGT_TopList* API_GetLuaTopList() { return (InBigLock() ? &CACHE::SGT_TopList::GetInstance() : 0); }

#endif //_TOPLIST_H_

