#ifndef __GNET_CLIENT_STATE
#define __GNET_CLIENT_STATE

#ifdef WIN32
#include "gnproto.h"
#else
#include "protocol.h"
#endif

namespace GNET
{

extern GNET::Protocol::Manager::Session::State state_GateClient;

extern GNET::Protocol::Manager::Session::State state_StatusClient;

extern GNET::Protocol::Manager::Session::State state_TransClient;

extern GNET::Protocol::Manager::Session::State state_UDPTransClient;

extern GNET::Protocol::Manager::Session::State state_Null;

};

#endif
