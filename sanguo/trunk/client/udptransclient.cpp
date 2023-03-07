
#include "udptransclient.hpp"
#include "state.hxx"

#include "connection.h"

namespace GNET
{

//UDPTransClient UDPTransClient::instance;

const Protocol::Manager::Session::State* UDPTransClient::GetInitState() const
{
	return &state_UDPTransClient;
}

void UDPTransClient::OnSetTransport(SESSION_ID sid, const SockAddr& local, const SockAddr& peer)
{
	char buf[128];
	const struct sockaddr_in *l = local;
	inet_ntop(AF_INET, &l->sin_addr, buf, sizeof(buf));
	local_port = ntohs(l->sin_port);
	printf("UDPTransClient::OnSetTransport, sid=%u, local_port=%d\n", sid, local_port);

	const struct sockaddr_in *p = peer;
	printf("UDPTransClient::OnSetTransport, sid=%u, peer.port=%d\n", sid, ntohs(p->sin_port));
	sid_2_addr[sid] = peer;
}

const SockAddr* UDPTransClient::GetSockAddrBySid(unsigned int sid) const
{
	auto it = sid_2_addr.find(sid);
	if(it == sid_2_addr.end()) return 0;
	return &it->second;
}

void UDPTransClient::SendTo(const char *dest_ip, unsigned short dest_port, const Protocol& protocol)
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

void UDPTransClient::SendTo(const SockAddr& dest, const Protocol& protocol)
{
	int fd = ((PollIO*)_assoc_passiveio)->GetFD();
	
	Marshal::OctetsStream os;
	protocol.Encode(os);
	
	sendto(fd, os.begin(), os.size(), 0, (const struct sockaddr*)dest, sizeof(sockaddr_in));
}

};
