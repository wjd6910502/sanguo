
#include "pvpgameserver.hpp"
#include "state.hxx"

namespace GNET
{

PVPGameServer PVPGameServer::instance;

const Protocol::Manager::Session::State* PVPGameServer::GetInitState() const
{
	return &state_PVPGameServer;
}

void PVPGameServer::OnAddSession(Session::ID sid)
{
}

void PVPGameServer::OnDelSession(Session::ID sid)
{
}

};
