
#ifndef __GNET_PVPD_CALLID
#define __GNET_PVPD_CALLID

namespace GNET
{

enum CallID
{
	RPC_PVPCREATE	=	41,
};

enum ProtocolType
{
	PROTOCOL_UDPS2CGAMEPROTOCOLS	=	36,
	PROTOCOL_PVPSERVERREGISTER	=	39,
	PROTOCOL_PVPSERVERUPDATESTATUS	=	40,
	PROTOCOL_PVPEND	=	44,
	PROTOCOL_PVPOPERATION	=	1020,
	PROTOCOL_AUDIENCEOPERATION	=	1028,
	PROTOCOL_PVPPAUSE	=	45,
	PROTOCOL_PVPCONTINUE	=	47,
	PROTOCOL_UDPKEEPALIVE	=	13,
	PROTOCOL_UDPGAMEPROTOCOL	=	11,
	PROTOCOL_UDPC2SGAMEPROTOCOLS	=	35,
	PROTOCOL_PVPDELETE	=	43,
	PROTOCOL_PVPPAUSE_RE	=	46,
};

};
#endif
