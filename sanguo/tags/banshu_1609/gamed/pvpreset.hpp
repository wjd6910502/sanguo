
#ifndef __GNET_PVPRESET_HPP
#define __GNET_PVPRESET_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class PvpReset : public GNET::Protocol
{
	#include "pvpreset"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
