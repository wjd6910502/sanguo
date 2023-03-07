/*
 * FILE: AWString.h
 *
 * DESCRIPTION: wchar_t String operating class
 *
 * CREATED BY: duyuxin, 2004/2/10
 *
 * HISTORY:
 *
 * Copyright (c) 2001 Archosaur Studio, All Rights Reserved.
 */

#ifndef _AWString_H_
#define _AWString_H_

//#include <assert.h>
#include <wchar.h>
#include <stdio.h>
#include "ABaseDef.h"

///////////////////////////////////////////////////////////////////////////
//
//  Define and Macro
//
///////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////
//
//  Types and Global variables
//
///////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////
//
//  Declare of Global functions
//
///////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////
//
//  class AWString
//
///////////////////////////////////////////////////////////////////////////

class AWString
{
public:    //  Types

  struct s_STRINGDATA
  {
    int    iRefs;    //  Reference count
    int    iDataLen;  //  Length of data (not including terminator)
    int    iMaxLen;  //  Maximum length of data (not including terminator)
    
    AWCHAR*  Data()  { return (AWCHAR*)(this+1); }  //  AWCHAR* to managed data
  };

  struct s_DOUBLE
  { 
    unsigned char  aDoubleBits[sizeof (double)];
  };

public:    //  Constructors and Destructors

  AWString() : m_pStr(m_pEmptyStr) {}
  AWString(const AWString& str);
  AWString(const AWCHAR* szStr);
  AWString(const AWCHAR* szStr, int iLen);
  AWString(AWCHAR ch, int iRepeat);
  ~AWString();

public:    //  Attributes

public:    //  Operations

  const AWString& operator = (AWCHAR ch);
  const AWString& operator = (const AWCHAR* szStr);
  const AWString& operator = (const AWString& str);

  const AWString& operator += (AWCHAR ch);
  const AWString& operator += (const AWCHAR* szStr);
  const AWString& operator += (const AWString& str);

  friend AWString operator + (const AWString& str1, const AWString& str2) { return AWString(str1, str2); }
  friend AWString operator + (AWCHAR ch, const AWString& str) { return AWString(ch, str); }
  friend AWString operator + (const AWString& str, AWCHAR ch) { return AWString(str, ch); }
  friend AWString operator + (const AWCHAR* szStr, const AWString& str) { return AWString(szStr, str); }
  friend AWString operator + (const AWString& str, const AWCHAR* szStr) { return AWString(str, szStr); }

  int Compare(const AWCHAR* szStr) const;
  int CompareNoCase(const AWCHAR* szStr) const;

  bool operator == (AWCHAR ch) const { return (GetLength() == 1 && m_pStr[0] == ch); }
  bool operator == (const AWCHAR* szStr) const;
  bool operator == (const AWString& str) const;

  bool operator != (AWCHAR ch) const { return !(GetLength() == 1 && m_pStr[0] == ch); }
  bool operator != (const AWCHAR* szStr) const { return !((*this) == szStr); }
  bool operator != (const AWString& str) const { return !((*this) == str); }

  bool operator > (const AWCHAR* szStr) const { return Compare(szStr) > 0; }
  bool operator < (const AWCHAR* szStr) const { return Compare(szStr) < 0; }
  bool operator >= (const AWCHAR* szStr) const { return !((*this) < szStr); }
  bool operator <= (const AWCHAR* szStr) const { return !((*this) > szStr); }

  AWCHAR operator [] (int n) const { ASSERT(n >= 0 && n <= GetLength()); return m_pStr[n]; }
  AWCHAR& operator [] (int n);

  operator const AWCHAR* () const { return m_pStr; }

  //  Get string length
  int  GetLength()  const { return GetData()->iDataLen; }
  //  String is empty ?
  bool IsEmpty() const { return m_pStr == m_pEmptyStr ? true : false; }
  //  Empty string
  void Empty() { FreeBuffer(GetData()); m_pStr = m_pEmptyStr; }
  //  Convert to upper case
  void MakeUpper();
  //  Convert to lower case
  void MakeLower();
  //  Format string
  AWString& Format(const AWCHAR* szFormat, ...);

  //  Get buffer
  AWCHAR* GetBuffer(int iMinSize);
  //  Release buffer gotten through GetBuffer()
  void ReleaseBuffer(int iNewSize=-1);
  //  Lock buffer
  AWCHAR* LockBuffer();
  //  Unlock buffer
  void UnlockBuffer();

  //  Trim left
  void TrimLeft();
  void TrimLeft(AWCHAR ch);
  void TrimLeft(const AWCHAR* szChars);
  //  Trim right
  void TrimRight();
  void TrimRight(AWCHAR ch);
  void TrimRight(const AWCHAR* szChars);

  //  Cut left sub string
  void CutLeft(int n);
  //  Cut right sub string
  void CutRight(int n);

  //  Finds a character or substring inside a larger string. 
  int Find(AWCHAR ch, int iStart=0) const;
  int Find(const AWCHAR* szSub, int iStart=0) const;
  //  Finds a character inside a larger string; starts from the end. 
  int ReverseFind(AWCHAR ch) const;
  //  Finds the first matching character from a set. 
  int FindOneOf(const AWCHAR* szCharSet) const;

  //  Get left string
  inline AWString Left(int n) const;
  //  Get right string
  inline AWString Right(int n) const;
  //  Get Mid string
  inline AWString Mid(int iFrom, int iNum=-1) const;

  //  Convert string to integer
  inline int ToInt() const;
  //  Convert string to float
  inline float ToFloat() const;

#ifdef _ENABLE_64
  //  Convert string to __int64
  inline a_int64 ToInt64() const;
#endif // #ifdef _ENABLE_64

  //  Convert string to double
  inline double ToDouble() const;
  
protected:  //  Attributes

  AWCHAR*    m_pStr;      //  String buffer
  static AWCHAR*  m_pEmptyStr;

protected:  //  Operations

  //  These constructors are used to optimize operations such as 'operator +'
  AWString(const AWString& str1, const AWString& str2);
  AWString(AWCHAR ch, const AWString& str);
  AWString(const AWString& str, AWCHAR ch);
  AWString(const AWCHAR* szStr, const AWString& str);
  AWString(const AWString& str, const AWCHAR* szStr);

  //  Get string data
  s_STRINGDATA* GetData() const { return ((s_STRINGDATA*)m_pStr)-1; }

  //  Safed strlen()
  static int SafeStrLen(const AWCHAR* szStr) { return szStr ? (int)wcslen((wchar_t*)szStr) : 0; } // It is wrong for ios
  //  String copy
  static void StringCopy(AWCHAR* szDest, const AWCHAR* szSrc, int iLen);
  //  Alocate string buffer
  static AWCHAR* AllocBuffer(int iLen);
  //  Free string data buffer
  static void FreeBuffer(s_STRINGDATA* pStrData);
  //  Judge whether two strings are equal
  static bool StringEqual(const AWCHAR* s1, const AWCHAR* s2, int iLen);

  //  Allocate memory and copy string
  static AWCHAR* AllocThenCopy(const AWCHAR* szSrc, int iLen);
  static AWCHAR* AllocThenCopy(const AWCHAR* szSrc, AWCHAR ch, int iLen);
  static AWCHAR* AllocThenCopy(AWCHAR ch, const AWCHAR* szSrc, int iLen);
  static AWCHAR* AllocThenCopy(const AWCHAR* s1, const AWCHAR* s2, int iLen1, int iLen2);
};

///////////////////////////////////////////////////////////////////////////
//
//  Inline functions
//
///////////////////////////////////////////////////////////////////////////

//  Get left string
AWString AWString::Left(int n) const
{
  ASSERT(n >= 0);
  int iLen = GetLength();
  return AWString(m_pStr, iLen < n ? iLen : n);
}

//  Get right string
AWString AWString::Right(int n) const
{
  ASSERT(n >= 0);
  int iFrom = GetLength() - n;
  return Mid(iFrom < 0 ? 0 : iFrom, n);
}

//  Get Mid string
AWString AWString::Mid(int iFrom, int iNum/* -1 */) const
{
  int iLen = GetLength() - iFrom;
  if (iLen <= 0 || !iNum)
    return AWString();  //  Return empty string

  if (iNum > 0 && iLen > iNum)
    iLen = iNum;

  return AWString(m_pStr+iFrom, iLen);
}

//  Convert string to integer
int AWString::ToInt() const
{
  return IsEmpty() ? 0 : a_wtoi(m_pStr);
}

//  Convert string to float
float AWString::ToFloat() const
{
  if (IsEmpty())
    return 0.0f;
  
  float fValue;
  //swscanf((wchar_t*)m_pStr, L"%f", &fValue); // WRONG for iOS
  fValue = (float)wcstod(m_pStr,0);
  return fValue;
}

#ifdef _ENABLE_64
//  Convert string to __int64
a_int64 AWString::ToInt64() const
{
  return IsEmpty() ? 0 : a_wtoi64(m_pStr);
}
#endif // #ifdef _ENABLE_64

//  Convert string to double
double AWString::ToDouble() const
{
  if (IsEmpty())
    return 0.0;
  
   AWCHAR *endptr;
   return wcstod((wchar_t*)m_pStr, (wchar_t**)&endptr); // WRONG for iOS
}

#endif  //  _AWString_H_
