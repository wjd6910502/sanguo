
#include "laohuproxyclient.hpp"
#include "state.hxx"
#include "timertask.h"
namespace GNET
{

LaohuProxyClient LaohuProxyClient::instance;

void LaohuProxyClient::Reconnect()
{
	Thread::HouseKeeper::AddTimerTask(new ReconnectTask(this, 1), backoff);
	backoff *= 2;
	if (backoff > BACKOFF_DEADLINE) backoff = BACKOFF_DEADLINE;
}

const Protocol::Manager::Session::State* LaohuProxyClient::GetInitState() const
{
	return &state_LaohuProxyClient;
}

void LaohuProxyClient::OnAddSession(Session::ID sid)
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

void LaohuProxyClient::OnDelSession(Session::ID sid)
{
	Thread::Mutex::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
}

void LaohuProxyClient::OnAbortSession(const SockAddr &sa)
{
	Thread::Mutex::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
}

void LaohuProxyClient::OnCheckAddress(SockAddr &sa) const
{
}

};
