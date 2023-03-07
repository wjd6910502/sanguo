#ifdef WIN32
#include <winsock2.h>
#include "gncompress.h"
#else
//#include "binder.h"
#endif
#include "pvpcreate.hrp"
#include "udps2cgameprotocols.hpp"
#include "pvpserverregister.hpp"
#include "pvpserverupdatestatus.hpp"
#include "pvpend.hpp"
#include "pvpoperation.hpp"
#include "audienceoperation.hpp"
#include "udpkeepalive.hpp"
#include "udpgameprotocol.hpp"
#include "udpc2sgameprotocols.hpp"
#include "pvpdelete.hpp"

namespace GNET
{

static PVPCreate __stub_PVPCreate (RPC_PVPCREATE, new PVPCreateArg, new PVPCreateRes);
static UDPS2CGameProtocols __stub_UDPS2CGameProtocols((void*)0);
static PVPServerRegister __stub_PVPServerRegister((void*)0);
static PVPServerUpdateStatus __stub_PVPServerUpdateStatus((void*)0);
static PVPEnd __stub_PVPEnd((void*)0);
static PvpOperation __stub_PvpOperation((void*)0);
static AudienceOperation __stub_AudienceOperation((void*)0);
static UDPKeepAlive __stub_UDPKeepAlive((void*)0);
static UDPGameProtocol __stub_UDPGameProtocol((void*)0);
static UDPC2SGameProtocols __stub_UDPC2SGameProtocols((void*)0);
static PVPDelete __stub_PVPDelete((void*)0);
void make_compile_unit_stubs_o_md5sum_no_change_no_use_but_do_not_delete_it___for_pvpd() {} //非常山寨的解决重新编译md5sum保持不变的问题
};

