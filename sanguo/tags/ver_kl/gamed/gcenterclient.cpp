#include "gcenterclient.hpp"
#include "state.hxx"
#include "kuafuzoneregister.hpp"

namespace GNET
{
int g_zoneid = 0;

GCenterClient GCenterClient::instance;

void GCenterClient::Reconnect()
{
	Thread::HouseKeeper::AddTimerTask(new ReconnectTask(this, 1), 3);
}

const Protocol::Manager::Session::State* GCenterClient::GetInitState() const
{
	return &state_GCenterClient;
}

void GCenterClient::OnAddSession(Session::ID sid)
{
	Thread::Mutex::Scoped l(locker_state);
	if (conn_state)
	{
		Close(sid);
		return;
	}
	conn_state = true;
	this->sid = sid;

	KuafuZoneRegister prot;
	prot.zoneid = g_zoneid;
	SendProtocol(prot);
}

void GCenterClient::OnDelSession(Session::ID sid)
{
	Thread::Mutex::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
	GLog::log(LOG_INFO, "GCenterClient::OnAbortSession ... ...");
}

void GCenterClient::OnAbortSession(const SockAddr &sa)
{
	Thread::Mutex::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
	GLog::log(LOG_INFO, "GCenterClient::OnAbortSession ... ...");
}

void GCenterClient::OnCheckAddress(SockAddr &sa) const
{
}

};
