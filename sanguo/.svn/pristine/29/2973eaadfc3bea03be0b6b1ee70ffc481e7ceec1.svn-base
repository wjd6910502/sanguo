
#ifndef __GNET_CENTERCOMMAND_HPP
#define __GNET_CENTERCOMMAND_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include "gcenterserver.hpp"
#include "gmserver.hpp"
#include "centercommandre.hpp"
#include "commonmacro.h"
#include "common_var.h"

extern leveldb::DB* g_db;

extern std::map< int,std::vector<package_gift> > g_gift;

using namespace GNET;

namespace GNET
{

class CenterCommand : public GNET::Protocol
{
	#include "centercommand"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//在这里如果是全服发奖品的话，需要写一个新的ID
		if(cmd == GAMED_SEND_SERVER_GIFT)
		{
			std::string find_key = "servergiftid";
			std::string value;
			leveldb::Status status = g_db->Get(leveldb::ReadOptions(),find_key,&value);
			
			if(!status.ok())
			{
				//代表没有找到，那么就直接赋值初始化，然后存进去
			}
			else
			{

			}
			std::map< int,std::vector<package_gift> >::iterator it = g_gift.find(1001);
			if(it == g_gift.end())
			{
			}
			else
			{
			//	std::string result = SerializeGift(it->second);
			}
		}
		this->gmsid = sid;
		GCenterServer::GetInstance()->BroadcastToAllServer(this);
	}
};

};

#endif
