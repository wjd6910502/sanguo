#ifndef __GNET_GACTIVECODE_STATE
#define __GNET_GACTIVECODE_STATE

#ifdef WIN32
#include "gnproto.h"
#else
#include "protocol.h"
#endif

namespace GNET
{

extern GNET::Protocol::Manager::Session::State state_GACCodeServer;

};

#endif
