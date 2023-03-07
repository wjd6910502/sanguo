
#ifndef __GNET_REPORTUDPINFO_HPP
#define __GNET_REPORTUDPINFO_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class ReportUDPInfo : public GNET::Protocol
{
	#include "reportudpinfo"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
	}
};

};

#endif
