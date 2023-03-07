/*
 * FILE: AAssist.h
 *
 * DESCRIPTION: Assist routines
 *
 * CREATED BY: duyuxin, 2003/6/6
 *
 * HISTORY:
 *
 * Copyright (c) 2001 Archosaur Studio, All Rights Reserved.
 */

#ifndef _AASSIST_H_
#define _AASSIST_H_

#include "ABaseDef.h"
#include "AString.h"
#include "AWString.h"
#include "utf16string.h"
#if defined(_WIN32)
#include <windows.h>
#else
#include <sys/time.h>
#endif

///////////////////////////////////////////////////////////////////////////
//
//  Define and Macro
//
///////////////////////////////////////////////////////////////////////////

#if defined(_WIN32)
#include <Windows.h>
#define DLL_API __declspec(dllexport)
#elif defined(_IOS)
#define DLL_API
#define WINAPI
#else
#define DLL_API
#define WINAPI
#endif


#define ARAND_MAX  RAND_MAX

#define min2(a, b) (((a) > (b)) ? (b) : (a))
#define min3(a, b, c) (min2(min2((a), (b)), (c)))
#define max2(a, b) (((a) > (b)) ? (a) : (b))
#define max3(a, b, c) (max2(max2((a), (b)), (c)))
#define min4(a, b, c, d) (min2(min2((a), (b)), min2((c), (d))))
#define max4(a, b, c, d) (max2(max2((a), (b)), max2((c), (d))))

#ifdef UNICODE
  #define ACString    AWString
  #define AS2AC(s)    AS2WC(s)
  #define WC2AC(s)    AWString(s)
  #define AC2AS(s)    WC2AS(s)
  #define  AC2WC(s)    AWString(s)
  #define AS2AC_CP(cp, s)  AS2WC(cp, s)
  #define WC2AC_CP(cp, s)  AWString(s)
  #define AC2AS_CP(cp, s)  WC2AS(cp, s)
  #define  AC2WC_CP(cp, s)  AWString(s)
#else  
  #define ACString    AString
  #define AS2AC(s)    AString(s)
  #define WC2AC(s)    WC2AS(s)
  #define AC2AS(s)    AString(s)
  #define  AC2WC(s)    AS2WC(s)
  #define AS2AC_CP(cp, s)  AString(s)
  #define WC2AC_CP(cp, s)  WC2AS(cp, s)
  #define AC2AS_CP(cp, s)  AString(s)
  #define  AC2WC_CP(cp, s)  AS2WC(cp, s)
#endif  

///////////////////////////////////////////////////////////////////////////
//
//  Types and Global variables
//
///////////////////////////////////////////////////////////////////////////

//  Make ID from string
ADWORD a_MakeIDFromString(const char* szStr);
ADWORD a_MakeIDFromLowString(const char* szStr);
bool a_GetStringAfter(const char* szBuffer, const char* szTag, char* szResult);

//  Calculate CRC
//  Note: the CRC result of one call to a_CalcCRC32 may not be equal to the one
//    got from n times call to a_CalcCRC32Step !
ADWORD a_CalcCRC32(const void* pData, int iDataLen);
ADWORD a_CalcCRC32Step(ABYTE ch, ADWORD dwIterator);

//  Set / Get current character code page
void a_SetCharCodePage(ADWORD dwCodePage);
ADWORD a_GetCharCodePage();

void a_InitEncodingConverter(void* wc2as, void* as2wc);

//  Conversion between multibyte char and wide char
//int a_MultiByteToWideChar(const char* szMultiByte, int iMultiByte, AWCHAR* wszWideChar, int iWideChar);
//int a_WideCharToMultiByte(const AWCHAR* wszWideChar, int iWideChar, char* szMultiByte, int iMultiByte);
AWString AS2WC(const char* szAnsi);
AString WC2AS(const AWCHAR* szWide);

int a_MultiByteToWideChar(int iCodePage, const char* szMultiByte, int iMultiByte, utf16_char* wszWideChar, int iWideChar);
int a_WideCharToMultiByte(int iCodePage, const utf16_char* wszWideChar, int iWideChar, char* szMultiByte, int iMultiByte);
AWString AS2WC(int iCodePage, const char* szAnsi);
AString WC2AS(int iCodePage, const AWCHAR* szWide);

//  Random number generator
bool a_InitRandom();
int a_Random();
float a_Random(float fMin, float fMax);
int a_Random(int iMin, int iMax);

//  Memory statistic functions
int a_GetMemPeakSize();
ADWORD a_GetMemAllocCounter();
int a_GetMemCurSize();
int a_GetMemRawSize();
void a_GetSmallMemInfo(int iSlot, int* piBlkSize, int* piBlkCnt, int* piFreeCnt);
void a_GetLargeMemInfo(int* piBlkCnt, int* piAllocSize);
void a_MemGarbageCollect();
void a_Sleep(unsigned milliseconds);
//return milliseconds
a_int64 a_GetTime();

///////////////////////////////////////////////////////////////////////////
//
//  Declare of Global functions
//
///////////////////////////////////////////////////////////////////////////

template <class T>
inline void a_Swap(T& lhs, T& rhs)
{
  T tmp;
  tmp = lhs;
  lhs = rhs;
  rhs = tmp;
}

template <class T>
inline const T& a_Min(const T& x, const T& y)
{
  return y < x ? y : x;
}

template <class T>
inline const T& a_Max(const T& x, const T& y)
{
  return y < x ? x : y;
}

template <class T>
inline const T& a_Min(const T& x, const T& y, const T& z)
{
  return a_Min(a_Min(x, y), z);
}

template <class T>
inline const T& a_Max(const T& x, const T& y, const T& z)
{
  return a_Max(a_Max(x, y), z);
}

template <class T>
inline void a_ClampRoof(T& x, const T& max)
{
  if (x > max) x = max;
}

template <class T>
inline void a_ClampFloor(T& x, const T& min)
{
  if (x < min) x = min;
}

template <class T>
inline void a_Clamp(T& x, const T& min, const T& max)
{
  if (x < min) x = min;
  if (x > max) x = max;
}

#endif  //  _AASSIST_H_
