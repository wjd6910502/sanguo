
#include "uniquenameclient.hpp"
#include "state.hxx"
#include "timertask.h"
namespace GNET
{

UniqueNameClient UniqueNameClient::instance;

void UniqueNameClient::Reconnect()
{
	Thread::HouseKeeper::AddTimerTask(new ReconnectTask(this, 1), backoff);
	backoff *= 2;
	if (backoff > BACKOFF_DEADLINE) backoff = BACKOFF_DEADLINE;
}

const Protocol::Manager::Session::State* UniqueNameClient::GetInitState() const
{
	return &state_UniqueNameClient;
}

void UniqueNameClient::OnAddSession(Session::ID sid)
{
	Thread::Mutex2::Scoped l(locker_state);
	if (conn_state)
	{
		Close(sid);
		return;
	}
	conn_state = true;
	this->sid = sid;
	backoff = BACKOFF_INIT;
}

void UniqueNameClient::OnDelSession(Session::ID sid)
{
	Thread::Mutex2::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
}

void UniqueNameClient::OnAbortSession(const SockAddr &sa)
{
	Thread::Mutex2::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
}

void UniqueNameClient::OnCheckAddress(SockAddr &sa) const
{
}

};
