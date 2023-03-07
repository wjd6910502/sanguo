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

static GNET::Protocol::Type _state_VerificationClient[] = 
{
	PROTOCOL_VERFICATIONOPERATION,
	PROTOCOL_VERFICATIONOPERATION_RE,
	PROTOCOL_REGISTER,
};

GNET::Protocol::Manager::Session::State state_VerificationClient(_state_VerificationClient,
						sizeof(_state_VerificationClient)/sizeof(GNET::Protocol::Type), 86400);

static GNET::Protocol::Type _state_Null[] = 
{
};

GNET::Protocol::Manager::Session::State state_Null(_state_Null,
						sizeof(_state_Null)/sizeof(GNET::Protocol::Type), 5);


};

