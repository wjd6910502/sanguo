
#ifndef __GNET_GAMEPROTOCOL_HPP
#define __GNET_GAMEPROTOCOL_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "commonmacro.h"
#include "playermanager.h"
#include "script_wrapper.h"
#include "mafiamanager.h"
#include "pvpmanager.h"
#include "TopList.h"
#include "Misc.h"
#include "singletonmanager.h"

#include <lua.hpp>
#include "glog.h"
#include <set>
#include "statistic_manager.h"
#include "transaction.h"
#include "iatomic.h"
#include "NoLoadPlayer.h"

using namespace CACHE;

extern __thread lua_State *g_L;
extern int g_reload_lua;
extern __thread int g_reload_lua_local;
extern lua_State* InitLuaEnv();
extern void DestroyLuaEnv(lua_State *l);

extern int64_t AllocTransactionId();
extern __thread int64_t g_transaction_id;
extern int g_server_state;

extern std::map<int, int> g_cmd_extra_roles_max_map; //cmd=>extra_roles_max
extern std::map<int, int> g_cmd_extra_mafias_max_map; //cmd=>extra_mafias_max
extern std::map<int, int> g_cmd_extra_pvps_max_map; //cmd=>extra_pvps_max
extern std::set<int> g_cmd_lock_toplist_map; //cmd=>lock_toplist
extern std::set<int> g_cmd_lock_mist_map; //cmd=>mist

//extern int g_wait_count;
//extern GNET::Thread::Mutex2 g_wait_count_lock;
//extern GNET::Thread::Mutex2 g_big_lock;
extern atomic_t g_wait_count;
extern GNET::Thread::RWLock2 g_big_lock;

namespace GNET
{

class CommandTask: public GNET::Runnable
{
	//Player *_player;
	int _roleid;
	int _sid;
	Octets _data;
	std::vector<int64_t> _extra_roles;
	std::vector<int64_t> _extra_mafias;
	std::vector<int> _extra_pvps;

public:
	//CommandTask(Player *player, const Octets& data): _player(player), _data(data) {}
	//CommandTask(Player *player, const Octets& data, const std::vector<int64_t>& extra_roles, const std::vector<int64_t>& extra_mafias,
	//            const std::vector<int>& extra_pvps)
	//           : _player(player), _data(data), _extra_roles(extra_roles), _extra_mafias(extra_mafias), _extra_pvps(extra_pvps)
	CommandTask(int64_t roleid, const Octets& data): _roleid(roleid), _sid(0), _data(data) {}
	CommandTask(int sid, const Octets& data, const std::vector<int64_t>& extra_roles, const std::vector<int64_t>& extra_mafias,
	            const std::vector<int>& extra_pvps)
	           : _roleid(0), _sid(sid), _data(data), _extra_roles(extra_roles), _extra_mafias(extra_mafias), _extra_pvps(extra_pvps)
	{
	}

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

		//GLog::log(LOG_INFO, "CommandTask::Run, _data=%.*s, thread=%u",
		//          (int)_data.size(), (char*)_data.begin(), (unsigned int)pthread_self());

		//data来自于客户端，必须严格检查
		//check data and get game protocol type

		//查看当前是否停服了，如果是不在进行处理
		if(g_server_state == SERVER_STATE_CLOSED)
		{
			GLog::log(LOG_ERR, "CommandTask::Run, CloseServer\n");
			delete this;
			return;
		}

		if(_data.size() < 2)
		{
			GLog::log(LOG_ERR, "CommandTask::Run, wrong data length\n");
			delete this;
			return;
		}
		for(size_t i=0; i<_data.size(); ++i)
		{
			int c = ((char*)_data.begin())[i];
			if(!isupper(c) && !islower(c) && !isdigit(c) && c!='+' && c!='/' && c!='=' && c!=':' && c!='.')
			{
				GLog::log(LOG_ERR, "CommandTask::Run, wrong char(%d)\n", c);
				delete this;
				return;
			}
		}
		std::string s((const char*)_data.begin(), _data.size()); //opt: size limit
		int cmd = atoi(s.c_str());
		if(cmd <= 0)
		{
			GLog::log(LOG_ERR, "CommandTask::Run, wrong cmd(%d)\n", cmd);
			delete this;
			return;
		}

		Player *_player = 0;
		if(_roleid)
		{
			_player = PlayerManager::GetInstance().FindByRoleId(_roleid);
		}
		else if(_sid)
		{
			_player = PlayerManager::GetInstance().FindByTransSid(_sid, false);
		}
		if(!_player)
		{
			GLog::log(LOG_ERR, "CommandTask::Run, no player\n");
			delete this;
			return;
		}
		//检查是否已经创建了角色
		if(cmd<=1000000 && (int64_t)_player->_role._roledata._base._id==0)
		{
			GLog::log(LOG_ERR, "CommandTask::Run, no role\n"); //TODO:
			delete this;
			return;
		}
		//check extra_roles
		int max = 0;
		{
			auto it = g_cmd_extra_roles_max_map.find(cmd);
			if(it != g_cmd_extra_roles_max_map.end()) max = it->second;
		}
		if(max > 0)
		{
			if(_extra_roles.size() > (size_t)max)
			{
				GLog::log(LOG_ERR, "CommandTask::Run, too much _extra_roles(%lu>%d)\n", _extra_roles.size(), max);
				delete this;
				return;
			}
		}
		else
		{
			_extra_roles.clear();
		}
		//check extra_mafias
		max = 0;
		{
			auto it = g_cmd_extra_mafias_max_map.find(cmd);
			if(it != g_cmd_extra_mafias_max_map.end()) max = it->second;
		}
		if(max > 0)
		{
			if(_extra_mafias.size() > (size_t)max)
			{
				GLog::log(LOG_ERR, "CommandTask::Run, too much _extra_mafias(%lu>%d)\n", _extra_mafias.size(), max);
				delete this;
				return;
			}
		}
		else
		{
			_extra_mafias.clear();
		}
		//check extra_pvps
		max = 0;
		{
			auto it = g_cmd_extra_pvps_max_map.find(cmd);
			if(it != g_cmd_extra_pvps_max_map.end()) max = it->second;
		}
		if(max > 0)
		{
			if(_extra_pvps.size() > (size_t)max)
			{
				GLog::log(LOG_ERR, "CommandTask::Run, too much _extra_pvps(%lu>%d)\n", _extra_pvps.size(), max);
				delete this;
				return;
			}
		}
		else
		{
			_extra_pvps.clear();
		}

		//准备参数
		APISet api;
		LuaParameter lp(_player, &api, std::string((char*)_data.begin(), _data.size()));

		std::set<Player*> player_set;
		std::set<Mafia*> mafia_set;
		std::set<PVP*> pvp_set;
		//extra_roles
		//bool load_flag = false;
		for(auto it=_extra_roles.begin(); it!=_extra_roles.end(); ++it)
		{
			Player *p = PlayerManager::GetInstance().FindByRoleId(*it);
			if(p)
			{
				player_set.insert(p);
			}
			else
			{
				//在这里对需要锁的玩家判断一下，如果没有进行Load的话，那么提示客户端，然后继续
				//服务器进行玩家数据的Load。
				std::string tmp_account = SGT_NoLoadPlayer::GetInstance().HaveLoadPlayer(*it);
				if(tmp_account != "")
				{
					//load_flag = true;
					SGT_NoLoadPlayer::GetInstance().GetRoleInfo(tmp_account);
				}
			}
		}
		//if(load_flag)
		//{
		//	char msg[100];
		//	snprintf(msg, sizeof(msg), "15:"); //ErrorInfo
		//	MessageManager::GetInstance().Put((int64_t)_player->_role._roledata._base._id, 
		//			(int64_t)_player->_role._roledata._base._id, msg, 0);
		//	delete this;
		//	return;
		//}
		lp.AddParameter((int)player_set.size()); //extra_roles size
		for(auto it=player_set.begin(); it!=player_set.end(); ++it)
		{
			lp.AddParameter(*it);
		}
		player_set.insert(_player); //最后把自己放进去
		//extra_mafias
		for(auto it=_extra_mafias.begin(); it!=_extra_mafias.end(); ++it)
		{
			Mafia *p = MafiaManager::GetInstance().Find(*it);
			if(p) mafia_set.insert(p);
		}
		lp.AddParameter((int)mafia_set.size()); //extra_mafias size
		for(auto it=mafia_set.begin(); it!=mafia_set.end(); ++it)
		{
			lp.AddParameter(*it);
		}
		//extra_pvps
		for(auto it=_extra_pvps.begin(); it!=_extra_pvps.end(); ++it)
		{
			PVP *p = PVPManager::GetInstance().Find(*it);
			if(p) pvp_set.insert(p);
		}
		lp.AddParameter((int)pvp_set.size()); //extra_pvps size
		for(auto it=pvp_set.begin(); it!=pvp_set.end(); ++it)
		{
			lp.AddParameter(*it);
		}
		SingletonManager::GetInstance().Add2CommandParameter(cmd, lp);

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
		SingletonManager::GetInstance().Add2CommandLock(cmd, keeper_list);

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
		SingletonManager::GetInstance().Add2CommandTransaction(cmd, transaction_list);
		transaction_list.push_back(TransactionKeeper(&api));

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
				GLog::log(LOG_INFO, "CommandTask::Run, lua reload ok, g_reload_lua=%d, thread=%u\n", g_reload_lua, (unsigned int)pthread_self());
			}
			else
			{
				GLog::log(LOG_ERR, "CommandTask::Run, error, reload lua");
			}
		}
		if(g_L)
		{
			g_transaction_id = AllocTransactionId();

			LuaWrapper lw(g_L);
			if(!lw.gExec("DeserializeAndProcessCommand", 1000, 20*1024*1024, lp))
			{
				fprintf(stderr, "\033[31mCommandTask::Run, gExec, error, DeserializeAndProcessCommand, %.*s\n%s\033[0m\n", (int)_data.size(), (char*)_data.begin(), lw.ErrorMsg());
				GLog::log(LOG_ERR, "CommandTask::Run, gExec, error, DeserializeAndProcessCommand, %.*s\n%s", (int)_data.size(), (char*)_data.begin(), lw.ErrorMsg());
				//cancel
				for(auto it=transaction_list.begin(); it!=transaction_list.end(); ++it)
				{
					it->SetCancel();
				}
				if(strcasestr(lw.ErrorMsg(), "not enough memory"))
				{
					GLog::log(LOG_WARNING, "CommandTask::Run, gExec, memory reached limit, force do lua gc");
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
			//			GLog::log(LOG_WARNING, "CommandTask::Run, gExec, cost too much memory, reload lua");
			//			DestroyLuaEnv(g_L);
			//			g_L = 0;
			//		}
			//	}
			//}
		}

		//keeper_list具体解锁顺序是无关紧要的
		delete this;
	}
};

class GameProtocol : public GNET::Protocol
{
	#include "gameprotocol"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//GLog::log(LOG_INFO, "GameProtocol::Process, data=%.*s, extra_roles.size()=%lu, extra_mafias.size()=%lu, extra_pvps.size()=%lu, sid=%u, thread=%u",
		//          (int)data.size(), (char*)data.begin(), extra_roles.size(), extra_mafias.size(), extra_pvps.size(), sid, (unsigned int)pthread_self());

		StatisticManager::GetInstance().IncCmdCount();

		Player *player = PlayerManager::GetInstance().FindByTransSid(sid, true);
		if(!player) return;
		if(!player->GetCanReceiveProtocol()) return;

		player->OnRecvCommand();
		if(player->IsClientCmdSendTooFast())
		{
			player->KickoutSelf(KICKOUT_REASON_TOO_MUCH_COMMAND);
			return;
		}

		//Thread::Mutex2::Scoped keeper(player->_lock);

		player->UpdateLatency(client_send_time, server_send_time);
		player->UpdateActiveTime_NOLOCK();
		player->OnReceivedGameProtocol_NOLOCK(); //这步必须收到就做

		//GNET::Thread::Pool::_pool.AddSeqTask(player->GetHash_NOLOCK()%100, new CommandTask(player, data, extra_roles, extra_mafias, extra_pvps));
		GNET::Thread::Pool::_pool.AddSeqTask(player->GetHash_NOLOCK()%100, new CommandTask(sid, data, extra_roles, extra_mafias, extra_pvps));
	}
};

};

#endif
