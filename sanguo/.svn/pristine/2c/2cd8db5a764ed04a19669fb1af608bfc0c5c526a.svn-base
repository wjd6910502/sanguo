#include "customerserviceclient.hpp"
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
	if (argc < 3 || argc > 13 || access(argv[1], R_OK) == -1)
	{
		std::cerr << "Usage: " << argv[0] << " configurefile" << std::endl;
		exit(-1);
	}

	CustomerServiceClient::GetInstance()->typ = atoi(argv[2]);
	for(int index = 3; index < argc; index++)
	{
		CustomerServiceClient::GetInstance()->arg[index-3] = argv[index];
	}

	GNET::InitStaticObjects();
	GNET::IOMan::_man.SetDelayThreshold(50, 500);
	GNET::PollIO::Init(true);
	GNET::Thread::Pool::_pool.Init( new ThreadPolicySingle());
	GNET::IntervalTimer::StartTimer(50000, true);
	Conf *conf = Conf::GetInstance(argv[1]);
	Log::setprogname("customer");
	{
		CustomerServiceClient *manager = CustomerServiceClient::GetInstance();
		manager->SetAccumulate(atoi(conf->find(manager->Identification(), "accumulate").c_str()));
		if(NULL == Protocol::Client(manager))
		{
			std::cout << "初始化失败" << std::endl;
			return 0;
		}
		std::cout << "初始化成功" << std::endl;
		int time = Timer::GetTime();
		while(1)
		{
			GNET::PollIO::Poll(10);
			GNET::Timer::Update();
			GNET::IntervalTimer::UpdateTimer();
			GNET::Thread::Pool::_pool.TryProcessAllTask();
			if(Timer::GetTime() - time > 10)
			{
				std::cout << "server error" << std::endl;
				break;
			}
		}
	}

	return 0;
}

