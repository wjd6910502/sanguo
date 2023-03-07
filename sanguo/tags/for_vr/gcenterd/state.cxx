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

static GNET::Protocol::Type _state_GMServer[] = 
{
	PROTOCOL_CENTERCOMMAND,
	PROTOCOL_CENTERCOMMANDRE,
};

GNET::Protocol::Manager::Session::State state_GMServer(_state_GMServer,
						sizeof(_state_GMServer)/sizeof(GNET::Protocol::Type), 86400);

static GNET::Protocol::Type _state_GCenterServer[] = 
{
	PROTOCOL_CENTERCOMMAND,
	PROTOCOL_CENTERCOMMANDRE,
	PROTOCOL_KUAFUZONEREGISTER,
	RPC_PVPJOIN,
	PROTOCOL_PVPMATCHSUCCESS,
	PROTOCOL_PVPENTER,
	PROTOCOL_PVPENTERRE,
	PROTOCOL_SENDPVPVIDEOID,
	PROTOCOL_PVPLEAVE,
	PROTOCOL_PVPLEAVERE,
	PROTOCOL_PVPCENTERCREATE,
	PROTOCOL_PVPREADY,
	PROTOCOL_PVPSPEED,
	PROTOCOL_PVPSPEEDRE,
	PROTOCOL_PVPRESET,
	PROTOCOL_PVPRESETRE,
	PROTOCOL_GETPVPVIDEO,
	PROTOCOL_GETPVPVIDEORE,
	PROTOCOL_DELPVPVIDEO,
	RPC_PVPCANCLE,
};

GNET::Protocol::Manager::Session::State state_GCenterServer(_state_GCenterServer,
						sizeof(_state_GCenterServer)/sizeof(GNET::Protocol::Type), 86400);

static GNET::Protocol::Type _state_PVPGameServer[] = 
{
	PROTOCOL_PVPSERVERREGISTER,
	PROTOCOL_PVPSERVERUPDATESTATUS,
	PROTOCOL_PVPEND,
	PROTOCOL_PVPOPERATION,
	RPC_PVPCREATE,
};

GNET::Protocol::Manager::Session::State state_PVPGameServer(_state_PVPGameServer,
						sizeof(_state_PVPGameServer)/sizeof(GNET::Protocol::Type), 86400);


};

