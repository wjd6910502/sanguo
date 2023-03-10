#include "playermanager.h"
#include "glog.h"
#include "script_wrapper.h"
#include "mafiamanager.h"
#include "pvpmanager.h"
#include "message.h"
#include "transaction.h"
#include "Misc.h"
#include "singletonmanager.h"
#include "iatomic.h"

using namespace CACHE;

extern __thread lua_State *g_L;
extern lua_State *g_L_new;
extern int g_reload_lua;
extern __thread int g_reload_lua_local;
extern lua_State* InitLuaEnv();
extern void DestroyLuaEnv(lua_State *l);

extern int64_t AllocTransactionId();
extern __thread int64_t g_transaction_id;

extern std::map<int, std::string> g_msg_receiver2; //msg=>receiver2

extern int g_server_state;

extern int script_DataPool_Clear(lua_State *l);

extern std::map<Octets, Octets> g_save_data_map;
extern std::map<int, int> g_cmd_extra_roles_max_map; //cmd=>extra_roles_max
extern std::map<int, int> g_cmd_extra_mafias_max_map; //cmd=>extra_mafias_max
extern std::map<int, int> g_cmd_extra_pvps_max_map; //cmd=>extra_pvps_max
extern std::map<std::string,std::set<int> > g_lock_cmd_set_map; //lock=>cmd_set
extern std::map<std::string,std::set<int> > g_lock_msg_set_map; //lock=>msg_set

//临时单线程化
//int g_wait_count = 0;
//GNET::Thread::Mutex2 g_wait_count_lock("g_wait_count_lock");
//GNET::Thread::Mutex2 g_big_lock("g_big_lock");
atomic_t g_wait_count;
GNET::Thread::RWLock2 g_big_lock("g_big_lock");

class WaitBigTask: public GNET::Runnable
{
	int _index;
public:
	WaitBigTask(int index): _index(index) {}
	
	virtual void Run()
	{
		//GLog::log(LOG_ERR, "WaitBigTask::Run, _index=%d, thread=%u\n", _index, (unsigned int)pthread_self());

		{
		//GNET::Thread::Mutex2::Scoped keeper(g_wait_count_lock);
		//g_wait_count++;
		atomic_inc(&g_wait_count);
		}
		{
		//GNET::Thread::Mutex2::Scoped keeper(g_big_lock);
		//GNET::Thread::Mutex2::Scoped keeper2(g_wait_count_lock);
		//g_wait_count--;
		GNET::Thread::RWLock2::RDScoped keeper(g_big_lock);
		atomic_dec(&g_wait_count);
		}

		if(g_server_state==SERVER_STATE_CLOSED)
		{
			//clear thread resource
			if(g_L)
			{
				DestroyLuaEnv(g_L);
				g_L = 0;
			}

			//inf loop
			delete this;
			while(true) sleep(1);
			return;
		}

		delete this;
	}
};

class MessageTask: public GNET::Runnable
{
	Message _msg;
	APISet _api;

public:
	MessageTask(const Message& msg): _msg(msg) {}

	virtual void Run()
	{
#if 1
		{
		//GNET::Thread::Mutex2::Scoped keeper(g_wait_count_lock);
		//g_wait_count++;
		atomic_inc(&g_wait_count);
		}
		{
		//GNET::Thread::Mutex2::Scoped keeper(g_big_lock);
		//GNET::Thread::Mutex2::Scoped keeper2(g_wait_count_lock);
		//g_wait_count--;
		GNET::Thread::RWLock2::RDScoped keeper(g_big_lock);
		atomic_dec(&g_wait_count);
		}
#endif

		StatisticManager::GetInstance().IncMsgRunCount();

		//get msg type
		int msg_type = atoi(_msg._data.c_str());
		if(msg_type <= 0)
		{
			GLog::log(LOG_ERR, "MessageTask::Run, wrong msg type(%d)\n", msg_type);
			delete this;
			return;
		}

		auto it = g_msg_receiver2.find(msg_type);
		if(it == g_msg_receiver2.end())
		{
			GLog::log(LOG_ERR, "MessageTask::Run, cannot found the msg_type(%d) in g_msg_receiver2\n", msg_type);
			delete this;
			return;
		}
		std::string receiver2 = it->second;

		LuaParameter lp;
		if(receiver2 == "player")
		{
			Player *player = PlayerManager::GetInstance().FindByRoleId(_msg._target);
			if(!player)
			{
				GLog::log(LOG_ERR, "MessageTask::Run, no player: %ld\n", _msg._target);
				delete this;
				return;
			}
			lp.AddParameter(player);
			_Run(player, 0, 0, lp, false);
		}
		else if(receiver2 == "mafia")
		{
			Mafia *mafia = MafiaManager::GetInstance().Find(_msg._target);
			if(!mafia)
			{
				GLog::log(LOG_ERR, "MessageTask::Run, no mafia: %ld\n", _msg._target);
				delete this;
				return;
			}
			lp.AddParameter(mafia);
			_Run(0, mafia, 0, lp, false);
		}
		else if(receiver2 == "pvp")
		{
			PVP *pvp = PVPManager::GetInstance().Find((int)_msg._target);
			if(!pvp)
			{
				GLog::log(LOG_ERR, "MessageTask::Run, no pvp: %ld\n", _msg._target);
				delete this;
				return;
			}
			lp.AddParameter(pvp);
			_Run(0, 0, pvp, lp, false);
		}
		else if(receiver2 == "null")
		{
			lp.AddParameter(0/*ud*/);
			_Run(0, 0, 0, lp, false);
		}
		else if(receiver2 == "big")
		{
			{
			//GNET::Thread::Mutex2::Scoped keeper(g_wait_count_lock);
			//g_wait_count++;
			atomic_inc(&g_wait_count);
			}

			//GNET::Thread::Mutex2::Scoped keeper(g_big_lock);
			GNET::Thread::RWLock2::WRScoped keeper(g_big_lock);

			//上wait task
			for(int i=0; i<100; i++)
			{
				//GNET::Thread::Pool::_pool.AddTask(new WaitBigTask());
				GNET::Thread::Pool::_pool.AddSeqTask(i%100, new WaitBigTask(i%100));
			}
			//等待直到所有worker都停下来
			int c = 0;
			while(true)
			{
				usleep(1000);

				//GNET::Thread::Mutex2::Scoped keeper2(g_wait_count_lock);
				//if(g_wait_count == SERVER_CONST_WORKER_THREAD_COUNT+2) break; //TODO: 直接数有点危险
				if(atomic_read(&g_wait_count) == SERVER_CONST_WORKER_THREAD_COUNT+2) break; //TODO: 直接数有点危险
				//很久还没锁住worker，再补点wait task?
				c++;
				if(c%100 == 0)
				{
					for(int i=0; i<100; i++)
					{
						//GNET::Thread::Pool::_pool.AddTask(new WaitBigTask());
						GNET::Thread::Pool::_pool.AddSeqTask(i%100, new WaitBigTask(i%100));
					}
				}
				if(c%10000 == 0) 
				{
					//printf("%d\n", atomic_read(&g_wait_count));
					abort();
				}
			}
			GLog::log(LOG_ERR, "MessageTask::Run, WaitBigTask, c=%d\n", c);

			lp.AddParameter(0/*ud*/);
			_Run(0, 0, 0, lp, true);

			if(g_L_new) //big _Run时可能会发生lua热加载
			{
				DestroyLuaEnv(g_L);

				g_L = g_L_new;
				g_L_new = 0;
				g_reload_lua++; //通知其他线程也要reload
				g_reload_lua_local = g_reload_lua; //本线程已经reload过了
				GLog::log(LOG_INFO, "MessageTask::Run, lua reload ok, g_reload_lua=%d, thread=%u\n", g_reload_lua, (unsigned int)pthread_self());
			}

			//GNET::Thread::Mutex2::Scoped keeper3(g_wait_count_lock);
			//g_wait_count--;
			atomic_dec(&g_wait_count);

			if(g_server_state==SERVER_STATE_CLOSED)
			{
				//clear thread resource
				if(g_L)
				{
					DestroyLuaEnv(g_L);
					g_L = 0;
				}

				//clear global resource
				//TODO:
				PlayerManager::GetInstance().Shutdown();
				script_DataPool_Clear(0);

				g_save_data_map.clear();
				g_cmd_extra_roles_max_map.clear();
				g_cmd_extra_mafias_max_map.clear();
				g_cmd_extra_pvps_max_map.clear();
				g_msg_receiver2.clear();
				g_lock_cmd_set_map.clear();
				g_lock_msg_set_map.clear();

				//exit
				sleep(120);
				exit(0);
			}
		}
		else
		{
			GLog::log(LOG_ERR, "MessageTask::Run, wrong receiver2: %s\n", receiver2.c_str());
			delete this;
			return;
		}

		delete this;
	}

private:
	void _Run(Player *player, Mafia *mafia, PVP *pvp, LuaParameter& lp, bool big)
	{
		//GLog::log(LOG_INFO, "MessageTask::_Run, _msg._data=%s, thread=%u", _msg._data.c_str(), (unsigned int)pthread_self());

		lp.AddParameter(&_api);
		lp.AddParameter(_msg._data);

		std::set<Player*> player_set;
		std::set<Mafia*> mafia_set;
		std::set<PVP*> pvp_set;

		//extra_roles
		for(auto it=_msg._extra_roles.begin(); it!=_msg._extra_roles.end(); ++it)
		{
			Player *p = PlayerManager::GetInstance().FindByRoleId(*it);
			if(p) player_set.insert(p);
		}
		lp.AddParameter((int)player_set.size()); //extra_roles size
		for(auto it=player_set.begin(); it!=player_set.end(); ++it)
		{
			lp.AddParameter(*it);
		}
		if(player) player_set.insert(player); //最后把自己放进去
		//extra_mafias
		for(auto it=_msg._extra_mafias.begin(); it!=_msg._extra_mafias.end(); ++it)
		{
			Mafia *p = MafiaManager::GetInstance().Find(*it);
			if(p) mafia_set.insert(p);
		}
		lp.AddParameter((int)mafia_set.size()); //extra_mafias size
		for(auto it=mafia_set.begin(); it!=mafia_set.end(); ++it)
		{
			lp.AddParameter(*it);
		}
		if(mafia) mafia_set.insert(mafia); //最后把自己放进去
		//extra_pvps
		for(auto it=_msg._extra_pvps.begin(); it!=_msg._extra_pvps.end(); ++it)
		{
			PVP *p = PVPManager::GetInstance().Find(*it);
			if(p) pvp_set.insert(p);
		}
		lp.AddParameter((int)pvp_set.size()); //extra_pvps size
		for(auto it=pvp_set.begin(); it!=pvp_set.end(); ++it)
		{
			lp.AddParameter(*it);
		}
		if(pvp) pvp_set.insert(pvp); //最后把自己放进去

		int msg_type = atoi(_msg._data.c_str());
		SingletonManager::GetInstance().Add2MessageParameter(msg_type, lp);

		//顺序多锁
		std::list<MyScoped> keeper_list;
		for(auto it=player_set.begin(); it!=player_set.end(); ++it)
		{
			Player *p = *it;
			keeper_list.push_back(MyScoped(p->_lock));
		}
		for(auto it=mafia_set.begin(); it!=mafia_set.end(); ++it)
		{
			Mafia *p = *it;
			keeper_list.push_back(MyScoped(p->_lock));
		}
		for(auto it=pvp_set.begin(); it!=pvp_set.end(); ++it)
		{
			PVP *p = *it;
			keeper_list.push_back(MyScoped(p->_lock));
		}
		SingletonManager::GetInstance().Add2MessageLock(msg_type, keeper_list);

		//transaction
		std::list<TransactionKeeper> transaction_list;
		for(auto it=player_set.begin(); it!=player_set.end(); ++it)
		{
			Player *p = *it;
			transaction_list.push_back(TransactionKeeper(p));
		}
		for(auto it=mafia_set.begin(); it!=mafia_set.end(); ++it)
		{
			Mafia *p = *it;
			transaction_list.push_back(TransactionKeeper(p));
		}
		for(auto it=pvp_set.begin(); it!=pvp_set.end(); ++it)
		{
			PVP *p = *it;
			transaction_list.push_back(TransactionKeeper(p));
		}
		SingletonManager::GetInstance().Add2MessageTransaction(msg_type, transaction_list);
		transaction_list.push_back(TransactionKeeper(&_api));

		//需要存盘时先存盘
		for(auto it=player_set.begin(); it!=player_set.end(); ++it)
		{
			Player *p = *it;
			if(p->NeedDoSave()) p->DoSave();
		}

		if(!g_L)
		{
			g_L = InitLuaEnv();
			g_reload_lua_local = g_reload_lua;
		}
		else if(g_reload_lua > g_reload_lua_local) //需要热更新lua
		{
			//需要考虑热加载失败
			lua_State *g_L_new = InitLuaEnv();
			if(g_L_new)
			{
				DestroyLuaEnv(g_L);
				g_L = g_L_new;
				g_reload_lua_local = g_reload_lua;
				GLog::log(LOG_INFO, "MessageTask::_Run, lua reload ok, g_reload_lua=%d, thread=%u\n", g_reload_lua, (unsigned int)pthread_self());
			}
			else
			{
				GLog::log(LOG_ERR, "MessageTask::_Run, error, reload lua");
			}
		}
		if(g_L)
		{
			g_transaction_id = AllocTransactionId();

			LuaWrapper lw(g_L);
			if(!lw.gExec("DeserializeAndProcessMessage", (big?(1000*60*60):1000), (big?0:(20*1024*1024)), lp))
			{
				//fprintf(stderr, "\033[31mMessageTask::Run, gExec, error, DeserializeAndProcessMessage, thread=%u, %.*s\n%s\033[0m\n",
				//        (unsigned int)pthread_self(), (int)_msg._data.size(), (char*)_msg._data.c_str(), lw.ErrorMsg());
				GLog::log(LOG_ERR, "MessageTask::Run, gExec, error, DeserializeAndProcessMessage, thread=%u, %.*s\n%s",
				          (unsigned int)pthread_self(), (int)_msg._data.size(), (char*)_msg._data.c_str(), lw.ErrorMsg());

				//cancel
				for(auto it=transaction_list.begin(); it!=transaction_list.end(); ++it)
				{
					it->SetCancel();
				}
				if(strcasestr(lw.ErrorMsg(), "not enough memory"))
				{
					GLog::log(LOG_WARNING, "MessageTask::Run, gExec, memory reached limit, force do lua gc");
					lua_gc(g_L, LUA_GCCOLLECT, 0);
				}
			}
			//if(g_L)
			//{
			//	void *ud = 0;
			//	lua_getallocf(g_L, &ud);
			//	if(ud)
			//	{
			//		LuaMemory *mem = (LuaMemory*)ud;
			//		if(mem->GetTotalBytes() > SERVER_CONST_LUA_MEMORY_MAX)
			//		{
			//			GLog::log(LOG_WARNING, "MessageTask::Run, gExec, cost too much memory, reload lua");
			//			DestroyLuaEnv(g_L);
			//			g_L = 0;
			//		}
			//	}
			//}
		}
	}
};

void MessageManager::OnTimer(int tick, time_t now)
{
	std::list<Message> msgs;
	std::list<Message> delay_msgs;
	{
		GNET::Thread::Mutex2::Scoped keeper(_lock);

		msgs.swap(_msgs);

		if(_prev_now != now)
		{
			//每秒检查一次
			_prev_now = now;
			if(!_delay_msgs.empty())
			{
				auto it = _delay_msgs.begin();
				while(it!=_delay_msgs.end())
				{
					time_t t = it->first;
					if(now<t) break;
					delay_msgs.insert(delay_msgs.end(), it->second.begin(), it->second.end());
					_delay_msgs.erase(it);
					//next
					it = _delay_msgs.begin();
				}
			}
		}
	}
	msgs.insert(msgs.end(), delay_msgs.begin(), delay_msgs.end());

	std::vector<int64_t> roles;
	for(auto it=msgs.begin(); it!=msgs.end(); ++it)
	{
		Message& msg = *it;

		if(msg._target == -1)
		{
			//broadcast to all role
			if(roles.size() == 0) PlayerManager::GetInstance().GetActiveRoles(roles);
			for(auto it=roles.begin(); it!=roles.end(); ++it)
			{
				msg._target = *it;
				GNET::Thread::Pool::_pool.AddSeqTask(*it%100, new MessageTask(msg));
			}
		}
		else
		{
			GNET::Thread::Pool::_pool.AddSeqTask(msg._target%100, new MessageTask(msg));
		}
	}
}

void MessageManager::Put(int64_t target, int64_t src, const std::string& data, int delay, const std::vector<int64_t> *extra_roles,
                         const std::vector<int64_t> *extra_mafias, const std::vector<int> *extra_pvps)
{
	StatisticManager::GetInstance().IncMsgPutCount();

	GNET::Thread::Mutex2::Scoped keeper(_lock);

	if(delay == 0)
	{
		_msgs.push_back(Message(target, src, data, 0, extra_roles, extra_mafias, extra_pvps));
	}
	else
	{
		time_t t = _prev_now+delay+1; //并不精确，但要保证不比delay少
		_delay_msgs[t].push_back(Message(target, src, data, 0, extra_roles, extra_mafias, extra_pvps));
	}
}
void MessageManager::Put(const Message& msg)
{
	StatisticManager::GetInstance().IncMsgPutCount();

	GNET::Thread::Mutex2::Scoped keeper(_lock);

	if(msg._delay == 0)
	{
		_msgs.push_back(msg);
	}
	else
	{
		time_t t = _prev_now+msg._delay+1;
		//msg._delay = 0;
		_delay_msgs[t].push_back(msg);
	}
}
