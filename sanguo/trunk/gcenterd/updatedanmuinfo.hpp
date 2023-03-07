
#ifndef __GNET_UPDATEDANMUINFO_HPP
#define __GNET_UPDATEDANMUINFO_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class UpdateDanMuInfo : public GNET::Protocol
{
	#include "updatedanmuinfo"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
