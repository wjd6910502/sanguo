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

static GNET::Protocol::Type _state_RegisterServer[] = 
{
	PROTOCOL_ROLEINFOREGISTER,
};

GNET::Protocol::Manager::Session::State state_RegisterServer(_state_RegisterServer,
						sizeof(_state_RegisterServer)/sizeof(GNET::Protocol::Type), 86400);


};

