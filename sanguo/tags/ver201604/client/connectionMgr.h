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
	std::map<Protocol::Manager*, Connection* > m_mapCon;     // ��Ӧgatesid--Connnection��map
	std::map<Protocol::Manager*, Connection* > m_mapTranCon; // ��Ӧtransid--Connnection��map 
	
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
	 * 	@brief  ��ʼ��gate��ip��port,server��ip��port
	 */
	void Initialize(std::string gateIp, unsigned short gatePort, std::string statusIp, unsigned short statusPort);
	
	/**
	 *	@brief  �����������������
	 *	
	 *	@param  startIdx       �����˿�ʼ���
	 *			cnt            �����˸���	
	 *			accountHeader  �������˺�ͷ�� �������˺� = �������˺�ͷ�� + ���������
	 *			password       ����������
	 */
	bool StartMultConnection(int startIdx, int cnt, std::string accountHeader, std::string password);
	
	/**
	 * 	@brief  ע��sid��Ӧ��connection
	 *	
	 * 	@param  sid      connection��Ӧsid
	 * 		    connect_type  connection��������
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
	 *  @ brief ���ݻ�����������ַ�Э��
	 */
	void SendProtocolByIndex(int index, const Octets& data, const std::vector<int64_t>& extra_roles, const std::vector<int64_t>& extra_mafias);		
	
	/**
	 *  @brief ����manager��ȡg_L�ͼ���
	 */
	lua_State* GetGLandReiveProtocol(Protocol::Manager *manager);

	/**
	 *  @brief �������л���������
	 */ 
	void  StartAllHeartBeat();
};

#endif
