
#include "pvpgameclient.hpp"
#include "state.hxx"
#include "timertask.h"
#include "pvpudptransserver.hpp"
#include "pvpserverregister.hpp"

namespace GNET
{

PVPGameClient PVPGameClient::instance;

void PVPGameClient::Reconnect()
{
	Thread::HouseKeeper::AddTimerTask(new ReconnectTask(this, 1), backoff);
	backoff *= 2;
	if (backoff > BACKOFF_DEADLINE) backoff = BACKOFF_DEADLINE;
}

const Protocol::Manager::Session::State* PVPGameClient::GetInitState() const
{
	return &state_PVPGameClient;
}

void PVPGameClient::OnAddSession(Session::ID sid)
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

	//每次连上gamed都汇报信息
	PVPServerRegister prot;
	prot.ip = PVPUDPTransServer::GetInstance()->GetPublicAddress();
	prot.port = PVPUDPTransServer::GetInstance()->GetPublicPort();
	SendProtocol(prot);
}

void PVPGameClient::OnDelSession(Session::ID sid)
{
	Thread::Mutex::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
}

void PVPGameClient::OnAbortSession(const SockAddr &sa)
{
	Thread::Mutex::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
}

void PVPGameClient::OnCheckAddress(SockAddr &sa) const
{
}

};
