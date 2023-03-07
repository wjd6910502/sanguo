/*
 * FILE: AWString.cpp
 *
 * DESCRIPTION: AWCHAR String operating class
 *
 * CREATED BY: duyuxin, 2004/2/10
 *
 * HISTORY:
 *
 * Copyright (c) 2001 Archosaur Studio, All Rights Reserved.
 */

#include "ABaseDef.h"
#include "AWString.h"
#include "AMemory.h"
#include <wchar.h>
#include <stdarg.h>

///////////////////////////////////////////////////////////////////////////
//
//  Define and Macro
//
///////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////
//
//  Reference to External variables and functions
//
///////////////////////////////////////////////////////////////////////////
AWCHAR tolowerW(AWCHAR c)
{
  if(c >= 'A' && c <= 'Z') {
    return c - 'A' + 'a';
  }
  return c;
}

AWCHAR toupperW(AWCHAR c)
{
  if(c >= 'a' && c <= 'z') {
    return c - 'a' + 'A';
  }
  return c;
}

int a_wcsicmp( const AWCHAR *str1, const AWCHAR* str2 )
{
  for (;;)
  {
    int ret = tolowerW(*str1) - tolowerW(*str2);
    if (ret || !*str1) return ret;
    str1++;
    str2++;
  }
}

AWCHAR* a_wcsupr(AWCHAR *str)
{
  AWCHAR* ret = str;
  for ( ; *str; str++) *str = toupperW(*str);
  return ret;
}

AWCHAR* a_wcslwr(AWCHAR *str)
{
    AWCHAR* ret = str;
    for ( ; *str; str++) *str = tolowerW(*str);
    return ret;
}

///////////////////////////////////////////////////////////////////////////
//
//  Local Types and Variables and Global variables
//
///////////////////////////////////////////////////////////////////////////

struct s_WEMPTYSTRING
{
  AWString::s_STRINGDATA  Data;

  AWCHAR  szStr[1];

  s_WEMPTYSTRING()
  {
    Data.iRefs    = 0;
    Data.iDataLen  = 0;
    Data.iMaxLen  = 0;
    szStr[0]    = '\0';
  }
};

//  For an empty string, m_pchData will point here
static s_WEMPTYSTRING l_WEmptyString;
AWCHAR* AWString::m_pEmptyStr = l_WEmptyString.szStr;

///////////////////////////////////////////////////////////////////////////
//
//  Local functions
//
///////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////
//
//  Implement AWString
//
///////////////////////////////////////////////////////////////////////////

/*  Alocate string buffer

  iLen: length of data (not including terminator)
*/
AWCHAR* AWString::AllocBuffer(int iLen)
{
  s_STRINGDATA* pData;
  char* pBuf;

  if (iLen < 64)
  {
    pBuf  = (char*)a_malloc(sizeof (AWCHAR) * 64 + sizeof (s_STRINGDATA));
    pData = (s_STRINGDATA*)pBuf;

    pData->iRefs  = 1;
    pData->iDataLen  = iLen;
    pData->iMaxLen  = 63;
  }
  else if (iLen < 128)
  {
    pBuf  = (char*)a_malloc(sizeof (AWCHAR) * 128 + sizeof (s_STRINGDATA));
    pData = (s_STRINGDATA*)pBuf;

    pData->iRefs  = 1;
    pData->iDataLen  = iLen;
    pData->iMaxLen  = 127;
  }
  else if (iLen < 256)
  {
    pBuf  = (char*)a_malloc(sizeof (AWCHAR) * 256 + sizeof (s_STRINGDATA));
    pData = (s_STRINGDATA*)pBuf;

    pData->iRefs  = 1;
    pData->iDataLen  = iLen;
    pData->iMaxLen  = 255;
  }
  else if (iLen < 512)
  {
    pBuf  = (char*)a_malloc(sizeof (AWCHAR) * 512 + sizeof (s_STRINGDATA));
    pData = (s_STRINGDATA*)pBuf;

    pData->iRefs  = 1;
    pData->iDataLen  = iLen;
    pData->iMaxLen  = 511;
  }
  else
  {
    pBuf  = (char*)a_malloc(sizeof (AWCHAR) * (iLen + 1) + sizeof (s_STRINGDATA));
    pData = (s_STRINGDATA*)pBuf;

    pData->iRefs  = 1;
    pData->iDataLen  = iLen;
    pData->iMaxLen  = iLen;
  }

  return (AWCHAR*)(pBuf + sizeof (s_STRINGDATA));
}

//  Free string data buffer
void AWString::FreeBuffer(s_STRINGDATA* pStrData)
{
  switch (pStrData->iRefs)
  {
  case 0:  return;
  case 1:

    a_free(pStrData);
    break;

  default:

    pStrData->iRefs--;
    break;
  }
}

//  Copy iLen characters from szSrc to szDest and add terminator at the tail of szDest
void AWString::StringCopy(AWCHAR* szDest, const AWCHAR* szSrc, int iLen)
{
  int i;
  for (i=0; i < iLen; i++)
    szDest[i] = szSrc[i];

  szDest[i] = '\0';
}

//  Judge whether two strings are equal
bool AWString::StringEqual(const AWCHAR* s1, const AWCHAR* s2, int iLen)
{
  for (int i=0; i < iLen; i++)
  {
    if (s1[i] != s2[i])
      return false;
  }

  return true;
}

//  Allocate memory and copy string
AWCHAR* AWString::AllocThenCopy(const AWCHAR* szSrc, int iLen)
{
  if (!iLen)
    return m_pEmptyStr;
  
  AWCHAR* s = AllocBuffer(iLen);
  StringCopy(s, szSrc, iLen);

  return s;
}

//  Allocate a new string which is merged by szSrc + ch
AWCHAR* AWString::AllocThenCopy(const AWCHAR* szSrc, AWCHAR ch, int iLen)
{
  if (!ch)
    return AllocThenCopy(szSrc, iLen-1);

  AWCHAR* s = AllocBuffer(iLen);
  StringCopy(s, szSrc, iLen-1);

  s[iLen-1]  = ch;
  s[iLen]    = '\0';

  return s;
}

//  Allocate a new string which is merged by ch + szSrc
AWCHAR* AWString::AllocThenCopy(AWCHAR ch, const AWCHAR* szSrc, int iLen)
{
  if (!ch)
    return l_WEmptyString.szStr;

  AWCHAR* s = AllocBuffer(iLen);
  
  s[0] = ch;
  StringCopy(s+1, szSrc, iLen-1);

  return s;
}

//  Allocate a new string which is merged by s1 + s2
AWCHAR* AWString::AllocThenCopy(const AWCHAR* s1, const AWCHAR* s2, int iLen1, int iLen2)
{
  if (!iLen2)
    return AllocThenCopy(s1, iLen1);
  
  int iLen = iLen1 + iLen2;
  AWCHAR* s = AllocBuffer(iLen);

  StringCopy(s, s1, iLen1);
  StringCopy(s+iLen1, s2, iLen2);

  return s;
}

AWString::AWString(const AWString& str)
{
  if (str.IsEmpty())
  {
    m_pStr = m_pEmptyStr;
    return;
  }

  s_STRINGDATA* pSrcData = str.GetData();

  if (pSrcData->iRefs == -1)  //  Source string is being locked
  {
    s_STRINGDATA* pData = GetData();
    m_pStr = AllocThenCopy(str.m_pStr, pSrcData->iDataLen);
  }
  else
  {
    pSrcData->iRefs++;
    m_pStr = str.m_pStr;
  }
}

AWString::AWString(const AWCHAR* szStr)
{
  int iLen = SafeStrLen(szStr);
  m_pStr = AllocThenCopy(szStr, iLen);
}

AWString::AWString(const AWCHAR* szStr, int iLen)
{
  m_pStr = AllocThenCopy(szStr, iLen);
}

AWString::AWString(AWCHAR ch, int iRepeat)
{
  m_pStr = AllocBuffer(iRepeat);

  for (int i=0; i < iRepeat; i++)
    m_pStr[i] = ch;

  m_pStr[iRepeat] = '\0';
}

AWString::AWString(const AWString& str1, const AWString& str2)
{
  m_pStr = AllocThenCopy(str1.m_pStr, str2.m_pStr, str1.GetLength(), str2.GetLength());
}

AWString::AWString(AWCHAR ch, const AWString& str)
{
  m_pStr = AllocThenCopy(ch, str.m_pStr, str.GetLength() + 1);
}

AWString::AWString(const AWString& str, AWCHAR ch)
{
  m_pStr = AllocThenCopy(str.m_pStr, ch, str.GetLength() + 1);
}

AWString::AWString(const AWCHAR* szStr, const AWString& str)
{
  m_pStr = AllocThenCopy(szStr, str.m_pStr, SafeStrLen(szStr), str.GetLength());
}

AWString::AWString(const AWString& str, const AWCHAR* szStr)
{
  m_pStr = AllocThenCopy(str.m_pStr, szStr, str.GetLength(), SafeStrLen(szStr));
}

AWString::~AWString()
{
  s_STRINGDATA* pData = GetData();

  if (pData->iRefs == -1)  //  Buffer is being locked
    pData->iRefs = 1;

  FreeBuffer(pData);
  m_pStr = m_pEmptyStr;
}

const AWString& AWString::operator = (AWCHAR ch)
{
  if (!ch)
  {
    Empty();
    return *this;
  }

  s_STRINGDATA* pData = GetData();

  if (IsEmpty())
    m_pStr = AllocBuffer(1);
  else if (pData->iRefs > 1)
  {
    pData->iRefs--;
    m_pStr = AllocBuffer(1);
  }
  else
    pData->iRefs = 1;
  
  m_pStr[0] = ch;
  m_pStr[1] = '\0';

  GetData()->iDataLen = 1;

  return *this;
}

const AWString& AWString::operator = (const AWCHAR* szStr)
{
  int iLen = SafeStrLen(szStr);
  if (!iLen)
  {
    Empty();
    return *this;
  }

  s_STRINGDATA* pData = GetData();

  if (pData->iRefs > 1)
  {
    pData->iRefs--;
    m_pStr = AllocThenCopy(szStr, iLen);
  }
  else
  {
    if (iLen <= pData->iMaxLen)
    {
      StringCopy(m_pStr, szStr, iLen);
      pData->iDataLen = iLen;
    }
    else
    {
      FreeBuffer(pData);
      m_pStr = AllocThenCopy(szStr, iLen);
    }
  }

  return *this;
}

const AWString& AWString::operator = (const AWString& str)
{
  if (m_pStr == str.m_pStr)
    return *this;

  if (str.IsEmpty())
  { 
    Empty();
    return *this; 
  }

  s_STRINGDATA* pSrcData = str.GetData();

  if (pSrcData->iRefs == -1)  //  Source string is being locked
  {
    s_STRINGDATA* pData = GetData();

    if (pData->iRefs > 1)
    {
      pData->iRefs--;
      m_pStr = AllocThenCopy(str.m_pStr, pSrcData->iDataLen);
    }
    else
    {
      if (pSrcData->iDataLen <= pData->iMaxLen)
      {
        StringCopy(m_pStr, str.m_pStr, pSrcData->iDataLen);
        pData->iDataLen = pSrcData->iDataLen;
      }
      else
      {
        FreeBuffer(pData);
        m_pStr = AllocThenCopy(str.m_pStr, pSrcData->iDataLen);
      }
    }
  }
  else
  {
    FreeBuffer(GetData());
    pSrcData->iRefs++;
    m_pStr = str.m_pStr;
  }

  return *this;
}

const AWString& AWString::operator += (AWCHAR ch)
{
  if (!ch)
    return *this;

  s_STRINGDATA* pData = GetData();

  if (pData->iRefs > 1)
  {
    pData->iRefs--;
    m_pStr = AllocThenCopy(m_pStr, ch, pData->iDataLen+1);
    return *this;
  }

  int iLen = pData->iDataLen + 1;
  if (iLen <= pData->iMaxLen)
  {
    m_pStr[iLen-1]  = ch;
    m_pStr[iLen]  = '\0';
    pData->iDataLen++;
  }
  else
  {
    m_pStr = AllocThenCopy(m_pStr, ch, iLen);
    FreeBuffer(pData);
  }

  return *this;
}

const AWString& AWString::operator += (const AWCHAR* szStr)
{
  int iLen2 = SafeStrLen(szStr);
  if (!iLen2)
    return *this;

  s_STRINGDATA* pData = GetData();

  if (pData->iRefs > 1)
  {
    pData->iRefs--;
    m_pStr = AllocThenCopy(m_pStr, szStr, pData->iDataLen, iLen2);
    return *this;
  }

  int iLen = pData->iDataLen + iLen2;
  if (iLen <= pData->iMaxLen)
  {
    StringCopy(m_pStr+pData->iDataLen, szStr, iLen2);
    pData->iDataLen = iLen;
  }
  else
  {
    m_pStr = AllocThenCopy(m_pStr, szStr, pData->iDataLen, iLen2);
    FreeBuffer(pData);
  }

  return *this;
}

const AWString& AWString::operator += (const AWString& str)
{
  int iLen2 = str.GetLength();
  if (!iLen2)
    return *this;

  s_STRINGDATA* pData = GetData();

  if (pData->iRefs > 1)
  {
    pData->iRefs--;
    m_pStr = AllocThenCopy(m_pStr, str.m_pStr, pData->iDataLen, iLen2);
    return *this;
  }

  int iLen = pData->iDataLen + iLen2;
  if (iLen <= pData->iMaxLen)
  {
    StringCopy(m_pStr+pData->iDataLen, str.m_pStr, iLen2);
    pData->iDataLen = iLen;
  }
  else
  {
    m_pStr = AllocThenCopy(m_pStr, str.m_pStr, pData->iDataLen, iLen2);
    FreeBuffer(pData);
  }

  return *this;
}

int AWString::Compare(const AWCHAR* szStr) const
{
  if (m_pStr == szStr)
    return 0;

  return wcscmp(m_pStr, szStr);
}

int AWString::CompareNoCase(const AWCHAR* szStr) const
{
  if (m_pStr == szStr)
    return 0;

  return a_wcsicmp(m_pStr, szStr); // TODO
}

bool AWString::operator == (const AWCHAR* szStr) const
{
  //  Note: szStr's boundary may be crossed when StringEqual() do
  //      read operation, if szStr is shorter than 'this'. Now, this
  //      read operation won't cause problem, but in the future,
  //      should we check the length of szStr at first, and put the 
  //      shorter one between 'this' and szStr front when we call StringEqual ?
  int iLen = GetLength();
  return StringEqual(m_pStr, szStr, iLen+1);
}

bool AWString::operator == (const AWString& str) const
{
  if (m_pStr == str.m_pStr)
    return true;

  int iLen = GetLength();
  if (iLen != str.GetLength())
    return false;

  return StringEqual(m_pStr, str.m_pStr, iLen);
}

AWCHAR& AWString::operator [] (int n)
{
  ASSERT(n >= 0 && n <= GetLength());

  s_STRINGDATA* pData = GetData();
  if (pData->iRefs > 1)
  {
    pData->iRefs--;
    m_pStr = AllocThenCopy(m_pStr, GetLength());
  }

  return m_pStr[n];
}

//  Convert to upper case
void AWString::MakeUpper()
{
  int iLen = GetLength();
  if (!iLen)
    return;

  s_STRINGDATA* pData = GetData();
  if (pData->iRefs > 1)
  {
    pData->iRefs--;
    m_pStr = AllocThenCopy(m_pStr, iLen);
  }

  a_wcsupr(m_pStr);
}

//  Convert to lower case
void AWString::MakeLower()
{
  int iLen = GetLength();
  if (!iLen)
    return;

  s_STRINGDATA* pData = GetData();
  if (pData->iRefs > 1)
  {
    pData->iRefs--;
    m_pStr = AllocThenCopy(m_pStr, iLen);
  }

  a_wcslwr(m_pStr);
}

//  Format string
AWString& AWString::Format(const AWCHAR* szFormat, ...)
{/*
  va_list argList;
  va_start(argList, szFormat);

  int iNumWritten, iMaxLen = _vscwprintf(szFormat, argList) + 1;

  s_STRINGDATA* pData = GetData();

#ifdef _WIN32
  if (pData->iRefs > 1)
    pData->iRefs--;
  else if (iMaxLen <= pData->iMaxLen)
  {
    vswprintf(m_pStr, szFormat, argList);
    pData->iDataLen = SafeStrLen(m_pStr);
    goto End;
  }
  else  //  iMaxLen > pData->iMaxLen
    FreeBuffer(pData);

  m_pStr = AllocBuffer(iMaxLen);
  iNumWritten = vswprintf(m_pStr, szFormat, argList);
  ASSERT(iNumWritten < iMaxLen);
  GetData()->iDataLen = SafeStrLen(m_pStr);
#else
    if (pData->iRefs > 1)
        pData->iRefs--;
    else if (iMaxLen <= pData->iMaxLen)
    {
        vswprintf(m_pStr, szFormat, argList);
        pData->iDataLen = SafeStrLen(m_pStr);
        goto End;
    }
    else  //  iMaxLen > pData->iMaxLen
        FreeBuffer(pData);
    
    m_pStr = AllocBuffer(iMaxLen);
    iNumWritten = vswprintf(m_pStr, szFormat, argList);
    ASSERT(iNumWritten < iMaxLen);
    GetData()->iDataLen = SafeStrLen(m_pStr);
#endif // #define _WIN32
End:

  va_end(argList);*/
  return *this;
}

/*  Get buffer. If you have changed content buffer returned by GetBuffer(), you
  must call ReleaseBuffer() later. Otherwise, ReleaseBuffer() isn't necessary.

  Return buffer's address for success, otherwise return NULL.

  iMinSize: number of bytes in string buffer user can changed.
*/
AWCHAR* AWString::GetBuffer(int iMinSize)
{
  if (iMinSize < 0)
  {
    ASSERT(iMinSize >= 0);
    return NULL;
  }

  //  Ensure we won't allocate an empty string when iMinSize == 1
  if (!iMinSize)
    iMinSize = 1;

  s_STRINGDATA* pData = GetData();

  if (IsEmpty())
  {
    m_pStr = AllocBuffer(iMinSize);
    m_pStr[0] = '\0';
    GetData()->iDataLen = 0;
  }
  else if (pData->iRefs > 1)
  {
    pData->iRefs--;

    if (iMinSize <= pData->iDataLen)
    {
      m_pStr = AllocThenCopy(m_pStr, pData->iDataLen);
    }
    else
    {
      AWCHAR* wszOld = m_pStr;
      m_pStr = AllocBuffer(iMinSize);
      StringCopy(m_pStr, wszOld, pData->iDataLen);
      GetData()->iDataLen = pData->iDataLen;
    }
  }
  else if (iMinSize > pData->iMaxLen)
  {
    AWCHAR* szOld = m_pStr;
    m_pStr = AllocBuffer(iMinSize);
    StringCopy(m_pStr, szOld, pData->iDataLen);
    GetData()->iDataLen = pData->iDataLen;
    FreeBuffer(pData);
  }

  return m_pStr;
}

/*  If you have changed content of buffer returned by GetBuffer(), you must call
  ReleaseBuffer() later. Otherwise, ReleaseBuffer() isn't necessary.

  iNewSize: new size in bytes of string. -1 means string is zero ended and it's
        length can be got by strlen().
*/
void AWString::ReleaseBuffer(int iNewSize/* -1 */)
{
  s_STRINGDATA* pData = GetData();
  if (pData->iRefs != 1)
  {
    ASSERT(pData->iRefs == 1);  //  Ensure GetBuffer has been called.
    return;
  }
  
  if (iNewSize == -1)
    iNewSize = SafeStrLen(m_pStr);

  if (iNewSize > pData->iMaxLen)
  {
    ASSERT(iNewSize <= pData->iMaxLen);
    return;
  }
  
  if( iNewSize == 0)
  {
    Empty();
  }
  else
  {
    pData->iDataLen = iNewSize;
    m_pStr[iNewSize] = '\0';
  }
}

//  Lock buffer. Locked buffer disable reference counting
AWCHAR* AWString::LockBuffer()
{
  if (IsEmpty())
  {
    ASSERT(!IsEmpty());
    return NULL;
  }

  s_STRINGDATA* pData = GetData();
  if (pData->iRefs <= 0)
  {
    ASSERT(pData->iRefs > 0);  //  Buffer has been locked ?
    return NULL;
  }

  if (pData->iRefs > 1)
  {
    pData->iRefs--;
    m_pStr = AllocThenCopy(m_pStr, pData->iDataLen);
    pData  = GetData();
  }

  pData->iRefs = -1;

  return m_pStr;
}

//  Unlock buffer
void AWString::UnlockBuffer()
{
  s_STRINGDATA* pData = GetData();
  if (pData->iRefs >= 0)
  {
    ASSERT(pData->iRefs < 0);  //  Buffer must has been locked.
    return;
  }

  pData->iDataLen  = SafeStrLen(m_pStr);
  pData->iRefs  = 1;
}

//  Cut left sub string
void AWString::CutLeft(int n)
{
  if (!GetLength() || n <= 0)
    return;

  s_STRINGDATA* pData = GetData();

  if (n >= pData->iDataLen)
  {
    Empty();
    return;
  }

  int iNewLen = pData->iDataLen - n;

  if (pData->iRefs > 1)
  {
    pData->iRefs--;
    m_pStr = AllocThenCopy(m_pStr+n, iNewLen);
    return;
  }

  for (int i=0; i < iNewLen; i++)
    m_pStr[i] = m_pStr[n+i];

  m_pStr[iNewLen] = '\0';
  pData->iDataLen = iNewLen;
}

//  Cut right sub string
void AWString::CutRight(int n)
{
  if (!GetLength() || n <= 0)
    return;

  s_STRINGDATA* pData = GetData();

  if (n >= pData->iDataLen)
  {
    Empty();
    return;
  }

  int iNewLen = pData->iDataLen - n;

  if (pData->iRefs > 1)
  {
    pData->iRefs--;
    m_pStr = AllocThenCopy(m_pStr, iNewLen);
    return;
  }

  m_pStr[iNewLen] = '\0';
  pData->iDataLen = iNewLen;
}

//  Trim left
void AWString::TrimLeft()
{
  if (!GetLength())
    return;

  int i;

  for (i=0; m_pStr[i]; i++)
  {
    if (m_pStr[i] > 32)
      break;
  }

  CutLeft(i);
}

//  Trim left
void AWString::TrimLeft(AWCHAR ch)
{
  if (!GetLength())
    return;

  int i;

  for (i=0; m_pStr[i]; i++)
  {
    if (m_pStr[i] != ch)
      break;
  }

  CutLeft(i);
}

//  Trim left
void AWString::TrimLeft(const AWCHAR* szChars)
{
  if (!GetLength())
    return;

  int i, j;

  for (i=0; m_pStr[i]; i++)
  {
    for (j=0; szChars[j]; j++)
    {
      if (m_pStr[i] == szChars[j])
        break;
    }

    if (!szChars[j])
      break;
  }

  CutLeft(i);
}

//  Trim right
void AWString::TrimRight()
{
  if (!GetLength())
    return;

  int i, iLen = GetLength();

  for (i=iLen-1; i >= 0; i--)
  {
    if (m_pStr[i] > 32)
      break;
  }

  CutRight(iLen-1-i);
}

//  Trim right
void AWString::TrimRight(AWCHAR ch)
{
  if (!GetLength())
    return;

  int i, iLen = GetLength();

  for (i=iLen-1; i >= 0; i--)
  {
    if (m_pStr[i] != ch)
      break;
  }

  CutRight(iLen-1-i);
}

//  Trim right
void AWString::TrimRight(const AWCHAR* szChars)
{
  if (!GetLength())
    return;

  int i, j, iLen = GetLength();

  for (i=iLen-1; i >= 0; i--)
  {
    for (j=0; szChars[j]; j++)
    {
      if (m_pStr[i] == szChars[j])
        break;
    }

    if (!szChars[j])
      break;
  }

  CutRight(iLen-1-i);
}

//  Finds a character inside a larger string. 
//  Return -1 for failure.
int AWString::Find(AWCHAR ch, int iStart/* 0 */) const
{
  int iLen = GetLength();
  if (!iLen || iStart < 0 || iStart >= iLen)
    return -1;

  for (int i=iStart; i < iLen; i++)
  {
    if (m_pStr[i] == ch)
      return i;
  }

  return -1;
}

//  Finds a substring inside a larger string. 
//  Return -1 for failure.
int AWString::Find(const AWCHAR* szSub, int iStart/* 0 */) const
{
  int iLen = GetLength();
  if (!iLen || iStart < 0 || iStart >= iLen)
    return -1;

  AWCHAR* pTemp = wcsstr(m_pStr+iStart, szSub);
  if (!pTemp)
    return -1;

  return int(pTemp - m_pStr); 
}

//  Finds a character inside a larger string; starts from the end. 
//  Return -1 for failure.
int AWString::ReverseFind(AWCHAR ch) const
{
  if (!GetLength())
    return -1;

  AWCHAR* pTemp = wcsrchr(m_pStr, ch);
  if (!pTemp)
    return -1;

  return int(pTemp - m_pStr); 
}

//  Finds the first matching character from a set. 
//  Return -1 for failure.
int AWString::FindOneOf(const AWCHAR* szCharSet) const
{
  int iLen = GetLength();
  if (!iLen)
    return -1;

  return ((int)wcscspn(m_pStr, szCharSet) == iLen) ? -1 : 0;
}

