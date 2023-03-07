
#include "gaccodeserver.hpp"
#include "state.hxx"

namespace GNET
{

GACCodeServer GACCodeServer::instance;

const Protocol::Manager::Session::State* GACCodeServer::GetInitState() const
{
	return &state_GACCodeServer;
}

void GACCodeServer::OnAddSession(Session::ID sid)
{
}

void GACCodeServer::OnDelSession(Session::ID sid)
{
}

};
