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

static GNET::Protocol::Type _state_GMClient[] = 
{
	PROTOCOL_CENTERCOMMAND,
	PROTOCOL_CENTERCOMMANDRE,
};

GNET::Protocol::Manager::Session::State state_GMClient(_state_GMClient,
						sizeof(_state_GMClient)/sizeof(GNET::Protocol::Type), 86400);


};

