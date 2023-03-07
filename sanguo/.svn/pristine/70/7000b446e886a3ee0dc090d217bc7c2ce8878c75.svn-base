#ifndef _TOP_MANAGER_H_
#define _TOP_MANAGER_H_

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
#define TOPLIST_TYPE_LEVEL 	1  //等级榜
#define TOPLIST_TYPE_CAPACITY	2  //战力榜
#define TOPLIST_TYPE_RANKING	3  //pvp积分

	
#define TOPLIST_TIME_NOW 	1  //实时榜
#define TOPLIST_TIME_HISTORY 	2  //历史榜

class TopManager: public TransactionBase
{
private:
	bool _in_transaction;
	int _transaction_id;
	std::map<std::string, GNET::Octets> _transaction_data;
public:
	TopManagerMap _top_manager;
	mutable Thread::Mutex _lock;
	TopManager():_in_transaction(false), _transaction_id(0)
	{
		//添加新的排行榜的时候需要去msg的openserver中进行初始化
		//TopList top_value;
		
		//int time_stamp = Now();
	
		//time_t now = Timer::GetTime();
		//struct tm *tmp = localtime(&now);
		//tmp->tm_hour = 5;
		//tmp->tm_min = 0;
		//tmp->tm_sec = 0;
		//int update_time = mktime(tmp);

		//if(time_stamp >= update_time)
		//	top_value._new_top_list_by_data._timestamp = update_time + 24*3600;
		//else
		//	top_value._new_top_list_by_data._timestamp = update_time;

		//top_value._top_list_type = TOPLIST_TYPE_LEVEL;
		//_top_manager.Insert(TOPLIST_TYPE_LEVEL, top_value);
		//top_value._top_list_type = TOPLIST_TYPE_CAPACITY;
		//_top_manager.Insert(TOPLIST_TYPE_CAPACITY, top_value);
		//top_value._top_list_type = TOPLIST_TYPE_RANKING;
		//_top_manager.Insert(TOPLIST_TYPE_RANKING, top_value);
	}
	static TopManager* GetInstance()
	{
		static TopManager _instance;
		return &_instance;
	}
	void OnTimer(int tick, int now);
	
	//for TopManagerMap
	//void OnChanged();
	//int Tag() const;
	//std::map<int, TopList>::iterator End();

	//for lua
	//int Size() const;

	//TopList* Find(const int& k);

	//TopManagerMapIter SeekToBegin();
	//TopManagerMapIter Seek(const int& k);
	void SendMessageDaily(const Int64& target, const std::string& msgid, const int& mailid, const std::string& arg);
	void SendMessageServerEvent(const int& event_type, const int& end_time);


	//for DB
	void Load(Octets &key, Octets &value);
	void Save();
	void SaveToDB();

	virtual void BeginTransaction();
	virtual void CommitTransaction();
	virtual void CancelTransaction();
	void backup(const char *name, int transaction_id);
	void restore(int transaction_id);
	void cleanup();
	
	//Test
	void SaveTest();
};

}

inline CACHE::TopManager* API_GetLuaTopManager(void *r) { return (CACHE::TopManager*)r; }
inline CACHE::TopManager* API_GetLuaTopManager() { return CACHE::TopManager::GetInstance(); }

#endif //_TOP_MANAGER_H_

