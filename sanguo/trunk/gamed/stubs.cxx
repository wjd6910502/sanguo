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
#include "changerolename.hrp"
#include "createmafianame.hrp"
#include "changemafianame.hrp"
#include "gettextinspeech.hrp"
#include "pvpjoin.hrp"
#include "pvpcreate.hrp"
#include "guseactivecode.hrp"
#include "verficationoperation.hpp"
#include "verficationoperation_re.hpp"
#include "register.hpp"
#include "challenge.hpp"
#include "authresult.hpp"
#include "transchallenge.hpp"
#include "transauthresult.hpp"
#include "kickout.hpp"
#include "syncnetime.hpp"
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
#include "audiencegetlist.hpp"
#include "audiencegetlistre.hpp"
#include "audiencegetoperation.hpp"
#include "audiencegetoperationre.hpp"
#include "audienceupdatenum.hpp"
#include "audiencesendoperation.hpp"
#include "audienceleaveroom.hpp"
#include "yuezhanbegin.hpp"
#include "pvpdanmu.hpp"
#include "audiencefinishroom.hpp"
#include "updatedanmuinfo.hpp"
#include "yuezhanend.hpp"
#include "delpvpvideo.hpp"
#include "pvpdelete.hpp"
#include "udpstunresponse.hpp"
#include "forwardudpstunrequest.hpp"
#include "getiatextinspeechre.hpp"
#include "sttzoneregister.hpp"
#include "pvppause_re.hpp"
#include "gmcmd_getacccharlist_re.hpp"
#include "gmcmd_getchar_re.hpp"
#include "gmcmd_addforbidlogin_re.hpp"
#include "gmcmd_delforbidlogin_re.hpp"
#include "gmcmd_addforbidtalk_re.hpp"
#include "gmcmd_delforbidtalk_re.hpp"
#include "gmcmd_getaccid_re.hpp"
#include "gmcmd_bull_re.hpp"
#include "gmcmd_mailitemtoplayer_re.hpp"
#include "gmcmd_mailtoallplayer_re.hpp"
#include "gmcmd_getroleforbidchat_re.hpp"
#include "gmcmd_getroleforbidlogin_re.hpp"
#include "gmcmd_addforbidword_re.hpp"
#include "gmcmd_delforbidword_re.hpp"
#include "gmcmd_addserverreward_re.hpp"
#include "gmcmd_listserverreward_re.hpp"
#include "gmcmd_removeserverreward_re.hpp"
#include "gmcmd_mailtoplayer_re.hpp"
#include "laohu_checktoken.hpp"
#include "laohu_pay_re.hpp"
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
#include "udpstunrequest.hpp"
#include "pvppause.hpp"
#include "pvpcontinue.hpp"
#include "pvpserverregister.hpp"
#include "pvpserverupdatestatus.hpp"
#include "pvpend.hpp"
#include "pvpoperation.hpp"
#include "audienceoperation.hpp"
#include "roleinforegister.hpp"
#include "customerrequest.hpp"
#include "customerrequest_re.hpp"
#include "gmcmd_getacccharlist.hpp"
#include "gmcmd_getchar.hpp"
#include "gmcmd_addforbidlogin.hpp"
#include "gmcmd_delforbidlogin.hpp"
#include "gmcmd_addforbidtalk.hpp"
#include "gmcmd_delforbidtalk.hpp"
#include "gmcmd_getaccid.hpp"
#include "gmcmd_bull.hpp"
#include "gmcmd_mailitemtoplayer.hpp"
#include "gmcmd_mailtoallplayer.hpp"
#include "gmcmd_getroleforbidchat.hpp"
#include "gmcmd_getroleforbidlogin.hpp"
#include "gmcmd_addforbidword.hpp"
#include "gmcmd_delforbidword.hpp"
#include "gmcmd_addserverreward.hpp"
#include "gmcmd_listserverreward.hpp"
#include "gmcmd_removeserverreward.hpp"
#include "gmcmd_mailtoplayer.hpp"
#include "aczoneregister.hpp"
#include "laohu_checktoken_re.hpp"
#include "laohu_pay.hpp"

namespace GNET
{

static DBLoadData __stub_DBLoadData (RPC_DBLOADDATA, new DBLoadDataArg, new DBLoadDataRes);
static DBLoadRoleData __stub_DBLoadRoleData (RPC_DBLOADROLEDATA, new DBLoadRoleDataArg, new DBLoadRoleDataRes);
static DBSaveData __stub_DBSaveData (RPC_DBSAVEDATA, new DBSaveDataArg, new DBSaveDataRes);
static STUNGetServerInfo __stub_STUNGetServerInfo (RPC_STUNGETSERVERINFO, new STUNGetServerInfoArg, new STUNGetServerInfoRes);
static PvpCancle __stub_PvpCancle (RPC_PVPCANCLE, new PvpCancleArg, new PvpCancleRes);
static CreateRoleName __stub_CreateRoleName (RPC_CREATEROLENAME, new CreateRoleNameArg, new CreateRoleNameRes);
static ChangeRoleName __stub_ChangeRoleName (RPC_CHANGEROLENAME, new ChangeRoleNameArg, new ChangeRoleNameRes);
static CreateMafiaName __stub_CreateMafiaName (RPC_CREATEMAFIANAME, new CreateMafiaNameArg, new CreateMafiaNameRes);
static ChangeMafiaName __stub_ChangeMafiaName (RPC_CHANGEMAFIANAME, new ChangeMafiaNameArg, new ChangeMafiaNameRes);
static GetTextInSpeech __stub_GetTextInSpeech (RPC_GETTEXTINSPEECH, new GetTextInSpeechArg, new GetTextInSpeechRes);
static PvpJoin __stub_PvpJoin (RPC_PVPJOIN, new PvpJoinArg, new PvpJoinRes);
static PVPCreate __stub_PVPCreate (RPC_PVPCREATE, new PVPCreateArg, new PVPCreateRes);
static GUseActiveCode __stub_GUseActiveCode (RPC_GUSEACTIVECODE, new GUseActiveCodeArg, new GUseActiveCodeRes);
static VerficationOperation __stub_VerficationOperation((void*)0);
static VerficationOperation_re __stub_VerficationOperation_re((void*)0);
static Register __stub_Register((void*)0);
static Challenge __stub_Challenge((void*)0);
static AuthResult __stub_AuthResult((void*)0);
static TransChallenge __stub_TransChallenge((void*)0);
static TransAuthResult __stub_TransAuthResult((void*)0);
static Kickout __stub_Kickout((void*)0);
static SyncNetime __stub_SyncNetime((void*)0);
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
static AudienceGetList __stub_AudienceGetList((void*)0);
static AudienceGetListRe __stub_AudienceGetListRe((void*)0);
static AudienceGetOperation __stub_AudienceGetOperation((void*)0);
static AudienceGetOperationRe __stub_AudienceGetOperationRe((void*)0);
static AudienceUpdateNum __stub_AudienceUpdateNum((void*)0);
static AudienceSendOperation __stub_AudienceSendOperation((void*)0);
static AudienceLeaveRoom __stub_AudienceLeaveRoom((void*)0);
static YueZhanBegin __stub_YueZhanBegin((void*)0);
static PvpDanMu __stub_PvpDanMu((void*)0);
static AudienceFinishRoom __stub_AudienceFinishRoom((void*)0);
static UpdateDanMuInfo __stub_UpdateDanMuInfo((void*)0);
static YueZhanEnd __stub_YueZhanEnd((void*)0);
static DelPvpVideo __stub_DelPvpVideo((void*)0);
static PVPDelete __stub_PVPDelete((void*)0);
static UDPSTUNResponse __stub_UDPSTUNResponse((void*)0);
static ForwardUDPSTUNRequest __stub_ForwardUDPSTUNRequest((void*)0);
static GetIATextInSpeechRe __stub_GetIATextInSpeechRe((void*)0);
static STTZoneRegister __stub_STTZoneRegister((void*)0);
static PVPPause_Re __stub_PVPPause_Re((void*)0);
static GMCmd_GetAccCharList_Re __stub_GMCmd_GetAccCharList_Re((void*)0);
static GMCmd_GetChar_Re __stub_GMCmd_GetChar_Re((void*)0);
static GMCmd_AddForbidLogin_Re __stub_GMCmd_AddForbidLogin_Re((void*)0);
static GMCmd_DelForbidLogin_Re __stub_GMCmd_DelForbidLogin_Re((void*)0);
static GMCmd_AddForbidTalk_Re __stub_GMCmd_AddForbidTalk_Re((void*)0);
static GMCmd_DelForbidTalk_Re __stub_GMCmd_DelForbidTalk_Re((void*)0);
static GMCmd_GetAccID_Re __stub_GMCmd_GetAccID_Re((void*)0);
static GMCmd_Bull_Re __stub_GMCmd_Bull_Re((void*)0);
static GMCmd_MailItemToPlayer_Re __stub_GMCmd_MailItemToPlayer_Re((void*)0);
static GMCmd_MailToAllPlayer_Re __stub_GMCmd_MailToAllPlayer_Re((void*)0);
static GMCmd_GetRoleForbidChat_Re __stub_GMCmd_GetRoleForbidChat_Re((void*)0);
static GMCmd_GetRoleForbidLogin_Re __stub_GMCmd_GetRoleForbidLogin_Re((void*)0);
static GMCmd_AddForbidWord_Re __stub_GMCmd_AddForbidWord_Re((void*)0);
static GMCmd_DelForbidWord_Re __stub_GMCmd_DelForbidWord_Re((void*)0);
static GMCmd_AddServerReward_Re __stub_GMCmd_AddServerReward_Re((void*)0);
static GMCmd_ListServerReward_Re __stub_GMCmd_ListServerReward_Re((void*)0);
static GMCmd_RemoveServerReward_Re __stub_GMCmd_RemoveServerReward_Re((void*)0);
static GMCmd_MailToPlayer_Re __stub_GMCmd_MailToPlayer_Re((void*)0);
static Laohu_CheckToken __stub_Laohu_CheckToken((void*)0);
static Laohu_Pay_Re __stub_Laohu_Pay_Re((void*)0);
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
static UDPSTUNRequest __stub_UDPSTUNRequest((void*)0);
static PVPPause __stub_PVPPause((void*)0);
static PVPContinue __stub_PVPContinue((void*)0);
static PVPServerRegister __stub_PVPServerRegister((void*)0);
static PVPServerUpdateStatus __stub_PVPServerUpdateStatus((void*)0);
static PVPEnd __stub_PVPEnd((void*)0);
static PvpOperation __stub_PvpOperation((void*)0);
static AudienceOperation __stub_AudienceOperation((void*)0);
static RoleinfoRegister __stub_RoleinfoRegister((void*)0);
static CustomerRequest __stub_CustomerRequest((void*)0);
static CustomerRequest_Re __stub_CustomerRequest_Re((void*)0);
static GMCmd_GetAccCharList __stub_GMCmd_GetAccCharList((void*)0);
static GMCmd_GetChar __stub_GMCmd_GetChar((void*)0);
static GMCmd_AddForbidLogin __stub_GMCmd_AddForbidLogin((void*)0);
static GMCmd_DelForbidLogin __stub_GMCmd_DelForbidLogin((void*)0);
static GMCmd_AddForbidTalk __stub_GMCmd_AddForbidTalk((void*)0);
static GMCmd_DelForbidTalk __stub_GMCmd_DelForbidTalk((void*)0);
static GMCmd_GetAccID __stub_GMCmd_GetAccID((void*)0);
static GMCmd_Bull __stub_GMCmd_Bull((void*)0);
static GMCmd_MailItemToPlayer __stub_GMCmd_MailItemToPlayer((void*)0);
static GMCmd_MailToAllPlayer __stub_GMCmd_MailToAllPlayer((void*)0);
static GMCmd_GetRoleForbidChat __stub_GMCmd_GetRoleForbidChat((void*)0);
static GMCmd_GetRoleForbidLogin __stub_GMCmd_GetRoleForbidLogin((void*)0);
static GMCmd_AddForbidWord __stub_GMCmd_AddForbidWord((void*)0);
static GMCmd_DelForbidWord __stub_GMCmd_DelForbidWord((void*)0);
static GMCmd_AddServerReward __stub_GMCmd_AddServerReward((void*)0);
static GMCmd_ListServerReward __stub_GMCmd_ListServerReward((void*)0);
static GMCmd_RemoveServerReward __stub_GMCmd_RemoveServerReward((void*)0);
static GMCmd_MailToPlayer __stub_GMCmd_MailToPlayer((void*)0);
static ACZoneRegister __stub_ACZoneRegister((void*)0);
static Laohu_CheckToken_Re __stub_Laohu_CheckToken_Re((void*)0);
static Laohu_Pay __stub_Laohu_Pay((void*)0);
void make_compile_unit_stubs_o_md5sum_no_change_no_use_but_do_not_delete_it___for_gamed() {} //非常山寨的解决重新编译md5sum保持不变的问题
};

