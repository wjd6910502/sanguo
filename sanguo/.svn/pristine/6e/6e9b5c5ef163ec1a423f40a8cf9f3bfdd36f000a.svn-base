#include "laohuinformclient.hpp"
#include "conf.h"
#include "log.h"
#include "thread.h"
#include <iostream>
#include <unistd.h>
#include "pollio.h"
#include "threadpolicy.h"
#include "gnet_init.h"

bool hasfinish=false;

using namespace GNET;

int main(int argc, char *argv[])
{
	if (argc != 2 || access(argv[1], R_OK) == -1)
	{
		std::cerr << "Usage: " << argv[0] << " configurefile" << std::endl;
		exit(-1);
	}
	
	GNET::InitStaticObjects();
	GNET::IOMan::_man.SetDelayThreshold(50, 500);
	GNET::PollIO::Init(true);
	GNET::Thread::Pool::_pool.Init( new ThreadPolicySingle());
	GNET::IntervalTimer::StartTimer(50000, true);
	Conf *conf = Conf::GetInstance(argv[1]);
	
	//GLog::Init("laohuinform");	
	{
		LaohuInformClient *manager = LaohuInformClient::GetInstance();
		manager->SetAccumulate(atoi(conf->find(manager->Identification(), "accumulate").c_str()));
		Protocol::Client(manager);
	}
	
	int time = Timer::GetTime();
	while(1)
	{
		GNET::PollIO::Poll(1);
		GNET::Timer::Update();
		GNET::IntervalTimer::UpdateTimer();
		GNET::Thread::Pool::_pool.TryProcessAllTask();
		if(hasfinish || Timer::GetTime() - time > 5)
			break;
	}	

	return 0;
}

