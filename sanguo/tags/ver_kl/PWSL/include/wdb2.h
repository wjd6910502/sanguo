/*
 	WDB2 WDB Storage 的封装接口
 	公司：完美时空
	日期：2009
	修改：崔铭 

	本头文件修改了原有的wdb.h头文件，去除了原先bdb的支持功能，但仍然基于原有的db.h文件数据库底层。应该说，WDB2只是做了非常少的改动工作。
	主要变动为：修改了原先的事务接口，使之更加明确化，显示的禁止了嵌套调用。
 
*/



#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <set> 
#include <map>

#include "octets.h"
#include "thread.h"

#ifndef __STORAGE_WDB_2_H_
#define __STORAGE_WDB_2_H_

#define WDB_HOMEDIR_DEFAULT "./dbhome"
#define WDB_DATADIR_DEFAULT "./dbdata"
#define WDB_LOGDIR_DEFAULT  "./dblogs"

namespace GNET
{
	class DB;
	class DBCollection;
};


namespace WDB2          
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
#define DB_NOOVERWRITE          WDB2::WDB_FLAG_NOVERWRITE
#define DB_OK                   WDB2::WDB_OK
#define DB_NOTFOUND             WDB2::WDB_NOTFOUND
#define DB_OVERWRITE            WDB2::WDB_OVERWRITE
#define DB_OLD_VERSION          WDB2::WDB_OLD_VERSION
#define DB_LOCK_DEADLOCK        WDB2::WDB_LOCK_DEADLOCK
#define DB_VERIFY_BAD           WDB2::WDB_VERIFY_BAD
#define DB_KEYSIZE_ZERO         WDB2::WDB_KEYSIZE_ZERO
#endif          

class CursorQuery;
class CursorQueryRaw;
class Transaction;

class DbException
{
	int code;
public:
	enum { WDB_OK = WDB2::WDB_OK, WDB_NOTFOUND = WDB2::WDB_NOTFOUND, WDB_OVERWRITE = WDB2::WDB_OVERWRITE, WDB_DISKERROR=WDB2::WDB_DISKERROR};
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

class Storage
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
	GNET::DB *db;   
	DataCoder *compressor;
	DataCoder *uncompressor;
	GNET::Thread::Mutex locker;
public:
	class Cursor
	{
		const char  *path;
		GNET::DB *db;
		DataCoder *uncompressor;
		friend class WDB2::CursorQuery;
		friend class WDB2::CursorQueryRaw;
	public: 
		Cursor( const char *_path, GNET::DB *_db, DataCoder *u );
		void walk( IQuery &query );
		void walk( GNET::Octets &begin, IQuery &query );
		void walk_raw( IQuery &query );
		void walk_raw( GNET::Octets &begin, IQuery &query );
		void browse( IQuery &query );
		void browse_raw( IQuery &query );
	};
public:
	~Storage();
	Storage( const char *file, GNET::DB *_db, DataCoder *c, DataCoder *u );
	void SetCompressor( DataCoder *c, DataCoder *u );

	void snapshot_create();
	void snapshot_release();
	void lock() { locker.Lock();}
	void unlock() { locker.Unlock();}
	void checkpoint( bool cancel);			//commit ?/////
	void insert( const GNET::Octets &key, const GNET::Octets &val, int flags = 0 );
	GNET::Octets find( const GNET::Octets &key);
	bool find( const GNET::Octets &key, GNET::Octets &val);
	void remove(const GNET::Octets &key, int flags = 0 );
	size_t count() const;
	Cursor cursor() { return Cursor(path, db, uncompressor ); }
};



class StorageEnv
{
	typedef std::map< std::string, Storage * > StorageMap;
	typedef std::vector<Storage *> StorageVec;
	static StorageMap storage_map;
	static StorageVec storage_vec;  
	static GNET::DBCollection *env; 
	static std::string homedir;     
	static std::string datadir;
	static std::string logdir;
	static GNET::Thread::Mutex checkpoint_locker;
public:

	static std::string get_datadir() { return datadir; }
	static std::string get_logdir() { return logdir; }
	static bool Open();
	static void Close();
	static bool checkpoint();
	static void removeoldlogs();
	static void backup( const char * __destdir, bool increment = false );

	static Storage * GetStorage(const char * name);						//只有开始了事务才能获取Storage 而且只能获取事务开始时指定的数据表，否则会返回NULL并记入错误日志
public:
	static void * BackupThread( void * pParam );
protected:
	//请用Transaction类来开始和结束一个事务
	static bool BeginTransaction(const char * trans_name, const char *files,...);	    	//开始一个事务 变参形式，请用 NULL作为最后一个参数，否则会出错
	static bool BeginTransaction(const char * trans_name, size_t n, const char **files); 	//开始一个事务
	static bool CommitTransaction();
	static bool AbortTransaction();
	friend class Transaction;
};

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

#endif

