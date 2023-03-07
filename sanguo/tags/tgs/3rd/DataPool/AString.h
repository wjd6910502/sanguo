/*
 * FILE: AString.h
 *
 * DESCRIPTION: String operating class
 *
 * CREATED BY: duyuxin, 2003/6/4
 *
 * HISTORY:
 *
 * Copyright (c) 2001 Archosaur Studio, All Rights Reserved.
 */

#ifndef _ASTRING_H_
#define _ASTRING_H_

//#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>
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
//  class AString
//
///////////////////////////////////////////////////////////////////////////

class AString
{
public:    //  Types

  struct s_STRINGDATA
  {
    int    iRefs;    //  Reference count
    int    iDataLen;  //  Length of data (not including terminator)
    int    iMaxLen;  //  Maximum length of data (not including terminator)
    
    char*  Data()  { return (char*)(this+1); }  //  char* to managed data
  };

  struct s_DOUBLE
  { 
    unsigned char  aDoubleBits[sizeof (double)];
  };

public:    //  Constructors and Destructors

  AString() : m_pStr(m_pEmptyStr) {}
  AString(const AString& str);
  AString(const char* szStr);
  AString(const char* szStr, int iLen);
  AString(char ch, int iRepeat);
  ~AString();

public:    //  Attributes

public:    //  Operations

  const AString& operator = (char ch);
  const AString& operator = (const char* szStr);
  const AString& operator = (const AString& str);

  const AString& operator += (char ch);
  const AString& operator += (const char* szStr);
  const AString& operator += (const AString& str);

  friend AString operator + (const AString& str1, const AString& str2) { return AString(str1, str2); }
  friend AString operator + (char ch, const AString& str) { return AString(ch, str); }
  friend AString operator + (const AString& str, char ch) { return AString(str, ch); }
  friend AString operator + (const char* szStr, const AString& str) { return AString(szStr, str); }
  friend AString operator + (const AString& str, const char* szStr) { return AString(str, szStr); }

  int Compare(const char* szStr) const;
  int CompareNoCase(const char* szStr) const;

  bool operator == (char ch) const { return (GetLength() == 1 && m_pStr[0] == ch); }
  bool operator == (const char* szStr) const;
  bool operator == (const AString& str) const;

  bool operator != (char ch) const { return !(GetLength() == 1 && m_pStr[0] == ch); }
  bool operator != (const char* szStr) const { return !((*this) == szStr); }
  bool operator != (const AString& str) const { return !((*this) == str); }

  bool operator > (const char* szStr) const { return Compare(szStr) > 0; }
  bool operator < (const char* szStr) const { return Compare(szStr) < 0; }
  bool operator >= (const char* szStr) const { return !((*this) < szStr); }
  bool operator <= (const char* szStr) const { return !((*this) > szStr); }

  char operator [] (int n) const { ASSERT(n >= 0 && n <= GetLength()); return m_pStr[n]; }
  char& operator [] (int n);

  operator const char* () const { return m_pStr; }

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
  AString& Format(const char* szFormat, ...);

  //  Get buffer
  char* GetBuffer(int iMinSize);
  //  Release buffer gotten through GetBuffer()
  void ReleaseBuffer(int iNewSize=-1);
  //  Lock buffer
  char* LockBuffer();
  //  Unlock buffer
  void UnlockBuffer();

  //  Trim left
  void TrimLeft();
  void TrimLeft(char ch);
  void TrimLeft(const char* szChars);
  //  Trim right
  void TrimRight();
  void TrimRight(char ch);
  void TrimRight(const char* szChars);

  //  Cut left sub string
  void CutLeft(int n);
  //  Cut right sub string
  void CutRight(int n);

  //  Finds a character or substring inside a larger string. 
  int Find(char ch, int iStart=0) const;
  int Find(const char* szSub, int iStart=0) const;
  //  Finds a character inside a larger string; starts from the end. 
  int ReverseFind(char ch) const;
  //  Finds the first matching character from a set. 
  int FindOneOf(const char* szCharSet) const;

  //  Get left string
  inline AString Left(int n) const;
  //  Get right string
  inline AString Right(int n) const;
  //  Get Mid string
  inline AString Mid(int iFrom, int iNum=-1) const;

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

  char*      m_pStr;      //  String buffer
  static char*  m_pEmptyStr;

protected:  //  Operations

  //  These constructors are used to optimize operations such as 'operator +'
  AString(const AString& str1, const AString& str2);
  AString(char ch, const AString& str);
  AString(const AString& str, char ch);
  AString(const char* szStr, const AString& str);
  AString(const AString& str, const char* szStr);

  //  Get string data
  s_STRINGDATA* GetData() const { return ((s_STRINGDATA*)m_pStr)-1; }

  //  Safed strlen()
  static int SafeStrLen(const char* szStr) { return szStr ? (int)strlen(szStr) : 0; }
  //  String copy
  static void StringCopy(char* szDest, const char* szSrc, int iLen);
  //  Alocate string buffer
  static char* AllocBuffer(int iLen);
  //  Free string data buffer
  static void FreeBuffer(s_STRINGDATA* pStrData);
  //  Judge whether two strings are equal
  static bool StringEqual(const char* s1, const char* s2, int iLen);

  //  Allocate memory and copy string
  static char* AllocThenCopy(const char* szSrc, int iLen);
  static char* AllocThenCopy(const char* szSrc, char ch, int iLen);
  static char* AllocThenCopy(char ch, const char* szSrc, int iLen);
  static char* AllocThenCopy(const char* s1, const char* s2, int iLen1, int iLen2);
};

///////////////////////////////////////////////////////////////////////////
//
//  Inline functions
//
///////////////////////////////////////////////////////////////////////////

//  Get left string
AString AString::Left(int n) const
{
  ASSERT(n >= 0);
  int iLen = GetLength();
  return AString(m_pStr, iLen < n ? iLen : n);
}

//  Get right string
AString AString::Right(int n) const
{
  ASSERT(n >= 0);
  int iFrom = GetLength() - n;
  return Mid(iFrom < 0 ? 0 : iFrom, n);
}

//  Get Mid string
AString AString::Mid(int iFrom, int iNum/* -1 */) const
{
  int iLen = GetLength() - iFrom;
  if (iLen <= 0 || !iNum)
    return AString();  //  Return empty string

  if (iNum > 0 && iLen > iNum)
    iLen = iNum;

  return AString(m_pStr+iFrom, iLen);
}

//  Convert string to integer
int AString::ToInt() const
{
  return IsEmpty() ? 0 : atoi(m_pStr);
}

//  Convert string to float
float AString::ToFloat() const
{
  return IsEmpty() ? 0.0f : (float)atof(m_pStr);
}

#ifdef _ENABLE_64
//  Convert string to __int64
a_int64 AString::ToInt64() const
{
  return IsEmpty() ? 0 : a_atoi64(m_pStr);
}
#endif // _ENABLE_64

//  Convert string to double
double AString::ToDouble() const
{
  return IsEmpty() ? 0.0 : atof(m_pStr);
}

template <class _InIt>
inline unsigned int _Hash_value(_InIt _Begin, _InIt _End)
{  // hash range of elements
  unsigned int _Val = 2166136261U;

  while (_Begin != _End)
    _Val = 16777619U * _Val ^ (unsigned int)*_Begin++;
  return (_Val);
}

inline unsigned int hash_value(const AString& _Str)
{  // hash string to unsigned int value
  const char*_Ptr = _Str;

  return (_Hash_value(_Ptr, _Ptr + _Str.GetLength()));
}

//template <> struct _LIBCPP_VISIBLE hash<const char*>
//: public unary_function<const char*, unsigned int>
//{
//    _LIBCPP_INLINE_VISIBILITY
//    unsigned int operator()(const char *__c) const _NOEXCEPT
//    {
//        return __do_string_hash(__c, __c + strlen(__c));
//    }
//};

#endif  //  _ASTRING_H_
