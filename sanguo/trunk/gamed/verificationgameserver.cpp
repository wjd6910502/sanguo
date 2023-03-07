
#include "verificationgameserver.hpp"
#include "state.hxx"

namespace GNET
{

VerificationGameServer VerificationGameServer::instance;

const Protocol::Manager::Session::State* VerificationGameServer::GetInitState() const
{
	return &state_VerificationGameServer;
}

void VerificationGameServer::OnAddSession(Session::ID sid)
{
	GLog::log(LOG_INFO, "VerificationGameServer::OnAddSession ... ...%d", sid);
	conn_state = true;
}

void VerificationGameServer::OnDelSession(Session::ID sid)
{
	GLog::log(LOG_INFO, "VerificationGameServer::OnDelSession ... ...");
	conn_state = false;
}

};
