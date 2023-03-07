
#include "stungameserver.hpp"
#include "state.hxx"

namespace GNET
{

STUNGameServer STUNGameServer::instance;

const Protocol::Manager::Session::State* STUNGameServer::GetInitState() const
{
	return &state_STUNGameServer;
}

void STUNGameServer::OnAddSession(Session::ID sid)
{
}

void STUNGameServer::OnDelSession(Session::ID sid)
{
}

};
