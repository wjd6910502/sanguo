
#ifndef __GNET_LAOHU_CHECKTOKEN_HPP
#define __GNET_LAOHU_CHECKTOKEN_HPP

#include "localdefs.h"
#include "callid.hxx"
#include "state.hxx"
#include "curldef.h"
#include "thread.h"

extern std::map<std::string, CURL_OBJ* > g_mapobj; 
extern Thread::Mutex g_locker_state;
namespace GNET
{

class Laohu_CheckToken : public GNET::Protocol
{
	#include "laohu_checktoken"

	void Process(Manager *manager, Manager::Session::ID sid)
	{
		CURL_OBJ* obj = new CURL_OBJ(std::string((char*)account.begin(),account.size()));
		
		GNET::Thread::Mutex::Scoped scoped_lock(g_locker_state); 
		g_mapobj.insert(std::make_pair(obj->account,obj));	
		scoped_lock.Unlock();
	}
};

};

#endif
