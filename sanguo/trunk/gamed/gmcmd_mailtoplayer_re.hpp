
#ifndef __GNET_GMCMD_MAILTOPLAYER_RE_HPP
#define __GNET_GMCMD_MAILTOPLAYER_RE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_MailToPlayer_Re : public GNET::Protocol
{
	#include "gmcmd_mailtoplayer_re"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
