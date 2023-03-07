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

static GNET::Protocol::Type _state_CustomerServiceClient[] = 
{
	PROTOCOL_CUSTOMERREQUEST,
	PROTOCOL_CUSTOMERREQUEST_RE,
};

GNET::Protocol::Manager::Session::State state_CustomerServiceClient(_state_CustomerServiceClient,
						sizeof(_state_CustomerServiceClient)/sizeof(GNET::Protocol::Type), 86400);


};

