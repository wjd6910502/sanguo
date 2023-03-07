/*
 *
 * 	���ļ��Ƕ�IO���ʼ�����̵�һЩ��װ��ʹ����Ĭ���Ƽ��Ĳ����ͳ�ʼ�����̡�
 * 	����ʹ���У��ɸ������ѡ��ֲ���ʼ�����������ĳһ���Ĳ������е�����
 */
#ifndef _GNET_INIT_H_
#define _GNET_INIT_H_
#include "thread.h"
#include "threadpolicy.h"
#include "glog.h"
#include "gnet_timer.h"
#include "statistic.h"
#include "conf.h"

namespace GNET
{
	//��ʼ����̬����������ʹ������ྲ̬���������ǵĳ�ʼ��˳���н��ϸ��Ҫ����������������ȷ����˳����С�
	//�ú���������ã����Ҿ�������ǰ��û�е��õĻ���Timer����������������
	void InitStaticObjects();

#ifdef __OLD_IOLIB_COMPATIBLE__ 

	inline void InitIoMan(bool single_thread)		//IOMan��ʼ��
	{
		GNET::PollIO::Init (single_thread);
	}

	inline void InitThreadPolicy(bool single_thread)	//�Ƽ����̳߳س�ʼ��
	{
		if (single_thread)
		{
			Thread::Pool::_pool.Init( new ThreadPolicySingle());
			return;
		}
		ThreadPolicyBase * policy = new ThreadPolicyBase();
		policy->AddGroup(-1, 0); 
		policy->AddGroup(-1, 0);
		policy->SetSequenceCount(2);
		policy->AddThread(0, GNET::TASK_TYPE_GLOBAL);
		policy->AddThread(1, GNET::TASK_TYPE_GLOBAL);
		policy->AddThread(0, GNET::TASK_TYPE_GLOBAL | GNET::TASK_TYPE_SEQUENCE);
		policy->AddThread(1, GNET::TASK_TYPE_GLOBAL | GNET::TASK_TYPE_SEQUENCE);
		Thread::Pool::_pool.Init(policy);
		Thread::Pool::_pool.Start();
	}

	inline void InitLog(const char *name)			//��־���ʼ��������Conf, IOMan��ʼ����ɺ����
	{
		GLog::Init(name);
	}

	inline void InitTimer(bool single_thread, abase::timer *gtimer = NULL)	//�Ƽ���itimer��ʼ��
	{
		if (single_thread)
		{
			GNET::IntervalTimer::StartTimer(50000, true);
		}
		else
		{
			IntervalTimer::PrepareTimer(gtimer, 50000);
			IntervalTimer::StartTimerThread();
		}
	}

	//�Ƽ��ĳ�ʼ����ʽ, ���ʼ��˳���Ǿ�����ϸ���ǵġ�
	//�ڶ��߳�ģʽ�£�gtimer�������ⲿ���������롣���߳�ģʽ�£�gtimerΪ�ա�
	inline void AppInit(const char *conf_file, const char *servername, bool single_thread = true, abase::timer *gtimer = NULL)
	{
		InitStaticObjects();
		Conf::GetInstance(conf_file /* , servername */);  //�����ļ��ĳ�ʼ��. �ڶ���������conf��group���ơ�
		InitIoMan(single_thread);
		InitThreadPolicy(single_thread);
		InitLog(servername);
		InitTimer(single_thread, gtimer);
	}

	//�Ƽ�����ѭ��
	inline void AppRun(bool single_thread)
	{
		UpdateStatToLog  stat_observer;	//����һ������ˢ�µ���־�е��ࡣ���Զ�Attach
		if (single_thread)
		{
			while(1)
			{
				PollIO::Poll(10);
				Timer::Update();
				IntervalTimer::UpdateTimer();
				Thread::Pool::_pool.TryProcessAllTask();
			}
		}
		else
		{
			while(1)
			{
				PollIO::Poll(10);
				Timer::Update();
			}

		}
	}

	//�Ƽ��Ĺرշ�ʽ
	inline void AppStop()
	{
		GNET::IntervalTimer::StopTimer();
		GNET::Thread::Pool::_pool.Stop();
		sleep(2);
		GNET::Thread::Pool::_pool.WaitStop();
	}
#endif

};
#endif
