/*
 * 		������־���ܵ�ʵ�֣�ȱʡʵ���Ǽ�¼��syslog�еģ��ṩ��vlogϵ�к�����LogTrait���Ա������Զ����¼��־�������ط�
 *		��˾������ʱ��
 *		���ڣ�2009-06-18
 *		�޸ģ����� ������LogTrait
 */

#ifndef __GNET_LOG_H__
#define __GNET_LOG_H__

#include <stdio.h>
#include <syslog.h>
#include <stdarg.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/un.h>
#include <errno.h>
#include <stdlib.h>

#include <ios>
#include <iostream>
#include <fstream>
#include <string>


//LOG_DEBUG=7
#define GLOG_ERR	LOG_ERR
#define GLOG_INFO	LOG_INFO
#define GLOG_WARNING	LOG_WARNING
#define LOG_CHAT	8
#define LOG_STAT	9
#define LOG_ACTION	10

namespace GNET
{
	class LogTrait
	{
	public:
		virtual ~LogTrait() {}
		virtual const char * GetPriorityName(int __priority) = 0;
		virtual void SetProgName(const char * __name) = 0;
		virtual void VLog(int __priority, const char * __fmt, va_list ap) = 0;
		virtual void VLogVital(int __priority, const char * __fmt, va_list ap) = 0;
		virtual void VStatInfo(int __priority, const char * __fmt, va_list ap) = 0;
		virtual void LogString(int __priotiry, const char * string) = 0;
	};

	class  Statistic;
	class Log
	{
	private:
		char * m_progname;
		bool	connected;
		int		LogFile;
		int		LogFacility;
		int 		console_mask;
		int		tracelevel;

		enum {
			DEFAULT_CONSOLE_MASK =  (1 << LOG_EMERG) | (1 << LOG_ALERT) | (1 << LOG_CRIT)
				| (1 << LOG_ERR) | (1 << LOG_WARNING) /*| (1 << LOG_NOTICE)*/
				| (1 <<LOG_INFO) | (1 << LOG_DEBUG) | (1 << LOG_CHAT)
				| (1 <<LOG_STAT) | (1 << LOG_ACTION) ,
		};

		Log() : m_progname(0),connected(false), LogFile(-1), LogFacility(LOG_USER), console_mask(DEFAULT_CONSOLE_MASK),tracelevel(1) { }

		static Log s_log;
		static LogTrait *_trait;

		~Log()
		{
			if( connected ) close( LogFile );
			closelog();
			if (m_progname) free(m_progname);
		}

		static Log & instance( ) { return s_log; }
		static bool LogStatistic( const std::string & __name, const Statistic * __pstat ); 	//��¼һ��ͳ����Ϣ ��ϵͳ��־��

		static void statinfo( int __priority, const char * __fmt, ... );
		static void open_internal( );
	public:
		static void vsyslog( int pri, const char * log, int len);
		static void vsyslog( int pri, const char * fmt, va_list ap );
		static void syslog_string( int pri, const char * str);

		static void setconsole(int __priority, bool enable);		//ָ��ĳ���ȼ�����־�Ƿ�����Ļ�д��
		static void vconsole(int __priority, const char * fmt, va_list ap); //���׼�������
	public:

		static void StatEnumerate( unsigned int __interval );			//��¼ָ��ʱ���ͳ����Ϣ(min5, hour day) �����Ӧ����־����д���ر�

	//���г�ʼ���Ͷ����ȼ��������������ĺ���
		static const char * prioritystring( int __priority );
		static void setprogname( const char * __name );
		
	//������־���� ʹ�� va_list��Ϊ�����Ľӿ� ������Щ���������trait�Ĳ�ͬ���в�ͬ��ת������
		static void vlog( int __priority, const char * __fmt, va_list ap );
		static void vlogvital( int __priority, const char * __fmt, va_list ap );
		static void vstatinfo( int __priority, const char * __fmt, va_list ap );
		static void logstr(int __priority, const char * str);
	
	//��д��syslog����־���� ����Щ�����ǿ϶���д�뵽syslog֮�еģ���������²����������Щ����
		static void syslog_setprogname( const char * __name );
		static void syslog_vlog( int __priority, const char * __fmt, va_list ap ) { Log::vsyslog( __priority, __fmt, ap );}
		static void syslog_vlogvital( int __priority, const char * __fmt, va_list ap ) { Log::vsyslog( __priority, __fmt, ap );}
		static void syslog_vstatinfo( int __priority, const char * __fmt, va_list ap ) { Log::vsyslog( __priority, __fmt, ap );}
		static void syslog_logstr(int __priority, const char * str) { Log::syslog_string(__priority, str);}

	//�������װ�ĺ�������Щ�������ڲ�������ʹ��va_list�ĺ���ʵ��
		static void log( int __priority, const char * __fmt, ... );
		static void logvital( int __priority, const char * __fmt, ... );
		static void trace( const char * __fmt, ... );	//�϶�����LOG_DEBUG��־
		static int trace_level() {return s_log.tracelevel;}
		static void set_trace_level(int level) {s_log.tracelevel = level;}
		
		static LogTrait *  SetNewTrait(LogTrait * trait) { LogTrait *old = _trait;_trait = trait; return old;}
	};

}

#ifdef _DEBUG
	#define LOG_TRACE	GNET::Log::trace
	#define LOG_TRACE1	if (GNET::Log::trace_level()>=1) GNET::Log::trace
	#define LOG_TRACE2	if (GNET::Log::trace_level()>=2) GNET::Log::trace
	#define LOG_TRACE3	if (GNET::Log::trace_level()>=3) GNET::Log::trace
	#define LOG_TRACE4	if (GNET::Log::trace_level()>=4) GNET::Log::trace
#else
	#define LOG_TRACE(...)
	#define LOG_TRACE1(...)
	#define LOG_TRACE2(...)
	#define LOG_TRACE3(...)
	#define LOG_TRACE4(...)
#endif


#endif


