#include "statusserver.hpp"
#include "conf.h"
#include "log.h"
#include "thread.h"
#include <iostream>
#include <unistd.h>
#include "gnet_init.h"
#include <signal.h>

using namespace GNET;

void SigHandler_USR1(int sig)
{
	GLog::log(LOG_INFO, "SigHandler_USR1, sig=%d", sig);
	if(sig == SIGUSR1)
	{
		StatusServer::SetPrompt();
	}
}

int main(int argc, char *argv[])
{
	if (argc != 2 || access(argv[1], R_OK) == -1)
	{
		std::cerr << "Usage: " << argv[0] << " configurefile" << std::endl;
		exit(-1);
	}

	signal(SIGUSR1, SigHandler_USR1);

	Conf *conf = Conf::GetInstance(argv[1]);
	Log::setprogname("statusd");

	GNET::InitStaticObjects();
	//GNET::IOMan::_man.SetDelayThreshold(50, 500);
	GNET::PollIO::Init(true);
	GNET::Thread::Pool::_pool.Init(new ThreadPolicySingle());
	GNET::IntervalTimer::StartTimer(1000, true);
	GLog::Init("statusd");

	{
		StatusServer *manager = StatusServer::GetInstance();
		StatusServer::SetPrompt();
		manager->SetAccumulate(atoi(conf->find(manager->Identification(), "accumulate").c_str()));
		Protocol::Server(manager);
	}

	Log::setconsole(LOG_DEBUG, true);

	while(1)
	{
		//prof_stat::Instance().before_poll();
		PollIO::Poll(1);
		//prof_stat::Instance().after_poll();
		Timer::Update();
		IntervalTimer::UpdateTimer();
		//prof_stat::Instance().before_task();
		Thread::Pool::_pool.TryProcessAllTask();
		//prof_stat::Instance().after_task();
		STAT_MIN5("Poll",1);
	}

	return 0;
}

