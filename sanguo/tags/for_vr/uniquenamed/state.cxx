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

static GNET::Protocol::Type _state_UniqueNameServer[] = 
{
	RPC_CREATEROLENAME,
};

GNET::Protocol::Manager::Session::State state_UniqueNameServer(_state_UniqueNameServer,
						sizeof(_state_UniqueNameServer)/sizeof(GNET::Protocol::Type), 86400);


};

