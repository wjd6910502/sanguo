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

static GNET::Protocol::Type _state_GACCodeServer[] = 
{
	PROTOCOL_ACZONEREGISTER,
	RPC_GUSEACTIVECODE,
};

GNET::Protocol::Manager::Session::State state_GACCodeServer(_state_GACCodeServer,
						sizeof(_state_GACCodeServer)/sizeof(GNET::Protocol::Type), 86400);


};

