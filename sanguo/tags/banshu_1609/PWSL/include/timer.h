/*
	��ʱ��ģ�飬 �ṩ��һ����Ч�Ķ�ʱ�����ܣ�
	���ߣ�����
	��˾������ʱ��
	ʱ�䣺2002-4-1
*/


#ifndef __CMLIB_TIMER_H__
#define __CMLIB_TIMER_H__

#include <sys/time.h>
#include <stdint.h>
#include "ASSERT.h"

namespace abase
{
typedef void (*timer_callback)(int index,void *object,int remain);

class  timer
{
	void * __imp;
public:
	enum 
	{
		TICKTIME = 50000,
		MINTIME = 10000
	};
	/*
		��ʼ��һ��timer����,һ������������
		1:idx_tab_size ��ʾ������timer������������Ĵ�С, 
			�������ṩ�˿��ٲ�ѯ��������ʹ��ÿ��timer�¼�����ʱ�����ٽ��и��Ӳ�ѯ
			���������Ĵ�С������Ҫ������ٸ�tick��timer�¼���
			���ֵԽ����ô�Ϳ��Զ�Խ���¼���Χ�Ķ�ʱ�����л���
		2:max_timer_count ��ʾ����ܹ�ͬʱ������ٸ�timer	
			ÿ�������timer entry�������44��32λϵͳ���ֽ��ڴ�
	*/
	timer(int idx_tab_size,int max_timer_count);	
	~timer();


	uint64_t get_tick();
	long 	get_systime();				//ͬ��
	void 	get_systime(timeval & tv);		//��timer��ʱ�侫����ȡ��ϵͳʱ�䣬���ڲ���ȷ��Ҫ�󣬿���ʹ��������������Ա���ϵͳ����
	int 	get_free_timer_count();
	int64_t	get_timer_total_alloced();
	int 	set_timer(int interval,int start_time,int times,timer_callback routine, void * obj);
	/*
	 *	remove_timer
	 * 	ɾ��һ��timer��������һ��tickʱɾ��������һ��tick�˶�ʱ�����ܱ�����Ӧ��
	 *	����tick��Ȼ���ܻᱻɨ�赽�����ʱ����
	 *	������timer��callback�����ᱻ����,��˲�������� 
	 *	ע�⣺��Ҫ��callback����OnTimer�е��ô˺���ɾ������,���Ҫɾ������������һ������ callback_remove_self
	 */
	int 		remove_timer(int index,void *object);
	//�˺���ֻ����callback����OnTimer����ò�����ɾ������
	int		callback_remove_self(int index);		
	int		get_next_interval(int index,void * obj, int * interval, int *rtimes);
	int		change_interval(int index ,void * obj, int interval,bool nolock/* in callback*/);
	int		change_interval_at_once(int index ,void * obj, int interval,bool nolock/* in callback*/);
	void 		timer_thread(int ticktime = TICKTIME,int mintime  = MINTIME);	//ʱ���߳�Ӧ�õ��õĺ��� ����������᷵�أ����������̵߳�����stop_thread
	void 		stop_thread();							//stop֮��Ҫ�������¿�ʼ,�ȴ�һ��ʱ����������˳�
	void		pause_thread();	
	void		resume_thread();
	void		prepare_for_single_thread(int ticktime = TICKTIME, int mintime = MINTIME);
	void 		single_turn();	//���߳�ģʽ�� Ӧ�õ��õĺ��� ������û����Ƿ���ʱ����ת�����ҵ�����Ӧ�Ĵ�������
	void		reset();	// reset timer
	void		timer_tick();	// timer tick 

};

class timer_task
{
	virtual bool OnTimer2(int index,int rtimes) { OnTimer(index, rtimes); return true;}
	virtual void OnTimer(int index,int rtimes) = 0;		//����ֵ�����Ƿ�ɾ������ �����true��δɾ�� 
	inline void DoTimer(int index,int rtimes)
	{
		int tdx = _timer_index;
		timer * tm = _tm;
		if(OnTimer2(index,rtimes))
		{
			if(rtimes == 0)
			{
				//��ʱ�����Զ�ɾ��
				_timer_index = -1;
				_tm = NULL;
			}
		}
		else
		{
			if(rtimes != 0) tm->callback_remove_self(tdx);
		}
	}
	static void _callback(int index,void *object,int rtimes)
	{
		((timer_task*)object)->DoTimer(index,rtimes);
	}

protected:

	int _timer_index;
	timer * _tm;
	timer_task():_timer_index(-1),_tm(NULL){}
	virtual  ~timer_task()
	{
		ASSERT(_timer_index == -1 && _tm == NULL);
	}
	int RemoveSelf()
	{
		int rst = _tm->callback_remove_self(_timer_index);
		_timer_index = -1;
		_tm = NULL;
		return rst;
	}

	int ChangeIntervalAtOnce(int new_interval)
	{
		ASSERT(new_interval > 0);
		if(_timer_index < 0) return -1;
		int rst = _tm->change_interval_at_once(_timer_index,this,new_interval,false);
		ASSERT(rst == 0);
		return rst;
	}

	int ChangeInterval(int new_interval)
	{
		ASSERT(new_interval > 0);
		if(_timer_index < 0) return -1;
		int rst = _tm->change_interval(_timer_index,this,new_interval,false);
		ASSERT(rst == 0);
		return rst;
	}

	int ChangeIntervalInCallback(int new_interval)
	{
		ASSERT(new_interval > 0);
		int rst = _tm->change_interval(_timer_index,this,new_interval,true);
		ASSERT(rst == 0);
		return rst;
	}
	
public:

	int SetTimer(timer & tm, int interval,int times,int start_time = -1)
	{
		if(_timer_index != -1 &&  _tm != NULL )
		{
			ASSERT(false && "ͬ��һ�������ظ��ļ��뵽�˶�ʱ����");
			return -1;
		}
		_tm = & tm;
		_timer_index = tm.set_timer(interval,start_time,times,_callback,this);
		return _timer_index;
	}

	int RemoveTimer()
	{
		timer * __tm = _tm;
		int __index = _timer_index;
		if(!__tm || __index < 0) return -1;
		int tmp = __tm->remove_timer(__index,this);
		_timer_index = -1;
		_tm = NULL;
		return tmp;
	}

	inline int GetTimerIndex() { return _timer_index; }

};

}
#endif

