
#ifndef __GNET_SYNCCMDACK_HPP
#define __GNET_SYNCCMDACK_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class SyncCmdAck : public GNET::Protocol
{
	#include "synccmdack"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
