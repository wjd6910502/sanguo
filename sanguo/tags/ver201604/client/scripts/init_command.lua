--DONT CHANGE ME!

dofile "scripts/base64.lua"
dofile "scripts/serialize.lua"
dofile "scripts/serialize_struct.lua"
dofile "scripts/deserialize_struct.lua"
dofile "scripts/common.lua"
dofile "scripts/util.lua"

dofile "scripts/cmds/GetVersion_Re.lua"
dofile "scripts/cmds/GetRoleInfo_Re.lua"
dofile "scripts/cmds/CreateRole_Re.lua"
dofile "scripts/cmds/EnterInstance_Re.lua"
dofile "scripts/cmds/CompleteInstance_Re.lua"
dofile "scripts/cmds/SyncRoleInfo.lua"
dofile "scripts/cmds/SweepInstance_Re.lua"
dofile "scripts/cmds/GetBackPack_Re.lua"
dofile "scripts/cmds/GetInstance_Re.lua"
dofile "scripts/cmds/Role_Mon_Exp.lua"
dofile "scripts/cmds/BuyVp_Re.lua"
dofile "scripts/cmds/BuyInstanceCount_Re.lua"
dofile "scripts/cmds/RoleCommonLimit.lua"
dofile "scripts/cmds/ChongZhi_Re.lua"
dofile "scripts/cmds/TaskFinish_Re.lua"
dofile "scripts/cmds/Task_Condition.lua"
dofile "scripts/cmds/BuyHero_Re.lua"
dofile "scripts/cmds/HeroList_Re.lua"
dofile "scripts/cmds/AddHero.lua"
dofile "scripts/cmds/UpdateHeroInfo.lua"
dofile "scripts/cmds/UseItem_Re.lua"
dofile "scripts/cmds/One_Level_Up_Re.lua"
dofile "scripts/cmds/Hero_Up_Grade_Re.lua"
dofile "scripts/cmds/ErrorInfo.lua"
dofile "scripts/cmds/BuyHorse_Re.lua"
dofile "scripts/cmds/AddHorse.lua"
dofile "scripts/cmds/GetLastHero_Re.lua"
dofile "scripts/cmds/PvpJoin_Re.lua"
dofile "scripts/cmds/PvpMatchSuccess.lua"
dofile "scripts/cmds/PvpEnter_Re.lua"
dofile "scripts/cmds/PvpCancle_Re.lua"
dofile "scripts/cmds/PvpSpeed.lua"
dofile "scripts/cmds/SendNotice.lua"
dofile "scripts/cmds/CurrentTask.lua"
dofile "scripts/cmds/FinishedTask.lua"
dofile "scripts/cmds/ItemCountChange.lua"
dofile "scripts/cmds/HeroUpgradeSkill_Re.lua"
dofile "scripts/cmds/GetHeroComments_Re.lua"
dofile "scripts/cmds/AgreeHeroComments_Re.lua"
dofile "scripts/cmds/WriteHeroComments_Re.lua"
dofile "scripts/cmds/ReWriteHeroComments_Re.lua"
dofile "scripts/cmds/UpdateHeroSkillPoint.lua"
dofile "scripts/cmds/GetVPRefreshTime_Re.lua"
dofile "scripts/cmds/GetSkillPointRefreshTime_Re.lua"
dofile "scripts/cmds/BuySkillPoint_Re.lua"
dofile "scripts/cmds/UpdatePvpVideo.lua"
dofile "scripts/cmds/GetVideo_Re.lua"
dofile "scripts/cmds/PrivateChatHistory.lua"
dofile "scripts/cmds/AddBlackList_Re.lua"
dofile "scripts/cmds/DelBlackList_Re.lua"
dofile "scripts/cmds/SeeAnotherRole_Re.lua"
dofile "scripts/cmds/ReadMail_Re.lua"
dofile "scripts/cmds/GetAttachment_Re.lua"
dofile "scripts/cmds/UpdateMail.lua"
dofile "scripts/cmds/UpdatePvpEndTime.lua"
dofile "scripts/cmds/UpdateHeroPvpInfo.lua"
dofile "scripts/cmds/DeleteTask.lua"
dofile "scripts/cmds/BroadcastPvpVideo_Re.lua"
dofile "scripts/cmds/ChangeHeroSelectSkill_Re.lua"
dofile "scripts/cmds/UpdatePvpInfo.lua"
dofile "scripts/cmds/UpdateRep.lua"
dofile "scripts/cmds/MallBuyItem_Re.lua"
dofile "scripts/cmds/UpdatePvpStar.lua"
dofile "scripts/cmds/UpdateHeroSoul.lua"
dofile "scripts/cmds/LevelUpHeroStar_Re.lua"
dofile "scripts/cmds/ClearHeroPvpInfo.lua"
dofile "scripts/cmds/UpdateMysteryShopInfo.lua"
dofile "scripts/cmds/MysteryShopBuyItem_Re.lua"
dofile "scripts/cmds/RefreshMysteryShop_Re.lua"
dofile "scripts/cmds/ResetBattleField_Re.lua"
dofile "scripts/cmds/BattleFieldBegin_Re.lua"
dofile "scripts/cmds/BattleFieldMove_Re.lua"
dofile "scripts/cmds/BattleFieldJoinBattle_Re.lua"
dofile "scripts/cmds/BattleFieldFinishBattle_Re.lua"
dofile "scripts/cmds/BattleFieldEnd.lua"
dofile "scripts/cmds/BattleFieldGetPrize_Re.lua"
dofile "scripts/cmds/SetInstanceHeroInfo_Re.lua"
dofile "scripts/cmds/Lottery_Re.lua"
dofile "scripts/cmds/GetBattleFieldInfo_Re.lua"
dofile "scripts/cmds/ChangeBattleState.lua"
dofile "scripts/cmds/BattleFieldCancel_Re.lua"
dofile "scripts/cmds/BattleFieldGetEvent_Re.lua"
dofile "scripts/cmds/BattleFieldCapturedPosition.lua"
dofile "scripts/cmds/GetCurBattleField_Re.lua"
dofile "scripts/cmds/BattleFieldFinishEvent_Re.lua"
dofile "scripts/cmds/GiveUpCurBattleField_Re.lua"
dofile "scripts/cmds/GetRefreshTime_Re.lua"
dofile "scripts/cmds/DailySign_Re.lua"
dofile "scripts/cmds/PrivateChat.lua"
dofile "scripts/cmds/PublicChat.lua"
dofile "scripts/cmds/ListFriends_Re.lua"
dofile "scripts/cmds/FriendRequest.lua"
dofile "scripts/cmds/NewFriend.lua"
dofile "scripts/cmds/MafiaGet_Re.lua"
dofile "scripts/cmds/MafiaCreate_Re.lua"
dofile "scripts/cmds/MafiaInvite.lua"
dofile "scripts/cmds/MafiaAddMember.lua"
dofile "scripts/cmds/MafiaUpdate.lua"
dofile "scripts/cmds/MafiaKickout_Re.lua"
dofile "scripts/cmds/MafiaLoseMember.lua"
dofile "scripts/cmds/MafiaQuit_Re.lua"
dofile "scripts/cmds/MafiaDestory_Re.lua"
dofile "scripts/cmds/MafiaAnnounce_Re.lua"
dofile "scripts/cmds/Ping_Re.lua"
dofile "scripts/cmds/UDPPing_Re.lua"
dofile "scripts/cmds/PVPInvite.lua"
dofile "scripts/cmds/PVPPrepare.lua"
dofile "scripts/cmds/PVPBegin.lua"
dofile "scripts/cmds/PVPOperation.lua"
dofile "scripts/cmds/PVPOperationSet.lua"
dofile "scripts/cmds/PVPEnd.lua"
dofile "scripts/cmds/PVPError.lua"
dofile "scripts/cmds/PVPPeerLatency.lua"
dofile "scripts/cmds/TopListGet_Re.lua"

dofile "scripts/serialize_command.lua"
dofile "scripts/deserialize_command.lua"

function InitCommandInMainThread()
	API_ResetCmdExtraRolesMax()
	API_ResetCmdExtraMafiasMax()
	API_ResetCmdExtraPVPsMax()
	API_ResetCmdLockToplist()
	API_ReSetCmdLockMisc()

	API_SetCmdExtraRolesMax(10306,1)
	API_SetCmdExtraRolesMax(10310,1)
	API_SetCmdExtraRolesMax(172,1)
	API_SetCmdExtraRolesMax(10301,1)
	API_SetCmdExtraRolesMax(176,1)
	API_SetCmdExtraRolesMax(10003,1)
	API_SetCmdExtraRolesMax(10009,1)
	API_SetCmdExtraRolesMax(10008,1)
	API_SetCmdExtraRolesMax(10105,1)
	API_SetCmdExtraRolesMax(10106,1)
	API_SetCmdExtraRolesMax(10109,1)
	API_SetCmdExtraRolesMax(10302,1)
	API_SetCmdExtraMafiasMax(10112,1)
	API_SetCmdExtraMafiasMax(10114,1)
	API_SetCmdExtraMafiasMax(10116,1)
	API_SetCmdExtraMafiasMax(10101,1)
	API_SetCmdExtraMafiasMax(10105,1)
	API_SetCmdExtraMafiasMax(10106,1)
	API_SetCmdExtraMafiasMax(10109,1)
	API_SetCmdExtraPVPsMax(10304,1)
	API_SetCmdExtraPVPsMax(10306,1)
	API_SetCmdExtraPVPsMax(10308,1)
	API_SetCmdExtraPVPsMax(10310,1)
	API_SetCmdLockToplist(20000)
	API_SetCmdLockToplist(99999)
	API_SetCmdLockMisc(152)
	API_SetCmdLockMisc(10401)
	API_SetCmdLockMisc(154)
	API_SetCmdLockMisc(156)
	API_SetCmdLockMisc(158)

end

