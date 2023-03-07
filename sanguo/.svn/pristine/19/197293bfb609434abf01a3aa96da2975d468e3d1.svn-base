#include "objectmanager.h"


ObjectManager ObjectManager::instance;

ObjectManager::ObjectManager()
{
	//for(int i = 0 ; i < 10000; i++)
	{
	//	m_poollist.insert(std::make_pair(new SpeechMsg(),POOL_OBJECT_STATUS_FREE));				
	}			
}

ObjectManager::~ObjectManager() 
{
	for(auto ibeg = m_poollist.begin(); ibeg != m_poollist.end(); ibeg++)
	{
		SpeechMsg* pmsg = ibeg->first;	
		delete pmsg;
		pmsg = NULL;
	}
	m_poollist.clear();
	m_poollist.swap(std::map<SpeechMsg*,int>());
		
}

SpeechMsg* ObjectManager::allocMsg() 
{			
	auto it = std::find_if(m_poollist.begin(),m_poollist.end(),map_value_finder(0));
	if(it != m_poollist.end())
	{
		it->second = POOL_OBJECT_STATUS_INUSE; //正在使用
		//printf("msg use_status = %d type = %d\n",it->second,msg->GetType());
		return it->first;
		printf("分配的内存...........\n");
	}
		
	//printf("分配的内存快已经用完...........\n");
	return NULL;
}

void ObjectManager::setState(SpeechMsg* msg ,int st)
{
	auto ifind = m_poollist.find(msg);
	if(ifind != m_poollist.end())
	{
		ifind->second = st;	
	}

}

void ObjectManager::Staticdata()
{
	int free_cnt = 0;
	int use_cnt = 0;
	for(auto ibeg =m_poollist.begin(); ibeg != m_poollist.end(); ibeg++)
	{
		if(ibeg->second == POOL_OBJECT_STATUS_FREE)
			free_cnt = free_cnt +1;
		
		if(ibeg->second == POOL_OBJECT_STATUS_INUSE)
			use_cnt= use_cnt + 1 ;
	
	}
	printf("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
	printf("status result free_cnt= %d, use_cnt = %d\n",free_cnt,use_cnt);
	printf("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n"); 
}



