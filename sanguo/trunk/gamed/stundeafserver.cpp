
#include "stundeafserver.hpp"
#include "state.hxx"

namespace GNET
{

STUNDeafServer STUNDeafServer::instance;

const Protocol::Manager::Session::State* STUNDeafServer::GetInitState() const
{
	return &state_STUNDeafServer;
}

void STUNDeafServer::OnAddSession(Session::ID sid)
{
}

void STUNDeafServer::OnDelSession(Session::ID sid)
{
}

void STUNDeafServer::SendTo(const char *dest_ip, unsigned short dest_port, const Protocol& protocol) const
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

void STUNDeafServer::SendTo(const SockAddr dest, const Protocol& protocol) const
{
	int fd = ((PollIO*)_assoc_passiveio)->GetFD();

	Marshal::OctetsStream os;
	protocol.Encode(os);

	sendto(fd, os.begin(), os.size(), 0, (const struct sockaddr*)dest, sizeof(sockaddr_in));
}

};
