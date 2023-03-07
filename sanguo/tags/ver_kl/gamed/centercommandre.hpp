
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
		//等于0的话说明value中的值才是我们需要的值
		if(retcode == 0)
		{
			if(cmd == GAMEDBD_FIND_ROLE)
			{
				//在这里需要对value进行解析
				Role role(0);
				Marshal::OctetsStream os(res);
				int db_version = 0;
				os >> db_version;
				os._dbversion = db_version;
				role.unmarshal(os);
				//看以后需要拿什么数值再进行后面的书写
			}
		}
		GCenterClient::GetInstance()->SendProtocol(this);
	}
};

};

#endif
