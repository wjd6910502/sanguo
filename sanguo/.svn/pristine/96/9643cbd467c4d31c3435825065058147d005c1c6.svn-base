#ifndef __GNET_DBSAVEMANAGER_H
#define __GNET_DBSAVEMANAGER_H

#include "playermanager.h"
#include "mafiamanager.h"
#include "packagemanager.h"
#include "TopList.h"
#include "Misc.h"
#include "PveArena.h"
#include "dbsave.h"

using namespace CACHE;
extern int g_db_save_flag;
extern int g_server_state;

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
			if(g_server_state == SERVER_STATE_RUNNING && g_db_save_flag == 1)
			{
				PlayerManager::GetInstance().Save();
				//MafiaManager::GetInstance().Save();
				PackagManager::GetInstance().Save();
				SGT_TopList::GetInstance().Save();
				SGT_Misc::GetInstance().Save();
				SGT_PveArena::GetInstance().Save();

				//在这里扔一个任务，把这些数据存储到数据库中去
				Thread::HouseKeeper::AddTimerTask(DelayDBSaveTask::GetInstance(), 1);

				GLog::log(LOG_INFO, "dbsavedata end ... ...");
				GLog::log(LOG_INFO, "dbsavedata begin2 ... ...");
			}
		}
	};
};

inline void API_LuaSave() { DBSaveManager::GetInstance().Save();}

#endif
