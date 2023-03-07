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
//ע���������һ��ȫ������Ĺ�������Ҫ�����κεĴ洢���ݿ�Ĳ�����
//��Ϣ����Դ�Ƿ������������ļ����Լ�ͨ���ͷ�ƽ̨����������Ϣ��
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

	//�����Ƕ�ȡ�����ļ�
	void Load();
	//����ǿͷ�����һ���µĹ㲥
	void Insert(Notice notice);

	//����ӿ�����ʵ�ʵĸ�ȫ����ҷ��͹���
	void SendNotice(std::string notice);
};

};

#endif
