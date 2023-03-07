
#ifndef __GNET_GMCMD_MAILTOALLPLAYER_HPP
#define __GNET_GMCMD_MAILTOALLPLAYER_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_MailToAllPlayer : public GNET::Protocol
{
	#include "gmcmd_mailtoallplayer"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
