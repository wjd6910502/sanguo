
#ifndef __GNET_VERFICATIONOPERATION_HPP
#define __GNET_VERFICATIONOPERATION_HPP

#include <fstream>
#include <time.h>
#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include "verificationclient.hpp"
#include "verficationoperation_re.hpp"
#include "judge.h"

namespace GNET
{

class VerficationOperation : public GNET::Protocol
{
	#include "verficationoperation"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		Log::log(LOG_INFO, "VerificationClient::VerficationOperation ... ...");

		VerficationOperation_re prot;
		VerificationClient::GetInstance()->SendProtocol(prot);

		time_t tt = time(NULL);
		char time_str[256];
		memset(time_str,0,256);
		snprintf(time_str,256,"%ld",tt);
		string operation_file = time_str, hero_info_file = time_str;
		operation_file += "operation";
		hero_info_file += "heroinfo.lua";
		ofstream fout;
		fout.open(operation_file);
		fout << operation;
		fout << flush;
		fout.close();
		
		fout.open(hero_info_file);
		fout << hero_info;
		fout << flush;
		fout.close();

		JudgeOperation(stage_id, hero_info_file, operation_file);
	}
};

};

#endif
