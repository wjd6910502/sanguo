
#include <string.h>
#include <stdlib.h>
#include "connectionMgr.h"
#include "connection.h"
#include "transclient.hpp"

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
	static time_t first_t = 0;

	timeval tv;
	gettimeofday(&tv, 0);

	if(first_t==0) first_t=tv.tv_sec;
	tv.tv_sec -= first_t;

	lua_pushinteger(l, (int)(tv.tv_sec*1000000+tv.tv_usec));

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

/**
 * @brief 这个函数对应脚本函数API_SendGameProtocol,为了做底层脚本协议的分发，必须第一个参数是g_main_thread_index,第二个为对应的cmd
 * 		   
 * @param index 代表机器人序列索引
 *		  cmd   消息协议
 *
 */
static int script_SendGameProtocol(lua_State *l)
{
	int n = lua_gettop(l);
	if(n < 1) return 0;
	
	int index       = lua_tointeger(l, 1);
	const char *cmd = lua_tostring(l, 2);

	std::vector<int64_t> extra_roles;
	std::vector<int64_t> extra_mafias;
	for(auto i=3; i<=n; i++)
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
		else
		{
			abort();
		}
	}

	Octets data(cmd, strlen(cmd));
	
	ConnectionMgr::GetInstance().SendProtocolByIndex(index,data,extra_roles,extra_mafias);
	
	return 0;
}

class GC: public GameClient
{
	int _index;
	std::string _policy;
public:
	
	lua_State* g_L;
	GC(int index, const char *policy): _index(index), _policy(policy), g_L(0) {}
	
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
		
		if(!g_L)
		{
			g_L = luaL_newstate();
			if(g_L)
			{
				luaL_openlibs(g_L);
				lua_register(g_L, "API_Log", script_Log);
				lua_register(g_L, "API_GetTime", script_GetTime);
				lua_register(g_L, "API_GetTime2", script_GetTime2);
				lua_register(g_L, "API_IsNULL", script_IsNULL);
				lua_register(g_L, "API_SendGameProtocol", script_SendGameProtocol);
				if(luaL_dofile(g_L, "./scripts/init_command.lua"))
				{
					fprintf(stderr, "GC::DoReload, luaL_dofile(init.lua) error\n");
					lua_close(g_L);
					g_L = 0;
				}
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
};

ConnectionMgr::ConnectionMgr()
{
	gateCnt = 0;
	maxCnt = 0;
}
	
ConnectionMgr::~ConnectionMgr()
{
	auto it = m_mapCon.begin();
	for(; it != m_mapCon.end(); it++)
	{
		Connection *p = it->second;
		if(p != NULL)
		{
			delete p;
			p = NULL;
		}
	}
	m_mapCon.clear();

	auto it1 = m_mapTranCon.begin();
	for(; it1 != m_mapTranCon.end(); it1++)
	{
		Connection *p = it->second;
		if(p != NULL)
		{
			delete p;
			p = NULL;
		}		
	}
	m_mapTranCon.clear();

	auto iter = m_veCon.begin();
	for(; iter != m_veCon.end(); iter++)
	{
		Connection *p = *iter;
		if(p != NULL)
		{
			delete p;
			p = NULL;
		}
	}
	m_veCon.clear();

}

void ConnectionMgr::Initialize(std::string gateIp, unsigned short gatePort, std::string statusIp, unsigned short statusPort)
{
	_gate_ip     = gateIp;
	_gate_port   = gatePort;
	_status_ip   = statusIp;
	_status_port = statusPort;		
}

bool ConnectionMgr::StartMultConnection(int startIdx, int cnt, std::string accountHeader, std::string password)
{
	//set maxcnt
	maxCnt = cnt;

	for(int i = startIdx; i< startIdx + maxCnt; i++)
	{
		Connection* pConn = CreateNewConn();
		if( pConn == NULL )
			return false;
	
		GC* gc = new  GC(i,password.c_str());
		if(gc == NULL)
			return false;

		char s[256];
		memset(s,'0',256);
		sprintf(s,"%d",i);		
		std::string account = accountHeader + s;	
		pConn->Open(gc, i, account.c_str(), "123456" );		
		m_veCon.push_back(pConn);
	}

	return true;		
}
	
bool ConnectionMgr::RegisterCon(Protocol::Manager* mgr,unsigned int sid, int connect_type)
{
	if(sid == 0)
		return false;
	
	//从vector中删除触发连接服务器的connection,建立sid与connection的map
	if(connect_type == GATECLIENT_CONNECT)
	{
		auto iter = m_veCon.begin();
		if(iter == m_veCon.end())
			return false;

		Connection* pConn = *iter;
		iter = m_veCon.erase(iter);
		if(pConn == NULL)
			return false;
		
		auto it = m_mapCon.find(mgr);
		if(it == m_mapCon.end())
		{
			m_mapCon.insert(std::make_pair(mgr,pConn));
		}
		//IntervalTimer::Attach(pConn, (1000000)/IntervalTimer::Resolution());
		pConn->Initialize();
	}
	
	if(connect_type == TRANSCLIENT_CONNECT)
	{
		auto iter = m_mapCon.begin();

		Connection* pConn = iter->second;
		m_mapCon.erase(iter++);
		if(pConn == NULL)
			return false;
		
		auto it = m_mapTranCon.find(mgr);
		if( it == m_mapTranCon.end() )
		{
			m_mapTranCon.insert(std::make_pair(mgr,pConn));
		}
	}	

	return true;	
}

bool ConnectionMgr::UnRegisterCon(Protocol::Manager *mgr, unsigned int sid, int connect_type)
{
	if(sid == 0)
		return false;

	if(connect_type == TRANSCLIENT_CONNECT)
	{
		auto it = m_mapTranCon.find(mgr);
		if( it != m_mapTranCon.end() )
		{
			m_mapCon.insert(std::make_pair(mgr, it->second));
			m_mapTranCon.erase(it++);
		}
	}	
	
	if(connect_type == STATUSCLIENT_CONNECT)
	{
		auto it = m_mapTranCon.find(mgr);
		if( it != m_mapTranCon.end() ) 
		{
			m_mapCon.insert(std::make_pair(mgr, it->second));
			m_mapTranCon.erase(it++);		
		}
		else
		{
			it = m_mapCon.find(mgr);
			if( it != m_mapCon.end() ) 
			{
				m_veCon.push_back(it->second);
				m_mapCon.erase(it++);
			}					
		}
	}

	return true;	
}

Connection* ConnectionMgr::FindGConBymgr(Protocol::Manager *mgr)
{	
	auto iter = m_mapCon.find(mgr);
	if( iter != m_mapCon.end() )
		return iter->second;

	return NULL;
}

Connection* ConnectionMgr::FindTConBymgr(Protocol::Manager *mgr)
{
	auto iter = m_mapTranCon.find(mgr);
	if( iter != m_mapTranCon.end() )
		return iter->second;

	return NULL;
}

void ConnectionMgr::OnChallenge(Protocol::Manager *manager, int sid, const Octets& server_rand1)
{
	Connection* pConn = FindGConBymgr(manager);
	if(pConn == NULL)
		return;

	pConn->OnChallenge(manager,sid,server_rand1);		
}

void ConnectionMgr::OnAuthResult(Protocol::Manager *manager, int sid, int retcode, const Octets& trans_ip, unsigned short trans_port, const Octets& trans_token)
{
	Connection* pConn = FindGConBymgr(manager); 
	if(pConn == NULL) 
		return;
		
	pConn->OnAuthResult(manager,sid,retcode,trans_ip,trans_port,trans_token);			
	gateCnt++;
								
	fprintf(stderr,"---------------------- gateCnt = %d, maxCnt = %d\n",gateCnt,maxCnt);
	//如果获取的所有状态都为可以连接transclient状态
	if(gateCnt >= maxCnt )
	{
		auto iter = m_mapCon.begin();
		for(int i = 0; i < maxCnt && iter != m_mapCon.end(); iter++, i++)	
		{	
			Connection* pConn = iter->second;
			PWASSERT(pConn);
			
			TransClient* pTranclient = pConn->GetTransClient();
			PWASSERT(pTranclient);

			pTranclient->Init(pConn->GetTransIP(), pConn->GetTransPort());
			Protocol::Client(pTranclient);		
		}		
	}
}

void ConnectionMgr::OnTransChallenge(Protocol::Manager *manager, int sid, const Octets& server_rand2)
{
	Connection* pConn = FindTConBymgr(manager);
	if(pConn == NULL)
		return;
		
	pConn->OnTransChallenge(manager,sid,server_rand2);	
}

void ConnectionMgr::OnTransAuthResult(Protocol::Manager *manager, int sid, int retcode, int server_received_count, bool do_reset)
{
	Connection* pConn = FindTConBymgr(manager);
	if(pConn == NULL)
		return;
		
	pConn->OnTransAuthResult(manager,sid,retcode,server_received_count,do_reset);	
}

void ConnectionMgr::OnContinue(Protocol::Manager *manager, int sid, bool reset)
{	
	Connection* pConn = FindTConBymgr(manager);
	if(pConn == NULL)
		return;
	
	pConn->OnContinue(manager,sid,reset);							
}

void ConnectionMgr::OnTransLostConnection(Protocol::Manager *manager, int sid)
{
	Connection* pConn = FindTConBymgr(manager);
	if(pConn == NULL)
		return;
		
	pConn->OnTransLostConnection(manager,sid);			
}

void ConnectionMgr::OnKickout(Protocol::Manager *manager, int sid, int reason)
{

	Connection* pConn = FindTConBymgr(manager);
	if(pConn == NULL)
		return;
		
	pConn->OnKickout(manager,sid,reason);				
}

void ConnectionMgr::OnServerStatus(Protocol::Manager *manager, int sid, const Octets& info)
{
	Connection* pConn = FindTConBymgr(manager);
	if(pConn == NULL)
		return;
	
	pConn->OnServerStatus(manager,sid,info);			
}

void ConnectionMgr::SendProtocolByIndex(int index, const Octets& data, const std::vector<int64_t>& extra_roles, const std::vector<int64_t>& extra_mafias)	
{
	//考虑是否可以用算法函数代替这种的查找方法
	auto iter = m_mapTranCon.begin();
	for(;iter != m_mapTranCon.end() ; iter++)
	{
		Connection* pConn = iter->second;
		if( pConn && pConn->GetIndex() == index )
		{
			pConn->SendGameProtocol(data,extra_roles,extra_mafias);
			break;
		}
	}		
}

lua_State* ConnectionMgr::GetGLandReiveProtocol(Protocol::Manager *manager)
{
	Connection *pConn = FindTConBymgr(manager);	
	if(pConn == NULL)
		return NULL;
	
	GC* pgc = (GC*)pConn->GetGC();
	if(pgc == NULL)
		return NULL;
	
	pConn->OnReceivedGameProtocol(); 

	return pgc->g_L;	
}

void ConnectionMgr::StartAllHeartBeat()
{
	auto iter = m_mapTranCon.begin(); 
	for(; iter != m_mapTranCon.end(); iter++)
	{		
		Connection *pConn = (Connection*)iter->second;
		if(pConn == NULL) return;
	
		GC* pgc = (GC*)pConn->GetGC();
		if(pgc == NULL) return;
	
		lua_State* g_L = pgc->g_L;
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

