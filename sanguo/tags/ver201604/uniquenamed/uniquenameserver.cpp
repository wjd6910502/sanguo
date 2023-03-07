
#include "uniquenameserver.hpp"
#include "state.hxx"

namespace GNET
{

UniqueNameServer UniqueNameServer::instance;

const Protocol::Manager::Session::State* UniqueNameServer::GetInitState() const
{
	return &state_UniqueNameServer;
}

void UniqueNameServer::OnAddSession(Session::ID sid)
{
}

void UniqueNameServer::OnDelSession(Session::ID sid)
{
}

};
