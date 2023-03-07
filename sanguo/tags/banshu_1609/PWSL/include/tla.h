/*
	Thread Local Allocator
	����ջ�ķ���������ӵ�нϸߵ��ݴ��ԣ�������ʱʹ�õ��ڴ棬���Դﵽ���ߵ����ܺͲ�������

	���ߣ� ����  ����ʱ��
	ʱ�䣺 2010-9-1

	***˵����
	�ֲ߳̾�����������������ʱ���ڴ�ʹ�õ�һ�ַ���������һ�ε��������ڣ�������ڴ�ֻ����һ��ʹ�ã����������ã��������������������ͳһ���л��ղ�ȷ���Ƿ���й¶���ڡ�
	ʹ�����ӣ�
		BeginTLA();
		void *p Alloc(a);
		use p
		free(p, a);
		EndTLA();
	BeginTLA��EndTLA����Ƕ��ʹ�ã���һ��Begin/End���ﶼ���뱣֤�ڴ汻��ȷ���ͷţ����⣬��ʹǶ��ʹ�ã���Щ���е�Begin/End�Զ�ʹ��һ���ڴ�ء�ֻ����������EndTLA���ú��ڴ�زŻ�ͳһ�Ļ��ո�λ��
	������һ��BeginTLA/EndTLA�����ڣ��������ڴ����ò�����������һ�β����з�����ڴ������������Ƶģ����ۼƷ���������Ӧ�����ڴ�صĴ�С�����������TLA���������Զ�ת���׼��CRT���䣬��ȷ����Ȼ�ܹ���֤�������ܻή�͡�
		���磺
		BeginTLA();
		void * p = Alloc(a); Free(p,a):
		p = Alloc(a); Free(p,a);
		EndTLA();
	������ռ��˫��a��С���ڴ棬������һ�ݣ���Ϊ֮ǰFree�����ڴ���EndTLA֮ǰ�ǲ������õģ��������Ƕ�ף����Begin/End���������� BeingTLA/EndTLA�ԣ������EndTLA������ڴ�Ҳ�������á�
	��Ȼû�������ڴ棬����Free��Ȼ�Ǳ�Ҫ�ģ����Free�� TLA�ڴ������֮��ת��CRT�ڴ�������������ģ�ͬʱҲ�������ڴ�й¶��ͳ�ƵĹ�����



	***���ܱ��֣�
		��ʵ�ʲ����У�TLA���������ڴ�ز��ľ�ʱ�����߳�����Ϊmalloc/free���������ϡ� �����ж��߳��ڴ����ʱ��TLA�����������ܼ�������ȫ���������ģ�����׼�ķ�������fast_allocator�ڶ��̻߳������Ž϶������ͻ��
		��������£�TLA���������Դﵽmalloc/free������10������50�����ϵķ������ܡ�ͬʱ������û������ͻ�� TLA�ڴ������Ժ�ƽ˳�Ľ��з�����ͷţ��Ӷ�ʹ�ӳٱ���Ҳ��ϼ�
		ͬʱ�����ڼ����ͷź����ã�TLA������ڴ���Ƭ�Ĳ������Ӷ��������CRT�ڴ�����Ч��


	***ʹ�ã�
		����ʹ��tla_manager��tla_alloc�����в����� tla_alloc��������hash_map,vector����Ҫ�������Ķ��� 


	***��Ҫע��ĵط���
		1. �Զ���ʼ���Ĺ��ܻ�Ƚϲ������㣬�������߳���Ŀ�ܶ��ʱ�����ɴ������ڴ�ķѣ���Ϊÿ���̶߳���Ҫ�Լ��������ڴ��
		   1a����������ĳЩ�̷߳���TLA�����ֲ�ȷ����Щ�߳��Ƿ�ʹ��TLA�����ԣ�����Ҫʹ��TLA���߳��ֶ�����InitThread�� 
		   								       ���ڲ�ʹ��TLA�߳�(�������߳�)������һ����С�ģ�����1����ֵ���Զ���ʼ��TLA����Щ�̵߳��ڴ�ؾͻ�����������Զ�ת��CRTģʽ
		   1b, �̳߳�ģ�����ṩ��һ����ں�����������ÿ���̳߳��̸߳տ�ʼ��ʱ��ִ��һ����������������������ڵ���InitThread���������ƵĲ���
		   1c���Զ���ʼ��ʱ����ʹ��TLA���߳�Ҳ�Ͳ��������Ӧ���ڴ��
		2. ѭ��������ͷ��ڴ�Ļ�����ڴ���ڴ�ľ�����ת�ɽ�����mallocģʽ�����Ӧ���������ĵ��ڴ�������������GetOMSize������Ƿ����ڴ�ľ������ ,ͬʱ����������ڴ�ش�С������ÿ���߳�2M���ϡ�
		3. BeginTLA()��EndTLA������ԣ���ȻҲ����ִ���
		   3a��BeginTLA��EndTLA֧��Ƕ�׵��ã�����Ӧ��Ƕ�׵��ó�Ϊһ��ͨ�����ַ���ע��ֻ��������EndTLA�Ż�����ڴ�صĻ��ղ���
		   3b�����з�����ڴ���Ȼ��Ҫ�����ͷź��������һ���Ҫ�ṩ����ʱ���ڴ��С������Ϊ��ͳ���ڴ�й¶���õ�
		   3c�����´��������⣺ BeginTLA();vector<int,tla_alloc> abc; use abc; EndTLA()����Ϊabc���������û���EndTLA()֮��
		   3d�����д������assert�ķ�ʽ��������뽫���Ը��ǵ����д����֧
		   3e��TLA������ڴ�������ڲ��ܳ���BeginTLA/EndTLA���������䣬��˲�Ҫ���ڱ����TLA�з���Ķ�����ڴ��ַ
		   
	
	***����
		��ʼ��,ÿ���߳��ڴ��Ϊ1M�ֽڣ�ʹ��ʱ�Զ���ʼ���̳߳�
		abase::tla_alloc::Init(1024*1024,true);
		ʹ��:
		abase::tla_alloc::BeginTLA();
		{
			abase::vector<int , abase::tla_alloc> list;
			list.push_back(1);

			void *p = abase::tla_alloc::allocate(1024);
			abase::tla_alloc::deallocate(p, 1024);
		}
		abase::tla_alloc::EndTLA();
 */

#ifndef __ABASE_TH_STACKLIKE_ALLOCATOR_H__
#define __ABASE_TH_STACKLIKE_ALLOCATOR_H__

#include <pthread.h>
#include <allocator.h>
namespace abase
{
class tla_mem;
class tla_manager
{	
	pthread_key_t _mem_key;		//for finalize
	size_t _pool_size;
	size_t _auto_pool_size;
	bool _auto_init;
	static void tla_mem_dtr(void * arg);
	
public:
	tla_manager();
	~tla_manager();
	tla_mem * GetAllocator();						//�ڲ�ʹ��

	bool Init(size_t pool_size, bool AutoInit = false, size_t auto_pool_size = 1);	//��ʼ�������ñ�Ҫ�Ĳ���������ÿ���ڴ�صĴ�С���Ƿ��Զ���ʼ����
											//�Զ���ʼ������ÿ���̵߳�һ�ε���BeginTLAʱ�������߳�û����ʾ���ù� InitThread����auto_pool_size��ֵ�����г�ʼ������
	tla_mem * InitThread(size_t init_size = 0);					//��ʼ���̱߳����ڴ�أ�ÿ���߳�ֻ�ܵ���һ�Σ��������Ĳ���Ϊ0 ����ʹ��initʱ�����pool_sizeֵ������Ϊ�ض����ڴ�ֵ ����ֵ�ɺ���
	int BeginTLA();									//��ʼ����TLA�ڴ������ ����ֵ�Ǵ�TLAǶ���˼����� ����1��ʾ�ǵ�һ��
	int EndTLA();									//����TLA�ڴ������ ����ֵ�ǵ�ǰ���м���Ƕ�ף�����0��ʾ��û��Ƕ����
	size_t GetOMSize();								//���س����ڴ�غ����������ⲿ�ڴ�Ĵ�С�����������ж��Ƿ���Ҫ�����ڴ�ش�С
	void * Alloc(size_t s);								//����
	void Free(void * p , size_t size);						//�ͷ�
	void * ReAlloc(void *oldp, size_t new_size, size_t old_size);			//���·���
};

class tla_alloc
{
	static tla_manager _tl_manager;
public:
	//�û���Ҫ�Լ�������_manager�ĳ�ʼ���������Լ����BeginTLA��EndTLA�Ĳ���
	static tla_manager & GetManager() { return _tl_manager; }
	static void Init(size_t pool_size, bool auto_pool) { _tl_manager.Init(pool_size, auto_pool, pool_size); }
	static void BeginTLA() { _tl_manager.BeginTLA();}
	static void EndTLA() { _tl_manager.EndTLA();}
public:
	tla_alloc(){}
	tla_alloc(alloc_implement *) {}
	inline static void * allocate(size_t size) {
		return _tl_manager.Alloc(size);
	}
	inline static void  deallocate(void * ptr,size_t size)
	{
		_tl_manager.Free(ptr,size);
	}
	inline static void *reallocate(void *oldptr, size_t newsize, size_t oldsize)
	{
		return _tl_manager.ReAlloc(oldptr, newsize, oldsize);	
	}

	inline void * alloc(size_t size)
	{
		return _tl_manager.Alloc(size);
	}

	inline void free(void * ptr, size_t size)
	{
		_tl_manager.Free(ptr,size);
	}

};
class tla_keeper
{
public:
	tla_keeper(){abase::tla_alloc::BeginTLA();}
	~tla_keeper(){abase::tla_alloc::EndTLA();}
};

class tla_alloc_implement : public alloc_implement
{
public:
	virtual void * alloc(size_t size)
	{
		return tla_alloc::allocate(size);
	}
	virtual void  free(void * ptr, size_t size)
	{
		tla_alloc::deallocate(ptr, size);
	}
};

class default_alloc_implement : public alloc_implement
{
public:
	virtual void * alloc(size_t size)
	{
		return malloc(size);
	}
	virtual void  free(void * ptr, size_t size)
	{
		::free(ptr);
	}
};

}
#endif

