
#ifndef __GNET_LAOHU_CHECKTOKEN_HPP
#define __GNET_LAOHU_CHECKTOKEN_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class Laohu_CheckToken : public GNET::Protocol
{
	#include "laohu_checktoken"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
