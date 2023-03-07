
#ifndef __GNET_GMCMD_GETCHAR_RE_HPP
#define __GNET_GMCMD_GETCHAR_RE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"


namespace GNET
{

class GMCmd_GetChar_Re : public GNET::Protocol
{
	#include "gmcmd_getchar_re"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO,
		          "gmadapterd::GMCmd_GetChar_Re::Process, retcode=%d, session_id=%d, roleid=%ld, rolename=%.*s, zoneid=%d, level=%d, sex=%d, profession=0, isdel=0, createtime=%.*s, lastlogintime=%.*s, deltime=0, ip=%.*s, exp=%ld, mafianame=%.*s, yuanbao=%d, money=%d, bdyuanbao=%d, vip=%d, account=%.*s, totalcash=%d, zhanli=%d, platform=laohu, desc=%.*s",
		          retcode, session_id, roleid, (int)rolename.size(), (char*)rolename.begin(), zoneid, level, sex, (int)createtime.size(), 
				  (char*)createtime.begin(), (int)lastlogintime.size(), (char*)lastlogintime.begin(), (int)ip.size(), 
				  (char*)ip.begin(), exp, (int)mafianame.size(), (char*)mafianame.begin(), yuanbao, money, bdyuanbao, vip, 
				  (int)account.size(), (char*)account.begin(), totalcash, zhanli, (int)desc.size(), (char*)desc.begin());

		//for PWRD
		char buf[1024];
		if(retcode == 0)
		{
			snprintf(buf, sizeof(buf),
			        "<cmd_command cmd_data=\"GetChar\" return=\"true\" charid=\"%ld\" name=\"%.*s\" lineid=\"%d\" level=\"%d\" sex=\"%d\" profession=\"\" isdel=\"\" registertime=\"%.*s\" lastlogintime=\"%.*s\" deltime=\"\" ip=\"%.*s\" exp=\"%ld\" familyname=\"%.*s\" gold=\"%d\" money=\"%d\" bdyuanbao=\"%d\" vip=\"%d\" account=\"%.*s\" totalcash=\"%d\" pingfen=\"%d\" platform=\"laohu\"/>",
					roleid, (int)rolename.size(), (char*)rolename.begin(), zoneid, level, sex, (int)createtime.size(), (char*)createtime.begin(), 
					(int)lastlogintime.size(), (char*)lastlogintime.begin(), (int)ip.size(), (char*)ip.begin(), exp, (int)mafianame.size(), 
					(char*)mafianame.begin(), yuanbao, money, bdyuanbao, vip, (int)account.size(), (char*)account.begin(), totalcash, zhanli);
		}
		else
		{
			snprintf(buf, sizeof(buf),
			         "<cmd_command cmd_data=\"GetChar\" return=\"false\" desc=\"%.*s\"/>",
			         (int)desc.size(), (char*)desc.begin());
		}
		PWRD::GetInstance().OnRecvResp(session_id, buf);
	}
};

};

#endif
