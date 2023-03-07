
#include "conf.h"
#include "log.h"
#include "thread.h"
#include <iostream>
#include <unistd.h>
#include "gnet_init.h"
#include <vector>
#include <map>
#include <thread>
#include "mysql_connector.hpp"
#include "registerserver.hpp"


using namespace GNET;


#define MAX_UPDATE_TIME 10
std::map<std::string, Roleinfo> g_mapcacherolinfo;
std::map<std::string, Roleinfo> g_mapupdaterolinfo;
//std::mutex g_lock;
Thread::Mutex g_locker_state("RegisterUpdateRoleinfo");
static int g_currenttime;

static void* UpdateRoleinfo2Https(void *arg)
{
	while(true)
	{
		time_t now_t = time(NULL);
	
		if( !g_mapcacherolinfo.empty() && ( g_currenttime == 0 || now_t - g_currenttime > MAX_UPDATE_TIME) )
		{
			cout<<"thread insert data"<<endl;
			//g_lock.lock();
			Thread::Mutex::Scoped scoped_lock(g_locker_state);
			g_mapupdaterolinfo.swap(g_mapcacherolinfo);	
			
			g_mapcacherolinfo.clear();
			g_mapcacherolinfo.swap(std::map<std::string, Roleinfo>());
		
			//g_lock.unlock();
			scoped_lock.Unlock();

			g_currenttime = now_t;

			//处理相关树冠数据插入
			MysqlConnector db;
			if(!g_mapupdaterolinfo.empty() && db.initDB("localhost","root","Sanguo6910502","douban"))
			{
		
				char sql[1024];
				auto ibeg = g_mapupdaterolinfo.begin();
				for(;ibeg != g_mapupdaterolinfo.end(); ibeg++)
				{
					memset(sql,'\0',1024);
					Roleinfo rr = ibeg->second;
					cout<<"account ="<<rr.account<<rr.account2zoneid<<rr.zoneid<<rr.name<<rr.level<<rr.photo<<endl;
					sprintf(sql,"replace into t2 values(\"%s\",\"%s\",%d,\"%s\",%d,%d)",rr.account.c_str(),rr.account2zoneid.c_str(),rr.zoneid,rr.name.c_str(),rr.level,rr.photo);
					cout<<"sql ="<<sql<<endl;
					db.exeSQL(sql);
				}
			}
		}
		
		//清空内存
		g_mapupdaterolinfo.clear();
		g_mapupdaterolinfo.swap(std::map<std::string, Roleinfo>());
		sleep(1); //空跑的话会占用CPU 100%
	}
	return 0;	
}


int main(int argc, char *argv[])
{
	if (argc < 2)
	{
		std::cerr << "Usage: " << argv[0] << " configurefile" << std::endl;
		exit(-1);
	}
	
	//test
	/*if (argc == 5)
	{
		std::cout << " zoneid argv[2]: " << argv[2] << " level argv[3]: " << argv[3] << " photo argv[4]: " << argv[4]<< std::endl; 
		for(int i =1; i < 100; i++)
		{	
			//插入数据
			int zoneid = atoi(argv[2]);
			int level = atoi(argv[3]);
			int photo = atoi(argv[4]);
		
			Roleinfo r;
			r.account = "www";
			r.name = "baga";
			r.level = level;
			r.zoneid = zoneid;
			r.photo = photo;

			char tempkey[128];
			memset(tempkey,'\0',128);
			sprintf(tempkey,"%s%d",r.account.c_str(),zoneid);
			r.account2zoneid = tempkey;

			g_mapcacherolinfo.insert(make_pair(r.account2zoneid,r));
		}
	}*/

	g_currenttime = 0;
	Conf *conf = Conf::GetInstance(argv[1]);
	Log::setprogname("register");
	{
		RegisterServer *manager = RegisterServer::GetInstance();
		manager->SetAccumulate(atoi(conf->find(manager->Identification(), "accumulate").c_str()));
		Protocol::Server(manager);
	}
	
	GNET::Thread::Pool::_pool.CreateThread(UpdateRoleinfo2Https, NULL); 

	GNET::InitStaticObjects();
	GNET::IOMan::_man.SetDelayThreshold(50, 500);
	GNET::PollIO::Init(true);
	GNET::Thread::Pool::_pool.Init( new ThreadPolicySingle());
	GNET::IntervalTimer::StartTimer(50000, true);
	
	while(1)
	{
		GNET::PollIO::Poll(10);
		GNET::Timer::Update();
		GNET::IntervalTimer::UpdateTimer();
		GNET::Thread::Pool::_pool.TryProcessAllTask();
	}

	return 0;
}

