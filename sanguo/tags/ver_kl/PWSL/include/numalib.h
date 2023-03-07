#ifndef __NUMA_LIB_H__
#define __NUMA_LIB_H__

namespace Numa
{
	enum {
		POLICY_LOCAL,		//���ط���(���ڵ�ǰCPU����Ӧ��NODE�Ϸ���)
		POLICY_PREFERRED,	//����ʹ��ĳ��NODE, �������ʧ�ܣ�ѡ��������NODE
		POLICY_INTERLEAVE,	//���桢��������
		POLICY_BIND,		//�ϸ�󶨵�NODE�Ϸ��䣬�������ʧ�ܣ������ʧ��
	};

	enum{
		MAX_CPU = 128,		//������мٶ������CPU��
		MAX_NODE = 32,		//�����ٶ������NODE��
	};

	/**********��ϵͳ������صĺ��� *********/
	namespace System {
		/**
		 * @brief ���ϵͳ�е�CPU��
		 *
		 * @return ��ȡCPU����
		 * @note   CPU������Ϊ0,1,...N-1
		 */
		int GetCpuNum();

		/**
		 * @brief ��ȡϵͳ�е�NODE��
		 *
		 * @return node��
		 * @note ���ڷ�NUMA�ṹ��ϵͳ��Node����1.
		 *	 �����ض���1��ʱ��node����������0,1,..N-1
		 */
		int GetNodeNum();

		/**
		 * @brief ��ȡĳ��NODE��������CPU
		 *
		 * @param node   Numa�ڴ�������
		 * @param cpu	���ڽ���cpu�ŵ���ʼ��ַ
		 * @param maxcpu ���Խ��ܶ��ٸ�cpu
		 *
		 * @return 	cpu��Ŀ, ������maxcpu
		 */
		int GetCpuOnNode(int node, int *cpu, int maxcpu); //ʹ��ͬһ��node��cpu�б�

		/**
		 * @brief ���ĳNUMA������Ϣ
		 *
		 * @param node  Numa�������
		 * @param total ���ڽ��ս���ܹ���С��ָ��
		 * @param free  ���ڽ��ս����пռ��ָ��
		 */
		void GetNodeSize(int node, size_t *total, size_t *free); //node�Ĵ�С
		/**
		 * @brief ���ĳNUMA������Ϣ64λ
		 *
		 * @param node  Numa�������
		 * @param total ���ڽ��ս���ܹ���С��ָ��
		 * @param free  ���ڽ��ս����пռ��ָ��
		 */
		void GetNodeSize64(int node, long long *total, long long *free); //node�Ĵ�С
	};

	/*********��ǰ�߳���صĺ��� ********/
	namespace Thread
	{
		//��õ�ǰ�߳������ĸ�CPU����, δʵ��
		int GetCurrentCpu();

		/**
		 * @brief ��õ�ǰ�߳��ڶ��ٸ�CPU����
		 * 	  SetAffinity()��Ӱ�������Ŀ
		 * @return cpu����
		 */
		int GetCpuNum();

		/**
		 * @brief ��ǰ�߳���������ЩCPU����
		 *
		 * @param cpu 	  ���ڽ���cpu�Ļ����ַ
		 * @param maxcpu  ���ɽ���CPU�ĸ���
		 *
		 * @return 	cpu��Ŀ, ������maxcpu
		 */
		int GetAffinity(int *cpu, int maxcpu);

		/**
		 * @brief  ������������ЩCPU����
		 *
		 * @param cpu	   cpu�ŵĻ�����ʼ��ַ
		 * @param cpu_num  cpu����
		 *
		 * @return  0 -- success  <0 -- failed
		 * @note  ���ܻ��������,�߳�Ǩ�Ƶ���һ��CPU��
		 */
		int SetAffinity(int *cpu, int cpu_num);	//sched_setaffinity

		/**
		 * @brief   �����������ĸ�NODE������CPU����
		 *
		 * @param node	  Numa���ڴ�������
		 * @return  0 -- success <0 --failed
		 * @note  ��ϵͳ��ֻ��һ��nodeʱ����󶨵�����CPU�ϡ�
		 */
		int SetAffinityByNode(int node);

		/**
		 * @brief ��ǰ�߳�ʹ�õ�NODE����
		 *
		 * @return node����, ��������ڵ���1
		 * @note ����ʹ��Ĭ��policy local�ģ�����ϵͳ�е�Node����
		 */
		int GetNodeNum();

		/**
		 * @brief 	��ȡ���߳�ʹ�õ�NODE�б�
		 *
		 * @param nodes		���ڴ��node�Ļ�������ַ
		 * @param maxnode	������������ŵ�node����
		 *
		 * @return 	Node����.   nodes�н�������node����.
		 * @note	�����ǰ�߳�POLICY�� local,�򷵻�ϵͳ�����н��
		 */
		int GetNode(int *nodes, int maxnode);
		/** 
		 * @brief ��ȡ��ǰ�̵߳�NUMA����
		 * 
		 * @param policy  ���Դ��NUMA�ڴ�������, ����ΪPOLICY_LOCAL, POLICY_PREFERRED,
				  POLICY_INTERLEAVE, POLICY_BIND
		 * @param nodes		���ڴ��node�Ļ�������ַ
		 * @param maxnode	������������ŵ�node����
		 * 
		 * @return 	node��������<=0ʱ��ʾ����ʧ��
				policy�н���������ԡ�nodes�б�����node����
		 */
		int GetPolicy(int *policy, int *nodes, int maxnode) ; //get_mempolicy

		/** 
		 * @brief ���õ�ǰ�̵߳�NUMA����
		 * 
		 * @param policy  NUMA�ڴ�������, ����ΪPOLICY_LOCAL, POLICY_PREFERRED,
				  POLICY_INTERLEAVE, POLICY_BIND
		 * @param nodes		�������󶨵�nodes
		 * @param node_num	�������󶨵�node��������policyΪlocalʱ��nodes,nodes_num������
		 * 
		 * @return  0 -- success <0 --failed
		 */
		int SetPolicy(int policy, int *nodes, int node_num); //set_mempolicy

		/** 
		 * @brief ���õ�ǰ�̵߳�NUMA����
		 * 
		 * @param policy  NUMA�ڴ�������, ����ΪPOLICY_LOCAL, POLICY_PREFERRED,
				  POLICY_INTERLEAVE, POLICY_BIND
		 * @param node		�������󶨵�node
		 * 
		 * @return  0 -- success <0 --failed
		 */
		int SetPolicy(int policy, int node);
	};

	/**********�ڴ�������صĺ��� *********/
	namespace Memory
	{
		/** 
		 * @brief 	��ȡ��ǰ�����У�ĳ���ڴ��ַ��ʹ�õ�NUMA����
		 * 
		 * @param policy   ���ڴ��policy��ָ��
		 * @param node		���ڴ��node�����ĵ�ַ
		 * @param maxnode	node�������������
		 * @param mem		��Ҫ�����ڴ��ַ
		 * 
		 * @return 	node��������<=0��ʾʧ��
		 */
		int GetPolicy(int *policy, int *node, int maxnode, const void *mem);

		/** 
		 * @brief ����ĳ���ڴ������NUMA����
		 * 
		 * @param policy  NUMA�ڴ�������, ����ΪPOLICY_LOCAL, POLICY_PREFERRED,
				  POLICY_INTERLEAVE, POLICY_BIND
		 * @param nodes		�������󶨵�nodes
		 * @param node_num	�������󶨵�node��������policyΪlocalʱ��nodes,nodes_num������
		 * @param mem		�ڴ���ʼ��ַ
		 * @param size		�ڴ泤��
		 * 
		 * @return  0 -- success <0 --failed
		 */
		int SetPolicy(int policy, const int *node, int nodenum, void *mem, size_t size);

		/** 
		 * @brief 	��ĳ���ض�NODE�Ϸ���һ����С���ڴ�
		 * 
		 * @param node	Numa�ڵ�
		 * @param size  ��������ڴ��С
		 * 
		 * @return 	��������ڴ档NULLʱ����ʧ��
		 * @note	һ������£�����Ҫʹ������ӿڣ�����ķ�����ʵ����mmap��һ���ڴ�Ȼ��
				���󶨵���node��.
				������ڴ������Free(void *mem, size_t size)���ͷ�
		 */
		void *Alloc(int node, size_t size);

		/** 
		 * @brief �ͷ���Alloc������ڴ�
		 * 
		 * @param mem	��Alloc������ڴ��ַ
		 * @param size	����
		 */
		void Free(void *mem, size_t size);
	};
};

#endif
