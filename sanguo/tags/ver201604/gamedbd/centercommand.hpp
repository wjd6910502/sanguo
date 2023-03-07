
#ifndef __GNET_CENTERCOMMAND_HPP
#define __GNET_CENTERCOMMAND_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include "centercommandre.hpp"
#include "gamedbserver.hpp"
#include "commonmacro.h"

#include "write_batch.h"
#include "leveldb.h"
extern leveldb::DB* g_db;

namespace GNET
{

class CenterCommand : public GNET::Protocol
{
	#include "centercommand"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//在这里需要注意一下，基本所有的命令处理都会在这里进行，只需要给value相应的值就可以了
		//然后会在gamed里面进行解析
		if(cmd >= GAMEDBD_BEGIN && cmd <= GAMEDBD_END)
		{
			std::string value;
			CenterCommandRe re;
			re.retcode = 0;
			if(cmd == GAMEDBD_FIND_ROLE)
			{
				std::string roleid = std::string((char*)arg1.begin(),arg1.size());
				std::string rolename = std::string((char*)arg2.begin(),arg2.size());
				std::string find_key = "roleinfo_" + roleid;
				leveldb::Status status = g_db->Get(leveldb::ReadOptions(),find_key,&value);

				if(!status.ok())
				{
					value = "can not find the role";
					re.retcode = 1;
				}

			}
			re.cmd = cmd;
			re.gmsid = this->gmsid;
			re.res = Octets(value.c_str(), value.size());

			GameDBServer::GetInstance()->DispatchProtocol(sid, re);
		}
	}
};

};

#endif
