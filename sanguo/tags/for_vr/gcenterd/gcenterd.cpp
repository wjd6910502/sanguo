#include "gmserver.hpp"
#include "gcenterserver.hpp"
#include "conf.h"
#include "thread.h"
#include <iostream>
#include <unistd.h>
#include "pollio.h"
#include "threadpolicy.h"
#include "gnet_init.h"
#include "pvpgameserver.hpp"
#include "glog.h"
#include "common_var.h"
#include <map>
#include <vector>

using namespace GNET;
leveldb::DB* g_db = NULL;

//std::map< int,std::vector<package_gift> > g_gift;

int main(int argc, char *argv[])
{
	if (argc != 2)
	{
		std::cerr << "Usage: " << argv[0] << " configurefile" << std::endl;
		exit(-1);
	}
	
	{
		leveldb::Options options;
		options.create_if_missing = true;
		std::string dbpath = "game_db";
		leveldb::Status status = leveldb::DB::Open(options, dbpath, &g_db);
		if(!status.ok())
		{
			Log::log(LOG_ERR,"Initialize storage environment failed.\n");
			exit(-1);
		}
	}
	
	//GNET::InitGift();

	GNET::InitStaticObjects();
	GNET::IOMan::_man.SetDelayThreshold(50, 500);
	GNET::PollIO::Init(true);
	GNET::Thread::Pool::_pool.Init( new ThreadPolicySingle());
	GNET::IntervalTimer::StartTimer(50000, true);
	Conf *conf = Conf::GetInstance(argv[1]);

	GLog::Init("gcenterd");
	{
		GMServer *manager = GMServer::GetInstance();
		manager->SetAccumulate(atoi(conf->find(manager->Identification(), "accumulate").c_str()));
		Protocol::Server(manager);
	}

	{
		GCenterServer *manager = GCenterServer::GetInstance();
		manager->SetAccumulate(atoi(conf->find(manager->Identification(), "accumulate").c_str()));
		//manager->InitDB();
		Protocol::Server(manager);
	}

	{
		PVPGameServer *manager = PVPGameServer::GetInstance();
		manager->SetAccumulate(atoi(conf->find(manager->Identification(), "accumulate").c_str()));
		Protocol::Server(manager);
	}

	while(1)
	{
		GNET::PollIO::Poll(10);
		GNET::Timer::Update();
		GNET::IntervalTimer::UpdateTimer();
		GNET::Thread::Pool::_pool.TryProcessAllTask();
	}

	return 0;
}

