
#ifndef __GNET_PVPMATCHSUCCESS_HPP
#define __GNET_PVPMATCHSUCCESS_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PvpMatchSuccess : public GNET::Protocol
{
	#include "pvpmatchsuccess"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
