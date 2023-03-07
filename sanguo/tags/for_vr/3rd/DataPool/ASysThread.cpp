#include "ASysThread.h"

#ifdef _WIN32

//-------------------------------------------------------------------------------------------------
//	ASysThreadAtomic
//-------------------------------------------------------------------------------------------------

int ASysThreadAtomic::Fetch_Add(int iAmount)
{
	return (int)InterlockedExchangeAdd((LPLONG)&m_iValue, (int)iAmount);
}

int ASysThreadAtomic::Fetch_Set(int iAmount)
{
	return (int)InterlockedExchange((LPLONG)&m_iValue, (int)iAmount);
}

int ASysThreadAtomic::Fetch_CompareSet(int iAmount, int iComparand)
{
	return (int)InterlockedCompareExchange((LPLONG)&m_iValue, (int)iAmount, (int)iComparand);
}

int ASysThreadAtomic::Increment_Fetch()
{
	return (int)InterlockedIncrement((LPLONG)&m_iValue);
}

int ASysThreadAtomic::Decrement_Fetch()
{
	return (int)InterlockedDecrement((LPLONG)&m_iValue);
}

//-------------------------------------------------------------------------------------------------
//	ASysThreadMutex
//-------------------------------------------------------------------------------------------------

ASysThreadMutex::ASysThreadMutex()
{
	InitializeCriticalSection(&m_cs);
}

ASysThreadMutex::~ASysThreadMutex()
{
	DeleteCriticalSection(&m_cs);
}

void ASysThreadMutex::Lock()
{
	EnterCriticalSection(&m_cs);
}

void ASysThreadMutex::Unlock()
{
	LeaveCriticalSection(&m_cs);
}

#else // Linux

//-------------------------------------------------------------------------------------------------
//	ASysThreadAtomic
//-------------------------------------------------------------------------------------------------

int ASysThreadAtomic::Fetch_Add(int iAmount)
{
	return __sync_fetch_and_add(&m_iValue, iAmount);
}

int ASysThreadAtomic::Fetch_Set(int iAmount)
{
	if (0 == iAmount)
		return __sync_fetch_and_and(&m_iValue, 0);
	else
		return __sync_lock_test_and_set(&m_iValue, iAmount);
}

int ASysThreadAtomic::Fetch_CompareSet(int iAmount, int iComparand)
{
	return __sync_val_compare_and_swap(&m_iValue, iComparand, iAmount);
}

int ASysThreadAtomic::Increment_Fetch()
{
	return __sync_add_and_fetch(&m_iValue, 1);
}

int ASysThreadAtomic::Decrement_Fetch()
{
	return __sync_sub_and_fetch(&m_iValue, 1);
}

//-------------------------------------------------------------------------------------------------
//	ASysThreadMutex
//-------------------------------------------------------------------------------------------------

ASysThreadMutex::ASysThreadMutex()
{
	pthread_mutexattr_t ma;
	pthread_mutexattr_init(&ma);
	pthread_mutexattr_settype(&ma, PTHREAD_MUTEX_RECURSIVE);
	pthread_mutex_init(&m_mutex, &ma);
	pthread_mutexattr_destroy(&ma);
}

ASysThreadMutex::~ASysThreadMutex()
{
	pthread_mutex_destroy(&m_mutex);
}

void ASysThreadMutex::Lock()
{
	pthread_mutex_lock(&m_mutex);
}

void ASysThreadMutex::Unlock()
{
	pthread_mutex_unlock(&m_mutex);
}

#endif
