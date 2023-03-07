
#include "laohuproxyserver.hpp"
#include "state.hxx"
#include "laohu_checktoken_re.hpp"
namespace GNET
{

LaohuProxyServer LaohuProxyServer::instance;

const Protocol::Manager::Session::State* LaohuProxyServer::GetInitState() const
{
	return &state_LaohuProxyServer;
}

void LaohuProxyServer::OnAddSession(Session::ID sid)
{
	sid = sid;	
}

void LaohuProxyServer::OnDelSession(Session::ID sid)
{

}

void LaohuProxyServer::SendContent(std::string content, std::string account)
{
	std::cout<<" LaohuProxyServer::SendContent content ="<<content<<std::endl;
	Laohu_CheckToken_Re resp;

	//TODO: 解析content返回结果
	
	resp.retcode = 0;
	resp.account = Octets(account.c_str(),account.size());
	SendProtocol(&resp);	
}

};
