
#include "conf.h"
#include "log.h"
#include "thread.h"
#include <iostream>
#include <unistd.h>
#include "storage.h"

#include "gaccodeserver.hpp"
#include "active_code_manager.h"

using namespace GNET;

void Usage(const char* exe)
{	
	std::cerr << "Usage: " << exe << " configurefile" << std::endl;
	std::cerr << "Usage: " << exe << " configurefile" << std::endl
							<< "\t[ mkcode type count use_time ]" << std::endl;

}

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
	if (argc < 2 || access(argv[1], R_OK) == -1)
	{
		Usage(argv[0]);
		exit(-1);
	}

	Conf *conf = Conf::GetInstance(argv[1]);
	if(!StorageEnv::Open())
	{
		Log::log(LOG_ERR,"Initialize storage environment failed.\n");
		exit(-1);
	}
		
	if (argc>2 && 0==strcmp(argv[2], "mkcode")) 
	{
		if (argc != 6)	
		{
			Usage(argv[0]);
			exit(1);	
		}	
		ActiveCodeManager::GetInstance().MakeActiveCode(atoi(argv[3]), atoi(argv[4]), atoi(argv[5]) ); 
		StorageEnv::checkpoint(); 
		StorageEnv::Close();
		return 0;
	}
	
	Log::setprogname("gactivecode");
	{	
		GACCodeServer *manager = GACCodeServer::GetInstance();
		manager->SetAccumulate(atoi(conf->find(manager->Identification(), "accumulate").c_str()));
		Protocol::Server(manager);
	}
	
	Thread::Pool::AddTask(PollIO::Task::GetInstance());
	pthread_t	th;
	pthread_create( &th, NULL, &StorageEnv::BackupThread, NULL );
	Thread::Pool::Run( &s_policy );	
	return 0;
}
