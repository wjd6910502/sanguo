
#ifndef __GNET_LAOHU_PAY_RE_HPP
#define __GNET_LAOHU_PAY_RE_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include <iostream>
#include "http_get_request.h"
#include "glog.h"

extern bool hasfinish;
namespace GNET
{

class Laohu_Pay_Re : public GNET::Protocol
{
	#include "laohu_pay_re"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		//GLog::log(LOG_INFO, "Laohu_Pay_Re:: retcode = %d  account =%.*s, order = %.*s, amount=%d, ext = %.*s  zoneid = %d\n",retcode,(int)account.size(),(char*)account.begin(),(int)order.size(),(char*)order.begin(), amount, (int)ext.size(),(char*)ext.begin(), zoneid);
		//printf("Laohu_Pay_Re:: retcode = %d  account =%.*s, order = %.*s, zoneid = %d\n",retcode,(int)account.size(),(char*)account.begin(),(int)order.size(),(char*)order.begin(), zoneid);
			
		//返回数据给第三方充值 直接在网页输出
		{
			std::string json_body;
			json_body += "{";
			AddResult(retcode);
		
			std::string act((char *)account.begin(),account.size());
			AddResult(act);

			std::string od((char *)order.begin(),order.size());
			AddResult(od);
		
			AddResult(amount);
			
			std::string e((char *)ext.begin(),ext.size());
			AddResult(e);

			AddResult(zoneid);
			json_body += "}";

			_HttpOutPut(json_body);

		}
		hasfinish = true;
	}

};

};

#endif
