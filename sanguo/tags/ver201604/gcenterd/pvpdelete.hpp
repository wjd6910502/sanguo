
#ifndef __GNET_PVPDELETE_HPP
#define __GNET_PVPDELETE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PVPDelete : public GNET::Protocol
{
	#include "pvpdelete"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
