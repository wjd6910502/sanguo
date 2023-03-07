
#ifndef __GNET_TRANSCHALLENGE_HPP
#define __GNET_TRANSCHALLENGE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class TransChallenge : public GNET::Protocol
{
	#include "transchallenge"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
