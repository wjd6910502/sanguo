/*
 * FILE: ABaseDef.h
 *
 * DESCRIPTION: Base definition
 *
 * CREATED BY: duyuxin, 2003/6/6
 *
 * HISTORY:
 *
 * Copyright (c) 2001 Archosaur Studio, All Rights Reserved.
 */

#ifndef _ABASEDEF_H_
#define _ABASEDEF_H_

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <string.h>
#include <ctype.h>

///////////////////////////////////////////////////////////////////////////
//
//  Define and Macro
//
///////////////////////////////////////////////////////////////////////////

//#ifndef ASSERT
//#include <assert.h>
//#define ASSERT  assert
//#endif  //  ASSERT

#ifdef _WIN32
# ifndef ASSERT
#define ASSERT(x)               if( !(x)) {__asm int 3}
# endif
#define DBGBREAK                ASSERT(0)
#else
#include <assert.h>
# ifndef ASSERT
#define ASSERT(x)               assert(x)
# endif
#define DBGBREAK                ASSERT(0)
#define _W64
#endif // #ifdef _WIN32

#define AMAX_PATH 260

//  Disable copy constructor and operator = 
#define DISABLE_COPY_AND_ASSIGNMENT(ClassName)  \
  private:\
  ClassName(const ClassName&);\
  ClassName& operator = (const ClassName&);

///////////////////////////////////////////////////////////////////////////
//
//  Types and Global variables
//
///////////////////////////////////////////////////////////////////////////

//  unsigned value
typedef unsigned int    ADWORD;    //  32-bit;
//typedef ADWORD			DWORD;
typedef unsigned short  AWORD;    //  16-bit;
typedef unsigned char    ABYTE;    //  8-bit;
typedef void            AVOID;
typedef void*           ALPVOID;
typedef char            ACHAR;
typedef char*           ALPSTR;
typedef const char*     ALPCSTR;
typedef wchar_t         AWCHAR;
typedef wchar_t*        ALPWSTR;
typedef const wchar_t*  ALPCWSTR;
typedef long        AINT_PTR;
typedef unsigned char*  ALPBYTE;
typedef unsigned short* ALPWORD;
typedef int             AINT;
typedef unsigned int    AUINT;
typedef int             ABOOL;


typedef int				ABOOL;
#define TRUE			1
#define FALSE			0

#ifdef UNICODE
  #define _AL(str)    L##str
#else
  #define _AL(str)    str
#endif

//  typedef int        INT
//  commone integer ---- int, but the size undetermined, so not defined, use carefully;

//  signed value
typedef short        SHORT;    //  16-bit;
typedef char        CHAR;    //  8-bit;
//typedef float        float;    //  float
typedef double        DOUBLE;    //  double

#ifdef _WIN32
typedef __int64           a_int64;
typedef unsigned __int64  a_uint64;
#else
typedef __int64_t         a_int64;
typedef __uint64_t        a_uint64;
#endif

#ifdef _WIN32
#define a_atoi64          _atoi64
#define a_wtoi64          _wtoi64
#define a_wtoi            _wtoi
#define a_stricmp         stricmp
#define a_vscprintf(fmt, var) _vscprintf(fmt, var) 
#define _STDCALL          __stdcall
#define AINT_MAX          INT_MAX
#elif defined(_ANDROID) //---------ANDROID------------
#define a_atoi64          a64l
#define a_wtoi64(x)       0
#define a_wtoi(x)         0
#define a_stricmp         strcasecmp
#define a_vscprintf(fmt, var) vsnprintf(NULL, 0, fmt, var) 
#define _STDCALL
#define AINT_MAX          2147483647
#define INFINITE          0xFFFFFFFF
#else //----------------------IOS---------------------
#define a_atoi64          a64l
#define a_wtoi64(x)       0
#define a_wtoi(x)         0
#define a_stricmp         strcasecmp
#define a_vscprintf(fmt, var) vsnprintf(NULL, 0, fmt, var) 
#define _STDCALL
#define AINT_MAX          2147483647
#define INFINITE          0xFFFFFFFF
#define _IOS
#endif // #ifdef _WIN32

typedef void*	AHANDLE;

inline char* a_strupr(char* str)
{
	char* ret = str;
	for ( ; *str; str++) *str = toupper(*str);
	return ret;
}

inline char* a_strlwr( char* str )
{
	char* ret = str;
	for ( ; *str; str++) *str = tolower(*str);
	return ret;
}

///////////////////////////////////////////////////////////////////////////
//
//  Declare of Global functions
//
///////////////////////////////////////////////////////////////////////////


#endif  //  _ABASEDEF_H_
