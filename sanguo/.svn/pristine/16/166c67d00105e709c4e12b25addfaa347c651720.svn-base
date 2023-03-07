 /*
 * FILE: AMemory.cpp
 *
 * DESCRIPTION: Routines for memory allocating and freeing
 *
 * CREATED BY: duyuxin, 2003/6/4
 *
 * HISTORY:
 *
 * Copyright (c) 2001 Archosaur Studio, All Rights Reserved.
 */

//#include <malloc.h>
//#include <assert.h>
//#include <stdio.h>
#include "AAssist.h"
#include "AMemory.h"
#include "ALog.h"
#include "hashmap.h"
#include "hashtab.h"
#include "AString.h"
#include "ASysThread.h"
//

/*  init_seg (lib) ensure ACommon::l_MemoryMan to be constructed before and
  destructed after all other application objects. This is very
  important, because some application's global or static objects may allocate
  or free memory in their constructor or destructors.

  init_seg (lib) will cause a VC compiling warning 4073, disable it.
*/
#pragma warning (disable: 4073)
#if defined(ENABLE_MEM_CATEGORY) || defined(ENABLE_MEM_CALLSTACK)
//#pragma comment(lib, "dbghelp.lib")
#include <DbgHelp.h>
BOOL (__stdcall *PSymInitializeW)      (__in HANDLE hProcess, __in_opt PCWSTR UserSearchPath, __in BOOL fInvadeProcess);
BOOL (__stdcall *PSymCleanup)          (__in HANDLE hProcess);
BOOL (__stdcall *PSymGetLineFromAddr64)(__in HANDLE hProcess, __in DWORD64 qwAddr, __out ADWORD* pdwDisplacement, __out PIMAGEHLP_LINE64 Line64);
#endif // #if defined(ENABLE_MEM_CATEGORY) || defined(ENABLE_MEM_CALLSTACK)
#pragma init_seg (lib)

///////////////////////////////////////////////////////////////////////////
//
//  Define and Macro
//
///////////////////////////////////////////////////////////////////////////

//  Memory align size
#define MEM_ALIGN      16
#define MEM_POOLSIZE    256
#define MEM_SMALLSIZE    256
#define MEM_SLOTNUM      (MEM_SMALLSIZE / MEM_ALIGN)
#define MEM_GC_COUNTER    1000

#define MEM_ALLOC_FLAG_S  0x0100
#define MEM_FREE_FLAG_S    0x0101
#define MEM_ALLOC_FLAG_L  0x0200
#define MEM_FREE_FLAG_L    0x0201

#define MEM_ALLOC_FILL    0xcd
#define MEM_FREE_FILL    0xfe
#define MEM_SLOP_OVER    0x98989898

//  Non-zero means thread safe opening
#define MEM_THREADSAFE    1

//  Size used for slop-over checking
#define SLOPOVER_SIZE    (sizeof (ADWORD) * 2)

#define ALIGN8(_SIZE)   ((_SIZE + 7) & (~7))
#define ALIGN16(_SIZE)  ((_SIZE + 15) & (~15))
#define ALIGN32(_SIZE)  ((_SIZE + 31) & (~31))
//  Max call stack level
const int MAX_CALLSTACK_LV = 8;

///////////////////////////////////////////////////////////////////////////
//
//  Reference to External variables and functions
//
///////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////
//
//  Local Types and Variables and Global variables
//
///////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////
//
//  Local functions
//
///////////////////////////////////////////////////////////////////////////

#if defined(ENABLE_MEM_CATEGORY) || (defined(ENABLE_MEM_CALLSTACK) && defined(_WIN32))
namespace AMemory
{
  class _alloc
  {
  public: 
    inline static void * allocate(unsigned int size) { 
      void * rst = ::LocalAlloc(LMEM_FIXED, size);
      return rst;
    }
    inline static void  deallocate(void * ptr,unsigned int size) 
    { 
      ::LocalFree(ptr);
    }
    inline static void  deallocate(void * ptr) 
    { 
      ::LocalFree(ptr);
    }
  };
} // namespace AMemory

struct MEMRECORD
{
  int nCurSize;
  int nMaxSize;
  
  inline void Add(int nSize)
  {
    nCurSize += nSize;
    nMaxSize = max(nMaxSize, nCurSize);
  }
  inline void Sub(int nSize)
  {
    nCurSize -= nSize;
  }
};

struct MEMUSAGE
{
  MEMRECORD act;  // actual
  MEMRECORD a8;   // surmise aligned 8 bytes
  MEMRECORD a16;  // surmise aligned 16 bytes
  MEMRECORD a32;  // surmise aligned 32 bytes

  inline void Add(int nSize)
  {
    act.Add(nSize);
     a8.Add(ALIGN8(nSize));
    a16.Add(ALIGN16(nSize));
    a32.Add(ALIGN32(nSize));
  }
  inline void Sub(int nSize)
  {
    act.Sub(nSize);
     a8.Sub(ALIGN8(nSize));
    a16.Sub(ALIGN16(nSize));
    a32.Sub(ALIGN32(nSize));
  }
};

#if defined(ENABLE_MEM_CATEGORY)
typedef abase::hash_map<const char*, MEMUSAGE, abase::_hash_function, AMemory::_alloc> MemStatusMap;
#endif // #if defined(ENABLE_MEM_CATEGORY)

struct MEMBLOCK
{
  unsigned int size;

# if defined(ENABLE_MEM_CATEGORY)
  const char* szCategory;
# endif // #if defined(ENABLE_MEM_CATEGORY)

  // 调用时直接提供的源代码记录
  const char* szFile;
  int nLine;

  // 调用时没有提供源代码的记录, 这里是堆栈追踪
# if defined(ENABLE_MEM_CALLSTACK) && defined(_WIN32)
  typedef abase::vector<void*, AMemory::_alloc> StackArray;
  StackArray aCallStack;
# endif // #if defined(ENABLE_MEM_CALLSTACK) && defined(_WIN32)
};
typedef abase::hash_map<void*, MEMBLOCK, abase::_hash_function, AMemory::_alloc> MemBlockMap;
MEMUSAGE g_sTotal = {0, 0};




ASysThreadMutex* g_pMemLocker = NULL;
MemBlockMap* g_pMemBlocks = NULL;


#if defined(ENABLE_MEM_CATEGORY)
MemStatusMap* g_pMemCateStatus = NULL;
#endif // #if defined(ENABLE_MEM_CATEGORY)

static void RegisterMem(void* ptr, unsigned int size, const char* szCategory, const char* szFile, int iLine)
{
  (*g_pMemLocker).Lock();

  const static char* szNoname = "<noname>";
  MEMBLOCK mb;
  mb.size = size;
# if defined(ENABLE_MEM_CATEGORY)
  mb.szCategory = szCategory == NULL ? szNoname : szCategory;
# endif // #if defined(ENABLE_MEM_CATEGORY)
  mb.szFile = szFile;
  mb.nLine = iLine;

# if defined(ENABLE_MEM_CALLSTACK) && defined(_WIN32)
  void* _ebp;
  __asm mov _ebp, ebp

  do {
    mb.aCallStack.push_back(((void**)_ebp)[1]);
    _ebp = ((void**)_ebp)[0];
  }while(_ebp);

# endif // #if defined(ENABLE_MEM_CALLSTACK) && defined(_WIN32)
  (*g_pMemBlocks)[ptr] = mb;

#if defined(ENABLE_MEM_CATEGORY)
  MemStatusMap::iterator it = (*g_pMemCateStatus).find(mb.szCategory);
  if(it != (*g_pMemCateStatus).end()) {
    it->second.Add(size);
  }
  else {
    MEMUSAGE mu;
    memset(&mu, 0, sizeof(mu));
    mu.Add(size);
    (*g_pMemCateStatus)[mb.szCategory] = mu;
  }
#endif // #if defined(ENABLE_MEM_CATEGORY)

  g_sTotal.Add(size);
  (*g_pMemLocker).Unlock();
}

static void UnregisterMem(void* ptr, const char* szCategory, const char* szFile, int iLine)
{
  (*g_pMemLocker).Lock();
  MemBlockMap::iterator it = (*g_pMemBlocks).find(ptr);
  if(it != (*g_pMemBlocks).end()) {
    g_sTotal.Sub(it->second.size);

#if defined(ENABLE_MEM_CATEGORY)
    (*g_pMemCateStatus)[it->second.szCategory].Sub(it->second.size);
#endif // #if defined(ENABLE_MEM_CATEGORY)

    (*g_pMemBlocks).erase(it);
  }
  (*g_pMemLocker).Unlock();
}

void* operator new (unsigned int size)
{
  void* ptr = ::malloc(size);
  RegisterMem(ptr, size, NULL, NULL, -1);
  return ptr;
}

void* operator new [] (unsigned int size)
{
  return ::operator new(size);
}

void operator delete (void* p)
{
  ::free(p);
  UnregisterMem(p, NULL, NULL, -1);
}

void operator delete[] (void* p)
{
  ::operator delete(p);
}

void* operator new (unsigned int size, const char* szCategory, const char* szFile, int iLine)
{
  void* ptr = ::malloc(size);
  RegisterMem(ptr, size, szCategory, szFile, iLine);
  return ptr;
}

void operator delete (void* p, const char* szCategory, const char* szFile, int iLine)
{
  ::free(p);
  UnregisterMem(p, szCategory, szFile, iLine);
}

void* operator new [] (unsigned int size, const char* szCategory, const char* szFile, int iLine)
{
  void* ptr = ::malloc(size);
  RegisterMem(ptr, size, szCategory, szFile, iLine);
  return ptr;
}

void operator delete [] (void* p, const char* szCategory, const char* szFile, int iLine)
{
  ::free(p);
  UnregisterMem(p, szCategory, szFile, iLine);
}

//
// 以下这些函数是可以在CRT之外正常运行的内存监视函数
// 1. void InitializeMemTracer();
// 2. void FinalizeMemTracer();
// 3. void DumpMemUsage();
//
void InitializeMemTracer()
{
  // 这里不能调用malloc函数,怀疑这个基于HeapAlloc,而Heap是在CRT中初始化的.
  g_pMemLocker     = (ASysThreadMutex*)LocalAlloc(LMEM_FIXED, sizeof(ASysThreadMutex));
  new(g_pMemLocker)    ASysThreadMutex();   // 显式构造函数

#if defined(ENABLE_MEM_CATEGORY)
  g_pMemCateStatus = (MemStatusMap*   )LocalAlloc(LMEM_FIXED, sizeof(MemStatusMap));
  new(g_pMemCateStatus)MemStatusMap   ();
#endif // #if defined(ENABLE_MEM_CATEGORY)

  g_pMemBlocks     = (MemBlockMap*    )LocalAlloc(LMEM_FIXED, sizeof(MemBlockMap));
  new(g_pMemBlocks)    MemBlockMap    ();
}

void FinalizeMemTracer()
{
  g_pMemLocker->~ASysThreadMutex();  // 显式析构函数
  LocalFree(g_pMemLocker);  // 内存释放

#if defined(ENABLE_MEM_CATEGORY)
  g_pMemCateStatus->~MemStatusMap();
  LocalFree(g_pMemCateStatus);
#endif // #if defined(ENABLE_MEM_CATEGORY)
  
  g_pMemBlocks->~MemBlockMap();
  LocalFree(g_pMemBlocks);
}

void DumpMemUsage()
{
  // 这里面不要有任何STL函数, 或者隐含的内存分配
  (*g_pMemLocker).Lock();
#if defined(ENABLE_MEM_CALLSTACK) && defined(_WIN32)
  HMODULE hDbgHelp = LoadLibraryA("DbgHelp.dll");

  if(hDbgHelp)
  {
    (*(INT_PTR*)&PSymInitializeW) = (INT_PTR)GetProcAddress(hDbgHelp, "SymInitializeW");
    (*(INT_PTR*)&PSymCleanup) = (INT_PTR)GetProcAddress(hDbgHelp, "SymCleanup");
    (*(INT_PTR*)&PSymGetLineFromAddr64) = (INT_PTR)GetProcAddress(hDbgHelp, "SymGetLineFromAddr64");
  }

  if(PSymInitializeW == NULL || PSymGetLineFromAddr64 == NULL || PSymCleanup == NULL) {
    return;
  }

  HANDLE hProcess = GetCurrentProcess();
  BOOL bval = PSymInitializeW(hProcess, NULL, TRUE);
#endif // #if defined(ENABLE_MEM_CALLSTACK) && defined(_WIN32)

  const char* szName = "Mem name";
  int nWidth = strlen(szName);

#if defined(ENABLE_MEM_CATEGORY)
  char szSpaces[128];
  // 确定统计列表里最大的宽度
  for(MemStatusMap::iterator it = (*g_pMemCateStatus).begin();
    it != (*g_pMemCateStatus).end(); ++it)
  {
    int nLen = strlen(it->first);
    nWidth = nWidth > nLen ? nWidth : nLen;
  }

  // 表头
  a_LogOutput(-1, "%s | curr size | max size  |aligned 8 max|"
  "aligned 16 max|aligned 32 max", szName);
  for(MemStatusMap::iterator it = (*g_pMemCateStatus).begin();
    it != (*g_pMemCateStatus).end(); ++it)
  {
    MEMUSAGE& ms = it->second;
    // 准备占位的空格
    int nEOS = nWidth - strlen(it->first);
    nEOS = nEOS < (sizeof(szSpaces) - 1) ? nEOS : (sizeof(szSpaces) - 1);
    memset(szSpaces, 0x20, nEOS);
    szSpaces[nEOS] = '\0';

    a_LogOutput(-1, "%s%s:|%9d  |%9d  |%11d  |%12d  |%12d", szSpaces, it->first,
      ms.act.nCurSize, ms.act.nMaxSize, ms.a8.nMaxSize,
      ms.a16.nMaxSize, ms.a32.nMaxSize);
  }
#endif // #if defined(ENABLE_MEM_CATEGORY)

  a_LogOutput(-1, "The max memory used:%d byte(s)(NOT the sum of above).", g_sTotal.act.nMaxSize);
  a_LogOutput(-1, "The max memory used aligned 8 is:%d bytes, aligned 16 is:%d, aligned 32 is: %d", 
    g_sTotal.a8.nMaxSize, g_sTotal.a16.nMaxSize, g_sTotal.a32.nMaxSize);

  for(MemBlockMap::iterator it = (*g_pMemBlocks).begin();
    it != (*g_pMemBlocks).end(); ++it)
  {
    MEMBLOCK& mb = it->second;
    if(mb.szFile != NULL && mb.nLine > 0)
    {
#if defined(ENABLE_MEM_CATEGORY)
      a_LogOutput(-1, ">%s(%d): %d byte(s) already used, (cate:%s).", mb.szFile, 
        mb.nLine, mb.size, mb.szCategory);
#else
      a_LogOutput(-1, ">%s(%d): %d byte(s) already used.", mb.szFile, 
        mb.nLine, mb.size);
#endif // #if defined(ENABLE_MEM_CATEGORY)
    }
#if defined(ENABLE_MEM_CALLSTACK) && defined(_WIN32)
    IMAGEHLP_LINE64  sourceInfo = { 0 };
    sourceInfo.SizeOfStruct = sizeof(IMAGEHLP_LINE64);
    ADWORD displacement = 0;

    a_LogOutput(-1, "We have %d byte(s) already used, call stack is:", mb.size);
    for(MEMBLOCK::StackArray::iterator itStack = mb.aCallStack.begin() + 1;
      itStack != mb.aCallStack.end(); ++itStack)
    {
      bval = PSymGetLineFromAddr64(hProcess, (DWORD64)*itStack, &displacement, &sourceInfo);
      if(bval) {
        a_LogOutput(-1, " >%s(%d);", sourceInfo.FileName, sourceInfo.LineNumber);
      }
      else {
        a_LogOutput(-1, " >address: 0x%08X;", *itStack);
      }
    }
    a_LogOutput(-1, "");
#endif // #if defined(ENABLE_MEM_CALLSTACK) && defined(_WIN32)
  }

#if defined(ENABLE_MEM_CALLSTACK) && defined(_WIN32)
  PSymCleanup(hProcess);
  FreeLibrary(hDbgHelp);
#endif // #if defined(ENABLE_MEM_CALLSTACK) && defined(_WIN32)

  (*g_pMemLocker).Unlock();
}

#endif // #if defined(ENABLE_MEM_CATEGORY) || (defined(ENABLE_MEM_CALLSTACK) && defined(_WIN32))

struct DBGCPPMEM
{
  AINT_PTR szName;  // 内存归类的名字
  unsigned int nCurSize;  // 当前使用的容量
  unsigned int nMaxSize;  // 峰值容量
  unsigned int nMaxSizeA8;
  unsigned int nMaxSizeA16;
  unsigned int nMaxSizeA32;
};

#if defined(ENABLE_MEM_CATEGORY)
extern "C" int DLL_API DbgCppMem(DBGCPPMEM* pMem, int nCount)
{
  if(nCount <= 0) {
    return g_pMemCateStatus->size();
  }

  int i = 0;
  for(MemStatusMap::iterator it = g_pMemCateStatus->begin();
    it != g_pMemCateStatus->end() && i < nCount; ++it, ++i)
  {
    pMem[i].szName = (AINT_PTR)it->first; // 这里不太安全, 取完了赶紧用
    pMem[i].nCurSize = it->second.act.nCurSize;
    pMem[i].nMaxSize = it->second.act.nMaxSize;
    pMem[i].nMaxSizeA8 = it->second.a8.nMaxSize;
    pMem[i].nMaxSizeA16 = it->second.a16.nMaxSize;
    pMem[i].nMaxSizeA32 = it->second.a32.nMaxSize;
  }
  //DumpMemUsage();
  return i;
}
#elif ! defined(ENABLE_MEM_CALLSTACK)
extern "C" int DLL_API DbgCppMem(DBGCPPMEM* pMem, int nCount)
{
  return 0;
}
void InitializeMemTracer()
{
}

void FinalizeMemTracer()
{
}

void DumpMemUsage()
{
}
#else
extern "C" int DLL_API DbgCppMem(DBGCPPMEM* pMem, int nCount)
{
  if(nCount <= 0) {
    return 1;
  }
  pMem->szName = 0;
  pMem->nCurSize = g_sTotal.nCurSize;
  pMem->nMaxSize = g_sTotal.nMaxSize;
  return 1;     
}
#endif // #if defined(ENABLE_MEM_CATEGORY)