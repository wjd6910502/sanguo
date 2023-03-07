#ifdef WIN32
#include <winsock2.h>
#include "gncompress.h"
#else
//#include "binder.h"
#endif
#include "stungetserverinfo.hrp"
#include "udpstunresponse.hpp"
#include "udpstunrequest.hpp"
#include "forwardudpstunrequest.hpp"

namespace GNET
{

static STUNGetServerInfo __stub_STUNGetServerInfo (RPC_STUNGETSERVERINFO, new STUNGetServerInfoArg, new STUNGetServerInfoRes);
static UDPSTUNResponse __stub_UDPSTUNResponse((void*)0);
static UDPSTUNRequest __stub_UDPSTUNRequest((void*)0);
static ForwardUDPSTUNRequest __stub_ForwardUDPSTUNRequest((void*)0);
void make_compile_unit_stubs_o_md5sum_no_change_no_use_but_do_not_delete_it___for_stund() {} //非常山寨的解决重新编译md5sum保持不变的问题
};

