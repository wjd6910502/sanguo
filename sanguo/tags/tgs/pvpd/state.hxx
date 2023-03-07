#ifndef __GNET_PVPD_STATE
#define __GNET_PVPD_STATE

#ifdef WIN32
#include "gnproto.h"
#else
#include "protocol.h"
#endif

namespace GNET
{

extern GNET::Protocol::Manager::Session::State state_PVPUDPTransServer;

extern GNET::Protocol::Manager::Session::State state_PVPGameClient;

extern GNET::Protocol::Manager::Session::State state_PVPCenterClient;

extern GNET::Protocol::Manager::Session::State state_Null;

};

#endif
