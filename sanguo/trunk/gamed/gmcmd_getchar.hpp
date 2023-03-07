
#ifndef __GNET_GMCMD_GETCHAR_HPP
#define __GNET_GMCMD_GETCHAR_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include "singletons/RoleNameCache.h"
#include "gmadapterserver.hpp"

namespace GNET
{

extern int g_zoneid;
class GMCmd_GetChar : public GNET::Protocol
{
	#include "gmcmd_getchar"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "gamed::GMCmd_GetChar::Process, roleid=%ld, rolename=%.*s, session_id=%d", 
				roleid, (int)rolename.size(), (char*)rolename.begin(), session_id);

		GMCmd_GetChar_Re resp;

		const Player *player = PlayerManager::GetInstance().FindByRoleId(roleid);
		if(player)
		{
			char msg[100];
			snprintf(msg, sizeof(msg), "11000:%d:%u:", session_id, sid);
			MessageManager::GetInstance().Put(roleid, roleid, msg, 0);
			return;
		}

		if(rolename.size() > 0)
		{
			string role_name = std::string((char*)rolename.begin(), rolename.size());
			GMAdapterServer::GetInstance()->ConvertToUtf8(role_name);

			RoleNameQueryResults *rets = SGT_RoleNameCache::GetInstance().Query_NoLock(role_name);
			RoleNameQueryResultsIter iter = rets->SeekToBegin();
			RoleBrief *role = iter.GetValue();
			while(role != NULL)
			{
				if(role->_name == role_name)
				{
					player = PlayerManager::GetInstance().FindByRoleId(role->_id);
					if(player)
					{
						char msg[100];
						snprintf(msg, sizeof(msg), "11000:%d:%u:", session_id, sid);
						MessageManager::GetInstance().Put(role->_id, role->_id, msg, 0);
						return;
					}
					break;
				}
				iter.Next();
				role = iter.GetValue();
			}
			SGT_RoleNameCache::GetInstance().ReleaseResult(rets);
		}
		
		GLog::log(LOG_INFO, "gamed::GMCmd_GetChar::Process, Failure, roleid=%ld, rolename=%.*s, session_id=%d, not found", 
				roleid, (int)rolename.size(), (char*)rolename.begin(), session_id);

		//TODO: noload player

		resp.retcode = -1;
		resp.session_id = session_id;
		const char *desc = "not found";
		resp.desc = Octets(desc, strlen(desc));
		manager->Send(sid, resp);
	}
};

};

#endif
