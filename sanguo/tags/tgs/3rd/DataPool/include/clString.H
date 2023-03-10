#ifndef _CL_STRING_H_
#define _CL_STRING_H_

#ifndef _CL_ALLOCATOR_H_
#error Must be include "clAllocator.h" first.
#endif // _CL_ALLOCATOR_H_

#include <stdarg.h>

namespace clstd
{
  template<typename _TCh>
  _TCh* strcpyn(_TCh* pDest, const _TCh* pSrc, size_t uCount);

  template<typename _TCh>
  _TCh* strcpyT(_TCh* pDest, const _TCh* pSrc);

  template<typename _TCh>
  _TCh* strstrT(_TCh* pStr, const _TCh* pSubStr);

  // 有符号数字 => 字符串
  template<typename _TCh, typename _TNum, typename _TUNum>
  void _ltox_t(_TNum value, _TCh* pDest, size_t uSize, i32 radix, i32 upper);

  // 无符号数字 => 字符串
  template<typename _TCh, typename _TNum>
  void _ultox_t(_TNum value, _TCh* pDest, size_t uSize, i32 radix, i32 upper);

  // 数学分组：12345678 => 12,345,678

  // 有符号数字 => 字符串(带数学分组)
  template<typename _TCh, typename _TNum, typename _TUNum>
  void _ltoxg_t(_TNum value, _TCh* pDest, size_t uSize, i32 radix, i32 group, i32 upper);

  // 无符号数字 => 字符串(带数学分组)
  template<typename _TCh, typename _TNum>
  void _ultoxg_t(_TNum value, _TCh* pDest, size_t uSize, i32 radix, i32 group, i32 upper);

  // string to integer
  template<typename _TInt, typename _TCh>
  _TInt _xstrtoi(const _TCh *String);

  template<typename _TInt, typename _TCh>
  _TInt _xstrtoi(const _TCh *str, i32 radix, clsize len = -1);  // (2-36进制)字符串转带符号整数

  template<typename _TUInt, typename _TCh>
  _TUInt _xstrtou(const _TCh *str);

  template<typename _TUInt, typename _TCh>
  _TUInt _xstrtou(const _TCh *str, i32 radix, clsize len = -1);  // (2-36进制)字符串转无符号整数


  template<typename _TCh>
  double _xstrtof(const _TCh *str);

  // double(float) to string
  template<typename _TCh>
  int _ftoxstr(double value, _TCh* ascii, int width, int prec1, _TCh format);

  // string to integer
  i32 xtoi(CLCONST wch* str);
  i32 xtoi(CLCONST ch* str);
  i32 xtoi(CLCONST wch* str, i32 radix, clsize len = -1);
  i32 xtoi(CLCONST ch* str, i32 radix, clsize len = -1);

  // string to unsigned integer
  u32 xtou(CLCONST wch* str);
  u32 xtou(CLCONST ch* str);
  u32 xtou(CLCONST wch* str, i32 radix, clsize len = -1);
  u32 xtou(CLCONST ch* str, i32 radix, clsize len = -1);

  // integer to string
  void ltox(i32 value, wch* pDest, size_t uSize, i32 radix, i32 upper = 0);
  void ltox(i32 value, ch* pDest, size_t uSize, i32 radix, i32 upper = 0);
  void l64tox(i64 value, wch* pDest, size_t uSize, i32 radix, i32 upper = 0);
  void l64tox(i64 value, ch* pDest, size_t uSize, i32 radix, i32 upper = 0);

  // unsigned integer to string
  void ultox(u32 value, wch* pDest, size_t uSize, i32 radix, i32 upper = 0);
  void ultox(u32 value, ch* pDest, size_t uSize, i32 radix, i32 upper = 0);
  void ul64tox(u64 value, wch* pDest, size_t uSize, i32 radix, i32 upper = 0);
  void ul64tox(u64 value, ch* pDest, size_t uSize, i32 radix, i32 upper = 0);

  template<typename _TCh>
  _TCh tolowerT(_TCh ch);

  template<typename _TCh>  // 比较str1的前n个字符,如果遇到'\0'则提前结束
  int strncmpiT( const _TCh *str1, const _TCh *str2, clsize n );

  template<typename _TCh>
  int strcmpiT( const _TCh *str1, const _TCh *str2);

  template<typename _TCh> // 比较str1的前n个字符,如果遇到'\0'则提前结束
  int strncmpT( const _TCh *str1, const _TCh *str2, clsize n );

  template<typename _TCh>
  int strcmpT(const _TCh *str1, const _TCh *str2);

  template<typename _TCh>
  _TCh* strchrT(const _TCh *str, i32 ch);

  template<typename _TCh>
  clsize strlenT(const _TCh* str);

  template<typename _TCh>
  b32 IsNumericT(const _TCh* str, i32 radix = 10, clsize len = -1);  // 遇到\0或者达到len时退出
}


//typedef std::string AString;
//typedef std::wstring WString;

extern clstd::Allocator g_Alloc_clStringW;
extern clstd::Allocator g_Alloc_clStringA;
extern clstd::StdAllocator g_StdAlloc;

template<typename _TCh, class _TAllocator, _TAllocator& _Alloc, class _Traits>
class clStringX
{
public:
  enum 
  {
    npos = (size_t)-1,
  };
  typedef typename _Traits::_XCh _XCh;
  typedef _TCh        TChar;
  typedef _XCh        XChar;
  typedef const _TCh* LPCSTR;
private:
  _TCh*        m_pBuf;  // 只能有一个变量, 否则作为Format参数时会把多余的成员变量也压入堆栈, 出现问题.
  //clAllocator* m_pAlloc;
  void  resizeLength        (size_t uLength);
  void  resizeLengthNoCopy  (size_t uLength);
  void  reduceLength        (size_t uLength);
  void  inflateCapacity     (size_t uLength);
  void  allocLength         (_TAllocator* pAlloc, size_t uLength);
public:
  clStringX();
  clStringX(const _TCh* pStr);
  clStringX(const _TCh* pStr, size_t uCount);
  clStringX(const _XCh* pStrX);
  clStringX(const _XCh* pStrX, size_t uCount);
  clStringX(const _TCh cCh, size_t uCount);
  //clStringX(clStringX& clStr);
  clStringX(const clStringX& clStr);
  explicit clStringX(const int nInteger);
  explicit clStringX(const float fFloat);
  explicit clStringX(const long lLong);
  explicit clStringX(const unsigned int uInteger);
  explicit clStringX(const unsigned long uLong);
  ~clStringX();

  clStringX& operator=(const _TCh* pStr);
  clStringX& operator=(const _XCh* pStrX);
  clStringX& operator=(const _TCh ch);
  clStringX& operator=(const clStringX& clStr);
  clStringX& operator=(const int nInteger);
  clStringX& operator=(const float fFloat);
  clStringX& operator=(const long lLong);
  clStringX& operator=(const unsigned int uInteger);
  clStringX& operator=(const unsigned long uLong);

  //bool operator==(const _TCh* pStr) const;
  bool operator==(const clStringX& clStr2) const;
  bool operator<(const clStringX& clStr2) const;
  bool operator>(const clStringX& clStr2) const;

  inline friend bool operator==(const clStringX& clStr, const _TCh* pStr)
  {
    return clStr.Compare(pStr) == 0;
  }
  inline friend bool operator!=(const clStringX& clStr, const _TCh* pStr)
  {
    return clStr.Compare(pStr) != 0;
  }

  clStringX operator+(const _TCh* pStr) const;
  clStringX operator+(const _TCh ch) const;
  clStringX operator+(const clStringX& clStr2) const;
  clStringX operator+(const _XCh* pStrX) const;
  //clStringX operator+(int nInteger) const;
  //clStringX operator+(float fFloat) const;
  //clStringX operator+(long lLong) const;
  //clStringX operator+(unsigned int uInteger) const;
  //clStringX operator+(unsigned long uLong) const;

  clStringX& operator+=(const _TCh* pStr);
  clStringX& operator+=(const _XCh* pStrX);
  clStringX& operator+=(const _TCh cCh);
  clStringX& operator+=(const clStringX& clStr);
  //clStringX& operator+=(const float fFloat);
  //clStringX& operator+=(const int nInteger);  // 参数容易混淆_TCh,出现Bug
  //clStringX& operator+=(const long lLong);  // 参数容易混淆为_TCh,出现Bug
  //clStringX& operator+=(const unsigned int uInteger);
  //clStringX& operator+=(const unsigned long uLong);

  _TCh&    operator[]    (int nIdx);
  //_TCh&    operator[]    (clsize nIdx);
  _TCh&    Front     () const;
  _TCh&    Back      () const;

  operator const _TCh*() const;

  size_t      GetLength       () const;
  size_t      GetCapacity     () const;
  _TCh*       GetBuffer       () const;
  _TCh*       GetBuffer       (size_t nSize);
  void        Reserve         (size_t nSize);
  void        ReleaseBuffer   ();
  size_t      Format          (const _TCh *pFmt, ...);
  void        Replace         (size_t idx, size_t uCount, const _TCh* pStr);
  size_t      Replace         (_TCh cFind, _TCh cReplaceWith, size_t uStart = 0);
  clStringX&  Append          (const _XCh* pStrX);
  clStringX&  Append          (const _XCh* pStrX, size_t uCount);
  clStringX&  Append          (const _TCh* pStr);
  clStringX&  Append          (const _TCh* pStr, size_t uCount);       // 追加字符串，如果长度大于count会被截断
  clStringX&  Append          (const _TCh* pStr, _TCh c, long nWidth);  // 追加字符串，如果长度小于width会以指定字符填充, width > 0 填充到头部，width < 0 填充尾部，width == 0按实际大小填充
  clStringX&  Append          (_TCh cCh);
  clStringX&  Append          (_TCh cCh, size_t uCount);
  clStringX&  Append          (const clStringX& clStr);
  clStringX&  AppendFloat     (float val);
  clStringX&  AppendInteger32 (s32 val, int nNumGroup = 0);
  clStringX&  AppendUInt32    (u32 val, int nNumGroup = 0);
  clStringX&  AppendInteger64 (s64 val, int nNumGroup = 0);
  clStringX&  AppendUInt64    (u64 val, int nNumGroup = 0);
  clStringX&  AppendFormat    (const _TCh *pFmt, ...);
  void        MakeReverser    ();
  void        MakeUpper       ();
  void        MakeLower       ();

  int         Compare         (const _TCh* pStr) const;
  int         CompareNoCase   (const _TCh* pStr) const;
  b32         BeginsWith      (const _TCh c) const;
  b32         BeginsWith      (const _TCh* pStr) const;
  b32         BeginsWith      (const _XCh* pStr) const;
  b32         EndsWith        (const _TCh c) const;
  b32         EndsWith        (const _TCh* pStr) const;
  b32         EndsWith        (const _XCh* pStr) const;

  size_t      Insert          (size_t idx, _TCh cCh);
  size_t      Insert          (size_t idx, const _TCh* pStr);
  size_t      Remove          (_TCh cCh);
  size_t      Remove          (size_t idx, size_t uCount);  // 返回值是剩余长度
  void        TrimLeft        (_TCh cTarget);
  void        TrimLeft        (const _TCh* pTarget);
  void        TrimRight       (_TCh cTarget);
  void        TrimRight       (const _TCh* pTarget);
  b32         IsEmpty         () const;
  b32         IsNotEmpty      () const;
  b32         IsFloat         () const; // 以'+'or'-'开头，'0'-'9',只出现一次的'.'，'F'或'f'结尾的形式，暂时不支持"1e2"这种科学计数形式
  b32         IsInteger       () const; // 判断是否是整数形式的字符串，以'+'or'-'开头，后面全是数字
  b32         IsAlphanumeric  () const; // 判断字符串是否只包含['a'-'z', 'A'-'Z', '0'-'9', '_']这些字符
  void        Clear           ();
  size_t      Find            (_TCh cFind, size_t uStart = 0) const;
  size_t      Find            (const _TCh* pFind, size_t uStart = 0) const;
  size_t      FindAny         (const _TCh* pCharList, size_t uStart = 0) const; // 字符串字母顺序优先查找
  size_t      FindAnyFromList (const _TCh* pCharList, size_t uStart = 0) const; // 列表字母顺序优先查找
  size_t      ReverseFind     (_TCh cFind) const;
  size_t      ReverseFind     (_TCh cFind, int nStart, int nEnd) const;
  clStringX   Left            (size_t uCount) const;
  clStringX   Right           (size_t uCount) const;
  clStringX   SubString       (size_t uStart, size_t uCount) const;
  size_t      DivideBy        (_TCh cCh, clStringX& strFront, clStringX& strBack) const;
  size_t      ReverseDivideBy (_TCh cCh, clStringX& strFront, clStringX& strBack) const;
  i32         ToInteger       (int nRadix = 10) const;
  double      ToFloat         () const;
  u32         GetHash         () const;
  //u32         GetCRC32        () const;
  size_t      VarFormat       (const _TCh *pFmt, va_list arglist);
};

struct clStringW_traits
{
  typedef ch _XCh;
  static clsize     StringLength        (const wch* pStr);
  static clsize     XStringLength       (const _XCh* pStrX);
  static wch*       CopyStringN         (wch* pStrDest, const wch* pStrSrc, size_t uLength);
  static i32        CompareString       (const wch* pStr1, const wch* pStr2);
  static i32        CompareStringNoCase (const wch* pStr1, const wch* pStr2);
  static const wch* StringSearchChar    (const wch* pStr, wch cCh);
  //static const wch* StringSearchString  (const wch* pMainStr, const wch* pSubStr);
  static void       Unsigned32ToString  (wch* pDestStr, size_t uMaxLength, u32 uNum, i32 nNumGroup);
  static void       Integer32ToString   (wch* pDestStr, size_t uMaxLength, i32 iNum, i32 nNumGroup);
  static i32        StringToInteger32   (wch* pString);
  static void       Unsigned64ToString  (wch* pDestStr, size_t uMaxLength, u64 uNum, i32 nNumGroup);
  static void       Integer64ToString   (wch* pDestStr, size_t uMaxLength, i64 iNum, i32 nNumGroup);
  static void       FloatToString       (wch* pDestStr, size_t uMaxLength, float fNum);
  static void       HexToLowerString    (wch* pDestStr, size_t uMaxLength, u32 uValue);
  static void       HexToUpperString    (wch* pDestStr, size_t uMaxLength, u32 uValue);
  static void       BinaryToString      (wch* pDestStr, size_t uMaxLength, u32 uValue);
  static void       OctalToString       (wch* pDestStr, size_t uMaxLength, u32 uValue);
  static size_t     XStringToNative     (wch* pNativeStr, size_t uLength, const _XCh* pStrX, size_t cchX);
};

struct clStringA_traits
{
  typedef wch _XCh;
  static clsize     StringLength        (const ch* pStr);
  static clsize     XStringLength       (const _XCh* pStrX);
  static ch*        CopyStringN         (ch* pStrDest, const ch* pStrSrc, size_t uLength);
  static const ch*  StringSearchChar    (const ch* pStr, ch cCh);
  static i32        CompareString       (const ch* pStr1, const ch* pStr2);
  static i32        CompareStringNoCase (const ch* pStr1, const ch* pStr2);
  //static const ch*  StringSearchString  (const ch* pMainStr, const ch* pSubStr);
  static void       Unsigned32ToString  (ch* pDestStr, size_t uMaxLength, u32 uNum, i32 nNumGroup);
  static void       Integer32ToString   (ch* pDestStr, size_t uMaxLength, i32 iNum, i32 nNumGroup);
  static i32        StringToInteger32   (ch* pString);
  static void       Unsigned64ToString  (ch* pDestStr, size_t uMaxLength, u64 uNum, i32 nNumGroup);
  static void       Integer64ToString   (ch* pDestStr, size_t uMaxLength, i64 iNum, i32 nNumGroup);
  static void       FloatToString       (ch* pDestStr, size_t uMaxLength, float fNum);
  static void       HexToLowerString    (ch* pDestStr, size_t uMaxLength, u32 uValue);
  static void       HexToUpperString    (ch* pDestStr, size_t uMaxLength, u32 uValue);
  static void       BinaryToString      (ch* pDestStr, size_t uMaxLength, u32 uValue);
  static void       OctalToString       (ch* pDestStr, size_t uMaxLength, u32 uValue);
  static size_t     XStringToNative     (ch* pNativeStr, size_t uLength, const _XCh* pStrX, size_t cchX);
};

int SimpleASCIItoUnicode(wch* pDestStr, int nCount, const ch* pSrcStr);
int SimpleUnicodeToASCII(ch* pDestStr, int nCount, const wch* pSrcStr);

typedef clStringX<wch, clstd::Allocator, g_Alloc_clStringW, clStringW_traits> clStringW;
typedef clStringX<ch, clstd::Allocator, g_Alloc_clStringA, clStringA_traits> clStringA;
typedef clStringX<wch, clstd::StdAllocator, g_StdAlloc, clStringW_traits> clTextBufferW;
typedef clStringX<ch, clstd::StdAllocator, g_StdAlloc, clStringA_traits> clTextBufferA;

inline size_t hash_value(const clStringW& _Str)
{
  return _Str.GetHash();
}
inline size_t hash_value(const clStringA& _Str)
{
  return _Str.GetHash();
}

#ifdef _ANDROID
// gcc stlport
namespace std
{
  template<> struct hash<clStringA>
  {
    size_t operator()(const clStringA& _Str) const { return _Str.GetHash(); }
  };

  template<> struct hash<clStringW>
  {
    size_t operator()(const clStringW& _Str) const { return _Str.GetHash(); }
  };
}
#elif _IOS
namespace __gnu_cxx
{
    template<> struct hash<clStringA>
    {
        size_t operator()(const clStringA& _Str) const { return _Str.GetHash(); }
    };
    
    template<> struct hash<clStringW>
    {
        size_t operator()(const clStringW& _Str) const { return _Str.GetHash(); }
    };
}
#elif defined(_LINUX)
namespace __gnu_cxx
{
  template<> struct hash<clStringA>
  {
    size_t operator()(const clStringA& _Str) const { return _Str.GetHash(); }
  };

  template<> struct hash<clStringW>
  {
    size_t operator()(const clStringW& _Str) const { return _Str.GetHash(); }
  };
}
#endif // #ifdef _ANDROID

//#ifdef _UNICODE
//typedef clStringW clString;
//#else
//typedef clStringA clString;
//#endif // _UNICODE
typedef const clStringW clConstStringW;
typedef const clStringA clConstStringA;
//typedef const clString clConstString;

typedef clvector<clStringW>   clStringArrayW;
typedef clvector<clStringA>   clStringArrayA;
typedef cllist<clStringW>     clStringListW;
typedef cllist<clStringA>     clStringListA;
typedef clhash_set<clStringW> clStringHashSetW;
typedef clhash_set<clStringA> clStringHashSetA;
//typedef clset<clStringW>      clStringSetW;
//typedef clset<clStringA>      clStringSetA;

clStringW AnsiStringToUnicodeString(const clStringA& str);
clStringA UnicodeStringToAnsiString(const clStringW& str);

//#ifdef _UNICODE
#define AS2TS(STR)  (const wch*)AnsiStringToUnicodeString(STR)
#define WS2TS(STR)  clStringW(STR)
#define TS2AS(STR)  (const ch*)UnicodeStringToAnsiString(STR)
#define TS2WS(STR)  clStringW(STR)
//typedef clStringArrayW clStringArray;
typedef clStringListW  clStringList;
//#else
//#define AS2TS(STR)  clStringA(STR)
//#define WS2TS(STR)  (const ch*)UnicodeStringToAnsiString(STR)
//#define TS2AS(STR)  clStringA(STR)
//#define TS2WS(STR)  (const wch*)AnsiStringToUnicodeString(STR)
////typedef clStringArrayA clStringArray;
//typedef clStringListA  clStringList;
//#endif

#define AS2WS(STR)  (const wch*)AnsiStringToUnicodeString(STR)
#define WS2AS(STR)  (const ch*)UnicodeStringToAnsiString(STR)


#endif // _CL_STRING_H_
