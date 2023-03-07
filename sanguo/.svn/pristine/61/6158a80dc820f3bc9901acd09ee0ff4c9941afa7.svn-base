#include "verificationclient.hpp"
#include "state.hxx"
#include "timertask.h"
#include "register.hpp"

namespace GNET
{

VerificationClient VerificationClient::instance;

void VerificationClient::Reconnect()
{
	Thread::HouseKeeper::AddTimerTask(new ReconnectTask(this, 1), backoff);
	backoff *= 2;
	if (backoff > BACKOFF_DEADLINE) backoff = BACKOFF_DEADLINE;
}

const Protocol::Manager::Session::State* VerificationClient::GetInitState() const
{
	return &state_VerificationClient;
}

void VerificationClient::OnAddSession(Session::ID sid)
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
	Log::log(LOG_INFO, "VerificationClient::OnAddSession ... ...");

	Register prot;
	prot.battle_ver = battle_ver;
	Send(sid, prot);
}

void VerificationClient::OnDelSession(Session::ID sid)
{
	Thread::Mutex::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
	Log::log(LOG_INFO, "VerificationClient::OnDelSession ... ...");
}

void VerificationClient::OnAbortSession(const SockAddr &sa)
{
	Thread::Mutex::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
	Log::log(LOG_INFO, "VerificationClient::OnAbortSession ... ...");
}

void VerificationClient::OnCheckAddress(SockAddr &sa) const
{
}

};
