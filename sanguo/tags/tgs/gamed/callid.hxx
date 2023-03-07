
#ifndef __GNET_GAMED_CALLID
#define __GNET_GAMED_CALLID

namespace GNET
{

enum CallID
{
	RPC_DBLOADDATA	=	1001,
	RPC_DBLOADROLEDATA	=	1025,
	RPC_DBSAVEDATA	=	1002,
	RPC_STUNGETSERVERINFO	=	101,
	RPC_PVPCANCLE	=	1014,
	RPC_CREATEROLENAME	=	1017,
	RPC_CREATEMAFIANAME	=	1026,
	RPC_GETTEXTINSPEECH	=	2001,
	RPC_PVPJOIN	=	1006,
	RPC_PVPCREATE	=	41,
};

enum ProtocolType
{
	PROTOCOL_CHALLENGE	=	1,
	PROTOCOL_AUTHRESULT	=	3,
	PROTOCOL_TRANSCHALLENGE	=	4,
	PROTOCOL_TRANSAUTHRESULT	=	6,
	PROTOCOL_KICKOUT	=	9,
	PROTOCOL_UDPS2CGAMEPROTOCOLS	=	36,
	PROTOCOL_SYNCNETIME	=	14,
	PROTOCOL_UDPSYNCNETTIME	=	37,
	PROTOCOL_CENTERCOMMAND	=	1003,
	PROTOCOL_CENTERCOMMANDRE	=	1004,
	PROTOCOL_KUAFUZONEREGISTER	=	1005,
	PROTOCOL_PVPMATCHSUCCESS	=	1007,
	PROTOCOL_PVPENTER	=	1008,
	PROTOCOL_PVPENTERRE	=	1009,
	PROTOCOL_SENDPVPVIDEOID	=	1021,
	PROTOCOL_PVPCENTERCREATE	=	1010,
	PROTOCOL_PVPLEAVE	=	1011,
	PROTOCOL_PVPLEAVERE	=	1012,
	PROTOCOL_PVPREADY	=	1013,
	PROTOCOL_PVPSPEED	=	1015,
	PROTOCOL_PVPSPEEDRE	=	1016,
	PROTOCOL_PVPRESET	=	1018,
	PROTOCOL_PVPRESETRE	=	1019,
	PROTOCOL_GETPVPVIDEO	=	1022,
	PROTOCOL_GETPVPVIDEORE	=	1023,
	PROTOCOL_DELPVPVIDEO	=	1024,
	PROTOCOL_PVPDELETE	=	43,
	PROTOCOL_UDPSTUNRESPONSE	=	103,
	PROTOCOL_FORWARDUDPSTUNREQUEST	=	104,
	PROTOCOL_GETIATEXTINSPEECHRE	=	2003,
	PROTOCOL_STTZONEREGISTER	=	2004,
	PROTOCOL_RESPONSE	=	2,
	PROTOCOL_TRANSRESPONSE	=	5,
	PROTOCOL_CONTINUE	=	7,
	PROTOCOL_GAMEPROTOCOL	=	8,
	PROTOCOL_KEEPALIVE	=	12,
	PROTOCOL_SYNCNETIMERE	=	15,
	PROTOCOL_REPORTUDPINFO	=	106,
	PROTOCOL_SERVERLOG	=	107,
	PROTOCOL_UDPGAMEPROTOCOL	=	11,
	PROTOCOL_UDPKEEPALIVE	=	13,
	PROTOCOL_UDPC2SGAMEPROTOCOLS	=	35,
	PROTOCOL_UDPSYNCNETTIMERE	=	38,
	PROTOCOL_UDPSTUNREQUEST	=	102,
	PROTOCOL_PVPSERVERREGISTER	=	39,
	PROTOCOL_PVPSERVERUPDATESTATUS	=	40,
	PROTOCOL_PVPEND	=	44,
	PROTOCOL_PVPOPERATION	=	1020,
};

};
#endif
