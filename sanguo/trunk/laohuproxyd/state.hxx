#ifndef __GNET_LAOHUPROXYD_STATE
#define __GNET_LAOHUPROXYD_STATE

#ifdef WIN32
#include "gnproto.h"
#else
#include "protocol.h"
#endif

namespace GNET
{

extern GNET::Protocol::Manager::Session::State state_LaohuProxyServer;

extern GNET::Protocol::Manager::Session::State state_Null;

};

#endif
