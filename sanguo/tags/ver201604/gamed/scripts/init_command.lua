--DONT CHANGE ME!

dofile "scripts/base64.lua"
dofile "scripts/serialize.lua"
dofile "scripts/serialize_struct.lua"
dofile "scripts/deserialize_struct.lua"
dofile "scripts/common.lua"
dofile "scripts/util.lua"

dofile "scripts/cmds/GetVersion.lua"
dofile "scripts/cmds/GetRoleInfo.lua"
dofile "scripts/cmds/CreateRole.lua"
dofile "scripts/cmds/EnterInstance.lua"
dofile "scripts/cmds/CompleteInstance.lua"
dofile "scripts/cmds/OPStat.lua"
dofile "scripts/cmds/SweepInstance.lua"
dofile "scripts/cmds/GetBackPack.lua"
dofile "scripts/cmds/GetInstance.lua"
dofile "scripts/cmds/BuyVp.lua"
dofile "scripts/cmds/BuyInstanceCount.lua"
dofile "scripts/cmds/TaskFinish.lua"
dofile "scripts/cmds/Client_User_Define.lua"
dofile "scripts/cmds/BuyHero.lua"
dofile "scripts/cmds/UseItem.lua"
dofile "scripts/cmds/One_Level_Up.lua"
dofile "scripts/cmds/Hero_Up_Grade.lua"
dofile "scripts/cmds/BuyHorse.lua"
dofile "scripts/cmds/GetLastHero.lua"
dofile "scripts/cmds/PvpJoin.lua"
dofile "scripts/cmds/PvpEnter.lua"
dofile "scripts/cmds/PvpCancle.lua"
dofile "scripts/cmds/PvpSpeed.lua"
dofile "scripts/cmds/ResetRoleInfo.lua"
dofile "scripts/cmds/GetTask.lua"
dofile "scripts/cmds/HeroUpgradeSkill.lua"
dofile "scripts/cmds/GetHeroComments.lua"
dofile "scripts/cmds/AgreeHeroComments.lua"
dofile "scripts/cmds/WriteHeroComments.lua"
dofile "scripts/cmds/ReWriteHeroComments.lua"
dofile "scripts/cmds/GetVPRefreshTime.lua"
dofile "scripts/cmds/GetSkillPointRefreshTime.lua"
dofile "scripts/cmds/RoleLogin.lua"
dofile "scripts/cmds/BuySkillPoint.lua"
dofile "scripts/cmds/GetVideo.lua"
dofile "scripts/cmds/AddBlackList.lua"
dofile "scripts/cmds/DelBlackList.lua"
dofile "scripts/cmds/SeeAnotherRole.lua"
dofile "scripts/cmds/GetPrivateChatHistory.lua"
dofile "scripts/cmds/ReadMail.lua"
dofile "scripts/cmds/GetAttachment.lua"
dofile "scripts/cmds/BroadcastPvpVideo.lua"
dofile "scripts/cmds/ChangeHeroSelectSkill.lua"
dofile "scripts/cmds/MallBuyItem.lua"
dofile "scripts/cmds/LevelUpHeroStar.lua"
dofile "scripts/cmds/MysteryShopBuyItem.lua"
dofile "scripts/cmds/RefreshMysteryShop.lua"
dofile "scripts/cmds/ResetBattleField.lua"
dofile "scripts/cmds/BattleFieldBegin.lua"
dofile "scripts/cmds/BattleFieldMove.lua"
dofile "scripts/cmds/BattleFieldJoinBattle.lua"
dofile "scripts/cmds/BattleFieldFinishBattle.lua"
dofile "scripts/cmds/BattleFieldGetPrize.lua"
dofile "scripts/cmds/SetInstanceHeroInfo.lua"
dofile "scripts/cmds/Lottery.lua"
dofile "scripts/cmds/GetBattleFieldInfo.lua"
dofile "scripts/cmds/BattleFieldCancel.lua"
dofile "scripts/cmds/BattleFieldGetEvent.lua"
dofile "scripts/cmds/GetCurBattleField.lua"
dofile "scripts/cmds/BattleFieldFinishEvent.lua"
dofile "scripts/cmds/GiveUpCurBattleField.lua"
dofile "scripts/cmds/GetRefreshTime.lua"
dofile "scripts/cmds/DailySign.lua"
dofile "scripts/cmds/PrivateChat.lua"
dofile "scripts/cmds/PublicChat.lua"
dofile "scripts/cmds/ListFriends.lua"
dofile "scripts/cmds/FriendRequest.lua"
dofile "scripts/cmds/FriendReply.lua"
dofile "scripts/cmds/MafiaGet.lua"
dofile "scripts/cmds/MafiaCreate.lua"
dofile "scripts/cmds/MafiaInvite.lua"
dofile "scripts/cmds/MafiaReply.lua"
dofile "scripts/cmds/MafiaKickout.lua"
dofile "scripts/cmds/MafiaQuit.lua"
dofile "scripts/cmds/MafiaDestory.lua"
dofile "scripts/cmds/MafiaAnnounce.lua"
dofile "scripts/cmds/Ping.lua"
dofile "scripts/cmds/UDPPing.lua"
dofile "scripts/cmds/PVPInvite.lua"
dofile "scripts/cmds/PVPReply.lua"
dofile "scripts/cmds/PVPReady.lua"
dofile "scripts/cmds/PVPOperation.lua"
dofile "scripts/cmds/PVPEnd.lua"
dofile "scripts/cmds/PVPPeerLatency.lua"
dofile "scripts/cmds/ReportClientVersion.lua"
dofile "scripts/cmds/TopListGet.lua"
dofile "scripts/cmds/DebugCommand.lua"

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

