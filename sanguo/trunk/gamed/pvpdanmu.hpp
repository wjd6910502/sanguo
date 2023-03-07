
#ifndef __GNET_PVPDANMU_HPP
#define __GNET_PVPDANMU_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PvpDanMu : public GNET::Protocol
{
	#include "pvpdanmu"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
