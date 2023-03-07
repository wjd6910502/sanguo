
#ifndef __GNET_PVPSPEEDRE_HPP
#define __GNET_PVPSPEEDRE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PvpSpeedRe : public GNET::Protocol
{
	#include "pvpspeedre"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
