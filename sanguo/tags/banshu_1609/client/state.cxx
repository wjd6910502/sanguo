#include "callid.hxx"

#ifdef WIN32
#include <winsock2.h>
#include "gnproto.h"
#include "gncompress.h"
#else
#include "protocol.h"
//#include "binder.h"
#endif

namespace GNET
{

static GNET::Protocol::Type _state_GateClient[] = 
{
	PROTOCOL_CHALLENGE,
	PROTOCOL_AUTHRESULT,
};

GNET::Protocol::Manager::Session::State state_GateClient(_state_GateClient,
						sizeof(_state_GateClient)/sizeof(GNET::Protocol::Type), 86400);

static GNET::Protocol::Type _state_StatusClient[] = 
{
	PROTOCOL_SERVERSTATUS,
};

GNET::Protocol::Manager::Session::State state_StatusClient(_state_StatusClient,
						sizeof(_state_StatusClient)/sizeof(GNET::Protocol::Type), 86400);

static GNET::Protocol::Type _state_TransClient[] = 
{
	PROTOCOL_TRANSCHALLENGE,
	PROTOCOL_TRANSAUTHRESULT,
	PROTOCOL_CONTINUE,
	PROTOCOL_GAMEPROTOCOL,
	PROTOCOL_KEEPALIVE,
	PROTOCOL_KICKOUT,
	PROTOCOL_SYNCNETIME,
};

GNET::Protocol::Manager::Session::State state_TransClient(_state_TransClient,
						sizeof(_state_TransClient)/sizeof(GNET::Protocol::Type), 86400);

static GNET::Protocol::Type _state_UDPTransClient[] = 
{
	PROTOCOL_UDPGAMEPROTOCOL,
	PROTOCOL_UDPKEEPALIVE,
	PROTOCOL_UDPS2CGAMEPROTOCOLS,
	PROTOCOL_UDPSTUNRESPONSE,
	PROTOCOL_UDPP2PMAKEHOLE,
	PROTOCOL_UDPC2SGAMEPROTOCOLS,
};

GNET::Protocol::Manager::Session::State state_UDPTransClient(_state_UDPTransClient,
						sizeof(_state_UDPTransClient)/sizeof(GNET::Protocol::Type), 86400);

static GNET::Protocol::Type _state_Null[] = 
{
};

GNET::Protocol::Manager::Session::State state_Null(_state_Null,
						sizeof(_state_Null)/sizeof(GNET::Protocol::Type), 5);


};

