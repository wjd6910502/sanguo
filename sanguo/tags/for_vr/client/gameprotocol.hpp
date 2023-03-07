
#ifndef __GNET_GAMEPROTOCOL_HPP
#define __GNET_GAMEPROTOCOL_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

namespace GNET
{

class GameProtocol : public GNET::Protocol
{
	#include "gameprotocol"

	void Process(Manager *manager, Manager::Session::ID sid);
};

};

#endif
