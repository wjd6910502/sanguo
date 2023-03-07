/*
 * FILE: AFPI.h
 *
 * DESCRIPTION: private interface functions for Angelica File Lib;
 *
 * CREATED BY: Hedi, 2001/12/31
 *
 * HISTORY:
 *
 * Copyright (c) 2001 Archosaur Studio, All Rights Reserved.	
 */

#ifndef _AFPI_H_
#define _AFPI_H_

#include "ABaseDef.h"
#include "AFPlatform.h"

//#ifdef _IOS
////#include "ZLib.h"
//#include "zlib.h"
//#elif defined(_LINUX)
//#include "ZLIB/zlib.h"
//#else
//#include "ZLib\ZLib.h"
//#endif
#include "ABaseDef.h"

#ifdef _ANDROID
#include <android/log.h>
#endif

class ALog;
extern ALog*	g_pAFErrLog;
extern char		g_szBaseDir[AMAX_PATH];
extern bool		g_bHasBackupBaseDir;
extern char		g_szBackupBaseDir[AMAX_PATH];

// You must use a () to include the fmt string;
// For example AFERRLOG(("Error Occurs at %d", nval))

#ifdef _ANDROID

inline void _AFERRLOG(const char *fmt, ...) 
{
	char szErrorMsg[2048];
	va_list args_list;

	va_start(args_list,fmt);
	vsnprintf(szErrorMsg,sizeof(szErrorMsg),fmt,args_list);
	va_end(args_list);

	__android_log_write(ANDROID_LOG_ERROR, "Angelica", szErrorMsg);
}
#define AFERRLOG(fmt) { _AFERRLOG fmt; }

#else

//#define AFERRLOG(fmt) {if(g_pAFErrLog) g_pAFErrLog->Log fmt;}
#define AFERRLOG(fmt) {}

#endif

#endif

