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

static GNET::Protocol::Type _state_GameDBServer[] = 
{
	RPC_DBLOADDATA,
	RPC_DBSAVEDATA,
	PROTOCOL_CENTERCOMMAND,
	PROTOCOL_CENTERCOMMANDRE,
};

GNET::Protocol::Manager::Session::State state_GameDBServer(_state_GameDBServer,
						sizeof(_state_GameDBServer)/sizeof(GNET::Protocol::Type), 600);


};

