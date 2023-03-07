
#include "gamedbclient.hpp"
#include "state.hxx"
#include "dbloaddata.hrp"

namespace GNET
{

GameDBClient GameDBClient::instance;

void GameDBClient::Reconnect()
{
	Thread::HouseKeeper::AddTimerTask(new ReconnectTask(this, 1), 3);
}

const Protocol::Manager::Session::State* GameDBClient::GetInitState() const
{
	return &state_GameDBClient;
}

void GameDBClient::OnAddSession(Session::ID sid)
{
	Thread::Mutex2::Scoped l(locker_state);
	if (conn_state)
	{
		Close(sid);
		return;
	}
	conn_state = true;
	this->sid = sid;

	//连接上以后，去数据库取相应的内容
	//在这里都加上_是为了避免名字有完全匹配，要是你一定要在名字里面加_，而且还是完全匹配的
	//那么你就是在自己给自己找事
	
	if(SERVER_STATE_BEGIN == g_server_state)
	{
		GLog::log(LOG_INFO, "dbloaddata begin ... ...");
		std::string table = "roleinfo_";
		DBLoadDataArg new_arg;
		DBLoadData *rpc = (DBLoadData *)Rpc::Call(RPC_DBLOADDATA,new_arg);
		GameDBClient::GetInstance()->SendProtocol(rpc);
		g_server_state = SERVER_STATE_LOADING;
	}
	//else if(SERVER_STATE_LOADING == g_server_state)
	//{
	//	GLog::log(LOG_INFO, "dbloaddata begin ... ...");
	//	std::string table = "roleinfo_";
	//	DBLoadDataArg new_arg;
	//	DBLoadData *rpc = (DBLoadData *)Rpc::Call(RPC_DBLOADDATA,new_arg);
	//	GameDBClient::GetInstance()->SendProtocol(rpc);
	//	g_server_state = SERVER_STATE_LOADING;
	//}
}

void GameDBClient::OnDelSession(Session::ID sid)
{
	Thread::Mutex2::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
	GLog::log(LOG_INFO, "GameDBClient::OnDelSession ... ...");
}

void GameDBClient::OnAbortSession(const SockAddr &sa)
{
	Thread::Mutex2::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
	GLog::log(LOG_INFO, "GameDBClient::OnAbortSession ... ...");
}

void GameDBClient::OnCheckAddress(SockAddr &sa) const
{
}

};
