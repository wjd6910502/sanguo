
#ifndef __GNET_CENTERCOMMAND_HPP
#define __GNET_CENTERCOMMAND_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class CenterCommand : public GNET::Protocol
{
	#include "centercommand"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//if(cmd >= GAMEDBD_BEGIN && cmd <= GAMEDBD_END)
		//{
		//	std::string value;
		//	CenterCommandRe re;
		//	re.retcode = 0;
		//	if(cmd == GAMEDBD_FIND_ROLE)
		//	{
		//		Marshal::OctetsStream key,value;
		//		std::string roleid = std::string((char*)arg1.begin(),arg1.size());
		//		std::string rolename = std::string((char*)arg2.begin(),arg2.size());
		//		std::string find_key = "roleinfo_" + roleid;
		//		CREATE_TRANSACTION(txnobj, txnerr, txnlog)
		//		LOCK_TABLE(db_data)
		//		START_TRANSACTION
		//		{
		//			key << find_key;
		//			if(db_data->find(key, value, txnobj))
		//			{
		//				string find_value;
		//				value >> find_value;
		//				re.cmd = cmd;
		//				re.gmsid = this->gmsid;
		//				re.res = Octets(find_value.data(), find_value.size());
		//				re.retcode = 0;
		//			}
		//			else
		//			{
		//				re.retcode = 1;
		//			}
		//		}
		//		END_TRANSACTION
		//		
		//		if(txnerr)
		//		{
		//		        Log::log(LOG_ERR, "DB::DBLoadRoleData: player=%.*s,(%d) %s", arg->key.size(), (char*)arg->key.begin(), txnerr, GamedbException::GetError(txnerr));
		//		        res->retcode = -1;
		//		}

		//	}

		//	GameDBServer::GetInstance()->DispatchProtocol(sid, re);
		//}
	}
};

};

#endif
