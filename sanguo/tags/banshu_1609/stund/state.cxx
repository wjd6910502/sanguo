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

static GNET::Protocol::Type _state_STUNServer[] = 
{
	PROTOCOL_UDPSTUNREQUEST,
};

GNET::Protocol::Manager::Session::State state_STUNServer(_state_STUNServer,
						sizeof(_state_STUNServer)/sizeof(GNET::Protocol::Type), 86400);

static GNET::Protocol::Type _state_STUNDeafServer[] = 
{
};

GNET::Protocol::Manager::Session::State state_STUNDeafServer(_state_STUNDeafServer,
						sizeof(_state_STUNDeafServer)/sizeof(GNET::Protocol::Type), 86400);

static GNET::Protocol::Type _state_STUNGameServer[] = 
{
	RPC_STUNGETSERVERINFO,
	PROTOCOL_FORWARDUDPSTUNREQUEST,
};

GNET::Protocol::Manager::Session::State state_STUNGameServer(_state_STUNGameServer,
						sizeof(_state_STUNGameServer)/sizeof(GNET::Protocol::Type), 86400);

static GNET::Protocol::Type _state_Null[] = 
{
};

GNET::Protocol::Manager::Session::State state_Null(_state_Null,
						sizeof(_state_Null)/sizeof(GNET::Protocol::Type), 5);


};

