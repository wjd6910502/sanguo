
#include "pvpcenterclient.hpp"
#include "state.hxx"
#include "timertask.h"
#include "pvpudptransserver.hpp"
#include "pvpserverregister.hpp"

namespace GNET
{

PVPCenterClient PVPCenterClient::instance;

void PVPCenterClient::Reconnect()
{
	Thread::HouseKeeper::AddTimerTask(new ReconnectTask(this, 1), backoff);
	backoff *= 2;
	if (backoff > BACKOFF_DEADLINE) backoff = BACKOFF_DEADLINE;
}

const Protocol::Manager::Session::State* PVPCenterClient::GetInitState() const
{
	return &state_PVPCenterClient;
}

void PVPCenterClient::OnAddSession(Session::ID sid)
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
	
	//每次连上gcenterd都汇报信息
	PVPServerRegister prot;
	prot.ip = PVPUDPTransServer::GetInstance()->GetPublicAddress();
	prot.port = PVPUDPTransServer::GetInstance()->GetPublicPort();
	SendProtocol(prot);
}

void PVPCenterClient::OnDelSession(Session::ID sid)
{
	Thread::Mutex::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
}

void PVPCenterClient::OnAbortSession(const SockAddr &sa)
{
	Thread::Mutex::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
}

void PVPCenterClient::OnCheckAddress(SockAddr &sa) const
{
}

};
