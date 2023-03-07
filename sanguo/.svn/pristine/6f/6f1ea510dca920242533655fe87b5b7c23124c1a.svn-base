
#include "gaccodeclient.hpp"
#include "state.hxx"
#include "timertask.h"
#include "aczoneregister.hpp"

extern int g_zoneid;
namespace GNET
{

GACCodeClient GACCodeClient::instance;

void GACCodeClient::Reconnect()
{
	Thread::HouseKeeper::AddTimerTask(new ReconnectTask(this, 1), backoff);
	backoff *= 2;
	if (backoff > BACKOFF_DEADLINE) backoff = BACKOFF_DEADLINE;
}

const Protocol::Manager::Session::State* GACCodeClient::GetInitState() const
{
	return &state_GACCodeClient;
}

void GACCodeClient::OnAddSession(Session::ID sid)
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

	ACZoneRegister prot;
	prot.zoneid = g_zoneid;
	SendProtocol(prot);

}

void GACCodeClient::OnDelSession(Session::ID sid)
{
	Thread::Mutex::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
}


void GACCodeClient::OnAbortSession(const SockAddr &sa)
{
	Thread::Mutex::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
}

void GACCodeClient::OnCheckAddress(SockAddr &sa) const
{
}

};
