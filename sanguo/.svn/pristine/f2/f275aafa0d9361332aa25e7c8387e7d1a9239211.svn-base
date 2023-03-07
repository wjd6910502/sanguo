#include "uniquenameserver.hpp"
#include "conf.h"
#include "log.h"
#include "thread.h"
#include <iostream>
#include <unistd.h>
#include "gnet_init.h"
#include "leveldb.h"
#include "write_batch.h"

using namespace GNET;

leveldb::DB* g_db;
int main(int argc, char *argv[])
{
	if (argc != 2 || access(argv[1], R_OK) == -1)
	{
		std::cerr << "Usage: " << argv[0] << " configurefile" << std::endl;
		exit(-1);
	}

	Conf *conf = Conf::GetInstance(argv[1]);
	
	GNET::InitStaticObjects();
	//GNET::IOMan::_man.SetDelayThreshold(50, 500);
	GNET::PollIO::Init(true);
	GNET::Thread::Pool::_pool.Init(new ThreadPolicySingle());
	GNET::IntervalTimer::StartTimer(1000, true);
	GLog::Init("pvpd");
	{
		UniqueNameServer *manager = UniqueNameServer::GetInstance();
		manager->SetAccumulate(atoi(conf->find(manager->Identification(), "accumulate").c_str()));
		Protocol::Server(manager);
	}

	Log::setconsole(LOG_DEBUG, true);

	leveldb::Options options;
	options.create_if_missing = true;
	std::string dbpath = "game_db";
	leveldb::Status status = leveldb::DB::Open(options, dbpath, &g_db);

	if(!status.ok())
	{
		GLog::log(LOG_ERR,"Initialize storage environment failed.\n");
		exit(-1);
	}

	while(1)
	{
		PollIO::Poll(1);
		Timer::Update();
		IntervalTimer::UpdateTimer();
		Thread::Pool::_pool.TryProcessAllTask();
		STAT_MIN5("Poll",1);
	}
	delete g_db;
	return 0;
}

