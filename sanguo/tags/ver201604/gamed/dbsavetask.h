#ifndef __GNET_DBSAVETASK_H
#define __GNET_DBSAVETASK_H

#include "thread.h"
#include "dbsavedata.hrp"
#include "topmanager.h"
#include "message.h"

using namespace GNET;

extern std::map<Octets, Octets> g_save_data_map;

namespace CACHE
{
	class DelayDBSaveDataTask : public Thread::Runnable
	{
	public:
		static DelayDBSaveDataTask * GetInstance()
		{
			static DelayDBSaveDataTask instance;
			return &instance;
		}
		DelayDBSaveDataTask(): Runnable(1){ }

		void Run()
		{
			//�����﷢��һ����Ϣ�����������ݵĿ�ʼ�洢��
		
			GLog::log(LOG_INFO, "dbSavedata begin ... ...");

			//���������һ���ж���һ�εĴ洢�Ƿ��Ѿ���ϣ��ǵĻ��ſ�ʼ��һ�Ρ�
			if(g_save_data_map.size() == 0)
			{
				char msg[100];
				snprintf(msg, sizeof(msg), "10006:");
				MessageManager::GetInstance().Put(0, 0, msg, 0);

				Thread::HouseKeeper::AddTimerTask(this, 60);
			}
			else
			{
				GLog::log(LOG_ERR, "last dbsave not finish");
			}
		};
	};
};

#endif
