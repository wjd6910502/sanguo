
#include "sttserver.hpp"
#include "state.hxx"

namespace GNET
{

STTServer STTServer::instance;

const Protocol::Manager::Session::State* STTServer::GetInitState() const
{
	return &state_STTServer;
}

void STTServer::OnAddSession(Session::ID sid)
{
	//GLog::log(LOG_INFO, "STTServer::OnAddSession ... ...");
	printf(" STTServer::OnAddSession ... ... \n");
}

void STTServer::OnDelSession(Session::ID sid)
{
}

};
