/* 
	�̳߳�ģ�飬 ����ʵ����һ���������õ��̳߳�ģ�飬�ṩ�˽Ϻõ����ܣ�ͬʱҲ�����˶Է�һ���ڴ��ȡ�ܹ���֧�֡�
	���ߣ�����
	�޸ģ�������
	��˾������ʱ��
	���ڣ�2009-06-08
 */

#include <stdlib.h>
#include <stdio.h>
#ifndef __ONLINEGAME_COMMON_THREAD_H
#define __ONLINEGAME_COMMON_THREAD_H

namespace GNET
{

	class Runnable
	{
		int m_priority;
	public:
		Runnable( int priority = 0 ) : m_priority(priority) { }
		virtual ~Runnable() {}
		virtual void Run() = 0;

		int GetPriority() const { return m_priority; }
		void SetPriority( int priority ) { m_priority = priority; }
	};

	enum
	{
		TASK_TYPE_GLOBAL 	= 0x0001,
		TASK_TYPE_GROUP	 	= 0x0002,
		TASK_TYPE_SEQUENCE 	= 0x0004,
		TASK_TYPE_GROUP_SEQ 	= 0x0008,
	};

	class ThreadPool;
	class ThreadPolicy
	{
		public:
			typedef void *(*PoolEntrance)(ThreadPool *__this, int group_index, bool group, bool group_seq, bool global, bool global_seq);
			typedef void (*ThreadInit)();
		protected:
			PoolEntrance _thread_entrance;
			ThreadInit  _thread_init;
			
		public:

			ThreadPolicy():_thread_entrance(NULL),_thread_init(NULL) {}
			virtual ~ThreadPolicy() {}

			virtual void SetPoolEntrance(PoolEntrance  entrance) { _thread_entrance = entrance;}	//�˺�����ThreadPool����
			virtual void * GroupMalloc(int group_index, size_t size) { return malloc(size);}
			virtual void GroupFree(int group_index, void * buf,size_t size) { return free(buf);}
			virtual void AddTask(ThreadPool * pool ,int arg,  Runnable * task);	//��׼ʵ���ǵ���AddTask
			virtual void * PoolMalloc(size_t size)  {return malloc(size);}
			virtual void PoolFree(void * buf) {free(buf);}

			virtual void Release() = 0;
			virtual int GetGroupCount() = 0;
			virtual int GetSeqCount(int group_index) = 0;		//-1 for global sequence 
			virtual void Run(ThreadPool * pool) = 0;
	};

	class ThreadPool
	{
		void * _imp;
		ThreadPolicy* _policy;

		static void *WorkThread(ThreadPool * __this, int group_index, bool group, bool group_seq, bool global, bool global_seq);
	public:
		ThreadPool();
		~ThreadPool();
		bool Init(ThreadPolicy *p);
		bool Start();
		void Stop();		//Stop֮���߳��ǲ������̽����������Ҫ�ȴ�����������������WaitStop
		void WaitStop();
		int TryProcessAllTask();	//��ͼһ���Դ��������е�TaskȻ�󷵻ء���ĳ��˳�����������߳�ִ��ʱ���޷��õ���˳�����������)
	public:
		void AddTask(Runnable * task);
		void AddGroupTask(size_t group_index, Runnable * task);
		void AddSeqTask(size_t seq_number, Runnable * task);
		void AddGroupSeqTask(size_t group_index, size_t seq_number, Runnable * task);		//���ڳ�ʼ��˳���ԭ�� ��û��Startǰ��������û��Զ�ת�Ƶ� AddSeqTask����AddTask��
		void CreateThread(void *(*function)(void*), void * param);	//����һ��������ִ���߳�
		inline void PolicyAddTask(int arg, Runnable * task) { _policy->AddTask(this, arg, task); }

		bool IsIdle();
		void dump(FILE *file = stdout);
		inline bool IsInitialized() const {return _imp && _policy;}
	};

}

#endif

