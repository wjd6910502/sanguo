
#ifndef __GNET_PVPOPERATION_HPP
#define __GNET_PVPOPERATION_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "pvpvideo"

namespace GNET
{

class PvpOperation : public GNET::Protocol
{
	#include "pvpoperation"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
