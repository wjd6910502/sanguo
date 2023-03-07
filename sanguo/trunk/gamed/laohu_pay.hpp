
#ifndef __GNET_LAOHU_PAY_HPP
#define __GNET_LAOHU_PAY_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"

#include "laohu_pay_re.hpp"

namespace GNET
{

class Laohu_Pay : public GNET::Protocol
{
	#include "laohu_pay"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		GLog::log(LOG_INFO, "gamed::Laohu_Pay::Process, account=%.*s, order=%.*s, amount=%d, ext=%.*s, zoneid=%d", 
		          (int)account.size(), (char*)account.begin(), (int)order.size(), (char*)order.begin(), amount,
		          (int)ext.size(), (char*)ext.begin(), zoneid);

		Laohu_Pay_Re resp;
		resp.account = account;
		resp.order = order;
		resp.amount = amount;
		resp.ext = ext;
		resp.zoneid = zoneid;

		const Player *player = PlayerManager::GetInstance().FindByAccount(account);
		if(!player || (int64_t)player->_role._roledata._base._id==0)
		{
			GLog::log(LOG_INFO, "gamed::Laohu_Pay::Process, account=%.*s, not found", 
			          (int)account.size(), (char*)account.begin());

			//TODO: noload player
			resp.retcode = -1; //TODO: error code
			manager->Send(sid, resp);
			return;
		}

		std::string s((char*)ext.begin(), ext.size());
		int id = atoi(s.c_str());
		if(id==0) return;

		Octets tmp_out;
		Base64Encoder::Convert(tmp_out, order);

		char msg[100];
		snprintf(msg, sizeof(msg), "11005:%d:%.*s:%d:%d:", id, (int)tmp_out.size(), (char*)tmp_out.begin(), amount, sid); //Pay
		MessageManager::GetInstance().Put(player->_role._roledata._base._id, player->_role._roledata._base._id, msg, 0);
	}
};

};

#endif
