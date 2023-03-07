
#include "registerclient.hpp"
#include "state.hxx"
#include "timertask.h"
namespace GNET
{

RegisterClient RegisterClient::instance;

void RegisterClient::Reconnect()
{
	Thread::HouseKeeper::AddTimerTask(new ReconnectTask(this, 1), backoff);
	backoff *= 2;
	if (backoff > BACKOFF_DEADLINE) backoff = BACKOFF_DEADLINE;
}

const Protocol::Manager::Session::State* RegisterClient::GetInitState() const
{
	return &state_RegisterClient;
}

void RegisterClient::OnAddSession(Session::ID sid)
{
	Thread::Mutex::Scoped l(locker_state);
	if (conn_state)
	{
		Close(sid);
		return;
	}
	conn_state = true;
	this->sid = sid;
	backoff = BACKOFF_INIT;
}

void RegisterClient::OnDelSession(Session::ID sid)
{
	Thread::Mutex::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
}

void RegisterClient::OnAbortSession(const SockAddr &sa)
{
	Thread::Mutex::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
}

void RegisterClient::OnCheckAddress(SockAddr &sa) const
{
}

};
