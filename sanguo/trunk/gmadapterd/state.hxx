#ifndef __GNET_GMADAPTERD_STATE
#define __GNET_GMADAPTERD_STATE

#ifdef WIN32
#include "gnproto.h"
#else
#include "protocol.h"
#endif

namespace GNET
{

extern GNET::Protocol::Manager::Session::State state_GMAdapterClient;

extern GNET::Protocol::Manager::Session::State state_Null;

};

#endif
