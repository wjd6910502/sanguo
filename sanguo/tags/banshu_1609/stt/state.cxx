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

static GNET::Protocol::Type _state_STTServer[] = 
{
	PROTOCOL_GETIATEXTINSPEECHRE,
	RPC_GETTEXTINSPEECH,
	PROTOCOL_STTZONEREGISTER,
};

GNET::Protocol::Manager::Session::State state_STTServer(_state_STTServer,
						sizeof(_state_STTServer)/sizeof(GNET::Protocol::Type), 86400);


};

