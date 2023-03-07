#include "uniquenameserver.hpp"
#include "conf.h"
#include "log.h"
#include "thread.h"
#include <iostream>
#include <unistd.h>

#include "storage.h"
#include "storagetool.h"

using namespace GNET;

class DbPolicy : public Thread::Pool::Policy
{
	public:
		virtual void OnQuit( )
		{
                	StorageEnv::checkpoint( );
                	StorageEnv::Close();
        	}
};

static DbPolicy s_policy;

int main(int argc, char *argv[])
{
	if (argc != 2 || access(argv[1], R_OK) == -1)
	{
		std::cerr << "Usage: " << argv[0] << " configurefile" << std::endl;
		exit(-1);
	}

	Conf *conf = Conf::GetInstance(argv[1]);
	
	Log::setprogname("uniquenamed");
	if(!StorageEnv::Open())
	{
		Log::log(LOG_ERR,"Initialize storage environment failed.\n");
		exit(-1);
	}

	{
		UniqueNameServer *manager = UniqueNameServer::GetInstance();
		manager->SetAccumulate(atoi(conf->find(manager->Identification(), "accumulate").c_str()));
		Protocol::Server(manager);
	}

	Thread::Pool::AddTask(PollIO::Task::GetInstance());
	pthread_t       th;
	pthread_create( &th, NULL, &StorageEnv::BackupThread, NULL );
	Thread::Pool::Run( &s_policy );
	return 0;
}
