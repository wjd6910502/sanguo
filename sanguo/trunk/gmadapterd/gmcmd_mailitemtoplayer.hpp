
#ifndef __GNET_GMCMD_MAILITEMTOPLAYER_HPP
#define __GNET_GMCMD_MAILITEMTOPLAYER_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_MailItemToPlayer : public GNET::Protocol
{
	#include "gmcmd_mailitemtoplayer"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
