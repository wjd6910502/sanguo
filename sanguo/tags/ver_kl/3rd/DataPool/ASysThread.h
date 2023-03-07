#ifndef _ASYSTHREAD_H__
#define _ASYSTHREAD_H__

#ifdef _WIN32

#include <Windows.h>

//-------------------------------------------------------------------------------------------------
//	ASysThreadAtomic
//-------------------------------------------------------------------------------------------------

class ASysThreadAtomic
{
public:

	ASysThreadAtomic(int value) :
	  m_iValue(value)
	{
	}

	int GetValue() const { return m_iValue; }

	int Fetch_Add(int iAmount);
	int Fetch_Set(int iAmount);
	int Fetch_CompareSet(int iAmount, int iComparand);

	int Increment_Fetch();
	int Decrement_Fetch();

private:

	__declspec(align(4)) volatile int	m_iValue;
};

//-------------------------------------------------------------------------------------------------
//	ASysThreadMutex
//-------------------------------------------------------------------------------------------------

class ASysThreadMutex
{
public:

	ASysThreadMutex();
	~ASysThreadMutex();

	void Lock();
	void Unlock();

private:

	CRITICAL_SECTION	m_cs;
};

#else // Linux

#include <pthread.h>

//-------------------------------------------------------------------------------------------------
//	ASysThreadAtomic
//-------------------------------------------------------------------------------------------------

class ASysThreadAtomic
{
public:

	ASysThreadAtomic(int value) :
	  m_iValue(value)
	{
	}

	int GetValue() const { return m_iValue; }

	int Fetch_Add(int iAmount);
	int Fetch_Set(int iAmount);
	int Fetch_CompareSet(int iAmount, int iComparand);

	int Increment_Fetch();
	int Decrement_Fetch();

private:

	volatile int	m_iValue;
};

//-------------------------------------------------------------------------------------------------
//	ASysThreadMutex
//-------------------------------------------------------------------------------------------------

class ASysThreadMutex
{
public:

	ASysThreadMutex();
	~ASysThreadMutex();

	void Lock();
	void Unlock();

private:

	pthread_mutex_t m_mutex;
};

#endif

#endif
