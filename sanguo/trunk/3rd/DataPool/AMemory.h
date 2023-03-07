/*
 * FILE: AMemory.h
 *
 * DESCRIPTION: Routines for memory allocating and freeing
 *
 * CREATED BY: Chenglong.Liu, 2012/12/9
 *
 * HISTORY:
 *
 */

#ifndef _AMEMORY_H_
#define _AMEMORY_H_
#include <new>
#include "ABaseDef.h"

///////////////////////////////////////////////////////////////////////////
//
//  Define and Macro
//
///////////////////////////////////////////////////////////////////////////
#define a_malloc(size)        malloc(size)
#define a_realloc(pMem, size) realloc(pMem, size)
#define a_free(p)             free(p)

//#endif  //  _A_FORBID_MALLOC

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
//  Inline functions
//
///////////////////////////////////////////////////////////////////////////

//#ifndef _A_FORBID_NEWDELETE

// TODO: 不同平台不同定义
#if defined(_WIN32)
#define ATHROW0
#define ATHROW1
#ifndef DISABLE_MEM_DEBUG
#define ENABLE_MEM_CATEGORY  // 内存归类记录
#define ENABLE_MEM_CALLSTACK // 内存分配调用堆栈记录, 只在Win32上有效
#endif

#elif defined(_IOS)
#define ATHROW0
#define ATHROW1

#elif defined(_ANDROID)
#define ATHROW0
#define ATHROW1
#endif

void InitializeMemTracer  ();
void FinalizeMemTracer    ();
void DumpMemUsage         ();

#if defined(ENABLE_MEM_CATEGORY) || defined(ENABLE_MEM_CALLSTACK)


void* operator new(unsigned int) ATHROW1;
void* operator new[](unsigned int) ATHROW1;
void operator delete(void*) ATHROW0;
void operator delete[](void*) ATHROW0;

// new 和 delete 参数中的字符串应该是静态常量, 如果是全局变量或者临时变量可能会出现问题.
void* operator new (unsigned int size, const char* szCategory, const char* szFile, int iLine);
void operator delete (void* p, const char* szCategory, const char* szFile, int iLine);
void* operator new [] (unsigned int size, const char* szCategory, const char* szFile, int iLine);
void operator delete [] (void* p, const char* szCategory, const char* szFile, int iLine);

#define ADEBUG_NEW(_CATE) new(_CATE, __FILE__, __LINE__)

#else
#define ADEBUG_NEW(_CATE) new
#endif // #if defined(ENABLE_MEM_CATEGORY) || defined(ENABLE_MEM_CALLSTACK)
#endif  //  _AMEMORY_H_
