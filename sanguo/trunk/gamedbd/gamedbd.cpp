#include "conf.h"
#include "log.h"
#include "thread.h"
#include <iostream>
#include <string>
#include <unistd.h>
#include <stdlib.h>

#include "storage.h"
#include "storagetool.h"

#include "gamedbserver.hpp"


using namespace GNET;

#define TO_STR(m) #m
#define MACRO_NAME(m) TO_STR(m)
std::map<string, string> g_save_data;
//std::map<Octets, Octets> g_save_data;
void version()
{
//#ifdef _RELEASE_VERSION_
//	printf("XO gamedbd (Release Version)\n");
//#else
//	printf("XO gamedbd (Debug Version)\n");
//#endif
//	printf("Copyright (C) 2011 XO Studio, Perfect World Inc.\n");
//	printf("SVN version:  %s\n", MACRO_NAME(_SVN_VERSION_));
//	printf("XML version:  %s\n", XMLVERSION);
//	printf("GCC version:  %s\n", __VERSION__);
//	printf("Build by %s at %s %s\n\n", MACRO_NAME(_XO_BUILDER_), __DATE__, __TIME__);
}

//void GNET::ShutDownGameDBD(int type)
void ShutDownGameDBD(int type = 1)
{
	LOG_TRACE("DB::ShutDownGameDBD type:%d.", type);
	StorageEnv::checkpoint( );
	StorageEnv::Close();
}

static char conf_filename[256];
class DbPolicy : public Thread::Pool::Policy
{
public:
	virtual void OnQuit( )
	{
		ShutDownGameDBD();
	}
};

static DbPolicy	s_policy;

///////////////////////////////////////////////////////////////////////////////
void printhelp( const char * cmd )
{
	//version();
	std::cerr << "Usage: " << cmd << " conf-file" << std::endl
			<< "\t[ importclsconfig | exportclsconfig | clearclsconfig | exportxml | importxml" << std::endl
			<< "\t| printlogicuid | printunamerole zoneid | printunamefaction zoneid | printunamefamily zoneid" << std::endl
			<< "\t| gennameidx | exportunique zoneid" << std::endl
			<< "\t| query roleid | exportrole roleid | merge dbdatapath" << std::endl
			<< "\t| listrole | listrolebrief | listuserbrief | listfaction | listfamily | listfamilyuser" << std::endl
			<< "\t| listshoplog | listsyslog | listwaitdel" << std::endl
			<< "\t| updateroles | convertdb | repairdb" << std::endl
			<< "\t| tablestat | tablestatraw | findmaxsize dumpfilename" << std::endl
			<< "\t| read tablename id" << std::endl
			<< "\t| rewritetable fromname toname | rewritedb" << std::endl
			<< "\t| listid tablename | rewritetable roleidfile fromname toname" << std::endl
			<< "\t| compressdb | decompressdb " << std::endl
			<< "\t| splitdb newdbpath backdbpath year-month-day" << std::endl
			<< "\t| createrobot firstuid count | copyrole srcroleid firstdstuid count gap | copyuser srcuid dstuid [count] " << std::endl
			<< "\t| whois rolename | copypos srcroleid firstuid count | copypos srcroleid dstroleid" << std::endl
			<< "\t| createfaction startuid offsert count basecount" << std::endl
			<< "\t| listtop listid | get toplist information "<< std::endl
			<< "\t| extendtable name size" << std::endl;
}

class LogTask : public Thread::Runnable
{
public:

	static LogTask * GetInstance()
	{
		static LogTask t;
		return &t;
	}

	void Run()
	{
		std::string str;
//		ForbidPolicy::GetInstance()->DumpPolicy(str);
		LOG_TRACE(str.c_str());
	}
};

int main(int argc, char *argv[])
{
//	if (argc < 2 || access(argv[1], R_OK) == -1 )
//	{
//		int opt;
//		while((opt = getopt(argc, argv, "hv")) != EOF)
//		{
//			switch(opt)
//			{
//				case 'v':
//					version();
//					exit(0);
//				default:
//					printhelp(argv[0]);
//					exit(0);
//			}
//		}
//		printhelp( argv[0] );
//		exit(-1);
//	}
	Conf *conf = Conf::GetInstance(argv[1]);
	strcpy(conf_filename,argv[1]);
	Log::setprogname("gamedbd");
	if(!StorageEnv::Open())
	{
		Log::log(LOG_ERR,"Initialize storage environment failed.\n");
		exit(-1);
	}
//
//	if( argc == 3 && 0 == strcmp(argv[2],"importclsconfig") )
//	{
//		RoleTemplate::Instance().Import();
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 3 && 0 == strcmp(argv[2],"exportclsconfig") )
//	{
//		RoleTemplate::Instance().Export();
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 3 && 0 == strcmp(argv[2],"clearclsconfig") )
//	{
//		RoleTemplate::Instance().Clear();
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 3 && 0 == strcmp(argv[2],"exportxml") )
//	{
//		RoleTemplate::Instance().ExportXml();
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 3 && 0 == strcmp(argv[2],"importxml") )
//	{
//		if(!RoleTemplate::Instance().ImportDefault("default_roles.xml"))
//			exit(EXIT_FAILURE);
//		if(!RoleTemplate::Instance().ImportSystem("sys_roles.xml"))
//			exit(EXIT_FAILURE);
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 4 && 0 == strcmp(argv[2],"exportrolebyroleid") )
//	{
//		RoleTemplate::Instance().ExportRoleByRoleid( atol(argv[3]));
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 5 && 0 == strcmp(argv[2],"importrolebyroleid") )
//	{
//		RoleTemplate::Instance().ImportRoleByRoleid( (argv[3]), atol(argv[4]));
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 4 && 0 == strcmp(argv[2],"printunamerole") )
//	{
//		PrintUnamerole( atoi(argv[3]) );
//		StorageEnv::checkpoint( );
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 4 && 0 == strcmp(argv[2],"printunamefaction") )
//	{
//		PrintUnamefaction( atoi(argv[3]) );
//		StorageEnv::checkpoint( );
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 4 && 0 == strcmp(argv[2],"printunamefamily") )
//	{
//		PrintUnamefamily( atoi(argv[3]) );
//		StorageEnv::checkpoint( );
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 3 && 0 == strcmp(argv[2],"gennameidx") )
//	{ 
//		GenNameIdx();
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 4 && 0 == strcmp(argv[2],"exportunique") )
//	{ 
//		ExportUnique( atoi(argv[3]) );
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 4 && 0 == strcmp(argv[2],"query") )
//	{
//		QueryRole( atoi(argv[3]) );
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 4 && 0 == strcmp(argv[2],"exportrole") )
//	{
//		ExportRole( atoll(argv[3]) );
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 4 && 0 == strcmp(argv[2],"merge") )
//	{
//		MergeServerAll( argv[3] );
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 3 && 0 == strcmp(argv[2],"listrole") )
//	{
//		ListRole();
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 4 && 0 == strcmp(argv[2],"listtop") )
//	{
//		ListTop( atoi(argv[3]) );				
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;	
//	}
//	else if( argc == 3 && 0 == strcmp(argv[2],"listrolebrief") )
//	{
//		ListRoleBrief();
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 3 && 0 == strcmp(argv[2],"listuserbrief") )
//	{
//		ListUserBrief();
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 3 && 0 == strcmp(argv[2],"listfaction") )
//	{
//		ListFaction();
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 3 && 0 == strcmp(argv[2],"listfamily") )
//	{
//#if 0
//		ListFamily();
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//#endif
//		return 0;
//	}
//	else if( argc == 3 && 0 == strcmp(argv[2],"listfamilyuser") )
//	{
//#if 0
//		ListFamilyUser();
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//#endif
//		return 0;
//	}
//	else if( argc == 3 && 0 == strcmp(argv[2],"listshoplog") )
//	{
//		ListShopLog();
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 3 && 0 == strcmp(argv[2],"listsyslog") )
//	{
//		ListSysLog();
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 3 && 0 == strcmp(argv[2],"updateroles") )
//	{
//		UpdateRoles();
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	//else if( argc == 3 && 0 == strcmp(argv[2],"convertdb") )
//	//{
//	//	ConvertDB();
//	//	StorageEnv::checkpoint();
//	//	StorageEnv::Close();
//	//	return 0;
//	//}
//	//else if( argc == 3 && 0 == strcmp(argv[2],"repairdb") )
//	//{
//	//	RepairDB();
//	//	StorageEnv::checkpoint();
//	//	StorageEnv::Close();
//	//	return 0;
//	//}
//	else if( argc == 3 && 0 == strcmp(argv[2],"tablestat") )
//	{
//		TableStat();
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 3 && 0 == strcmp(argv[2],"tablestatraw") )
//	{
//		TableStatRaw();
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 4 && 0 == strcmp(argv[2],"findmaxsize") )
//	{
//		FindMaxsizeValue(argv[3]);
//		StorageEnv::checkpoint( );
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 5 && 0 == strcmp(argv[2],"read") )
//	{
//		ReadTable( argv[3], atoi(argv[4]) );
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 3 && 0 == strcmp(argv[2],"rewritedb") )
//	{
//		RewriteDB();
//		StorageEnv::checkpoint( );
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 5 && 0 == strcmp(argv[2],"rewritetable") )
//	{
//		RewriteTable( argv[3], argv[4] );
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 4 && 0 == strcmp(argv[2],"listid") )
//	{
//		ListId( argv[3] );
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 6 && 0 == strcmp(argv[2],"rewritetable") )
//	{
//		RewriteTable( argv[3], argv[4], argv[5] );
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 3 && 0 == strcmp(argv[2],"compressdb") )
//	{
//		CompressDB();
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc == 3 && 0 == strcmp(argv[2],"decompressdb") )
//	{
//		DecompressDB();
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if (argc==6 && 0 == strcmp(argv[2], "splitdb"))
//	{
//		StorageEnv::Close();
//		SplitDB(argv[3], argv[4], argv[5]);
//		return 0;
//	}
//	else if ((argc == 5 || argc == 6) && 0 == strcmp(argv[2], "createrobot"))
//	{
//		if(argc == 5)
//			CreateRobot(argv[3], argv[4], "1");
//		else
//			CreateRobot(argv[3], argv[4], argv[5]);
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if (argc == 6 && 0 == strcmp(argv[2], "copyrole"))
//	{
//		CopyRole(argv[3], argv[4], argv[5]);
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if (argc == 7 && 0 == strcmp(argv[2], "copyrole"))
//	{
//		CopyRole(argv[3], argv[4], argv[5], argv[6]);
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if ((argc == 6 || argc == 5) && 0 == strcmp(argv[2], "copypos"))
//	{
//		if(argc == 6)	CopyPos(argv[3], argv[4], argv[5]);
//		else CopyPos(argv[3], argv[4]);
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if ((argc == 5 || argc == 6) && 0 == strcmp(argv[2], "copyuser"))
//	{
//		if(argc == 5)
//			CopyUser(argv[3], argv[4], "1");
//		else
//			CopyUser(argv[3], argv[4], argv[5]);
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if(argc == 4 && 0 == strcmp(argv[2], "whois"))
//	{
//		WhoIs(argv[3]);
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if(argc == 7 && 0 == strcmp(argv[2], "createfaction"))
//	{
//		CreateFaction(argv[3],argv[4],argv[5],argv[6]);
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if(argc == 5 && 0 == strcmp(argv[2],"extendtable")) //在status表后续上几个字节
//	{
//		ExtendTable(argv[3], atoi(argv[4]));
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return 0;
//	}
//	else if( argc >= 3 )
//	{
//		printhelp( argv[0] );
//		StorageEnv::checkpoint();
//		StorageEnv::Close();
//		return -1;
//	}
//
//
//	if (!GameDBManager::GetInstance()->InitGameDB())
//	{
//		Log::log( LOG_ERR, "Init GameDB, error initialize GameDB." );
//		exit(EXIT_FAILURE);
//	}
//
//	if(!RoleTemplate::Instance().LoadTemplate())
//	{
//		Log::log( LOG_ERR, "InitGameDB, read role template failed." );
//		return false;
//	}
//	if(!RoleTemplate::Instance().InitSysAccount())
//	{
//		Log::log( LOG_ERR, "InitSysAccount, init system role template failed." );
//		return false;
//	}
//
//	if( 1 == atol(conf->find("gamedbd","import_clsconfig").c_str()) )
//	{
//		int new_time = 0;
//		if (GameDBManager::GetInstance()->CheckImport("default_roles.xml", new_time))
//		{
//			Log::log( LOG_INFO, "Begin import default roles ..." );
//			if(!RoleTemplate::Instance().ImportDefault("default_roles.xml"))
//				exit(EXIT_FAILURE);
//		}
//		if (GameDBManager::GetInstance()->CheckImport("sys_roles.xml", new_time))
//		{
//			Log::log( LOG_INFO, "Begin import system roles ..." );
//			if(!RoleTemplate::Instance().ImportSystem("sys_roles.xml"))
//				exit(EXIT_FAILURE);
//		}
//		if(new_time) 
//		{
//			GameDBManager::GetInstance()->UpdateImportTime(new_time);
//			StorageEnv::checkpoint();
//		}
//		else
//			Log::log( LOG_INFO, "Skip import default roles");
//	}
//
//
	{
		GameDBServer *manager = GameDBServer::GetInstance();
		manager->SetAccumulate(atoi(conf->find(manager->Identification(), "accumulate").c_str()));
		Protocol::Server(manager);
	}
//	{
//		IWebDBServer *manager = IWebDBServer::GetInstance();
//		manager->SetAccumulate(atoi(conf->find(manager->Identification(), "accumulate").c_str()));
//		Protocol::Server(manager);
//	}
//	if( conf->find("BackDBClient","address").size())
//	{
//		BackDBClient *manager = BackDBClient::GetInstance();
//		manager->SetAccumulate(atoi(conf->find(manager->Identification(), "accumulate").c_str()));
//		Protocol::Client(manager);
//	}
//
//
//	ForbidPolicy::GetInstance()->LoadPolicy("forbidpolicy.conf");
//
//	Timer::Attach(EraseTimer::Instance());
	Thread::HouseKeeper::AddTimerTask(LogTask::GetInstance(),10);

	Thread::Pool::AddTask(PollIO::Task::GetInstance());
	pthread_t	th;
	pthread_create( &th, NULL, &StorageEnv::BackupThread, NULL );
	Thread::Pool::Run( &s_policy );
	return 0;
}

