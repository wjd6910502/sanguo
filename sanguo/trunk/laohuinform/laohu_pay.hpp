
#ifndef __GNET_LAOHU_PAY_HPP
#define __GNET_LAOHU_PAY_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class Laohu_Pay : public GNET::Protocol
{
	#include "laohu_pay"

	void Process(Manager *manager, Manager::Session::ID sid)
	{

	}
};

};

#endif
