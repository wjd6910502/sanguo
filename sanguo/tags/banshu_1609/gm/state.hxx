#ifndef __GNET_GM_STATE
#define __GNET_GM_STATE

#ifdef WIN32
#include "gnproto.h"
#else
#include "protocol.h"
#endif

namespace GNET
{

extern GNET::Protocol::Manager::Session::State state_GMClient;

};

#endif
