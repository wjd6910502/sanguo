/*
	互斥对象封装头文件，封装了Mutex和RWLock结构
	作者：崔铭
	公司：完美时空
	日期：2009-06-08
*/

#ifndef __ONLINEGMAE_COMMON_MUTEX_H__
#define __ONLINEGMAE_COMMON_MUTEX_H__

#include "spinlock.h"
#include "rwlock.h"
#include <pthread.h>
#include <errno.h>

namespace GNET
{
	class Mutex
	{
		int lock;
	public:
		Mutex(const char *):lock(0) {}
		Mutex():lock(0) {}
		void Lock()   { mutex_spinlock2(&lock); }
		void Unlock() { mutex_spinunlock(&lock); }
		void UNLock(){Unlock();}
		class Scoped
		{
			Mutex *mx;
		public:
			~Scoped () { if(mx) mx->Unlock(); }
			explicit Scoped(Mutex& m) : mx(&m) { mx->Lock(); }
			void Detach() { mx = NULL; }
			void Unlock() { mx->Unlock();}
			void Lock() {mx->Lock();}
		};

		class SmartScoped
		{
			Mutex *mx;
			bool locked;
		public:
			~SmartScoped () { if(mx && locked) mx->Unlock(); }
			explicit SmartScoped(Mutex& m,bool auto_lock = true) : mx(&m), locked(auto_lock) { if(auto_lock) mx->Lock(); }
			void Detach() { mx = NULL; }
			void Unlock() { if(!locked) return; mx->Unlock();locked =false;}
			void Lock() { if(locked) return; mx->Lock(); locked = true;}
		};
	};
#ifdef ENABLE_MUTEX_CONFLICT_DETECT
	class Mutex2
	{
		pthread_mutex_t _pmx;
		
		const char *_name;
		int _N;
		int64_t _lock_count;
		int64_t _lock_count_prev;
		int64_t _lock_fail_count;
		int64_t _lock_fail_count_prev;
	public:
		Mutex2(const char *name, int N=1000): _name(name), _N(N), _lock_count(0), _lock_count_prev(0), _lock_fail_count(0), _lock_fail_count_prev(0)
		{
			pthread_mutex_init(&_pmx, 0);
		}
		Mutex2(): _name("unknown"), _N(1000), _lock_count(0), _lock_count_prev(0), _lock_fail_count(0), _lock_fail_count_prev(0)
		{
			pthread_mutex_init(&_pmx, 0);
		}
		void Lock()
		{
			int ret = pthread_mutex_trylock(&_pmx);
			if(ret == 0)
			{
				_lock_count++;
				return;
			}
			else if(ret == EBUSY)
			{
				//锁冲突
				pthread_mutex_lock(&_pmx);
				_lock_count++;
				_lock_fail_count++;
			}
			else
			{
				abort();
			}
		}
		void Unlock()
		{
			bool b = false;
			int64_t lc;
			int64_t lfc;
			int64_t lc_inc;
			int64_t lfc_inc;
			if(_lock_fail_count-_lock_fail_count_prev >= _N)
			{
				b = true;
				lc = _lock_count;
				lfc = _lock_fail_count;
				lc_inc = _lock_count-_lock_count_prev;
				lfc_inc = _lock_fail_count-_lock_fail_count_prev;

				_lock_count_prev = _lock_count;
				_lock_fail_count_prev = _lock_fail_count;
			}

			pthread_mutex_unlock(&_pmx);

			if(b && (lfc_inc*100.0/lc_inc)>1)
			{
				fprintf(stderr, "LOCK conflict: thread=%u, _name=%s, _lock_count=%ld, _lock_count_inc=%ld, _lock_fail_count_inc=%ld(+%d%%,t%d%%)\n",
				        (unsigned int)pthread_self(), _name, lc, lc_inc, lfc_inc, (int)(lfc_inc*100.0/lc_inc), (int)(lfc*100.0/lc));
			}
		}
		void UNLock(){Unlock();}
		class Scoped
		{
			Mutex2 *mx;
		public:
			~Scoped () { if(mx) mx->Unlock(); }
			explicit Scoped(Mutex2& m) : mx(&m) { mx->Lock(); }
			void Detach() { mx = NULL; }
			void Unlock() { mx->Unlock();}
			void Lock() {mx->Lock();}
		};
	};
#else
	typedef Mutex Mutex2;
#endif

	class RWLock : private abase::RWLock
	{
	public:
		RWLock() {}
		RWLock(const char *) {}
		void WRLock() { WriteLock(); } 
		void RDLock() { ReadLock(); }
		void WRUnlock() { WriteUnlock(); } 
		void RDUnlock() { ReadUnlock(); }
		void RDToWR() { ReadLockToWrite();}
		void WRToRD() { WriteLockToRead();}
		class WRScoped
		{
			RWLock *rw;
		public:
			~WRScoped () { rw->WRUnlock(); }
			explicit WRScoped(RWLock &l) : rw(&l) { rw->WRLock(); }
		};
		class RDScoped
		{
			RWLock *rw;
		public:
			~RDScoped () { rw->RDUnlock(); }
			explicit RDScoped(RWLock &l) : rw(&l) { rw->RDLock(); }
		};
	};
#ifdef ENABLE_MUTEX_CONFLICT_DETECT
	class RWLock2
	{
		pthread_rwlock_t _prwl;

		const char *_name;
		int _N;
		int64_t _rd_lock_count;
		int64_t _wr_lock_count;
		int64_t _rd_lock_fail_count;
		int64_t _wr_lock_fail_count;
		int64_t _rd_lock_count_prev;
		int64_t _wr_lock_count_prev;
		int64_t _rd_lock_fail_count_prev;
		int64_t _wr_lock_fail_count_prev;
	public:
		RWLock2(const char *name, int N=1000): _name(name), _N(N), _rd_lock_count(0), _wr_lock_count(0), _rd_lock_fail_count(0), _wr_lock_fail_count(0), _rd_lock_count_prev(0), _wr_lock_count_prev(0), _rd_lock_fail_count_prev(0), _wr_lock_fail_count_prev(0)
		{
			pthread_rwlock_init(&_prwl, 0);
		}
		RWLock2(): _name("unknown"), _N(1000), _rd_lock_count(0), _wr_lock_count(0), _rd_lock_fail_count(0), _wr_lock_fail_count(0), _rd_lock_count_prev(0), _wr_lock_count_prev(0), _rd_lock_fail_count_prev(0), _wr_lock_fail_count_prev(0)
		{
			pthread_rwlock_init(&_prwl, 0);
		}

		void WRLock()
		{
			int ret = pthread_rwlock_trywrlock(&_prwl);
			if(ret == 0)
			{
				_wr_lock_count++;
				return;
			}
			else if(ret == EBUSY)
			{
				//锁冲突
				pthread_rwlock_wrlock(&_prwl);
				_wr_lock_count++;
				_wr_lock_fail_count++;
			}
			else
			{
				abort();
			}
		}
		void RDLock()
		{
			int ret = pthread_rwlock_tryrdlock(&_prwl);
			if(ret == 0)
			{
				_rd_lock_count++;
				return;
			}
			else if(ret == EBUSY)
			{
				//锁冲突
				pthread_rwlock_rdlock(&_prwl);
				_rd_lock_count++;
				_rd_lock_fail_count++;
			}
			else
			{
				abort();
			}
		}
		void WRUnlock()
		{
			bool b = false;
			int64_t lc;
			int64_t lfc;
			int64_t lc_inc;
			int64_t lfc_inc;
			if(_wr_lock_fail_count-_wr_lock_fail_count_prev >= _N)
			{
				b = true;
				lc = _wr_lock_count;
				lfc = _wr_lock_fail_count;
				lc_inc = _wr_lock_count-_wr_lock_count_prev;
				lfc_inc = _wr_lock_fail_count-_wr_lock_fail_count_prev;

				_wr_lock_count_prev = _wr_lock_count;
				_wr_lock_fail_count_prev = _wr_lock_fail_count;
			}

			pthread_rwlock_unlock(&_prwl);

			if(b && (lfc_inc*100.0/lc_inc)>1)
			{
				fprintf(stderr, "RWLOCK conflict: thread=%u, _name=%s, _wr_lock_count=%ld, _wr_lock_count_inc=%ld, _wr_lock_fail_count_inc=%ld(+%d%%,t%d%%)\n",
				        (unsigned int)pthread_self(), _name, lc, lc_inc, lfc_inc, (int)(lfc_inc*100.0/lc_inc), (int)(lfc*100.0/lc));
			}
		}
		void RDUnlock()
		{
			bool b = false;
			int64_t lc;
			int64_t lfc;
			int64_t lc_inc;
			int64_t lfc_inc;
			if(_rd_lock_fail_count-_rd_lock_fail_count_prev >= _N)
			{
				b = true;
				lc = _rd_lock_count;
				lfc = _rd_lock_fail_count;
				lc_inc = _rd_lock_count-_rd_lock_count_prev;
				lfc_inc = _rd_lock_fail_count-_rd_lock_fail_count_prev;

				_rd_lock_count_prev = _rd_lock_count;
				_rd_lock_fail_count_prev = _rd_lock_fail_count;
			}

			pthread_rwlock_unlock(&_prwl);

			if(b && (lfc_inc*100.0/lc_inc)>1)
			{
				fprintf(stderr, "RWLOCK conflict: thread=%u, _name=%s, _rd_lock_count=%ld, _rd_lock_count_inc=%ld, _rd_lock_fail_count_inc=%ld(+%d%%,t%d%%)\n",
				        (unsigned int)pthread_self(), _name, lc, lc_inc, lfc_inc, (int)(lfc_inc*100.0/lc_inc), (int)(lfc*100.0/lc));
			}
		}

		class WRScoped
		{
			RWLock2 *rw;
		public:
			~WRScoped () { rw->WRUnlock(); }
			explicit WRScoped(RWLock2 &l) : rw(&l) { rw->WRLock(); }
		};
		class RDScoped
		{
			RWLock2 *rw;
		public:
			~RDScoped () { rw->RDUnlock(); }
			explicit RDScoped(RWLock2 &l) : rw(&l) { rw->RDLock(); }
		};
	};
#else
	typedef RWLock RWLock2;
#endif

};

#endif

