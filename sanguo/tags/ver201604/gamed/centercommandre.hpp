
#ifndef __GNET_CENTERCOMMANDRE_HPP
#define __GNET_CENTERCOMMANDRE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include "gcenterclient.hpp"

namespace GNET
{

class CenterCommandRe : public GNET::Protocol
{
	#include "centercommandre"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//����0�Ļ�˵��value�е�ֵ����������Ҫ��ֵ
		if(retcode == 0)
		{
			if(cmd == GAMEDBD_FIND_ROLE)
			{
				//��������Ҫ��value���н���
				Role role(0);
				Marshal::OctetsStream os(res);
				int db_version = 0;
				os >> db_version;
				os._dbversion = db_version;
				role.unmarshal(os);
				//���Ժ���Ҫ��ʲô��ֵ�ٽ��к������д
			}
		}
		GCenterClient::GetInstance()->SendProtocol(this);
	}
};

};

#endif
