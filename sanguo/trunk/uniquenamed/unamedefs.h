#ifndef __GNET_UNAMEDEFS_H
#define __GNET_UNAMEDEFS_H

namespace GNET
{

enum UniqueNameStatus
{
	UNAME_STATUS_INVALID = 0,
	UNAME_STATUS_ALLOCATED,
	UNAME_STATUS_CONFIRMED
};

enum UniqueNameErrorCode
{
	// general
	UNAME_ERR_SUCCESS         = 0, 
	UNAME_ERR_UNKNOWN         = -1, 
	UNAME_ERR_MARSHAL         = -2,
	UNAME_ERR_NOTFOUND        = -3, 

	// db
	UNAME_ERR_DB_NOTFOUND     = -4, 
	UNAME_ERR_DB_UNKNOWN      = -5,

	// rolename/name 
	UNAME_ERR_NOFREENAMESPACE = -6, 
	UNAME_ERR_DUPLICATENAME   = -7,
	UNAME_ERR_INCONSISTENT    = -8,
};

class GamedbException
{
public:
	int err_code;
	int log_level;
	GamedbException(int err,int log=LOG_ERR) : err_code(err),log_level(log) { }
};


#define CREATE_TRANSACTION(txnobj,txnerr,txnlog) \
		int txnerr = 0;\
		int txnlog = LOG_ERR;\
		try{ \
			StorageEnv::CommonTransaction txnobj;\

#define LOCK_TABLE(name) \
			StorageEnv::Storage * p##name = StorageEnv::GetStorage(#name);

#define LOCK_TABLE2(name) \
			StorageEnv::Storage * p##name = StorageEnv::GetStorage(name);

#define START_TRANSACTION \
			try{

#define END_TRANSACTION \
			}\
			catch ( DbException e ) { throw; }\
			catch ( ... ){ txnobj.abort(); throw; }\
		}\
		catch ( DbException e )        { txnerr = e.get_errno(); }\
		catch ( GamedbException e )    { txnerr = e.err_code; txnlog = e.log_level;  }\
		catch ( Marshal::Exception e ) { txnerr = UNAME_ERR_MARSHAL; }\
		catch ( ... ) { txnerr = UNAME_ERR_DB_UNKNOWN; }

} // end of namespace GNET 

#endif

