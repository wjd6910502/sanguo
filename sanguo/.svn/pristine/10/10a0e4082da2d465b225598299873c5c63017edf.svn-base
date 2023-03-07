
#include "sttclient.hpp"
#include "state.hxx"
#include "sttzoneregister.hpp"
namespace GNET
{

STTClient STTClient::instance;

void STTClient::Reconnect()
{
	Thread::HouseKeeper::AddTimerTask(new ReconnectTask(this, 1), 3);
}

const Protocol::Manager::Session::State* STTClient::GetInitState() const
{
	return &state_STTClient;
}

void STTClient::OnAddSession(Session::ID sid)
{
	Thread::Mutex2::Scoped l(locker_state);
	if (conn_state)
	{
		Close(sid);
		return;
	}
	conn_state = true;
	this->sid = sid;
	
	STTZoneRegister prot;
	prot.zoneid = g_zoneid;
	SendProtocol(prot);
}

void STTClient::OnDelSession(Session::ID sid)
{
	Thread::Mutex2::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
	//GLog::log(LOG_INFO, "STTClient::OnAbortSession ... ...");

}

void STTClient::OnAbortSession(const SockAddr &sa)
{
	Thread::Mutex2::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
	//GLog::log(LOG_INFO, "STTClient::OnAbortSession ... ...");
}

void STTClient::OnCheckAddress(SockAddr &sa) const
{
}

};
