#include <stdio.h>

#include "glog.h"
#include "statistic.h"
#include "log.h"
#include "octets.h"
#include "conf.h"
#include "thread.h"
#include "logclientclient.hpp"
#include "remotelog.hpp"
#include "commonmacro.h"

using namespace GNET;
namespace GLog
{
	std::string g_hostname;
	std::string g_progname;

	void init(int lineid)
	{
		char buf[128];
		sprintf(buf, "gamed%03d", lineid);
		Log::setprogname( buf );
	}

	void log( int __priority, const char * __fmt, ... )
	{
		va_list ap;
		va_start(ap,__fmt);

		if( __priority <= LOG_NOTICE )
			Log::vlogvital( __priority, __fmt, ap );
		else
			Log::vlog( __priority, __fmt, ap );

		va_end(ap);
	}

	void logvital( int __priority, const char * __fmt, ... )
	{
		va_list ap;
		va_start(ap,__fmt);

		Log::vlogvital( __priority, __fmt, ap );

		va_end(ap);
	}

	void trace( const char * __fmt, ... )
	{
		va_list ap;
		va_start(ap,__fmt);

		Log::vlog( LOG_DEBUG, __fmt, ap );

		va_end(ap);
	}

	void tasklog( ruid_t roleid, int taskid, int type, const char * msg )
	{
		GLog::log( LOG_INFO, "task:roleid=%lld:taskid=%d:type=%d:msg=%s",
						roleid, taskid, type, msg );
	}

	void formatlog( const char * title, const char * msg )
	{
		Log::formatlog( title, msg );
	}

	void task( ruid_t roleid, int taskid, int type, const char * msg )
	{
		GLog::log( LOG_NOTICE, "formatlog:task:roleid=%lld:taskid=%d:type=%d:msg=%s",
							roleid, taskid, type, msg );
	}

	void upgrade( ruid_t roleid, int level, int money )
	{
		Log::upgrade( roleid, level, money );
	}

	void die( ruid_t roleid, int type, ruid_t attacker )
	{
		Log::die( roleid, type, attacker );
	}

	void keyobject( int id, int delta )
	{
		Log::keyobject( id, delta );
	}

	void refine( ruid_t roleid, int item, int level, int result, int cost )
	{
		GLog::log( LOG_NOTICE, "formatlog:refine:roleid=%lld:item=%d:level=%d:result=%d:cost=%d",
				roleid, item, level, result, cost);
	}

	void cash( const char * __fmt, ... )
	{
		va_list ap;
		va_start(ap,__fmt);

		Log::vlog( LOG_STAT, __fmt, ap );

		va_end(ap);
	}

	void formatlog(const char * __fmt, ...)
	{
		va_list ap;
		va_start(ap,__fmt);
		Log::vlogvital( LOG_NOTICE, __fmt, ap );
		va_end(ap);
	}

}



