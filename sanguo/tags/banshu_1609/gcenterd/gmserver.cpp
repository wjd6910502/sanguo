
#include "gmserver.hpp"
#include "state.hxx"

namespace GNET
{

GMServer GMServer::instance;

const Protocol::Manager::Session::State* GMServer::GetInitState() const
{
	return &state_GMServer;
}

void GMServer::OnAddSession(Session::ID sid)
{
	num++;
	_session_map[num] = sid;
}

void GMServer::OnDelSession(Session::ID sid)
{
}

void GMServer::DispatchProtocol(Session::ID sid,const Protocol* p)
{
	Send(sid, p);
}

};
