
#ifndef __GNET_CLIENT_CALLID
#define __GNET_CLIENT_CALLID

namespace GNET
{

enum CallID
{
};

enum ProtocolType
{
	PROTOCOL_RESPONSE	=	2,
	PROTOCOL_TRANSRESPONSE	=	5,
	PROTOCOL_GAMEPROTOCOL	=	8,
	PROTOCOL_KEEPALIVE	=	12,
	PROTOCOL_UDPC2SGAMEPROTOCOLS	=	35,
	PROTOCOL_SYNCNETIMERE	=	15,
	PROTOCOL_UDPSTUNREQUEST	=	102,
	PROTOCOL_REPORTUDPINFO	=	106,
	PROTOCOL_SERVERLOG	=	107,
	PROTOCOL_CHALLENGE	=	1,
	PROTOCOL_AUTHRESULT	=	3,
	PROTOCOL_SERVERSTATUS	=	10,
	PROTOCOL_TRANSCHALLENGE	=	4,
	PROTOCOL_TRANSAUTHRESULT	=	6,
	PROTOCOL_CONTINUE	=	7,
	PROTOCOL_KICKOUT	=	9,
	PROTOCOL_SYNCNETIME	=	14,
	PROTOCOL_UDPGAMEPROTOCOL	=	11,
	PROTOCOL_UDPKEEPALIVE	=	13,
	PROTOCOL_UDPS2CGAMEPROTOCOLS	=	36,
	PROTOCOL_UDPSTUNRESPONSE	=	103,
	PROTOCOL_UDPP2PMAKEHOLE	=	105,
};

};
#endif
