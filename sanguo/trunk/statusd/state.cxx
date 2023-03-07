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

static GNET::Protocol::Type _state_StatusServer[] = 
{
};

GNET::Protocol::Manager::Session::State state_StatusServer(_state_StatusServer,
						sizeof(_state_StatusServer)/sizeof(GNET::Protocol::Type), 10);

static GNET::Protocol::Type _state_Null[] = 
{
};

GNET::Protocol::Manager::Session::State state_Null(_state_Null,
						sizeof(_state_Null)/sizeof(GNET::Protocol::Type), 5);


};

