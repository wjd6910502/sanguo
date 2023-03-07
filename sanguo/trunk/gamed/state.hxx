#ifndef __GNET_GAMED_STATE
#define __GNET_GAMED_STATE

#ifdef WIN32
#include "gnproto.h"
#else
#include "protocol.h"
#endif

namespace GNET
{

extern GNET::Protocol::Manager::Session::State state_GateServer;

extern GNET::Protocol::Manager::Session::State state_TransServer;

extern GNET::Protocol::Manager::Session::State state_UDPTransServer;

extern GNET::Protocol::Manager::Session::State state_GameDBClient;

extern GNET::Protocol::Manager::Session::State state_GCenterClient;

extern GNET::Protocol::Manager::Session::State state_PVPGameServer;

extern GNET::Protocol::Manager::Session::State state_STUNGameClient;

extern GNET::Protocol::Manager::Session::State state_STUNDeafServer;

extern GNET::Protocol::Manager::Session::State state_UniqueNameClient;

extern GNET::Protocol::Manager::Session::State state_STTClient;

extern GNET::Protocol::Manager::Session::State state_RegisterClient;

extern GNET::Protocol::Manager::Session::State state_CustomerServiveServer;

extern GNET::Protocol::Manager::Session::State state_VerificationGameServer;

extern GNET::Protocol::Manager::Session::State state_GMAdapterServer;

extern GNET::Protocol::Manager::Session::State state_GACCodeClient;

extern GNET::Protocol::Manager::Session::State state_LaohuProxyClient;

extern GNET::Protocol::Manager::Session::State state_LaohuInformServer;

extern GNET::Protocol::Manager::Session::State state_Null;

};

#endif
