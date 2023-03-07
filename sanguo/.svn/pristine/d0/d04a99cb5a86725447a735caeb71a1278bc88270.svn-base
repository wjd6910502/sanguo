#include "gateclient.hpp"
#include "transclient.hpp"
#include "conf.h"
#include "log.h"
#include "thread.h"
#include <iostream>
#include <unistd.h>
#include "gnet_init.h"
#include "connection.h"
#include "script_wrapper.h"
#include <lua.hpp>
#include <signal.h>
#include "udpstunrequest.hpp"
#include "udptransclient.hpp"

using namespace GNET;

//int64_t g_delay = 0; 
//int64_t g_offset = 0;
lua_State *g_L = 0;

int64_t g_roleid = 0;
std::string g_pvpd_ip;
unsigned short g_pvpd_port = 0;

static int script_Log(lua_State *l)
{
	int n = lua_gettop(l);
	if(n != 1) return 0;

	const char *log = lua_tostring(l, 1);

	//fprintf(stderr, "===LUA LOG===: %s\n", log);
	printf("===LUA LOG(%d)===: %s\n", getpid(), log);

	return 0;
}

static int script_GetTime(lua_State *l)
{
	lua_pushinteger(l, (int)time(0));

	return 1;
}

static int script_GetTime2(lua_State *l)
{
	timeval tv;
	gettimeofday(&tv, 0);
	lua_pushnumber(l, (tv.tv_sec*1000+tv.tv_usec/1000));

	return 1;
}

//获取服务器时间
static int script_GetServerTime(lua_State *l)
{
	//timeval tval;
	//gettimeofday(&tval,NULL);
	//int servertime = (tval.tv_sec*1000000 + tval.tv_usec - g_offset)/1000000;
	//
	//lua_pushnumber(l, servertime);
	lua_pushnumber(l, Connection::GetInstance().GetServerTime());

	return 1;
}

static int script_IsNULL(lua_State *l)
{
	int n = lua_gettop(l);
	if(n != 1) return 0;

	void *p = lua_touserdata(l, 1);

	lua_pushboolean(l, !p);
	return 1;
}

static int _SendGameProtocol(lua_State *l, int type)
{
	int n = lua_gettop(l);
	if(n < 1) return 0;

	const char *cmd = lua_tostring(l, 1);

	std::vector<int64_t> extra_roles;
	std::vector<int64_t> extra_mafias;
	std::vector<int> extra_pvps;
	for(auto i=2; i<=n; i++)
	{
		const char *s = lua_tostring(l, i);
		if(*s == 'R')
		{
			//extra_role
			int64_t id = strtoll(s+1, 0, 10);
			if(id > 0) extra_roles.push_back(id);
		}
		else if(*s == 'M')
		{
			//extra_mafia
			int64_t id = strtoll(s+1, 0, 10);
			if(id > 0) extra_mafias.push_back(id);
		}
		else if(*s == 'P')
		{
			//extra_pvp
			int id = strtoll(s+1, 0, 10);
			if(id > 0) extra_pvps.push_back(id);
		}
		else
		{
			abort();
		}
	}

	Octets data(cmd, strlen(cmd));
	if(type == 1)
	{
		Connection::GetInstance().SendGameProtocol(data, extra_roles, extra_mafias, extra_pvps);
	}
	else if(type == 2)
	{
		Connection::GetInstance().SendUDPGameProtocol(data, extra_roles, extra_mafias, extra_pvps);
	}
	else
	{
		Connection::GetInstance().FastSess_Send(data, extra_roles, extra_mafias, extra_pvps);
	}

	return 0;
}

static int script_SendGameProtocol(lua_State *l)
{
	return _SendGameProtocol(l, 1);
}

static int script_SendUDPGameProtocol(lua_State *l)
{
	return _SendGameProtocol(l, 2);
}

static int script_SetRoleId(lua_State *l)
{
	int n = lua_gettop(l);
	if(n != 1) return 0;

	const char *r = lua_tostring(l, 1);
	g_roleid = strtoll(r, 0, 10);

	return 0;
}

static int script_FastSess_Send(lua_State *l)
{
	return _SendGameProtocol(l, 3);
}

static int script_FastSess_Open(lua_State *l)
{
	Connection::GetInstance().FastSess_Open();
	return 0;
}

static int script_FastSess_Reset(lua_State *l)
{
	Connection::GetInstance().FastSess_Reset();
	return 0;
}

static int script_GetNetType(lua_State *l)
{
	lua_pushinteger(l, Connection::GetInstance().P2P_GetNetType());
	return 1;
}

//static int script_IsGettingNetType(lua_State *l)
//{
//	lua_pushboolean(l, Connection::GetInstance().IsGettingNetType());
//	return 1;
//}
//
//static int script_TryGetNetType(lua_State *l)
//{
//	Connection::GetInstance().TryGetNetType();
//	return 0;
//}

static int script_TryMakeHole(lua_State *l)
{
	int n = lua_gettop(l);
	if(n != 3) return 0;

	int magic = lua_tointeger(l, 1);
	const char* ip = lua_tostring(l, 2);
	int port = lua_tointeger(l, 3);
	Connection::GetInstance().P2P_TryConnect(magic, ip, port);

	return 0;
}

static int script_SetPVPDInfo(lua_State *l)
{
	int n = lua_gettop(l);
	if(n != 2) return 0;

	g_pvpd_ip = lua_tostring(l, 1);
	g_pvpd_port = lua_tointeger(l, 2);
	//Connection::GetInstance().SetPVPDInfo(ip, port); TODO:

	return 0;
}

static int script_GetLatency(lua_State *l)
{
	lua_pushinteger(l, Connection::GetInstance().GetLatency());
	return 1;
}

static int script_GetPVPLatency(lua_State *l)
{
	lua_pushinteger(l, Connection::GetInstance().GetPVPLatency());
	return 1;
}

class GC: public GameClient
{
	int _index;
	std::string _policy;
	bool _random_seeded;

public:
	GC(int index, const char *policy): _index(index), _policy(policy), _random_seeded(false) {}

	virtual void OnServerMaintaining(const Octets& info)
	{
		fprintf(stderr, "OnServerMaintaining\n");
	}
	virtual void OnAuthFailed()
	{
		fprintf(stderr, "OnAuthFailed\n");
	}
	virtual void OnKickout(int reason)
	{
		fprintf(stderr, "OnKickout\n");
	}
	virtual void DoReload()
	{
		fprintf(stderr, "DoReload\n");

		g_L = luaL_newstate();
		if(g_L)
		{
			luaL_openlibs(g_L);
			lua_register(g_L, "API_Log", script_Log);
			lua_register(g_L, "API_GetTime", script_GetTime);
			lua_register(g_L, "API_GetTime2", script_GetTime2);
			lua_register(g_L, "API_GetServerTime", script_GetServerTime);
			lua_register(g_L, "API_IsNULL", script_IsNULL);
			lua_register(g_L, "API_SendGameProtocol", script_SendGameProtocol);
			lua_register(g_L, "API_SendUDPGameProtocol", script_SendUDPGameProtocol);
			lua_register(g_L, "API_SetRoleId", script_SetRoleId);
			lua_register(g_L, "API_FastSess_Send", script_FastSess_Send);
			lua_register(g_L, "API_FastSess_Open", script_FastSess_Open);
			lua_register(g_L, "API_FastSess_Reset", script_FastSess_Reset);
			lua_register(g_L, "API_GetNetType", script_GetNetType);
			//lua_register(g_L, "API_IsGettingNetType", script_IsGettingNetType);
			//lua_register(g_L, "API_TryGetNetType", script_TryGetNetType);
			lua_register(g_L, "API_TryMakeHole", script_TryMakeHole);
			lua_register(g_L, "API_SetPVPDInfo", script_SetPVPDInfo);
			lua_register(g_L, "API_GetLatency", script_GetLatency);
			lua_register(g_L, "API_GetPVPLatency", script_GetPVPLatency);

			if(luaL_dofile(g_L, "./scripts/init_command.lua"))
			{
				fprintf(stderr, "GC::DoReload, luaL_dofile(init_command.lua) error\n");
				lua_close(g_L);
				g_L = 0;
			}
		}
		if(g_L)
		{
			LuaWrapper lw(g_L);
			if(!lw.gExec("CreateThread", LuaParameter(_index, _policy.c_str())))
			{
				fprintf(stderr, "GC::DoReload, gExec error, CreateThread\n");
			}
		}
	}

	virtual void OnRecvGameProtocol(const Octets& lua_prot)
	{
		//check lua_prot
		if(lua_prot.size() < 2)
		{
			fprintf(stderr, "OnRecvGameProtocol, wrong length\n");
			return;
		}
		for(size_t i=0; i<lua_prot.size(); ++i)
		{
			int c = ((char*)lua_prot.begin())[i];
			if(!isupper(c) && !islower(c) && !isdigit(c) && c!='+' && c!='/' && c!='=' && c!=':' && c!='.')
			{
				fprintf(stderr, "OnRecvGameProtocol, wrong char(%d)\n", c);
				return;
			}
		}
		if(g_L)
		{
			LuaWrapper lw(g_L);
			if(!lw.gExec("DeserializeAndProcessCommand", LuaParameter((void*)0, std::string((char*)lua_prot.begin(), lua_prot.size()))))
			{
				fprintf(stderr, "OnRecvGameProtocol, gExec, DeserializeAndProcessCommand, %.*s\n", (int)lua_prot.size(), (char*)lua_prot.begin());
			}
		}
	}

	virtual time_t GetLocalTime()
	{
		return time(0);
	}
	virtual int64_t GetLocalTimeInMicroSec()
	{
		struct timeval tv;
		gettimeofday(&tv, 0);
		return (tv.tv_sec*1000000L+tv.tv_usec);
	}
	virtual int RandomInt()
	{
		if(!_random_seeded)
		{
			_random_seeded = true;
			srand((int)GetLocalTimeInMicroSec());
		}
		return rand();
	}
	virtual int64_t GetRoleId()
	{
		return g_roleid;
	}
	virtual const char* GetPVPDIP()
	{
		return g_pvpd_ip.c_str();
	}
	virtual unsigned short GetPVPDPort()
	{
		return g_pvpd_port;
	}
};

static std::string account = "Account";
static GC *gc = 0;

static void SIGUSR1_Handler(int sig)
{
#if 0
	//printf("SIGUSR1\n");
	Connection::GetInstance().Close();
	account += "_x";
	Connection::GetInstance().Open(gc, "10.68.8.16", 19228, account.c_str(), "123456", "10.68.8.16", 19229);
	//Connection::GetInstance().Open(gc, "10.68.8.39", 4001, account.c_str(), "123456", "10.68.8.39", 33229);
#endif
}

int main(int argc, char *argv[])
{
	if (argc != 4 || access(argv[1], R_OK) == -1)
	{
		std::cerr << "Usage: " << argv[0] << " configurefile index policy" << std::endl;
		exit(-1);
	}

	srandom(time(0));

	signal(SIGUSR1, SIGUSR1_Handler);

	Conf *conf = Conf::GetInstance(argv[1]);
	//Conf::GetInstance(argv[1]);
	Log::setprogname("client");

	GNET::InitStaticObjects();
	GNET::IOMan::_man.SetDelayThreshold(50, 500);
	GNET::PollIO::Init(true);
	GNET::Thread::Pool::_pool.Init(new ThreadPolicySingle());
	GNET::IntervalTimer::StartTimer(1000, true);
	GLog::Init("client");

	Log::setconsole(LOG_DEBUG, true);

	int index = atoi(argv[2]);
	account += argv[2];

	Connection::GetInstance().Initialize();
	gc = new GC(index, argv[3]);
	Connection::GetInstance().Open(gc, conf->find("Global", "ip").c_str(), atoi(conf->find("Global", "port").c_str()), account.c_str(), "123456", 
	                               conf->find("Global", "ip2").c_str(), atoi(conf->find("Global", "port2").c_str()));
	//Connection::GetInstance().Open(gc, "10.68.8.16", 19238, "duxg", "123456", "10.68.8.16", 19239);
	//Connection::GetInstance().Open(gc, "10.68.8.16", 9238, "pvprobot1", "123456", "10.68.8.16", 9239);

	int64_t t2 = 0;
	while(1)
	{
		PollIO::Poll(1);
		Timer::Update();
		IntervalTimer::UpdateTimer();
		Thread::Pool::_pool.TryProcessAllTask();
		STAT_MIN5("Poll",1);

		timeval tv;
		gettimeofday(&tv, 0);
		int64_t now = tv.tv_sec*(int64_t)1000000+tv.tv_usec;
		if(now-t2 >= 33*1000) //33ms
		{
			t2 = now;
			if(g_L)
			{
				LuaWrapper lw(g_L);
				if(!lw.gExec("Heartbeat"))
				{
					fprintf(stderr, "main, gExec error, Heartbeat\n");
				}
			}
		}
	}

	return 0;
}

void GameProtocol::Process(Manager *manager, Manager::Session::ID sid)
{
	//fprintf(stderr, "GameProtocol::Process, data=%s\n", B16EncodeOctets(data).c_str());
	//fprintf(stderr, "GameProtocol::Process, data=%.*s\n", (int)data.size(), (char*)data.begin());
	//printf("GameProtocol::Process, data=%.*s\n", (int)data.size(), (char*)data.begin());

	assert(((TransClient*)manager)->GetCurSID() == (int)sid);
	Connection::GetInstance().UpdateLatency(client_send_time, server_send_time);
	Connection::GetInstance().OnReceivedGameProtocol(data);
}

