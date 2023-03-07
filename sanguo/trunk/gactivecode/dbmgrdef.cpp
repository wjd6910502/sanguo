#include "dbmgrdef.h"

#include "conf.h"
#include "storage.h"

namespace GNET
{
	int GamedbException::ConvertError(int e)
	{
		switch(e)
		{
			case WDB_NOTFOUND:		return ERROR_DB_NOTFOUND;
			case WDB_OVERWRITE:		return ERROR_DB_OVERWRITE;
			case WDB_KEYSIZE_ZERO:		return ERROR_DB_NULLKEY;
		}
		return ERROR_DB_UNKNOWN;
	}
	const char* GamedbException::GetError(int e)
	{
		switch(e)
		{
			case ERROR_DB_NOTFOUND:        return "record not found";
			case ERROR_DB_OVERWRITE:       return "cannot overwrite";
			case ERROR_DB_NULLKEY:         return "key length is zero";
			case ERROR_DB_DECODE:          return "error occur while decoding record";
			case ERROR_DB_INVALIDINPUT:    return "argument verification failed";
			case ERROR_DB_UNKNOWN:         return "unknown error";
			case ERROR_DB_DISCONNECT:      return "db disconnected";
			case ERROR_DB_TIMEOUT:         return "timeout"; 
			case ERROR_DB_NOSPACE:         return "no space";
			case ERROR_DB_VERIFYFAILED:    return "verification failed";
			case ERROR_DB_CASHOVERFLOW:    return "cash overflow";
		}
		return "";
	}
};

