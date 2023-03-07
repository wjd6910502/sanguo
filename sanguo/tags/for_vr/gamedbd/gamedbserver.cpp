
#include "gamedbserver.hpp"
#include "state.hxx"

namespace GNET
{

GameDBServer GameDBServer::instance;

const Protocol::Manager::Session::State* GameDBServer::GetInitState() const
{
	return &state_GameDBServer;
}

void GameDBServer::OnAddSession(Session::ID sid)
{
}

void GameDBServer::OnDelSession(Session::ID sid)
{
}

void GameDBServer::DispatchProtocol(Session::ID sid,const Protocol* p)
{
	Send(sid, p);
}

};
