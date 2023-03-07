
#include "gateclient.hpp"
#include "state.hxx"

#include "connection.h"

namespace GNET
{

GateClient GateClient::instance;

const Protocol::Manager::Session::State* GateClient::GetInitState() const
{
	return &state_GateClient;
}

void GateClient::OnAddSession(Session::ID sid)
{
	fprintf(stderr, "GateClient::OnAddSession, this->sid=%d, sid=%d\n", this->sid, sid);

	Thread::Mutex::Scoped l(locker_state);

	if(conn_state)
	{
		Close(sid);
		return;
	}
	if(_discard_sid_le_than>0 && sid<=_discard_sid_le_than)
	{
		Close(sid);
		return;
	}
	conn_state = true;
	this->sid = sid;
}

void GateClient::OnDelSession(Session::ID sid)
{
	fprintf(stderr, "GateClient::OnDelSession, this->sid=%d, sid=%d\n", this->sid, sid);

	Thread::Mutex::Scoped l(locker_state);

	if(!conn_state || this->sid!=sid) return;
	conn_state = false;
}

void GateClient::OnAbortSession(const SockAddr &sa)
{
	//Thread::Mutex::Scoped l(locker_state);
	//conn_state = false;
}

void GateClient::OnCheckAddress(SockAddr &sa) const
{
}

bool GateClient::LoadSessionConfig(GNET::NetSession::Config &cnf)
{
	if(!GNET::Protocol::Manager::LoadSessionConfig(cnf)) return false;
	cnf.address = Connection::GetInstance().GetGateIP();
	cnf.port = Connection::GetInstance().GetGatePort();
	return true;
}

void GateClient::CloseCur()
{
	if (conn_state)
	{
		conn_state = false;
		Close(sid);
	}
}

int GateClient::GetCurSID() const
{
	if(!conn_state) return 0;
	return sid;
}

};
