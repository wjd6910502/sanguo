
#ifndef __GNET_DELPVPVIDEO_HPP
#define __GNET_DELPVPVIDEO_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class DelPvpVideo : public GNET::Protocol
{
	#include "delpvpvideo"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
