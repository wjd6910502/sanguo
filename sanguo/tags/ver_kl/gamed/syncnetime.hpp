
#ifndef __GNET_SYNCNETIME_HPP
#define __GNET_SYNCNETIME_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class SyncNetime : public GNET::Protocol
{
	#include "syncnetime"
	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
