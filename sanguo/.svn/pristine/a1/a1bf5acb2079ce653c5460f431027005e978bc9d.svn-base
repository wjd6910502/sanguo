
#include "gmadapterclient.hpp"
#include "state.hxx"
namespace GNET
{

GMAdapterClient GMAdapterClient::instance;

void GMAdapterClient::Reconnect()
{
	Thread::HouseKeeper::AddTimerTask(new ReconnectTask(this, 1), 3);
}

const Protocol::Manager::Session::State* GMAdapterClient::GetInitState() const
{
	return &state_GMAdapterClient;
}

void GMAdapterClient::OnAddSession(Session::ID sid)
{
	Thread::Mutex::Scoped l(locker_state);
	if (conn_state)
	{
		Close(sid);
		return;
	}
	conn_state = true;
	this->sid = sid;
}

void GMAdapterClient::OnDelSession(Session::ID sid)
{
	Thread::Mutex::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
}

void GMAdapterClient::OnAbortSession(const SockAddr &sa)
{
	Thread::Mutex::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
}

void GMAdapterClient::OnCheckAddress(SockAddr &sa) const
{
}

};
