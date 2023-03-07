
#ifndef __GNET_SYNCCMD_HPP
#define __GNET_SYNCCMD_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "synccmdack.hpp"

#include "commonmacro.h"
#include "connection.h"
#include "script_wrapper.h"
#include <lua.hpp>

extern lua_State *g_L;

extern std::map<Octets,std::pair<int,Octets> > g_command_version_content; //command=>(version,content)

namespace GNET
{

class SyncCmd : public GNET::Protocol
{
	#include "synccmd"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//fprintf(stderr, "SyncCmd::Process, command=%.*s, version=%d, content=%.*s\n", (int)command.size(), (char*)command.begin(),
		//        version, (int)content.size(), (char*)content.begin());

		SyncCmdAck prot;
		prot.command = command;
		prot.version = version;
		manager->Send(sid, prot);

		g_command_version_content[command] = std::make_pair(version, content);

		if(content.size() < 2)
		{
			fprintf(stderr, "SyncCmd::Process, wrong length\n");
			return;
		}
		for(size_t i=0; i<content.size(); ++i)
		{
			int c = ((char*)content.begin())[i];
			if(!isupper(c) && !islower(c) && !isdigit(c) && c!='+' && c!='/' && c!='=' && c!=':') //并不标准的base64
			{
				fprintf(stderr, "SyncCmd::Process, wrong char(%d)\n", c);
				return;
			}
		}

		if(g_L)
		{
			LuaWrapper lw(g_L);
			if(!lw.gExec("DeserializeAndProcessCommand", LuaParameter((void*)0, std::string((char*)content.begin(), content.size()), 0, 0)))
			{
				fprintf(stderr, "SyncCmd::Process, gExec, DeserializeAndProcessCommand\n");
			}
		}
	}
};

};

#endif
