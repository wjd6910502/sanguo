
#ifndef __GNET_ROLEINFOREGISTER_HPP
#define __GNET_ROLEINFOREGISTER_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include "mysql_connector.hpp"
#include "protocol.h"
#include "thread.h"

extern std::map<std::string, Roleinfo> g_mapcacherolinfo;
//extern std::mutex g_lock;
extern Thread::Mutex g_locker_state;
namespace GNET
{

class RoleinfoRegister : public GNET::Protocol
{
	#include "roleinforegister"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		/*
		MysqlConnector db;
		db.initDB("localhost","root","","douban");
		
		char sql[1024];
		memset(sql,'\0',1024);
		
		std::string roleaccount = (char*)account.begin();
		std::string rolename = (char*)name.begin();
		sprintf(sql,"insert into t1 values(%s,%d,%s,%d,%d)",roleaccount.c_str(),zone_id,rolename.c_str(),level,photo);
		db.exeSQL(sql);
		*/
		cout << " Rioleinfio s ----------------------------------------" <<endl;
		Roleinfo r;
		r.account = std::string((char*)account.begin(),account.size());
		r.name = std::string((char*)name.begin(),name.size());
		r.level = level;
		r.zoneid = zone_id;
		r.photo = photo;

		char tempkey[128];
		memset(tempkey,'\0',128);
		sprintf(tempkey,"%s%d",r.account.c_str(),zone_id);
		r.account2zoneid = tempkey;
		
		//g_lock.lock();
		GNET::Thread::Mutex::Scoped scoped_lock(g_locker_state);
		g_mapcacherolinfo.insert(make_pair(r.account2zoneid,r));
		//g_lock.unlock();
		scoped_lock.Unlock();
	}
};

};

#endif
