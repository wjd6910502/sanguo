
#ifndef __GNET_PVPLEAVERE_HPP
#define __GNET_PVPLEAVERE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PvpLeaveRe : public GNET::Protocol
{
	#include "pvpleavere"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
