
/**
	WDB3 文件数据库
	作者： 崔铭
	版权： 完美时空 2010 - 今

	WDB:  是第一代文件数据库，内部使用了db.h实现的一个基于页面和BTree的底层数据库 db.h是一个尽量将页面放在内存里的数据库底层，磁盘写入只间断的发生在Checkpoint区间
	WDB2: 重新包装了事务接口，使之更清晰话，不易出错， 仍然使用原有的底层数据库代码
	WDB3: 重写了底层数据库代码，主要修改为：
		1.更改了部分逻辑，使代码更加清晰，性能基本保持持平；
		2.增加了索引内的快速索引空间大小，由5字节增加到9字节，对于64 bit的key可以全部容纳在快速索引中，提高了64 bit key数据的查询速度。
		3.抛弃了原来考虑增量备份的日志方式，简化了写盘流程；但同时也降低了完整性检查的准确性；
		4.专门制作了增量备份功能,一个增量备份文件加一个主备份文件即可恢复原有库，还可以在不进行恢复库的情况下，使用主/增量备份文件直接以只读模式操作数据库；
		5.缓存处理统一化，使用统一的缓存空间，不再是每个表一个缓存，设置缓存大小直接针对系统内存进行考虑即可，不需要再根据表大小进行判断了；
		6.由于备份的复杂性，增加了供高层定义的备份配置功能，但由于备份和Checkpoint的关系，备份逻辑依然必须在数据库程序内部发起；

	WDB3依然基本保存了原有WDB2的接口方式和原来一致的底层模式，因此有一些问题依然存在，比如函数操作都是全局的，一个进程内只能打开一个数据库，写操作只能最小以记录为单位完成，可能会无谓得增大磁盘负担。依然没有SQL查询和其他方便的功能等等，这些都是下一代WDB应该设法改进的。


	WDB3 配置文件说明：
	WDB3 内部使用GNET::Conf模块来读取配置文件， 初始化配置文件的工作，请在初始化环境之前单独进行。 新的Conf模块增加的组了管理，内部也使用组，请用组 "WDB3"装载相应的配置文件，即：
		GNET::Conf::GetInstance("mydb.conf", "WDB3");
	
	WDB3 配置文件的内容应为:

		[PDB]
		wdb3	= actived		必须是这样写，表示配置文件存在
		homedir = 根目录所在
		datadir = 数据库文件所在位置  homedir 和datadir合在一起为全名称
		logdir	= logger文件所在位置  不要和datadir放在一起
		cache_bytes_high = 缓存最大值，以字节为单位 
		cache_bytes_low	 = 缓存最小值，以字节为单位 当缓存超过最大之后，会被调整成这个最小值，所有表会共用这个缓存空间
		tables	= 数据库中所有表的列表， 表名以逗号进行分隔 系统表(默认为system_tab)不要写在这个位置 会自动生成和管理

		例子:
		[PDB]
		wdb3	= actived
		homedir = /wdb
		datadir = dbdir
		logdir  = logdir
		cache_bytes_high = 1048576000
		cache_bytes_low	 = 524288000
		tables	= tab1,tab2,tab3,tab4,tab5

	与备份相关的配置文件，如下（这个配置与备份策略有可以通过写自己的备份策略，进行自行定义）
		[PDB]
		full_backup_dir 	= 全备份的目标目录
		inc_backup_dir		= 增量备份的目标目录
		checkpoint_interval 	= 每次存盘的间隔时间（单位秒）
		backup_lockfile		= 是否进行备份的lockfile
		full_backup_lockfile 	= 是否进行全备份的lockfile 这个文件的优先级高于back_lockfile对应的文件
		quit_lockfile 		= 是否退出的lockfile
*/

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <set> 
#include <map>
#include <string>

#include <stdlib.h>

#include "octets.h"
#include "thread.h"
#include "conf.h"

#ifndef __STORAGE_WDB_3_H_
#define __STORAGE_WDB_3_H_

#define WDB_HOMEDIR_DEFAULT "./dbhome"
#define WDB_DATADIR_DEFAULT "./dbdata"
#define WDB_LOGDIR_DEFAULT  "./dblogs"

namespace PDB
{
	class Database;
	class Table;
};


namespace WDB3
{               
        
enum {
	WDB_OK = 2, WDB_NOTFOUND,
	WDB_OVERWRITE, WDB_OLD_VERSION, WDB_LOCK_DEADLOCK,
	WDB_VERIFY_BAD, WDB_KEYSIZE_ZERO,WDB_DISKERROR,
};              

enum
{
	WDB_FLAG_NOVERWRITE = 1,
};

#ifndef DB_NOOVERWRITE  
#define DB_NOOVERWRITE          WDB3::WDB_NOOVERWRITE
#define DB_OK                   WDB3::WDB_OK
#define DB_NOTFOUND             WDB3::WDB_NOTFOUND
#define DB_OVERWRITE            WDB3::WDB_OVERWRITE
#define DB_OLD_VERSION          WDB3::WDB_OLD_VERSION
#define DB_LOCK_DEADLOCK        WDB3::WDB_LOCK_DEADLOCK
#define DB_VERIFY_BAD           WDB3::WDB_VERIFY_BAD
#define DB_KEYSIZE_ZERO         WDB3::WDB_KEYSIZE_ZERO
#endif          

class CursorQuery;
class CursorQueryRaw;
class Transaction;
class ThreadContext;

class DbException
{
	int code;
public:
	enum { WDB_OK = WDB3::WDB_OK, WDB_NOTFOUND = WDB3::WDB_NOTFOUND, WDB_OVERWRITE = WDB3::WDB_OVERWRITE, WDB_DISKERROR=WDB3::WDB_DISKERROR};
	DbException(int err_code):code(err_code) {}
	int get_errno() { return code;}
	const char * what()
	{
		switch( code )
		{
			case WDB_OK:            return "DB_NOERROR";
			case WDB_NOTFOUND:      return "DB_KEY_NOT_FOUND";
			case WDB_OVERWRITE:     return "DB_OVERWRITE";
						//				case WDB_NOOVERWRITE:   return "DB_NOOVERWRITE";
			case WDB_OLD_VERSION:   return "DB_OLD_VERSION";
			case WDB_LOCK_DEADLOCK: return "DB_LOCK_DEADLOCK";
			case WDB_VERIFY_BAD:    return "DB_VERIFY_BAD";
			case WDB_KEYSIZE_ZERO:  return "DB_ZERO_LENGTH_KEY";
			case WDB_DISKERROR:	return "DB_DISK_ERROR";
			default:                return "DB_UNKNOWN";
		}
	}
};

struct DataCoder
{
	virtual ~DataCoder();
	virtual GNET::Octets Update (GNET::Octets os) = 0;
};

struct NullCoder : public DataCoder { GNET::Octets Update (GNET::Octets os); };
struct Compressor : public DataCoder { GNET::Octets Update (GNET::Octets os_src); };
struct Uncompressor : public DataCoder { GNET::Octets Update (GNET::Octets os_com); };

class IQuery
{
public:
	virtual ~IQuery() { }
	virtual bool Update( GNET::Octets &key, GNET::Octets &val ) = 0;
};

class Storage		//数据库中一个单独的表
{
	struct CompareOctets            
	{                       
		bool operator() ( const GNET::Octets &o1, const GNET::Octets &o2 ) const
		{                       
			size_t s1 = o1.size();
			size_t s2 = o2.size();
			if ( int r = memcmp( o1.begin(), o2.begin(), std::min(s1, s2) ) )
				return r < 0;
			return s1 < s2; 
		}       
	};              
	typedef std::map< const GNET::Octets, std::pair< void *, size_t >, CompareOctets > Prepared;
	typedef std::set< GNET::Octets, CompareOctets > NewKey;
	Prepared prepared;
	NewKey   new_key;
	char     *path;
	PDB::Table *db;   
	PDB::Database *env;   
	DataCoder *compressor;
	DataCoder *uncompressor;
public:
	class Cursor
	{
		const char  *path;
		PDB::Table * tab;
		PDB::Database * dbs;
		DataCoder *uncompressor;
		friend class WDB3::CursorQuery;
		friend class WDB3::CursorQueryRaw;
	public: 
		Cursor( const char *_path, PDB::Table *_tab, PDB::Database * _dbs, DataCoder *u );
		void walk( IQuery &query );
		void walk( GNET::Octets &begin, IQuery &query );
		void walk_raw( IQuery &query );
		void walk_raw( GNET::Octets &begin, IQuery &query );
		void browse( IQuery &query );
		void browse_raw( IQuery &query );
	};
	friend class ThreadContext;
	void commit( bool cancel);			//提交本次修改并解锁（或者取消本次操作）
public:
	~Storage();
	Storage( const char *file,PDB::Database * _env, PDB::Table *_db, DataCoder *c, DataCoder *u );
	void SetCompressor( DataCoder *c, DataCoder *u );

	void lock();
	void unlock();
	void insert( const GNET::Octets &key, const GNET::Octets &val, int flags = 0 );
	GNET::Octets find( const GNET::Octets &key);
	bool find( const GNET::Octets &key, GNET::Octets &val);
	void remove(const GNET::Octets &key, int flags = 0 );
	size_t count() const;
	Cursor cursor() { return Cursor(path, db , env, uncompressor ); }
};

class BackupScheme	//备份与Checkpoint策略
{
protected:
	virtual ~BackupScheme() {}
public:
	virtual BackupScheme * Clone() const = 0;
	virtual void Release() = 0;

public:
	virtual std::string GenFullBackupPath(int version) = 0;
	virtual std::string GenIncBackupPath() =0 ;
	virtual std::string GenIncBackupName(int version, int sub_version) =0 ;

	virtual bool ExecuteBackup(std::string srcdir, std::string dest) = 0;
	
	virtual bool IsQuit() = 0;		//在Checkpoint完之后检查是否需要退出的标志
public:
	virtual void CPTick(int timesec) =0;	//备份线程每若干秒调用一次tick，比如10秒，应该在此tick中判断后面的操作，比如是否备份，是否退出  是否进行checkpoint等等
	virtual bool IsCheckpoint() = 0;	//CPTick调用结束后，用于判断是否需要进行Checkpoint
	virtual bool NeedBackup() = 0;		//CPTick调用结束后，用于判断是否需要进行备份
	virtual bool IsFullBackup() = 0;	//CPTick调用结束后，如果需要备份，判断是否需要全备份

	/*	注意：
		由于采用了增量备份，在一次全备份没有完成就发生异常结束（此时数据库无异常，但是存在全备份标志），
		会在下一次启动并做Checkpoint之后立刻重做全备份操作 否则之后的所有增量备份都不能保证正确性 
		所以即使判定为不该做全备份，与全备份相关的其他接口，依然应该保持正确性
	 */

	 //$$$$$$$ 备份恢复工具请注意清除全备份标志，清除后才修改此注释

};

/*
	**********DefaultBScheme 与增量备份概述**********

	这个类是备份与存盘策略的默认实现，所有代码均在本头文件中，用户可以参照自己写出自己的策略类；

	由于提供了增量备份的概念，备份出来的内容有全备份和增量备份两种。
	为了正确的维护这不同的备份文件，增加了版本的概念 数据库的主版本叫做 db_version, 子版本叫做 db_subversion。

	初始的主版本为1，子版本为 0
	每次全备份时，主版本会加 1，子版本会清零
	每次增量备份时，子版本会加1

	同样主版本的全备份和增量备份是配套的，可以用这个增量备份加上全备份进行恢复处理。 主版本不一样的全备份和增量备份是不能在一起操作的。
	每个全备份是一个和库文件一致的目录，也可以直接打开使用；每个增量备份是一个单独的文件，其中记录了从对应的全备份到此版本的所有变更。

	全备份目录名为： fulbackup-V00001-20101001-080000 
		其中V00001表示主版本为1，
		20101001-080000表示全备份开始操作的时间戳为2010年10月1日8点00分00秒

	增量备份的文件名为： incbackup-V00001-SV0003-20101001-080000
		其中V00001表示主版本为1，
		其中SV0003表示子版本为3，
		20101001-080000表示增量备份的时间戳为2010年10月1日8点00分00秒


*/
class DefaultBScheme : public BackupScheme
{
	int check_point_counter;
	struct 
	{
		bool checkpoint;
		bool backup;
		bool quit;
		bool fullbackup;
	} status;

protected:
	virtual ~DefaultBScheme() {}
public:
	virtual BackupScheme * Clone() const { return new DefaultBScheme(*this);}
	virtual void Release() { delete this;}

	DefaultBScheme()
	{
		check_point_counter = 0;
		memset(&status, 0, sizeof(status));
	}

public:
	virtual std::string GenFullBackupPath(int version)
	{
		GNET::Conf *conf = GNET::Conf::GetInstance(NULL, "WDB3");
		std::string path = conf->find( "PDB", "full_backup_dir" );
		if(path.length() > 0 && (*(path.end()-1) == '\\' || *(path.end()-1) == '/'))  path.erase(path.end() - 1);
		mkdir(path.c_str(), 0755);

		time_t t = time(NULL);
		struct tm lt;
		localtime_r( &t , &lt);
		char buf[128];
		sprintf(buf, "fulbackup-V%05d-%.4d%.2d%.2d-%.2d%.2d%.2d",version, lt.tm_year + 1900, lt.tm_mon +1 , lt.tm_mday, lt.tm_hour, lt.tm_min, lt.tm_sec);

		std::string dest = path + "/" + std::string(buf);
		return dest;
	}
	
	virtual std::string GenIncBackupPath()
	{
		GNET::Conf *conf = GNET::Conf::GetInstance(NULL, "WDB3");
		std::string path = conf->find( "PDB", "inc_backup_dir" );
		if(path.length() > 0 && (*(path.end()-1) == '\\' || *(path.end()-1) == '/'))  path.erase(path.end() - 1);
		mkdir(path.c_str(), 0755);
		return path;
		
	}

	virtual std::string GenIncBackupName(int version, int sub_version)
	{
		time_t t = time(NULL);
		struct tm lt;
		localtime_r( &t , &lt);
		char buf[128];
		sprintf(buf, "incbackup-V%05d-SV%04d-%.4d%.2d%.2d-%.2d%.2d%.2d",version, sub_version, lt.tm_year + 1900, lt.tm_mon +1 , lt.tm_mday, lt.tm_hour, lt.tm_min, lt.tm_sec);
		return std::string(buf);
	}

	virtual bool ExecuteBackup(std::string srcdir, std::string dest)
	{
		std::string destdir = dest;
		int len = destdir.length();
		if( len>0 && destdir[len-1] != '/' )
			destdir += "/"; 
		mkdir( destdir.c_str(), 0755 );

		std::string scmd = "/bin/cp -r ";
		scmd += srcdir + " " + destdir + "/";

		system( scmd.c_str() );

		//应该能够收集这个调用的错误返回，然后回传回去才是 $$$$$$$$$$$
		return true;
	}
	
public:
	virtual void CPTick(int time_sec)
	{
		// 每次都从配置中读取，这样可以在运行期更新配置文件，当然需要手动加载一下此配置文件
		GNET::Conf *conf = GNET::Conf::GetInstance(NULL, "WDB3");
		long cp_interval = atol( conf->find( "PDB", "checkpoint_interval" ).c_str() );
		std::string backup_lockfile = conf->find( "PDB", "backup_lockfile" );
		std::string full_backup_lockfile = conf->find( "PDB", "full_backup_lockfile" );
		std::string quit_lockfile = conf->find( "PDB", "quit_lockfile" );

		memset(&status, 0, sizeof(status));
		check_point_counter += time_sec;

		if(check_point_counter < cp_interval)
		{
			return;
		}

		check_point_counter = 0;
		status.checkpoint = true;

		if( 0 == unlink(quit_lockfile.c_str()) ) status.quit = true;
		if( 0 == unlink(backup_lockfile.c_str()) ) status.backup = true;
		if( 0 == unlink(full_backup_lockfile.c_str()) ) { status.fullbackup = true; status.backup = true;}
		return;
	}
	
	virtual bool IsCheckpoint() { return status.checkpoint;}
	virtual bool NeedBackup() { return status.backup;}
	virtual bool IsFullBackup() { return status.fullbackup;}
	virtual bool IsQuit() {return status.quit;}
};

class StorageLogIF;
class StorageEnv	//数据库环境
{
	typedef std::map< std::string, Storage * > StorageMap;
	typedef std::vector<Storage *> StorageVec;
	static StorageMap storage_map;
	static StorageVec storage_vec;  
	static PDB::Database *env; 
	static std::string homedir;     
	static std::string datadir;
	static std::string logdir;
	static GNET::Thread::Mutex checkpoint_locker;
	static BackupScheme * bscheme;
	static StorageLogIF * logif;

	static std::string GenIncBackupName(int db_version, int db_subversion);
public:

	static std::string get_datadir() { return datadir; }
	static std::string get_logdir() { return logdir; }

	static bool Open(const char *dbname="" , const BackupScheme * bs = NULL);		//dbname是这个数据库的名字，这个名字会保存在数据库中，可用于进行数据库的区分，不参与任何逻辑，已存在的数据库名字不会变化
												//备份策略会使用默认策略，如果传入了自定义的策略，会使用Clone函数复制出一份对象并保存起来
	static void Close();									//数据库关闭函数，请在Backup线程结束后调用此接口
	static bool Checkpoint(bool do_inc_backup);						//磁盘写入函数，在Backup线程中会调用这个函数，如果存在BackupThread，那么不要单独调用这个函数
	static void FullBackup();								//执行全备份，在Backup线程中会调用这个函数，如果存在BackupThread，那么不要单独调用这个函数
	static Storage * GetStorage(const char * name);						//只有开始了事务才能获取Storage 而且只能获取事务开始时指定的数据表，否则会返回NULL并记入错误日志
public:
	static void * BackupThread( void * );							//磁盘写入和备份线程入口，此线程由高层手动调用
protected:
	//请用Transaction类来开始和结束一个事务
	static bool BeginTransaction(const char * trans_name, const char *files,...);	    	//开始一个事务 变参形式，请用 NULL作为最后一个参数，否则会出错
	static bool BeginTransaction(const char * trans_name, size_t n, const char **files); 	//开始一个事务
	static bool CommitTransaction();							//提交事务，同时解开所有的数据表锁
	static bool AbortTransaction();								//取消事务，如果忘记了提交事务，这个是事务的默认操作，之前对数据库的所有操作，会被回滚至之前的状态
	friend class Transaction;
};
//增加备份恢复模式.......

class Transaction 	//对StorageEnv 事务系列操作的封装
{
	Transaction(const Transaction & );
	const Transaction& operator =(const Transaction & );
	std::string _name;
	bool _inited;
public:
	Transaction (const char * transaction_name);		//这个名字会用于一些错误日志和查错功能
	~Transaction ();					//如果已经开始了事务，并且没有调用Commit或者Abort终结， 那么会自动调用Abort
	bool Begin(const char * files, ...);			//开始一个事务 变参形式，请用 NULL作为最后一个参数，否则会出错 
	bool Begin(size_t n , const char ** files);		//开始一个事务
	bool Commit();
	bool Abort();
};

}
/*
WDB3使用简单示例
int main()
{
	GNET::Conf::GetInstance("db3.conf", "WDB3");
	if(!WDB3::StorageEnv::Open())
	{
		printf("error\n");
		return -1;
	}
	
	//插入一个记录
	int k = 10;
	int v = 1;
	Octets key(&k,sizeof(int));
	Octets value(&v,sizeof(int));
	try
	{
		WDB3::Transaction txn("加入一个记录");
		txn.Begin("table1", NULL);
		WDB3::Storage * storage = WDB3::StorageEnv::GetStorage("table1");
		try
		{
			storage->insert(key, value);
		}
		catch(WDB3::DbException e) 
		{
			txn.Abort();
			throw;
		}
		catch(...)
		{
			txn.Abort();
			throw WDB3::DbException( DB_OLD_VERSION );
		}
		txn.Commit();
	}catch( WDB3::DbException e)
	{
		printf( "Error when insert key:%d, what=%s\n",k, e.what() );
	}

	//写盘 并做增量备份
	WDB3::StorageEnv::Checkpoint(true);
	//或者做全备份
	// WDB3::Storage::FullBackup();
	
	//释放内存
	WDB3::StorageEnv::Close();
	return 0;
}

*/



#endif

