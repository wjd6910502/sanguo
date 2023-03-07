
#ifndef __GNET_VERFICATIONOPERATION_RE_HPP
#define __GNET_VERFICATIONOPERATION_RE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class VerficationOperation_re : public GNET::Protocol
{
	#include "verficationoperation_re"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GAMED::VerficationOperation_re, retcode=%d", retcode);
	}
};

};

#endif
