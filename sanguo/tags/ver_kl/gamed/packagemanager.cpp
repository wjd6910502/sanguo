#include "packagemanager.h"
#include "gamedbclient.hpp"

extern std::map<Octets, Octets> g_save_data_map;
namespace CACHE
{

void PackagManager::BeginTransaction()
{
}

void PackagManager::CommitTransaction()
{
}

void PackagManager::CancelTransaction()
{
}

void PackagManager::OnChanged()
{
}

int PackagManager::Tag() const
{
	return compensate_map.Tag();
}

std::map<int, Compensate>::iterator PackagManager::End()
{
	return compensate_map.End();
}

int PackagManager::Size() const
{
	return compensate_map.Size();
}

Compensate* PackagManager::Find(const int& k)
{
	Thread::Mutex::Scoped keeper(_lock);
	return compensate_map.Find(k);
}

void PackagManager::Insert(const int& k, const Compensate& v)
{
	Thread::Mutex::Scoped keeper(_lock);
	compensate_map.Insert(k, v);
}

void PackagManager::Clear()
{
	Thread::Mutex::Scoped keeper(_lock);
	compensate_map.Clear();
}

//ע����������Ǹ��������������������͵�
void PackagManager::Delete(int type)
{
	//��ΪĿǰ���ɵķ�����ɾ��һ���Ժ󣬾ͻ���ɵ�����ʧЧ��
	//�������ǲ����ȱ����ռ���Ҫɾ���ģ�Ȼ���ٴν���ɾ����
	Thread::Mutex::Scoped keeper(_lock);
	std::list<int> del_seq;
	CompensateMapIter it = compensate_map.SeekToBegin();
	Compensate *value;
	for(; (value = it.GetValue()); it.Next())
	{
		if(value->_type == type)
		{
			del_seq.push_back(value->_seq);
		}
	}

	std::list<int>::iterator list_it = del_seq.begin();
	for(; list_it != del_seq.end(); list_it++)
	{
		compensate_map.Delete(*list_it);
	}

}

CompensateMapIter PackagManager::SeekToBegin()
{
	return compensate_map.SeekToBegin();
}

CompensateMapIter PackagManager::Seek(const int& k)
{
	return compensate_map.Seek(k);
}

void PackagManager::Load(Octets &value)
{
	Thread::Mutex::Scoped keeper(_lock);
	Marshal::OctetsStream os(value);
	int db_version = 0;
	os >> db_version;
	os._dbversion = db_version;
	compensate_map.unmarshal(os);
}

void PackagManager::Save()
{
	Thread::Mutex::Scoped keeper(_lock);
	std::string key_str = "package_server";
	GNET::Marshal::OctetsStream value;
	int db_version = DB_VERSION;
	value << db_version;
	compensate_map.marshal(value);
	g_save_data_map[Octets(key_str.c_str(), key_str.size())] = value;
}

void PackagManager::Update()
{
	//��ΪĿǰ���ɵķ�����ɾ��һ���Ժ󣬾ͻ���ɵ�����ʧЧ��
	//�������ǲ����ȱ����ռ���Ҫɾ���ģ�Ȼ���ٴν���ɾ����
	Thread::Mutex::Scoped keeper(_lock);
	std::list<int> del_seq;
	CompensateMapIter it = compensate_map.SeekToBegin();
	Compensate *value;
	time_t now = Timer::GetTime();
	for(; (value = it.GetValue()); it.Next())
	{
		if(value->_end < Int64(now) && value->_date == 0 && value->_week ==0)
		{
			del_seq.push_back(value->_seq);
		}
	}

	std::list<int>::iterator list_it = del_seq.begin();
	for(; list_it != del_seq.end(); list_it++)
	{
		compensate_map.Delete(*list_it);
	}
}

};