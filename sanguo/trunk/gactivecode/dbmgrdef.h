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
#include "localmacro.h"
#include "storage.h"

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
};
#endif

