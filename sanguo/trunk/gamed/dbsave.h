#ifndef __GNET_DBSAVE_H
#define __GNET_DBSAVE_H

#include "thread.h"
#include "dbsavedata.hrp"

using namespace GNET;

extern GNET::Thread::Mutex2 g_save_data_lock;
//extern std::map<Octets, Octets> g_save_data_map;
//extern std::set<Octets> g_player_should_save_set;
extern std::map<Octets, Octets> g_save_data_map2;
extern GNET::Thread::Mutex2 g_save_data_ing_lock;
extern std::map<Octets, Octets> g_save_data_map_ing;

namespace CACHE
{
	class DelayDBSaveTask : public Thread::Runnable
	{
	public:
		static DelayDBSaveTask * GetInstance()
		{
			static DelayDBSaveTask instance;
			return &instance;
		}
		DelayDBSaveTask(): Runnable(1){ }

		void Run()
		{
			Thread::Mutex2::Scoped keeper(g_save_data_lock);
			Thread::Mutex2::Scoped keeper2(g_save_data_ing_lock);

			if(g_save_data_map2.empty()) return;
			if(!g_save_data_map_ing.empty()) return;

			g_save_data_map_ing.swap(g_save_data_map2);

			keeper.Unlock();
			keeper.Detach();

			GLog::log(LOG_INFO, "DelayDBSaveDataTask begin ... ...");
			DBSaveDataArg new_arg;
			std::map<Octets, Octets>::iterator it = g_save_data_map_ing.begin();
			if(it != g_save_data_map_ing.end())
			{
				int num = 0;
				for(; it != g_save_data_map_ing.end(); it++)
				{
					if(num >= 33554432)
					{
						new_arg.find_key = it->first;;
						break;
					}
					else
					{
						new_arg.result_key.push_back(it->first);
						new_arg.result_value.push_back(it->second);
						num += it->first.size();
						num += it->second.size();
					}
				}
				DBSaveData *rpc = (DBSaveData *)Rpc::Call(RPC_DBSAVEDATA,new_arg);
				GameDBClient::GetInstance()->SendProtocol(rpc);
			}
			
		};
	};
};

#endif

