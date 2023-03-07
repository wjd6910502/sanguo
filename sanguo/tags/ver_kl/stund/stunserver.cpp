
#include "stunserver.hpp"
#include "state.hxx"

namespace GNET
{

STUNServer STUNServer::instance;

const Protocol::Manager::Session::State* STUNServer::GetInitState() const
{
	return &state_STUNServer;
}

void STUNServer::OnAddSession(Session::ID sid)
{
}

void STUNServer::OnDelSession(Session::ID sid)
{
}

void STUNServer::OnSetTransport(SESSION_ID sid, const SockAddr& local, const SockAddr& peer)
{
	//const struct sockaddr_in *s = peer;
	//GLog::log(LOG_INFO, "GAMED::UDPTransServer::OnSetTransport, sid=%u, peer.port=%d", sid, ntohs(s->sin_port));

	sid_2_addr[sid] = peer;
}

const SockAddr* STUNServer::GetSockAddrBySid(unsigned int sid) const
{
	auto it = sid_2_addr.find(sid);
	if(it == sid_2_addr.end()) return 0;
	return &it->second;
}

void STUNServer::SendTo(const char *dest_ip, unsigned short dest_port, const Protocol& protocol) const
{
	int fd = ((PollIO*)_assoc_passiveio)->GetFD();

	Marshal::OctetsStream os;
	protocol.Encode(os);

	sockaddr_in dest_addr;
	memset(&dest_addr, 0, sizeof(dest_addr));
	dest_addr.sin_family = AF_INET;
	dest_addr.sin_addr.s_addr = inet_addr(dest_ip);
	dest_addr.sin_port = htons(dest_port);

	sendto(fd, os.begin(), os.size(), 0, (const struct sockaddr*)&dest_addr, sizeof(dest_addr));
}

void STUNServer::SendTo(const SockAddr dest, const Protocol& protocol) const
{
	int fd = ((PollIO*)_assoc_passiveio)->GetFD();

	Marshal::OctetsStream os;
	protocol.Encode(os);

	sendto(fd, os.begin(), os.size(), 0, (const struct sockaddr*)dest, sizeof(sockaddr_in));
}

};
