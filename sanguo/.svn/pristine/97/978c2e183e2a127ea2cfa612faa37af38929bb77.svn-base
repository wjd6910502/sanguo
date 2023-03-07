#ifndef __GNET_GAMEDBMANAGER_H
#define __GNET_GAMEDBMANAGER_H
/*		this class provide management tools for gamedb, such as:
 *	   	1. initialize tab and data
 *		2. query data
 *		3. show statistic informations
 */

#include <vector>
#include <map>

#include "thread.h"
#include "conv_charset.h"
#include "statistic.h"
#include "localmacro.h"

//#include "groleforbid"
//#include "grolebase"
//#include "groledetail"
//#include "roleid"
//#include "user"
//#include "userid"
//#include "dbconfig"

#include "map.h"

#define ROLELIST_DEFAULT	0x80000000
#define MAX_ROLE_COUNT		16
namespace GNET
{
	class GamedbException
	{
	public:
		int err_code;
		int log_level;
		GamedbException(int err,int log=LOG_ERR) : err_code(err),log_level(log) { }
		static int ConvertError(int);
		static const char* GetError(int);
	};

#define CREATE_TRANSACTION(txnobj,txnerr,txnlog) \
		int txnerr = 0;\
		int txnlog = LOG_ERR;\
		try{ \
			StorageEnv::CommonTransaction txnobj;\

#define LOCK_TABLE(name) \
			StorageEnv::Storage * name = StorageEnv::GetStorage(#name);

#define START_TRANSACTION \
			try{

#define END_TRANSACTION \
			}\
			catch ( DbException e ) { throw; }\
			catch ( ... ){ txnobj.abort(); throw; }\
		}\
		catch ( DbException e )        { txnerr = GamedbException::ConvertError((e.get_errno())); }\
		catch ( GamedbException e )    { txnerr = e.err_code; txnlog = e.log_level;  }\
		catch ( Marshal::Exception e ) { txnerr = ERROR_DB_DECODE; }\
		catch ( ... ) { txnerr = ERROR_DB_UNKNOWN; }

	#define	OBJECT_COUNT	4096
	#define	MATERIAL_COUNT	5
//	class GameDBManager
//	{
//		int areaid;
//		int zoneid;
//		int max_delta;
//		int create_count;
//
//		int deletetimeout;
//		int64_t guid;
//		Thread::Mutex	locker;
//		DBConfig config;
//		GameDBManager() 
//		{
//			max_delta = 0;
//			deletetimeout = 604800;	// a week
//			guid = 0;
//			areaid = 0;
//			zoneid = 0;
//			create_count = 0;
//		}
//	public:
//		~GameDBManager() { }
//		static GameDBManager* GetInstance() { static GameDBManager instance; return &instance;}
//		//initialize role base information when they are created
//		bool InitGameDB();
//		bool CheckImport(const char* file, int& new_time);
//		void UpdateImportTime(int new_time);
//		int GetDeleteRole_Timeout() {return deletetimeout;}
//		void InitGUID();
//		int64_t GetGUID() { return guid++; }
//		static int Zoneid() { return GetInstance()->zoneid; }
//		static int Areaid() { return GetInstance()->areaid; }
//		bool SetZoneid(int zid, int aid);
//		//list 
//		void ListUser() { }
//		void ListUser(const UserID& userid) { }
//		void ListRole() { }
//		void ListRole(const RoleId& roleid) { }
//
//		void UpdateTradeMoney( int money1, int money2 )
//		{
//			STAT_MIN5("TradeMoney", (int64_t)money1 + money2 );
//		}
//		void UpdateMoney(ruid_t roleid, int delta)
//		{
//			if(delta>max_delta)
//			{
//				LOG_TRACE("UpdateMoney, update max delta roleid=%lld", roleid);
//				max_delta = delta;
//			}
//
//			STAT_MIN5("Money",delta);
//		}
//		void UpdateCash( int delta )
//		{
//			STAT_MIN5("Cash",delta);
//		}
//		bool MustDelete(GRoleBase& base)
//		{
//			return ((base.status&BASE_STATUS_DELETING) && Timer::GetTime()-base.delete_time > deletetimeout);
//		}
//		bool MustDelete(time_t delete_time)
//		{
//			return Timer::GetTime()-delete_time > deletetimeout;
//		}
//		void ReadConfig();
//		bool NewServer() 
//		{ 
//			return config.open_time==0 || Timer::GetTime()-config.open_time < 86400;
//		}
//		void OnCreateRole();
//		void SendDBServerInfo();
//		int GetDayOfOpen() const;
//		int GetOpenTime() const { return config.open_time; }
//		void SetOpenTime(int t);
//		void AddCompensate(int seq,int begin,int end,int msgid,int item_tid,int create_early_than,int level_min,int duration,Octets subject,Octets context);
//		int InnerAddCash(ruid_t roleid,int cash);
//		int AddCash4R(int64_t seq,ruid_t roleid,int cash,int rmb);
//	};

//	void GRoleBaseToDetail( const GRoleBase & base, GRoleDetail & detail );
};
#endif

