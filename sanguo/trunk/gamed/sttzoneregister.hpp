
#ifndef __GNET_STTZONEREGISTER_HPP
#define __GNET_STTZONEREGISTER_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class STTZoneRegister : public GNET::Protocol
{
	#include "sttzoneregister"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
