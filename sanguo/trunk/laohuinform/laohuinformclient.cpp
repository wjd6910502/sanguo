
#include "laohuinformclient.hpp"
#include "state.hxx"
#include "laohu_pay.hpp"
#include <map>
#include "http_get_request.h"
#include "glog.h"
namespace GNET
{

LaohuInformClient LaohuInformClient::instance;

const Protocol::Manager::Session::State* LaohuInformClient::GetInitState() const
{
	return &state_LaohuInformClient;
}

void LaohuInformClient::OnAddSession(Session::ID sid)
{
	Thread::Mutex::Scoped l(locker_state);
	if (conn_state)
	{
		Close(sid);
		return;
	}
	conn_state = true;
	this->sid = sid;
			
	//这里发送协议并且获取环境变量 支持get 和post 方式 用cgi方式 		
	const char* env_param = getenv("QUERY_STRING"); 		
#if 1
	if ( env_param ==NULL )
	{
		fprintf(stderr,"lack of env_param\n");
		return;
	}
#else 
	env_param = "account=tj1712&order=11100025&amount=2500&ext=1&zoneid=3"; 
#endif	

	std::map<std::string,std::string> query_map;
	_ParseString(env_param,query_map);

	//GLog::log(LOG_INFO, "Laohu_pay:: account =%s, order = %s, amount=%s, ext = %s  zoneid = %s\n",(query_map["account"]).c_str(),(query_map["order"]).c_str(), (query_map["amount"]).c_str(), (query_map["ext"]).c_str(), (query_map["zoneid"]).c_str());

	//std::cout<<"account ="<<query_map["account"]<<" order ="<<query_map["order"]<<" ext="<<query_map["ext"]<<" zoneid = "<<query_map["zoneid"]<<std::endl;
	
	//发送充值协议
	Laohu_Pay command;
	std::string& act = query_map["account"]; //
	command.account = Octets(act.c_str(),act.size());
	std::string& order =query_map["order"];  //
	command.order = Octets(order.c_str(),order.size());
	command.amount = atoi((query_map["amount"]).c_str());//
	std::string& ext = query_map["ext"]; //
	command.ext = Octets(ext.c_str(),ext.size());
	command.zoneid = atoi(query_map["zoneid"].c_str()); //
	
	if( LaohuInformClient::GetInstance()->SendProtocol(&command) )
	{
		//std::cout<<"充值数据发送成功~~~~~~~"<<std::endl;	
	}
	else
	{
		std::cout<<"充值数据发送失败~~~~~~~"<<std::endl;
	}
}

void LaohuInformClient::OnDelSession(Session::ID sid)
{
	Thread::Mutex::Scoped l(locker_state);
	conn_state = false;
}

void LaohuInformClient::OnAbortSession(const SockAddr &sa)
{
	Thread::Mutex::Scoped l(locker_state);
	conn_state = false;
		
	std::string json_body="{ \"retcode\" = -100 , \"errorinfo\" = \"LINK FAULT\" }";	
	_HttpOutPut(json_body);		
}

void LaohuInformClient::OnCheckAddress(SockAddr &sa) const
{
}

};
