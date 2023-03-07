#ifndef _CONNECTION_MGR_H_
#define _CONNECTION_MGR_H_

#include <map>
#include <string>
#include <vector>
#include "commonmacro.h"
#include "script_wrapper.h"
#include "gnet_init.h"
#include "protocol.h"
#include "thread.h"
#include "conf.h"
#include "log.h"
#include <iostream>
#include <unistd.h>
#include <algorithm>
#include <lua.hpp>

#include "connection.h"

#define PWASSERT(p)  ({ if(p == NULL) return; })
#define PWASSERTR(p)  ({ if(p == NULL) return 0; })

enum CONNECT_TYPE
{
	GATECLIENT_CONNECT   = 0,	
	TRANSCLIENT_CONNECT  = 1,
	STATUSCLIENT_CONNECT = 2,	
};

class GC;

class ConnectionMgr
{
private:
	ConnectionMgr();	
	
	std::vector<Connection* > m_veCon;    
	std::map<Protocol::Manager*, Connection* > m_mapCon;     // 对应gatesid--Connnection的map
	std::map<Protocol::Manager*, Connection* > m_mapTranCon; // 对应transid--Connnection的map 
	
	std::string _gate_ip;
	unsigned short _gate_port;
	std::string _status_ip;
	unsigned short _status_port;
	
	int gateCnt;
	int maxCnt;
public:
	~ConnectionMgr();
	static ConnectionMgr& GetInstance() { static ConnectionMgr _instance; return _instance; }	

	std::string GetGateIP() { return _gate_ip; }
	unsigned short GetGatePort() { return _gate_port; }
	std::string GetStatusIP() { return _status_ip; }
	unsigned short GetStatusPort() { return _status_port; }
			
	Connection* CreateNewConn() { return new Connection(); }
	Connection* FindGConBymgr(Protocol::Manager *mgr);
	Connection* FindTConBymgr(Protocol::Manager *mgr);

	/** 
	 * 	@brief  初始化gate的ip和port,server的ip和port
	 */
	void Initialize(std::string gateIp, unsigned short gatePort, std::string statusIp, unsigned short statusPort);
	
	/**
	 *	@brief  启动多个机器人连接
	 *	
	 *	@param  startIdx       机器人开始序号
	 *			cnt            机器人个数	
	 *			accountHeader  机器人账号头部 机器人账号 = 机器人账号头部 + 机器人序号
	 *			password       机器人密码
	 */
	bool StartMultConnection(int startIdx, int cnt, std::string accountHeader, std::string password);
	
	/**
	 * 	@brief  注册sid对应的connection
	 *	
	 * 	@param  sid      connection对应sid
	 * 		    connect_type  connection连接类型
	 */
	bool RegisterCon(Protocol::Manager *mgr, unsigned int sid, int connect);
	bool UnRegisterCon(Protocol::Manager *mgr, unsigned int sid, int connect_type);

	void OnChallenge(Protocol::Manager *manager, int sid, const Octets& server_rand1);
	void OnAuthResult(Protocol::Manager *manager, int sid, int retcode, const Octets& trans_ip, unsigned short trans_port, const Octets& trans_token);
	void OnTransChallenge(Protocol::Manager *manager, int sid, const Octets& server_rand2);
	void OnTransAuthResult(Protocol::Manager *manager, int sid, int retcode, int server_received_count, bool do_reset);
	void OnContinue(Protocol::Manager *manager, int sid, bool reset);
	void OnTransLostConnection(Protocol::Manager *manager, int sid);
	void OnKickout(Protocol::Manager *manager, int sid, int reason);
	void OnServerStatus(Protocol::Manager *manager, int sid, const Octets& info);
	
	/**
	 *  @ brief 根据机器人序号来分发协议
	 */
	void SendProtocolByIndex(int index, const Octets& data, const std::vector<int64_t>& extra_roles, const std::vector<int64_t>& extra_mafias);		
	
	/**
	 *  @brief 根据manager获取g_L和计数
	 */
	lua_State* GetGLandReiveProtocol(Protocol::Manager *manager);

	/**
	 *  @brief 启动所有机器人心跳
	 */ 
	void  StartAllHeartBeat();
};

#endif
