#ifndef _CL_STD_CODE_
#define _CL_STD_CODE_

#define memcpy memmove

#if defined(_WINDOWS)
# include <windows.h>

# if !defined(_X86) && !defined(_X64)
# define _X86
# endif // #if !defined(_X86) && !defined(_X64)

# if !defined(_WIN32) && !defined(_WIN64)
# define _WIN32
# endif // #if !defined(_X86) && !defined(_X64)

#elif defined(_IOS)
# include <assert.h>
#else
# include <wchar.h>
#endif
#include "cltypes.h"
#include <memory.h>


#define CLMAKEFOURCC(ch0, ch1, ch2, ch3)                      \
  ((CLDWORD)(CLBYTE)(ch0) | ((CLDWORD)(CLBYTE)(ch1) << 8) |   \
  ((CLDWORD)(CLBYTE)(ch2) << 16) | ((CLDWORD)(CLBYTE)(ch3) << 24 ))
#define CLMAKEWORD(a, b)      ((CLWORD)(((CLBYTE)(((CLDWORD_PTR)(a)) & 0xff)) | ((CLWORD)((CLBYTE)(((CLDWORD_PTR)(b)) & 0xff))) << 8))
#define CLMAKELONG(a, b)      ((CLLONG)(((CLWORD)(((CLDWORD_PTR)(a)) & 0xffff)) | ((CLDWORD)((CLWORD)(((CLDWORD_PTR)(b)) & 0xffff))) << 16))

#define WIDEN2(x) L##x
#define WIDEN(x) WIDEN2(x)
#define __WFILE__ WIDEN(__FILE__)

#ifndef SAFE_DELETE
#define SAFE_DELETE(x)        if((x) != NULL) {delete (x); (x) = 0;}
#endif // SAFE_DELETE

#ifndef SAFE_DELETE_ARRAY
#define SAFE_DELETE_ARRAY(x)  if((x) != NULL) {delete[](x); (x) = 0;}
#endif // SAFE_DELETE_ARRAY

#ifndef SAFE_RELEASE
#define SAFE_RELEASE(pobj)    if((pobj) != NULL)  {(pobj)->Release(); (pobj) = NULL; }
#endif // SAFE_RELEASE

#define SETBIT(_DW, _IDX)       ((_DW) |= (1 << (_IDX)))
#define RESETBIT(_DW, _IDX)     ((_DW) &= (~(1 << (_IDX))))
#define TESTBIT(_DW, _IDX)      ((_DW) & (1 << (_IDX)))

#define TEST_FLAG(_F, _M)       (((_F) & (_M)) != 0)
#define TEST_FLAG_NOT(_F, _M)   (((_F) & (_M)) == 0)
#define TEST_FLAGS_ANY(_F, _M)  (((_F) & (_M)) != 0)
#define TEST_FLAGS_ALL(_F, _M)  (((_F) & (_M)) == (_M))
#define SET_FLAG(_F, _M)        ((_F) |= (_M))
#define RESET_FLAG(_F, _M)      ((_F) = ((_F) & (~(_M))))
#define SWITCH_FLAG(_F, _M)     ((_F) = ((_F) ^ (_M)))
#define UPDATE_FLAG(_F, _M, _B) ((_F) = (_B) ? ((_F) | (_M)) : ((_F) & (~(_M))))

#define ALIGN_2(x)              (((x) + 1) & (~1))
#define ALIGN_4(x)              (((x) + 3) & (~3))
#define ALIGN_8(x)              (((x) + 7) & (~7))
#define ALIGN_16(x)             (((x) + 15) & (~15))
#define ALIGN_32(x)             (((x) + 31) & (~31))

#define DECL_ALIGN_1            __declspec(align(1))
#define DECL_ALIGN_2            __declspec(align(2))
#define DECL_ALIGN_4            __declspec(align(4))
#define DECL_ALIGN_8            __declspec(align(8))
#define DECL_ALIGN_16           __declspec(align(16))
#define DECL_ALIGN_32           __declspec(align(32))

#define MEMBER_OFFSET(_CLS, _MEMBER)  ((size_t)(&(((_CLS*)0)->_MEMBER)))
#define CLARRAYSIZE(_ARRAY)           (sizeof(_ARRAY)/sizeof(_ARRAY[0]))

#ifdef _DEBUG
# if defined(_WIN32) || defined(_CONSOLE)
#   ifdef _X86
extern "C" void _cl_traceA(const char *fmt, ...);
extern "C" void _cl_traceW(const wchar_t *fmt, ...);
//extern "C" void _cl_WinVerifyFailure(const char *pszSrc, const char *pszSrcFile, int nLine, unsigned long dwErrorNum);
extern "C" void _cl_assertW(const wchar_t *pszSrc, const wchar_t *pszSrcFile, int nLine);

#     define TRACEW        _cl_traceW
#     define TRACEA        _cl_traceA
#     define TRACE         TRACEA
#     define CLOG_WARNING  TRACEA
#     define CLOG_ERROR    TRACEA
#     define CLOG          TRACEA
#     define CLOG_WARNINGW TRACEW
#     define CLOG_ERRORW   TRACEW
#     define CLOGW         TRACEW
#     define CLBREAK       {__asm int 3}

// TODO:????????????CLUNIQUEBREAK
//  1.??????????????????
//  2.???????????????????????????????????????log
#     define CLUNIQUEBREAK {__asm int 3}      // ????????????????????????
#     define CLNOP         {__asm nop}
#     define ASSERT(x)      if(!(x)) {_cl_assertW(L###x, __WFILE__, __LINE__); CLBREAK; } // TODO: ???????????????????????????????????????????????????Release??????????????????
#     define STATIC_ASSERT(x)    static_assert(x, #x);
#     define V(x)              if(FAILED(x)) { CLBREAK; }
#     define V_RETURN(x)       if(FAILED(x)) { return GX_FAIL; }
#   elif defined(_X64)
extern "C" void _cl_traceA(const char *fmt, ...);
extern "C" void _cl_traceW(const wchar_t *fmt, ...);
extern "C" void _cl_WinVerifyFailure(const char *pszSrc, const char *pszSrcFile, int nLine, unsigned long dwErrorNum);
extern "C" void _cl_assertW(const wchar_t *pszSrc, const wchar_t *pszSrcFile, int nLine);
extern "C" void _cl_Break();
extern "C" void _cl_NoOperation();
#     define TRACEW        _cl_traceW
#     define TRACEA        _cl_traceA
#     define TRACE         TRACEA
#     define CLOG_WARNING  TRACEA
#     define CLOG_ERROR    TRACEA
#     define CLOG          TRACEA
#     define CLOG_WARNINGW TRACEW
#     define CLOG_ERRORW   TRACEW
#     define CLOGW         TRACEW
#     define CLBREAK       { _cl_Break(); }
#     define CLUNIQUEBREAK CLBREAK
#     define CLNOP         _cl_NoOperation()
#     define ASSERT(x)      if(!(x)) {_cl_assertW(L###x, __WFILE__, __LINE__); _cl_Break();} // TODO: ???????????????????????????????????????????????????Release??????????????????
#     define STATIC_ASSERT(x)    static_assert(x, #x);
#     define V(x)              if(FAILED(x)) { _cl_Break(); }
#     define V_RETURN(x)       if(FAILED(x)) {return GX_FAIL;}
#   endif // #   ifdef _WIN32
# elif defined(_IOS)
void _cl_traceA(const char *fmt, ...);
void _cl_traceW(const wchar_t *fmt, ...);

#   define TRACEW  _cl_traceW
#   define TRACEA  _cl_traceA
#   define TRACE  TRACEA
#   define CLOG_WARNING
#   define CLOG_ERROR    TRACEA
#   define CLOG          TRACEA
#   define CLOG_WARNINGW TRACEW
#   define CLOG_ERRORW   TRACEW
#   define CLOGW         TRACEA
#   define CLBREAK       {;}
#   define CLNOP
#   define VERIFY(v)  (v)
#   define ASSERT(x)  assert(x)
#   define STATIC_ASSERT(x)
#   define V(x)      (x)
#   define V_RETURN(x)  (x)
# elif defined(_LINUX)
#   define TRACEW
#   define TRACEA
#   define TRACE
#   define CLOG_WARNING
#   define CLOG_ERROR
#   define CLOG
#   define CLOG_WARNINGW
#   define CLOG_ERRORW
#   define CLOGW
#   define CLBREAK       {;}
#   define CLNOP
#   define VERIFY(v)  (v)
#include <assert.h>
#   define ASSERT(x)  assert(x);
#   define STATIC_ASSERT(x)
#   define V(x)      (x)
#   define V_RETURN(x)  (x)
# endif // #if defined(_WINDOWS) || defined(_CONSOLE)
#else  // _DEBUG
#  if defined(_WINDOWS) || defined(_WIN32)
extern "C" void _cl_traceA(const char *fmt, ...);
extern "C" void _cl_traceW(const wchar_t *fmt, ...);
extern "C" void _cl_WinVerifyFailure(const char *pszSrc, const char *pszSrcFile, int nLine, unsigned long dwErrorNum);
extern "C" void _cl_assertW(const wchar_t *pszSrc, const wchar_t *pszSrcFile, int nLine);
#  elif defined(_IOS)
extern "C" void _cl_traceA(const char *fmt, ...);
extern "C" void _cl_traceW(const wch *fmt, ...);
#  elif defined(_ANDROID)
extern "C" void _cl_traceA(const char *fmt, ...);
extern "C" void _cl_traceW(const wch *fmt, ...);
#  elif defined(_LINUX)
extern "C" void _cl_traceA(const char *fmt, ...);
extern "C" void _cl_traceW(const wch *fmt, ...);
#  endif // #if defined(_WINDOWS) || defined(_WIN32)

#  define TRACEW
#  define TRACEA
#  define TRACE  TRACEA
#  define CLOG_WARNING  _cl_traceA
#  define CLOG_ERROR    _cl_traceA
#  define CLOG          _cl_traceA
#  define CLOG_WARNINGW _cl_traceW
#  define CLOG_ERRORW   _cl_traceW
#  define CLOGW         _cl_traceW
#  define CLBREAK       {;}
#  define CLUNIQUEBREAK CLBREAK
#  define CLNOP
#  define VERIFY(v)  (v)
#  define ASSERT(x)
#  define STATIC_ASSERT(x)
#  define V(x)      (x)
#  define V_RETURN(x)  (x)
#endif  // _DEBUG

#define NOT_IMPLEMENT_FUNC_MAKER  TRACE("%s(%d): Not implement:"__FUNCTION__"()\n", __FILE__, __LINE__)

#include "clAllocator.h"

#ifndef FALSE
#define FALSE 0
#endif

#ifndef TRUE
#define TRUE 1
#endif

//#ifndef INVALID_HANDLE_VALUE
//#define INVALID_HANDLE_VALUE ((HANDLE)(u32_ptr)-1)
//#endif // INVALID_HANDLE_VALUE

#if (defined(_WINDOWS) || defined(_WIN32)) && !defined(POSIX_THREAD)
#include <windows.h>
#define CL_CALLBACK  __stdcall
#else
#include <pthread.h>
#define CL_CALLBACK
#endif


#define CLCONST const


//
// Byte Order Mark
//
#define BOM_UNICODE             0xFEFF
#define BOM_UNICODE_BIGENDIAN   0xFFFE
#define BOM_UTF8                0xBFBBEF

extern "C" b32 strcmpnA(const ch* lpString1, const ch* lpString2, int nCount);
extern "C" b32 strcmpnW(const wch* lpString1, const wch* lpString2, int nCount);
extern "C" int cl_atoi(const char* szStr);
extern "C" double cl_atof(const char* szStr);

#else
//#pragma message(__FILE__": warning : Duplicate included this file.")
#endif // _CL_STD_CODE_
