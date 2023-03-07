/* 	
	�̳߳ش�����ִ�в��Զ����ļ�
	���ߣ�������
	�޸ģ�����
	��˾������ʱ��
	���ڣ�2009-06-08
 */

#ifndef __ONLINEGMAE_COMMON_THREAD_POLICY_H__
#define __ONLINEGMAE_COMMON_THREAD_POLICY_H__

#include "numalib.h"
#include "threadpool.h"
#include <vector>
#include <string.h>
#include <pthread.h>

namespace GNET
{
	class ThreadPolicySingle : public ThreadPolicy
	{
		public:
			virtual void Release() { delete this;}
			virtual int GetGroupCount()  { return 1;}
			virtual int GetSeqCount(int group_index) { if(group_index < 0) return 1; else return 0; }
			virtual void Run(ThreadPool * pool) { _thread_entrance(pool, 0, true, false, true, false);}
			virtual void AddTask(ThreadPool * pool, int arg, Runnable * task) { pool->AddSeqTask(0, task);}
			void RunTick(ThreadPool *pool) {pool->TryProcessAllTask();}
	};


	class ThreadPolicyBase : public ThreadPolicy
	{
		protected:
		struct thread_t 
		{
			bool global;
			bool group;
			bool sequence;
			bool group_sequence;
		};
		struct  group_t
		{
			int cpu_node;
			int seq_count;
			std::vector<thread_t> threads;
		};
		
		std::vector<group_t> _groups;
		int _seq_count;
		public:
			ThreadPolicyBase():_seq_count(0) {}
		
			//�����߳���Ϣ�ĺ���
			//����һ�����飬 cpu_node��ָ���groupϣ�����ĸ�cpu���ܡ�cpu_node<0ʱ��������Ч����ʾ��ϵͳ������䣬û������
			//seq_count��ָ��������У�����ͨ������Ŀ���м����ܵ��� ͬһ���ܵ��ϵ���Ҫ��˳��)
			//ע�⣬����Ҫ��һ�����飬�����̳߳��޷�����
			int AddGroup(int cpu_node, int seq_count)
			{
				group_t gt;
				gt.cpu_node = cpu_node;
				gt.seq_count = seq_count;
				_groups.push_back(gt);
				return _groups.size() - 1;
			}

			//����һ���̡߳�group_index��ָ����̸߳����ĸ�group
			//task_type_mask��ָ����̸߳�����Щ����
			void AddThread(int group_index, unsigned int task_type_mask) /*TASK_TYPE_GLOBAL, TASK_TYPE_GROUP,TASK_TYPE_SEQUENCE, TASK_TYPE_GROUP_SEQ*/
			{
				group_t & gt = _groups[group_index];
				thread_t tt;
				memset(&tt, 0, sizeof(tt));
				if(task_type_mask & TASK_TYPE_GLOBAL) tt.global = true;
				if(task_type_mask & TASK_TYPE_GROUP) tt.group = true;
				if(task_type_mask & TASK_TYPE_SEQUENCE) tt.sequence = true;
				if(task_type_mask & TASK_TYPE_GROUP_SEQ) tt.group_sequence = true;
				gt.threads.push_back(tt);
			}

			//����ʵ���ϵġ������Ϲ��м���������ͨ������   (�൱���������ϵ��ܵ���ʵʵ���ھ�8���ܵ�)
			//��seqence number��Ӧ�ó�������ġ��߼��ϵ����кš� (�൱���˶�Ա�����õĽ��������ƣ����ֿ��ܴܺ󣬱���100,101, 2000�ȵ�, û�ϳ���������Ķ���Ҳ�����ڣ�
			//ͬһ�߼����к��ϵ�Task��˳��ִ�еġ�  (������Ҫ��һ�������ﴫ����һ����������Ч)
			//ͬһ����������ͨ���ϵ�TaskҲ��˳��ִ�еģ� (��һС��ĵ�2���� ���ڶ�С��ĵ�2���� ��Ȼ�������кŲ�ͬ���������벻ͬ�� ��ҲҪ��һС������꣬�ڶ��������)
			void SetSequenceCount(int count) { _seq_count = count; }
		public:
			//�̳е��麯��
			virtual void Release() { delete this;}
			virtual int GetGroupCount() 
			{ 
				return _groups.size();
			}
			virtual int GetSeqCount(int group_index)
			{
				if(group_index < 0) return _seq_count;
				return _groups[group_index].seq_count;
			}

			virtual void Run(ThreadPool * pool)
			{
				for(size_t i =0; i < _groups.size(); i ++)
				{
					for(size_t j = 0;j < _groups[i].threads.size(); j ++)
					{
						thread_node_t * node = new thread_node_t(this, pool, i, j);
						pthread_t th;
						pthread_create(&th,NULL, GetThreadEntrance(),node);
					}
				}
			}
		protected:
			typedef void *(*THREAD_ENTRANCE)(void*);
			virtual THREAD_ENTRANCE GetThreadEntrance() { return ThreadEntrance;}
			struct thread_node_t
			{
				ThreadPolicyBase * __this;
				ThreadPool * pool;
				int group;
				int thread;
				thread_node_t(ThreadPolicyBase * tp, ThreadPool * p, int g, int t):__this(tp),pool(p), group(g),thread(t) {}
			};
			static void * ThreadEntrance(void * param)
			{
				pthread_detach(pthread_self());
				thread_node_t * node = (thread_node_t*)param;
				ThreadPolicyBase * __this = node->__this;
				ThreadPool * pool = node->pool;
				int group_index = node->group;
				thread_t & th = __this->_groups[node->group].threads[node->thread];
				delete node;
				
				if(__this->_thread_init) __this->_thread_init();	//�����߳���ڳ�ʼ��
				return __this->_thread_entrance(pool,  group_index, th.group, th. group_sequence, th.global, th.sequence);
			}
			#ifdef __OLD_IOLIB_COMPATIBLE__
			//Policy��AddTask�ı�׼ʵ����pool->AddTask, ���ڼ���ģʽ�£�Manager�յ��ˡ����ȼ���Ϊ0����Э�飬����ô˽ӿ���Ӵ���Э�飬
			//�����Ȼ����ȫ�ֵ�Task�����мӣ�����Э���˳��������ҵģ��롰���ȼ�Ϊ100,101��Э����˳������Ҫ�󲻷���
			//Ϊ���þɵ���Ŀ�����޸�rpcalls.xml��Ҳ����д�Լ���threadpoolpolicy������д���AddTask. 
			virtual void AddTask(ThreadPool * pool ,int arg,  Runnable * task)
			{
				int prior = arg;
				if (prior == 100 || prior == 101 || prior ==0) //����Ŀ��ʹ��100,101��ʾ˳����0����������pollio�̴߳���.
					pool->AddSeqTask(prior, task);
				else
					pool->AddTask(task);
			}
			#endif
	};

	class ThreadPolicyNuma : public ThreadPolicyBase
	{
		int _node_num;

		virtual void * GroupMalloc(int group_index, size_t size) {
			return Numa::Memory::Alloc(group_index % _node_num, size);
		}
		virtual void GroupFree(int group_index, void * buf, size_t size) 
		{
			Numa::Memory::Free(buf, size);
		}
		static void NewEntrance(PoolEntrance ent, ThreadPool * pool, int group_index, thread_t th, void * tmp)
		{
			ent(pool, group_index, th.group, th. group_sequence, th.global, th.sequence);
		}
		static void * ThreadEntranceNuma(void * param)
		{
			pthread_detach(pthread_self());
			thread_node_t * node = (thread_node_t*)param;
			ThreadPolicyNuma * __this = (ThreadPolicyNuma*)node->__this;
			ThreadPool * pool = node->pool;
			group_t & group = __this->_groups[node->group];
			thread_t & th = group.threads[node->thread];

			if(group.cpu_node >= 0)
			{
				int node_index = group.cpu_node % __this->_node_num;
				Numa::Thread::SetAffinityByNode(node_index);
				Numa::Thread::SetPolicy(Numa::POLICY_PREFERRED, node_index);
				char * tmp = (char*)alloca(4096);
				memset (tmp, 0, 4096);
				if(__this->_thread_init) __this->_thread_init();	//�����߳���ڳ�ʼ��
				NewEntrance(__this->_thread_entrance, pool, node->group, th, tmp);
			}
			else
			{
				if(__this->_thread_init) __this->_thread_init();	//�����߳���ڳ�ʼ��
				__this->_thread_entrance(pool,  node->group , th.group, th. group_sequence, th.global, th.sequence);
			}
			delete node;
			return NULL;
		}

		virtual THREAD_ENTRANCE GetThreadEntrance() { return ThreadEntranceNuma;}
	public:
		ThreadPolicyNuma()
		{
			_node_num = Numa::Thread::GetNodeNum();
		}
	};

}
 
#endif

