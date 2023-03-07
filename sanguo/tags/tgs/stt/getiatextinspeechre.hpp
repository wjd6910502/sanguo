
#ifndef __GNET_GETIATEXTINSPEECHRE_HPP
#define __GNET_GETIATEXTINSPEECHRE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GetIATextInSpeechRe : public GNET::Protocol
{
	#include "getiatextinspeechre"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
