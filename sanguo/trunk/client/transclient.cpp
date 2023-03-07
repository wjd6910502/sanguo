
#include "transclient.hpp"
#include "state.hxx"

#include "connection.h"

namespace GNET
{

//TransClient TransClient::instance;

const Protocol::Manager::Session::State* TransClient::GetInitState() const
{
	return &state_TransClient;
}

void TransClient::OnAddSession(Session::ID sid)
{
	fprintf(stderr, "TransClient::OnAddSession, this->sid=%d, sid=%d\n", this->sid, sid);

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

void TransClient::OnDelSession(Session::ID sid)
{
	fprintf(stderr, "TransClient::OnDelSession, this->sid=%d, sid=%d\n", this->sid, sid);

	Thread::Mutex::Scoped l(locker_state);

	if(!conn_state || this->sid!=sid) return;
	conn_state = false;
	//Connection::GetInstance().OnTransLostConnection(this, sid);
	_conn->OnTransLostConnection(this, sid);
}

void TransClient::OnAbortSession(const SockAddr &sa)
{
	//Thread::Mutex::Scoped l(locker_state);
	//conn_state = false;
}

void TransClient::OnCheckAddress(SockAddr &sa) const
{
}

bool TransClient::LoadSessionConfig(GNET::NetSession::Config &cnf)
{
	if(!GNET::Protocol::Manager::LoadSessionConfig(cnf)) return false;
	//cnf.address = Connection::GetInstance().GetTransIP();
	//cnf.port = Connection::GetInstance().GetTransPort();
	cnf.address = _conn->GetTransIP();
	cnf.port = _conn->GetTransPort();
	return true;
}

void TransClient::CloseCur()
{
	if (conn_state)
	{
		conn_state = false;
		Close(sid);
	}
}

void TransClient::OnSetTransport(SESSION_ID sid, const SockAddr& local, const SockAddr& peer)
{
	char buf[128];
	const struct sockaddr_in *l = local;
	inet_ntop(AF_INET, &l->sin_addr, buf, sizeof(buf));
	local_ip = buf;
	printf("TransClient::OnSetTransport, sid=%u, local_ip=%s\n", sid, local_ip.c_str());
}

int TransClient::GetCurSID() const
{
	if(!conn_state) return 0;
	return sid;
}

};
