--DONT CHANGE ME!

dofile "scripts/base64.lua"
dofile "scripts/serialize.lua"
dofile "scripts/serialize_struct.lua"
dofile "scripts/deserialize_struct.lua"
dofile "scripts/common.lua"
dofile "scripts/util.lua"

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
dofile "scripts/cmds/GetMyPveArenaInfo.lua"
dofile "scripts/cmds/GetOtherPveArenaInfo.lua"
dofile "scripts/cmds/GetFighterInfo.lua"
dofile "scripts/cmds/PveArenaJoinBattle.lua"
dofile "scripts/cmds/PveArenaEndBattle.lua"
dofile "scripts/cmds/PveArenaResetTime.lua"
dofile "scripts/cmds/PveArenaResetCount.lua"
dofile "scripts/cmds/ChallengeRoleByItem.lua"
dofile "scripts/cmds/GetPveArenaHistory.lua"
dofile "scripts/cmds/GetPveArenaOperation.lua"
dofile "scripts/cmds/SetPveArenaHero.lua"
dofile "scripts/cmds/ResetSkilllevel.lua"
dofile "scripts/cmds/WeaponEquip.lua"
dofile "scripts/cmds/WeaponLevelUp.lua"
dofile "scripts/cmds/WeaponStrength.lua"
dofile "scripts/cmds/WeaponDecompose.lua"
dofile "scripts/cmds/WeaponUnequip.lua"
dofile "scripts/cmds/WuZheShiLianGetDifficultyInfo.lua"
dofile "scripts/cmds/WuZheShiLianSelectDifficulty.lua"
dofile "scripts/cmds/WuZheShiLianGetOpponentInfo.lua"
dofile "scripts/cmds/WuZheShiLianGetHeroInfo.lua"
dofile "scripts/cmds/WuZheShiLianJoinBattle.lua"
dofile "scripts/cmds/WuZheShiLianFinishBattle.lua"
dofile "scripts/cmds/WuZheShiLianReset.lua"
dofile "scripts/cmds/WuZheShiLianGetReward.lua"
dofile "scripts/cmds/WuZheShiLianSweep.lua"
dofile "scripts/cmds/EquipmentEquip.lua"
dofile "scripts/cmds/EquipmentLevelUp.lua"
dofile "scripts/cmds/EquipmentGradeUp.lua"
dofile "scripts/cmds/EquipmentRefinable.lua"
dofile "scripts/cmds/EquipmentDecompose.lua"
dofile "scripts/cmds/EquipmentUnequip.lua"
dofile "scripts/cmds/EquipmentRefinableSave.lua"
dofile "scripts/cmds/TongQueTaiSetHeroInfo.lua"
dofile "scripts/cmds/TongQueTaiBeginMatch.lua"
dofile "scripts/cmds/TongQueTaiCancleMatch.lua"
dofile "scripts/cmds/TongQueTaiJoin.lua"
dofile "scripts/cmds/TongQueTaiOperation.lua"
dofile "scripts/cmds/TongQueTaiFinish.lua"
dofile "scripts/cmds/TongQueTaiSpeed.lua"
dofile "scripts/cmds/TongQueTaiLoad.lua"
dofile "scripts/cmds/TongQueTaiGetReward.lua"
dofile "scripts/cmds/TongQueTaiGetInfo.lua"
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
dofile "scripts/cmds/TopListGet.lua"
dofile "scripts/cmds/DebugCommand.lua"
dofile "scripts/cmds/GetRoleInfo.lua"
dofile "scripts/cmds/CreateRole.lua"
dofile "scripts/cmds/ReportClientVersion.lua"

dofile "scripts/serialize_command.lua"
dofile "scripts/prepare_others.lua"
dofile "scripts/deserialize_command.lua"

function InitCommandInMainThread()
	API_ResetCmdExtraRolesMax()
	API_ResetCmdExtraMafiasMax()
	API_ResetCmdExtraPVPsMax()
	API_ReSetCmdLock()

	API_SetCmdExtraRolesMax(368,2)
	API_SetCmdExtraRolesMax(10306,1)
	API_SetCmdExtraRolesMax(10310,1)
	API_SetCmdExtraRolesMax(359,2)
	API_SetCmdExtraRolesMax(361,2)
	API_SetCmdExtraRolesMax(363,2)
	API_SetCmdExtraRolesMax(172,1)
	API_SetCmdExtraRolesMax(366,2)
	API_SetCmdExtraRolesMax(10301,1)
	API_SetCmdExtraRolesMax(176,1)
	API_SetCmdExtraRolesMax(10008,1)
	API_SetCmdExtraRolesMax(243,1)
	API_SetCmdExtraRolesMax(10105,1)
	API_SetCmdExtraRolesMax(10003,1)
	API_SetCmdExtraRolesMax(10009,1)
	API_SetCmdExtraRolesMax(10106,1)
	API_SetCmdExtraRolesMax(10109,1)
	API_SetCmdExtraRolesMax(10302,1)
	API_SetCmdExtraRolesMax(255,1)

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

	API_SetCmdLock(99999,"singleton")
	API_SetCmdLock(353,"tongquetai")
	API_SetCmdLock(355,"tongquetai")
	API_SetCmdLock(359,"tongquetai")
	API_SetCmdLock(361,"tongquetai")
	API_SetCmdLock(363,"tongquetai")
	API_SetCmdLock(366,"tongquetai")
	API_SetCmdLock(368,"tongquetai")
	API_SetCmdLock(152,"misc")
	API_SetCmdLock(154,"misc")
	API_SetCmdLock(156,"misc")
	API_SetCmdLock(158,"misc")
	API_SetCmdLock(1000005,"misc")
	API_SetCmdLock(1000001,"noloadplayer")
	API_SetCmdLock(1000003,"noloadplayer")
	API_SetCmdLock(241,"pvearena")
	API_SetCmdLock(243,"pvearena")
	API_SetCmdLock(245,"pvearena")
	API_SetCmdLock(247,"pvearena")
	API_SetCmdLock(249,"pvearena")
	API_SetCmdLock(20000,"toplist")

end

