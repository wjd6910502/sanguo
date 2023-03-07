#ifdef WIN32
#include <winsock2.h>
#include "gncompress.h"
#else
//#include "binder.h"
#endif
#include "dbloaddata.hrp"
#include "dbloadroledata.hrp"
#include "dbsavedata.hrp"
#include "stungetserverinfo.hrp"
#include "pvpcancle.hrp"
#include "createrolename.hrp"
#include "gettextinspeech.hrp"
#include "pvpjoin.hrp"
#include "pvpcreate.hrp"
#include "challenge.hpp"
#include "authresult.hpp"
#include "transchallenge.hpp"
#include "transauthresult.hpp"
#include "kickout.hpp"
#include "udps2cgameprotocols.hpp"
#include "syncnetime.hpp"
#include "udpsyncnettime.hpp"
#include "centercommand.hpp"
#include "centercommandre.hpp"
#include "kuafuzoneregister.hpp"
#include "pvpmatchsuccess.hpp"
#include "pvpenter.hpp"
#include "pvpenterre.hpp"
#include "sendpvpvideoid.hpp"
#include "pvpcentercreate.hpp"
#include "pvpleave.hpp"
#include "pvpleavere.hpp"
#include "pvpready.hpp"
#include "pvpspeed.hpp"
#include "pvpspeedre.hpp"
#include "pvpreset.hpp"
#include "pvpresetre.hpp"
#include "getpvpvideo.hpp"
#include "getpvpvideore.hpp"
#include "delpvpvideo.hpp"
#include "pvpdelete.hpp"
#include "udpstunresponse.hpp"
#include "forwardudpstunrequest.hpp"
#include "getiatextinspeechre.hpp"
#include "sttzoneregister.hpp"
#include "response.hpp"
#include "transresponse.hpp"
#include "continue.hpp"
#include "gameprotocol.hpp"
#include "keepalive.hpp"
#include "syncnetimere.hpp"
#include "reportudpinfo.hpp"
#include "serverlog.hpp"
#include "udpgameprotocol.hpp"
#include "udpkeepalive.hpp"
#include "udpc2sgameprotocols.hpp"
#include "udpsyncnettimere.hpp"
#include "udpstunrequest.hpp"
#include "pvpserverregister.hpp"
#include "pvpserverupdatestatus.hpp"
#include "pvpend.hpp"
#include "pvpoperation.hpp"

namespace GNET
{

static DBLoadData __stub_DBLoadData (RPC_DBLOADDATA, new DBLoadDataArg, new DBLoadDataRes);
static DBLoadRoleData __stub_DBLoadRoleData (RPC_DBLOADROLEDATA, new DBLoadRoleDataArg, new DBLoadRoleDataRes);
static DBSaveData __stub_DBSaveData (RPC_DBSAVEDATA, new DBSaveDataArg, new DBSaveDataRes);
static STUNGetServerInfo __stub_STUNGetServerInfo (RPC_STUNGETSERVERINFO, new STUNGetServerInfoArg, new STUNGetServerInfoRes);
static PvpCancle __stub_PvpCancle (RPC_PVPCANCLE, new PvpCancleArg, new PvpCancleRes);
static CreateRoleName __stub_CreateRoleName (RPC_CREATEROLENAME, new CreateRoleNameArg, new CreateRoleNameRes);
static GetTextInSpeech __stub_GetTextInSpeech (RPC_GETTEXTINSPEECH, new GetTextInSpeechArg, new GetTextInSpeechRes);
static PvpJoin __stub_PvpJoin (RPC_PVPJOIN, new PvpJoinArg, new PvpJoinRes);
static PVPCreate __stub_PVPCreate (RPC_PVPCREATE, new PVPCreateArg, new PVPCreateRes);
static Challenge __stub_Challenge((void*)0);
static AuthResult __stub_AuthResult((void*)0);
static TransChallenge __stub_TransChallenge((void*)0);
static TransAuthResult __stub_TransAuthResult((void*)0);
static Kickout __stub_Kickout((void*)0);
static UDPS2CGameProtocols __stub_UDPS2CGameProtocols((void*)0);
static SyncNetime __stub_SyncNetime((void*)0);
static UDPSyncNetTime __stub_UDPSyncNetTime((void*)0);
static CenterCommand __stub_CenterCommand((void*)0);
static CenterCommandRe __stub_CenterCommandRe((void*)0);
static KuafuZoneRegister __stub_KuafuZoneRegister((void*)0);
static PvpMatchSuccess __stub_PvpMatchSuccess((void*)0);
static PvpEnter __stub_PvpEnter((void*)0);
static PvpEnterRe __stub_PvpEnterRe((void*)0);
static SendPvpVideoID __stub_SendPvpVideoID((void*)0);
static PvpCenterCreate __stub_PvpCenterCreate((void*)0);
static PvpLeave __stub_PvpLeave((void*)0);
static PvpLeaveRe __stub_PvpLeaveRe((void*)0);
static PvpReady __stub_PvpReady((void*)0);
static PvpSpeed __stub_PvpSpeed((void*)0);
static PvpSpeedRe __stub_PvpSpeedRe((void*)0);
static PvpReset __stub_PvpReset((void*)0);
static PvpResetRe __stub_PvpResetRe((void*)0);
static GetPvpVideo __stub_GetPvpVideo((void*)0);
static GetPvpVideoRe __stub_GetPvpVideoRe((void*)0);
static DelPvpVideo __stub_DelPvpVideo((void*)0);
static PVPDelete __stub_PVPDelete((void*)0);
static UDPSTUNResponse __stub_UDPSTUNResponse((void*)0);
static ForwardUDPSTUNRequest __stub_ForwardUDPSTUNRequest((void*)0);
static GetIATextInSpeechRe __stub_GetIATextInSpeechRe((void*)0);
static STTZoneRegister __stub_STTZoneRegister((void*)0);
static Response __stub_Response((void*)0);
static TransResponse __stub_TransResponse((void*)0);
static Continue __stub_Continue((void*)0);
static GameProtocol __stub_GameProtocol((void*)0);
static KeepAlive __stub_KeepAlive((void*)0);
static SyncNetimeRe __stub_SyncNetimeRe((void*)0);
static ReportUDPInfo __stub_ReportUDPInfo((void*)0);
static ServerLog __stub_ServerLog((void*)0);
static UDPGameProtocol __stub_UDPGameProtocol((void*)0);
static UDPKeepAlive __stub_UDPKeepAlive((void*)0);
static UDPC2SGameProtocols __stub_UDPC2SGameProtocols((void*)0);
static UDPSyncNetTimeRe __stub_UDPSyncNetTimeRe((void*)0);
static UDPSTUNRequest __stub_UDPSTUNRequest((void*)0);
static PVPServerRegister __stub_PVPServerRegister((void*)0);
static PVPServerUpdateStatus __stub_PVPServerUpdateStatus((void*)0);
static PVPEnd __stub_PVPEnd((void*)0);
static PvpOperation __stub_PvpOperation((void*)0);
void make_compile_unit_stubs_o_md5sum_no_change_no_use_but_do_not_delete_it___for_gamed() {} //非常山寨的解决重新编译md5sum保持不变的问题
};

