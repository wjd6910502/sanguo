
#include "stungameclient.hpp"
#include "state.hxx"
#include "timertask.h"
#include "stungetserverinfo.hrp"

namespace GNET
{

STUNGameClient STUNGameClient::instance;

void STUNGameClient::Reconnect()
{
	Thread::HouseKeeper::AddTimerTask(new ReconnectTask(this, 1), backoff);
	backoff *= 2;
	if (backoff > BACKOFF_DEADLINE) backoff = BACKOFF_DEADLINE;
}

const Protocol::Manager::Session::State* STUNGameClient::GetInitState() const
{
	return &state_STUNGameClient;
}

void STUNGameClient::OnAddSession(Session::ID sid)
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

	//每次连上stund都查询信息
	STUNGetServerInfoArg arg;
	arg.zoneid = 0; //TODO:
	STUNGetServerInfo *rpc = (STUNGetServerInfo*)Rpc::Call(RPC_STUNGETSERVERINFO, arg);
	SendProtocol(rpc);
}

void STUNGameClient::OnDelSession(Session::ID sid)
{
	Thread::Mutex2::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
}

void STUNGameClient::OnAbortSession(const SockAddr &sa)
{
	Thread::Mutex2::Scoped l(locker_state);
	conn_state = false;
	Reconnect();
}

void STUNGameClient::OnCheckAddress(SockAddr &sa) const
{
}

};
