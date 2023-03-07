#ifndef __GNET_VERIFICATION_STATE
#define __GNET_VERIFICATION_STATE

#ifdef WIN32
#include "gnproto.h"
#else
#include "protocol.h"
#endif

namespace GNET
{

extern GNET::Protocol::Manager::Session::State state_VerificationClient;

extern GNET::Protocol::Manager::Session::State state_Null;

};

#endif
