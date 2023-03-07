#ifndef __GNET_DBSAVEMANAGER_H
#define __GNET_DBSAVEMANAGER_H

#include "playermanager.h"
#include "mafiamanager.h"
#include "packagemanager.h"
#include "TopList.h"
#include "Misc.h"
#include "PveArena.h"
#include "dbsave.h"
#include "TopList_All_Role.h"
#include "JieYi_Info.h"
#include "ServerReward.h"

using namespace CACHE;
extern int g_db_save_flag;
extern int g_server_state;

extern GNET::Thread::Mutex2 g_save_data_lock;
extern std::map<Octets, Octets> g_save_data_map;
//extern std::set<Octets> g_player_should_save_set;
extern std::map<Octets, Octets> g_save_data_map2;
//extern GNET::Thread::Mutex2 g_save_data_ing_lock;
//extern std::map<Octets, Octets> g_save_data_map_ing;

namespace CACHE
{
	class DBSaveManager
	{
	public:
		static DBSaveManager GetInstance()
		{
			static DBSaveManager _instance;
			return _instance;
		}

		void Save()
		{
			//in big lock
			if((g_server_state == SERVER_STATE_RUNNING || g_server_state == SERVER_STATE_CLOSED)&& g_db_save_flag == 1)
			{
				PlayerManager::GetInstance().Save2();

				//�л�
				//g_save_data_map2���ܷ�empty��˵��save db������ˣ������ݼ���дg_save_data_map���ɣ��൱������save�ϲ�
				if(g_save_data_map2.empty()) g_save_data_map2.swap(g_save_data_map);

				//��ʼ��һ�ε�����save
				PlayerManager::GetInstance().Save();
				MafiaManager::GetInstance().Save();
				PackagManager::GetInstance().Save();
				SGT_TopList::GetInstance().Save();
				SGT_Misc::GetInstance().Save();
				SGT_PveArena::GetInstance().Save();
				SGT_TopList_All_Role::GetInstance().Save();
				SGT_JieYi_Info::GetInstance().Save();
				SGT_ServerReward::GetInstance().Save();

				//��������һ�����񣬰���Щ���ݴ洢�����ݿ���ȥ
				Thread::HouseKeeper::AddTimerTask(DelayDBSaveTask::GetInstance(), 10);

				GLog::log(LOG_INFO, "dbsavedata end ... ...");
				GLog::log(LOG_INFO, "dbsavedata begin2 ... ...");
			}
		}
	};
};

inline void API_LuaSave() { DBSaveManager::GetInstance().Save();}

#endif