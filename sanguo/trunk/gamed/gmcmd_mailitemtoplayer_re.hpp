
#ifndef __GNET_GMCMD_MAILITEMTOPLAYER_RE_HPP
#define __GNET_GMCMD_MAILITEMTOPLAYER_RE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_MailItemToPlayer_Re : public GNET::Protocol
{
	#include "gmcmd_mailitemtoplayer_re"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
