
#ifndef __GNET_AUDIENCEGETLISTRE_HPP
#define __GNET_AUDIENCEGETLISTRE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class AudienceGetListRe : public GNET::Protocol
{
	#include "audiencegetlistre"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "GAMED::AudienceGetListRe, retcode=%d, roleid=%ld", retcode, roleid);

		Octets con_result;
		Base64Encoder::Convert(con_result, fight_info);
		string msg = "51:";
		msg += std::string((char*)con_result.begin(), con_result.size());
		msg += ":";

		MessageManager::GetInstance().Put(roleid, roleid, msg.c_str(), 0);
	}
};

};

#endif
