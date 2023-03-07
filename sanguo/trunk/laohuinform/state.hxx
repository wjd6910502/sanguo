#ifndef __GNET_LAOHUINFORM_STATE
#define __GNET_LAOHUINFORM_STATE

#ifdef WIN32
#include "gnproto.h"
#else
#include "protocol.h"
#endif

namespace GNET
{

extern GNET::Protocol::Manager::Session::State state_LaohuInformClient;

extern GNET::Protocol::Manager::Session::State state_Null;

};

#endif
