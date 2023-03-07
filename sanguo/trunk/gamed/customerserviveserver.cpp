#include "message.h"
#include "customerserviveserver.hpp"
#include "state.hxx"

namespace GNET
{

CustomerServiveServer CustomerServiveServer::instance;

const Protocol::Manager::Session::State* CustomerServiveServer::GetInitState() const
{
	return &state_CustomerServiveServer;
}

void CustomerServiveServer::OnAddSession(Session::ID sid)
{
	std::cout << "CustomerServiveServer::OnAddSession" << std::endl;
	num++;
	_session_map[num] = sid;
}

void CustomerServiveServer::OnDelSession(Session::ID sid)
{
}

void CustomerServiveServer::DispatchProtocol(Session::ID sid,const Protocol* p)
{
	Send(sid, p);
}

//关闭服务器
//关闭服务器需要做的事情
//1。禁止玩家登录
//2。把所有的玩家踢下线
//3。对玩家的所有协议不再进行处理
//4。数据进行存储
//5。输出数据，告诉关服完毕
void CustomerServiveServer::CloseServer(Session::ID sid)
{
	//在这里扔一个全局的锁，然后对数据进行处理
	char msg[100];
	snprintf(msg, sizeof(msg), "10300:%d:", sid); //CloseServer
	MessageManager::GetInstance().Put(0, 0, msg, 0);
}

};
