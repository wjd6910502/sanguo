#include "include/clstd.h"
#include "include/clString.H"
#if defined(_WINDOWS) || defined(_WIN32)
#include <Windows.h>
#include <Shlwapi.h>
#ifdef _DEBUG
//#  include <vld.h>
#endif
//#pragma comment(lib, "shlwapi.lib")
#pragma warning(disable : 4996)
#endif // #if defined(_WINDOWS) || defined(_WIN32)

const static clstd::ALLOCPLOY aclAllocPloyW[] =
{
  {32, 1024},
  {48, 512},
  {64, 512},
  {96, 256},
  {128, 256},
  {256, 256},
  {512, 256},
  {1024, 64},
  {0,0},
};

const static clstd::ALLOCPLOY aclAllocPloyA[] =
{
  {16, 512},
  {32, 512},
  {48, 512},
  {64, 512},
  {96, 256},
  {128, 256},
  {256, 256},
  {512, 128},
  {1024, 32},
  {0,0},
};

// s_strRootDir 要在 alloc 之前析构
clstd::Allocator g_Alloc_clStringW("StringPoolW", aclAllocPloyW);
clstd::Allocator g_Alloc_clStringA("StringPoolA", aclAllocPloyA);
clstd::StdAllocator g_StdAlloc;
clStringW s_strRootDir;

#define MAX_TRACE_BUFFER 4096
//#ifdef _DEBUG

#if defined(_WINDOWS) || defined(_WIN32)
template<typename _TCh,
  int vsnprintfT(_TCh*, size_t, const _TCh*, va_list),
  void __stdcall OutputDebugStringT(const _TCh*),
  int printfT(const _TCh*, ...)>
void _cl_vtraceT(const _TCh *fmt, va_list val)
{
  //if(IsDebuggerPresent() == FALSE)
  //  return;

  int nTimes = 1;
  int nWriteToBuf;
  _TCh buffer[MAX_TRACE_BUFFER];

  // 流程描述:
  // * 用原始缓冲尝试生成Trace信息
  // * 如果失败尝试分配使用两倍大小的缓冲生成
  // * 如果再失败尝试分配使用三倍大小的缓冲生成
  // ! 综上,超大字符串会比较慢
  do {
    const int nBufferSize = MAX_TRACE_BUFFER * nTimes;
    _TCh* pBuffer = nTimes == 1 ? buffer : new _TCh[nBufferSize];
    nWriteToBuf = vsnprintfT(pBuffer, nBufferSize, fmt, val);
    nTimes++;

    if(nWriteToBuf >= 0) {
      if(IsDebuggerPresent()) {
        OutputDebugStringT(pBuffer);
      }
      else {
        printfT(pBuffer);
      }
    }

    if(pBuffer != buffer && pBuffer != NULL) {
      delete[] pBuffer;
      pBuffer = NULL;
    }
  } while(nWriteToBuf < 0);

  ASSERT(nWriteToBuf < MAX_TRACE_BUFFER * nTimes - 1 && nWriteToBuf >= 0);
}

// 不能用clString,因为clString使用的分配池会调用TRACE
extern "C" void _cl_traceA(const char *fmt, ...)
{
  va_list val;
  va_start(val, fmt);
  _cl_vtraceT<char, vsnprintf, OutputDebugStringA, printf>(fmt, val);
  va_end(val);
}

extern "C" void _cl_traceW(const wchar_t *fmt, ...)
{
  va_list val;
  va_start(val, fmt);
  _cl_vtraceT<wchar_t, _vsnwprintf, OutputDebugStringW, wprintf>(fmt, val);
  va_end(val);
}
#else
extern "C" void _cl_traceW(const wch *fmt, ...)
{
}
extern "C" void _cl_traceA(const char *fmt, ...)
{
}
#endif //defined(_WINDOWS) || defined(_WIN32)

extern "C" void _cl_assertW(const wchar_t *pszSrc, const wchar_t *pszSrcFile,int nLine)
{
  const wch szCaption[] = {'A','s','s','e','r','t',' ','f','a','i','l','e','d','\0'};
    static wch szLine[] = {'=','=','=','=','=','=','=','=','=','=','=','=','=','=','=','=','=','=',
        ' ','%','s',' ','=','=','=','=','=','=','=','=','=','=','=','=','=','=','=','=','=','=','\n',
        '>','%','s','(','%','d',')',':',' ','a','s','s','e','r','t',' ','f','a','i','l','e','d',':',
        ' ','\"','%','s','\"','\n','\n','\n','\0'};
  _cl_traceW(szLine,
    szCaption,pszSrcFile, nLine, pszSrc);
}

//#endif


extern "C" int cl_atoi(const char* szStr)
{
  return atoi(szStr);
}

extern "C" double cl_atof(const char* szStr)
{
  return atof(szStr);
}
