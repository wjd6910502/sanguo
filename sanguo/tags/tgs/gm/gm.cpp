#include "gmclient.hpp"
#include "conf.h"
#include "log.h"
#include "thread.h"
#include <iostream>
#include <unistd.h>
#include "parsestring.h"
#include "pollio.h"
#include "threadpolicy.h"
#include "gnet_init.h"

using namespace GNET;
using namespace std;

int main(int argc, char *argv[])
{
	if(argc < 3 || argc > 9)
	{
		std::cerr << "Usage: " << argv[0] << " configurefile" << std::endl;
		exit(-1);
	}

	GMClient::GetInstance()->game_sys_file = argv[1];
	GMClient::GetInstance()->cmd = atoi(argv[2]);
	for(int index = 3; index < argc; index++)
	{
		GMClient::GetInstance()->arg[index-3] = argv[index];
	}
	
	GNET::InitStaticObjects();
	GNET::IOMan::_man.SetDelayThreshold(50, 500);
	GNET::PollIO::Init(true);
	GNET::Thread::Pool::_pool.Init( new ThreadPolicySingle());
	GNET::IntervalTimer::StartTimer(50000, true);
	Conf *conf = Conf::GetInstance(argv[1]);
	
	Log::setprogname("gm");
	{
		GMClient *manager = GMClient::GetInstance();
		manager->SetAccumulate(atoi(conf->find(manager->Identification(), "accumulate").c_str()));
		Protocol::Client(manager);
	}

	int time = Timer::GetTime();
	while(1)
	{
		GNET::PollIO::Poll(10);
		GNET::Timer::Update();
		GNET::IntervalTimer::UpdateTimer();
		GNET::Thread::Pool::_pool.TryProcessAllTask();
		if(Timer::GetTime() - time > 60)
		{
			cout << "server error" << endl;
			break;
		}
	}

	return 0;
}

