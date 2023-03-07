
#include "udptransserver.hpp"
#include "state.hxx"

#include "transchallenge.hpp"
#include "commonmacro.h"
//#include "thread.h"
#include "glog.h"

namespace GNET
{

UDPTransServer UDPTransServer::instance;

const Protocol::Manager::Session::State* UDPTransServer::GetInitState() const
{
	return &state_UDPTransServer;
}

void UDPTransServer::OnAddSession(Session::ID sid)
{
	//GLog::log(LOG_INFO, "GAMED::UDPTransServer::OnAddSession, sid=%u", sid);
}

void UDPTransServer::OnDelSession(Session::ID sid)
{
}

void UDPTransServer::OnSetTransport(SESSION_ID sid, const SockAddr& local, const SockAddr& peer)
{
	const struct sockaddr_in *s = peer;
	GLog::log(LOG_INFO, "GAMED::UDPTransServer::OnSetTransport, sid=%u, peer.port=%d", sid, ntohs(s->sin_port));

	sid_2_addr[sid] = peer;
}

const SockAddr* UDPTransServer::GetSockAddrBySid(unsigned int sid) const
{
	auto it = sid_2_addr.find(sid);
	if(it == sid_2_addr.end()) return 0;
	return &it->second;
}

};
