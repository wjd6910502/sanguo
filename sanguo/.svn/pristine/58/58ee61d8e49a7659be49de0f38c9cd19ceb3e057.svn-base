#ifndef _NOTICE_MANAGER_H_
#define _NOTICE_MANAGER_H_

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "octets.h"
#include "forlua.h"
#include "itimer.h"
#include "thread.h"
#include "mutex.h"
#include "role.h"
#include "commonmacro.h"
#include "glog.h"
#include "structs.h"
#include <string>
#include <map>


using namespace GNET;

namespace CACHE
{
//注意这个就是一个全服公告的管理，不需要进行任何的存储数据库的操作。
//信息的来源是服务器的配置文件，以及通过客服平台发过来的信息。
class NoticeManager: public IntervalTimer::Observer
{
private:
	NoticeMap _notice_map;
	NoticeManager();
	~NoticeManager();
	time_t update_time;

public:
	mutable Thread::Mutex2 _lock; //TODO:

	bool Initialize();
	bool Update();
	static NoticeManager* GetInstance()
	{
		static NoticeManager _instance;
		return &_instance;
	}

	//这里是读取配置文件
	void Load();
	//这个是客服插入一条新的广播
	void Insert(Notice notice);

	//这个接口用来实际的给全服玩家发送公告
	void SendNotice(std::string notice);
};

};

#endif
