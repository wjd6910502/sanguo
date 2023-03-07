
/**
	WDB3 �ļ����ݿ�
	���ߣ� ����
	��Ȩ�� ����ʱ�� 2010 - ��

	WDB:  �ǵ�һ���ļ����ݿ⣬�ڲ�ʹ����db.hʵ�ֵ�һ������ҳ���BTree�ĵײ����ݿ� db.h��һ��������ҳ������ڴ�������ݿ�ײ㣬����д��ֻ��ϵķ�����Checkpoint����
	WDB2: ���°�װ������ӿڣ�ʹ֮�������������׳��� ��Ȼʹ��ԭ�еĵײ����ݿ����
	WDB3: ��д�˵ײ����ݿ���룬��Ҫ�޸�Ϊ��
		1.�����˲����߼���ʹ����������������ܻ������ֳ�ƽ��
		2.�����������ڵĿ��������ռ��С����5�ֽ����ӵ�9�ֽڣ�����64 bit��key����ȫ�������ڿ��������У������64 bit key���ݵĲ�ѯ�ٶȡ�
		3.������ԭ�������������ݵ���־��ʽ������д�����̣���ͬʱҲ�����������Լ���׼ȷ�ԣ�
		4.ר���������������ݹ���,һ�����������ļ���һ���������ļ����ɻָ�ԭ�п⣬�������ڲ����лָ��������£�ʹ����/���������ļ�ֱ����ֻ��ģʽ�������ݿ⣻
		5.���洦��ͳһ����ʹ��ͳһ�Ļ���ռ䣬������ÿ����һ�����棬���û����Сֱ�����ϵͳ�ڴ���п��Ǽ��ɣ�����Ҫ�ٸ��ݱ��С�����ж��ˣ�
		6.���ڱ��ݵĸ����ԣ������˹��߲㶨��ı������ù��ܣ������ڱ��ݺ�Checkpoint�Ĺ�ϵ�������߼���Ȼ���������ݿ�����ڲ�����

	WDB3��Ȼ����������ԭ��WDB2�Ľӿڷ�ʽ��ԭ��һ�µĵײ�ģʽ�������һЩ������Ȼ���ڣ����纯����������ȫ�ֵģ�һ��������ֻ�ܴ�һ�����ݿ⣬д����ֻ����С�Լ�¼Ϊ��λ��ɣ����ܻ���ν��������̸�������Ȼû��SQL��ѯ����������Ĺ��ܵȵȣ���Щ������һ��WDBӦ���跨�Ľ��ġ�


	WDB3 �����ļ�˵����
	WDB3 �ڲ�ʹ��GNET::Confģ������ȡ�����ļ��� ��ʼ�������ļ��Ĺ��������ڳ�ʼ������֮ǰ�������С� �µ�Confģ�����ӵ����˹����ڲ�Ҳʹ���飬������ "WDB3"װ����Ӧ�������ļ�������
		GNET::Conf::GetInstance("mydb.conf", "WDB3");
	
	WDB3 �����ļ�������ӦΪ:

		[PDB]
		wdb3	= actived		����������д����ʾ�����ļ�����
		homedir = ��Ŀ¼����
		datadir = ���ݿ��ļ�����λ��  homedir ��datadir����һ��Ϊȫ����
		logdir	= logger�ļ�����λ��  ��Ҫ��datadir����һ��
		cache_bytes_high = �������ֵ�����ֽ�Ϊ��λ 
		cache_bytes_low	 = ������Сֵ�����ֽ�Ϊ��λ �����泬�����֮�󣬻ᱻ�����������Сֵ�����б�Ṳ���������ռ�
		tables	= ���ݿ������б���б� �����Զ��Ž��зָ� ϵͳ��(Ĭ��Ϊsystem_tab)��Ҫд�����λ�� ���Զ����ɺ͹���

		����:
		[PDB]
		wdb3	= actived
		homedir = /wdb
		datadir = dbdir
		logdir  = logdir
		cache_bytes_high = 1048576000
		cache_bytes_low	 = 524288000
		tables	= tab1,tab2,tab3,tab4,tab5

	�뱸����ص������ļ������£���������뱸�ݲ����п���ͨ��д�Լ��ı��ݲ��ԣ��������ж��壩
		[PDB]
		full_backup_dir 	= ȫ���ݵ�Ŀ��Ŀ¼
		inc_backup_dir		= �������ݵ�Ŀ��Ŀ¼
		checkpoint_interval 	= ÿ�δ��̵ļ��ʱ�䣨��λ�룩
		backup_lockfile		= �Ƿ���б��ݵ�lockfile
		full_backup_lockfile 	= �Ƿ����ȫ���ݵ�lockfile ����ļ������ȼ�����back_lockfile��Ӧ���ļ�
		quit_lockfile 		= �Ƿ��˳���lockfile
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

class Storage		//���ݿ���һ�������ı�
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
	void commit( bool cancel);			//�ύ�����޸Ĳ�����������ȡ�����β�����
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

class BackupScheme	//������Checkpoint����
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
	
	virtual bool IsQuit() = 0;		//��Checkpoint��֮�����Ƿ���Ҫ�˳��ı�־
public:
	virtual void CPTick(int timesec) =0;	//�����߳�ÿ���������һ��tick������10�룬Ӧ���ڴ�tick���жϺ���Ĳ����������Ƿ񱸷ݣ��Ƿ��˳�  �Ƿ����checkpoint�ȵ�
	virtual bool IsCheckpoint() = 0;	//CPTick���ý����������ж��Ƿ���Ҫ����Checkpoint
	virtual bool NeedBackup() = 0;		//CPTick���ý����������ж��Ƿ���Ҫ���б���
	virtual bool IsFullBackup() = 0;	//CPTick���ý����������Ҫ���ݣ��ж��Ƿ���Ҫȫ����

	/*	ע�⣺
		���ڲ������������ݣ���һ��ȫ����û����ɾͷ����쳣��������ʱ���ݿ����쳣�����Ǵ���ȫ���ݱ�־����
		������һ����������Checkpoint֮����������ȫ���ݲ��� ����֮��������������ݶ����ܱ�֤��ȷ�� 
		���Լ�ʹ�ж�Ϊ������ȫ���ݣ���ȫ������ص������ӿڣ���ȻӦ�ñ�����ȷ��
	 */

	 //$$$$$$$ ���ݻָ�������ע�����ȫ���ݱ�־���������޸Ĵ�ע��

};

/*
	**********DefaultBScheme ���������ݸ���**********

	������Ǳ�������̲��Ե�Ĭ��ʵ�֣����д�����ڱ�ͷ�ļ��У��û����Բ����Լ�д���Լ��Ĳ����ࣻ

	�����ṩ���������ݵĸ�����ݳ�����������ȫ���ݺ������������֡�
	Ϊ����ȷ��ά���ⲻͬ�ı����ļ��������˰汾�ĸ��� ���ݿ�����汾���� db_version, �Ӱ汾���� db_subversion��

	��ʼ�����汾Ϊ1���Ӱ汾Ϊ 0
	ÿ��ȫ����ʱ�����汾��� 1���Ӱ汾������
	ÿ����������ʱ���Ӱ汾���1

	ͬ�����汾��ȫ���ݺ��������������׵ģ�����������������ݼ���ȫ���ݽ��лָ����� ���汾��һ����ȫ���ݺ����������ǲ�����һ������ġ�
	ÿ��ȫ������һ���Ϳ��ļ�һ�µ�Ŀ¼��Ҳ����ֱ�Ӵ�ʹ�ã�ÿ������������һ���������ļ������м�¼�˴Ӷ�Ӧ��ȫ���ݵ��˰汾�����б����

	ȫ����Ŀ¼��Ϊ�� fulbackup-V00001-20101001-080000 
		����V00001��ʾ���汾Ϊ1��
		20101001-080000��ʾȫ���ݿ�ʼ������ʱ���Ϊ2010��10��1��8��00��00��

	�������ݵ��ļ���Ϊ�� incbackup-V00001-SV0003-20101001-080000
		����V00001��ʾ���汾Ϊ1��
		����SV0003��ʾ�Ӱ汾Ϊ3��
		20101001-080000��ʾ�������ݵ�ʱ���Ϊ2010��10��1��8��00��00��


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

		//Ӧ���ܹ��ռ�������õĴ��󷵻أ�Ȼ��ش���ȥ���� $$$$$$$$$$$
		return true;
	}
	
public:
	virtual void CPTick(int time_sec)
	{
		// ÿ�ζ��������ж�ȡ�����������������ڸ��������ļ�����Ȼ��Ҫ�ֶ�����һ�´������ļ�
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
class StorageEnv	//���ݿ⻷��
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

	static bool Open(const char *dbname="" , const BackupScheme * bs = NULL);		//dbname��������ݿ�����֣�������ֻᱣ�������ݿ��У������ڽ������ݿ�����֣��������κ��߼����Ѵ��ڵ����ݿ����ֲ���仯
												//���ݲ��Ի�ʹ��Ĭ�ϲ��ԣ�����������Զ���Ĳ��ԣ���ʹ��Clone�������Ƴ�һ�ݶ��󲢱�������
	static void Close();									//���ݿ�رպ���������Backup�߳̽�������ô˽ӿ�
	static bool Checkpoint(bool do_inc_backup);						//����д�뺯������Backup�߳��л��������������������BackupThread����ô��Ҫ���������������
	static void FullBackup();								//ִ��ȫ���ݣ���Backup�߳��л��������������������BackupThread����ô��Ҫ���������������
	static Storage * GetStorage(const char * name);						//ֻ�п�ʼ��������ܻ�ȡStorage ����ֻ�ܻ�ȡ����ʼʱָ�������ݱ�����᷵��NULL�����������־
public:
	static void * BackupThread( void * );							//����д��ͱ����߳���ڣ����߳��ɸ߲��ֶ�����
protected:
	//����Transaction������ʼ�ͽ���һ������
	static bool BeginTransaction(const char * trans_name, const char *files,...);	    	//��ʼһ������ �����ʽ������ NULL��Ϊ���һ����������������
	static bool BeginTransaction(const char * trans_name, size_t n, const char **files); 	//��ʼһ������
	static bool CommitTransaction();							//�ύ����ͬʱ�⿪���е����ݱ���
	static bool AbortTransaction();								//ȡ����������������ύ��������������Ĭ�ϲ�����֮ǰ�����ݿ�����в������ᱻ�ع���֮ǰ��״̬
	friend class Transaction;
};
//���ӱ��ݻָ�ģʽ.......

class Transaction 	//��StorageEnv ����ϵ�в����ķ�װ
{
	Transaction(const Transaction & );
	const Transaction& operator =(const Transaction & );
	std::string _name;
	bool _inited;
public:
	Transaction (const char * transaction_name);		//������ֻ�����һЩ������־�Ͳ����
	~Transaction ();					//����Ѿ���ʼ�����񣬲���û�е���Commit����Abort�սᣬ ��ô���Զ�����Abort
	bool Begin(const char * files, ...);			//��ʼһ������ �����ʽ������ NULL��Ϊ���һ���������������� 
	bool Begin(size_t n , const char ** files);		//��ʼһ������
	bool Commit();
	bool Abort();
};

}
/*
WDB3ʹ�ü�ʾ��
int main()
{
	GNET::Conf::GetInstance("db3.conf", "WDB3");
	if(!WDB3::StorageEnv::Open())
	{
		printf("error\n");
		return -1;
	}
	
	//����һ����¼
	int k = 10;
	int v = 1;
	Octets key(&k,sizeof(int));
	Octets value(&v,sizeof(int));
	try
	{
		WDB3::Transaction txn("����һ����¼");
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

	//д�� ������������
	WDB3::StorageEnv::Checkpoint(true);
	//������ȫ����
	// WDB3::Storage::FullBackup();
	
	//�ͷ��ڴ�
	WDB3::StorageEnv::Close();
	return 0;
}

*/



#endif

