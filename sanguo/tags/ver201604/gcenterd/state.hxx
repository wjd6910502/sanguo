#ifndef __GNET_GCENTERD_STATE
#define __GNET_GCENTERD_STATE

#ifdef WIN32
#include "gnproto.h"
#else
#include "protocol.h"
#endif

namespace GNET
{

extern GNET::Protocol::Manager::Session::State state_GMServer;

extern GNET::Protocol::Manager::Session::State state_GCenterServer;

extern GNET::Protocol::Manager::Session::State state_PVPGameServer;

};

#endif
