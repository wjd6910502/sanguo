#ifndef _TOPLIST_H_
#define _TOPLIST_H_

#include "singletonmanager.h"
#include "structs.h"

using namespace GNET;

namespace CACHE
{

#define TOPLIST_TYPE_LEVEL 	1  //�ȼ���
#define TOPLIST_TYPE_CAPACITY	2  //ս����
#define TOPLIST_TYPE_RANKING	3  //pvp����
#define TOPLIST_TYPE_PVE_ARENA	4  //���������а�
#define TOPLIST_TYPE_WEAPON	5  //��ҵ��������а�
#define TOPLIST_TYPE_HERO	6  //��ҵ��佫���а�
#define TOPLIST_TYPE_MASHU	7  //��ҵ������������ְ�

	
#define TOPLIST_TIME_NOW 	1  //ʵʱ��
#define TOPLIST_TIME_HISTORY 	2  //��ʷ��


#define TOPLIST_ITEM_TYPE_WEAPON	1	//���а��ϵ���������
#define TOPLIST_ITEM_TYPE_HERO		2	//���а��ϵ��佫����


//ע�����а��1000��ʼ�����Զ����ɵ����а���
#define TOPLIST_AUTO_CREATE		1001
class SGT_TopList: public Singleton, TransactionBase
{
	bool _in_transaction;
	int _transaction_id;
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

	void backup(const char *name, int transaction_id);
	void restore(int transaction_id);
	void cleanup();

	//�ֶ����ӵĴ���
	void OnTimer(int tick, int now);
	void SendMessageDaily(const Int64& target, const std::string& msgid, const int& mailid, const std::string& arg); //FIXME: will delete
	void SendMessageServerEvent(const int& event_type, const int& end_time);
	//for DB
	void Load(Octets &key, Octets &value);
	void Save();
};

}

inline CACHE::SGT_TopList* API_GetLuaTopList(void *r) { return (CACHE::SGT_TopList*)r; }
inline CACHE::SGT_TopList* API_GetLuaTopList() { return (InBigLock() ? &CACHE::SGT_TopList::GetInstance() : 0); }

#endif //_TOPLIST_H_
