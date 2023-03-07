
#ifndef __GNET_PVPSERVERREGISTER_HPP
#define __GNET_PVPSERVERREGISTER_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include "pvpmanager.h"

namespace GNET
{

class PVPServerRegister : public GNET::Protocol
{
	#include "pvpserverregister"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "PVPServerRegister::Process, ip=%.*s, port=%d, sid=%u", (int)ip.size(), (char*)ip.begin(), port, sid);

		std::string s((char*)ip.begin(), ip.size());
		PVPManager::GetInstance().AddPVPServer(s.c_str(), port, sid);
	}
};

};

#endif
