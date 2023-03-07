#include "verificationclient.hpp"
#include "conf.h"
#include "log.h"
#include "thread.h"
#include <iostream>
#include <unistd.h>
#include "gnet_init.h"

using namespace GNET;

int main(int argc, char *argv[])
{
	if (argc != 2 || access(argv[1], R_OK) == -1)
	{
		std::cerr << "Usage: " << argv[0] << " configurefile" << std::endl;
		exit(-1);
	}

	Conf *conf = Conf::GetInstance(argv[1]);
	Log::setprogname("verification");
	
	GNET::InitStaticObjects();
	GNET::IOMan::_man.SetDelayThreshold(50, 500);
	GNET::PollIO::Init(true);
	GNET::Thread::Pool::_pool.Init(new ThreadPolicySingle());
	GNET::IntervalTimer::StartTimer(1000, true);
	GLog::Init("verification");

	{
		VerificationClient *manager = VerificationClient::GetInstance();
		manager->SetAccumulate(atoi(conf->find(manager->Identification(), "accumulate").c_str()));
		manager->SetBattleVer(atoi(conf->find(manager->Identification(), "battle_ver").c_str()));
		Protocol::Client(manager);
	}

	Log::setconsole(LOG_DEBUG, true);
	
	while(1)
	{
		PollIO::Poll(1);
		Timer::Update();
		IntervalTimer::UpdateTimer();
		Thread::Pool::_pool.TryProcessAllTask();
		//STAT_MIN5("Poll",1);
	}

	return 0;
}

