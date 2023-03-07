--DONT CHANGE ME!

dofile "scripts/localconfig.lua"
dofile "scripts/base64.lua"
dofile "scripts/serialize.lua"
dofile "scripts/serialize_struct.lua"
dofile "scripts/deserialize_struct.lua"
dofile "scripts/checksum.lua"
dofile "scripts/common.lua"
dofile "scripts/util.lua"

dofile "scripts/msgs/UpdateRoleInfo.lua"
dofile "scripts/msgs/PublicChat.lua"
dofile "scripts/msgs/MafiaAddMember.lua"
dofile "scripts/msgs/CheckClientVersion.lua"
dofile "scripts/msgs/RoleUpdatePveArenaTop.lua"
dofile "scripts/msgs/RoleUpdatePveArenaMisc.lua"
dofile "scripts/msgs/RoleUpdateDefencePlayerPveArenaInfo.lua"
dofile "scripts/msgs/RoleUpdatePveArenaHeroInfo.lua"
dofile "scripts/msgs/RoleUpdatePveArenaInfo.lua"
dofile "scripts/msgs/ClearPveArenaTop.lua"
dofile "scripts/msgs/ClearPveArenaMisc.lua"
dofile "scripts/msgs/PrintPveArenaMisc.lua"
dofile "scripts/msgs/PveArenaHeartBeat.lua"
dofile "scripts/msgs/PveArenaSendReward.lua"
dofile "scripts/msgs/ErrorInfo.lua"
dofile "scripts/msgs/TongQueTaiCancle.lua"
dofile "scripts/msgs/TongQueTaiHeartBeat.lua"
dofile "scripts/msgs/TongQueTaiMatchSuccess.lua"
dofile "scripts/msgs/TongQueTaiNoticeRoleJoin.lua"
dofile "scripts/msgs/TongQueTaiReload.lua"
dofile "scripts/msgs/TongQueTaiFail.lua"
dofile "scripts/msgs/RoleInfoInit.lua"
dofile "scripts/msgs/TestDeleteTop.lua"
dofile "scripts/msgs/DelFriend.lua"
dofile "scripts/msgs/UpdateRoleMaShuScoreTop.lua"
dofile "scripts/msgs/UpdateRoleMaShuScoreAllRoleTop.lua"
dofile "scripts/msgs/DeleteTopList.lua"
dofile "scripts/msgs/MaShuHelpMail.lua"
dofile "scripts/msgs/MaShuUpdateRoleRank.lua"
dofile "scripts/msgs/TopList_All_Role_HeartBeat.lua"
dofile "scripts/msgs/RoleLogout.lua"
dofile "scripts/msgs/RoleUpdateFriendInfo.lua"
dofile "scripts/msgs/RoleUpdateInfoMafiaTop.lua"
dofile "scripts/msgs/UpdateMafiaInfoTop.lua"
dofile "scripts/msgs/MafiaAddNewApply.lua"
dofile "scripts/msgs/MafiaDelNewApply.lua"
dofile "scripts/msgs/MafiaDelMember.lua"
dofile "scripts/msgs/MafiaDeleteTopList.lua"
dofile "scripts/msgs/DeleteMafiaInfoTop.lua"
dofile "scripts/msgs/MafiaUpdateInterfaceInfo.lua"
dofile "scripts/msgs/RoleUpdateMafiaInfoLogin.lua"
dofile "scripts/msgs/MafiaUpdateMember.lua"
dofile "scripts/msgs/MafiaUpdateExp.lua"
dofile "scripts/msgs/MafiaHeartBeat.lua"
dofile "scripts/msgs/RoleUpdateMafiaInfo.lua"
dofile "scripts/msgs/MafiaUpdateJiSi.lua"
dofile "scripts/msgs/RoleUpdateMafiaMaShuScore.lua"
dofile "scripts/msgs/SendMailToMafia.lua"
dofile "scripts/msgs/TestSendMailToMafia.lua"
dofile "scripts/msgs/ChangeMafiaName.lua"
dofile "scripts/msgs/AudienceGetList.lua"
dofile "scripts/msgs/AudienceGetRoomInfo.lua"
dofile "scripts/msgs/AudienceSendOperation.lua"
dofile "scripts/msgs/AudienceFinishRoom.lua"
dofile "scripts/msgs/TestMafiaLevelUp.lua"
dofile "scripts/msgs/MafiaUpdateNoticeInfo.lua"
dofile "scripts/msgs/MafiaBangZhuSendMail.lua"
dofile "scripts/msgs/TopListUpdateInfo.lua"
dofile "scripts/msgs/TopListInsertInfo.lua"
dofile "scripts/msgs/ClientTimeRequest.lua"
dofile "scripts/msgs/TestYueZhanCreate.lua"
dofile "scripts/msgs/TestYueZhanJoin.lua"
dofile "scripts/msgs/YueZhanEnd.lua"
dofile "scripts/msgs/UpdateDanMuInfo.lua"
dofile "scripts/msgs/YueZhanInfo.lua"
dofile "scripts/msgs/YueZhanUpdateState.lua"
dofile "scripts/msgs/KickOut.lua"
dofile "scripts/msgs/MafiaDeclarationBroadCast.lua"
dofile "scripts/msgs/ChongZhi.lua"
dofile "scripts/msgs/MafiaChat.lua"
dofile "scripts/msgs/MafiaYueZhan.lua"
dofile "scripts/msgs/AudienceUpdateNum.lua"
dofile "scripts/msgs/TowerUpdateRoleRank.lua"
dofile "scripts/msgs/TestFloat.lua"
dofile "scripts/msgs/CheckServerReward.lua"
dofile "scripts/msgs/SyncNetTime.lua"
dofile "scripts/msgs/UpdateSpecialTask.lua"
dofile "scripts/msgs/CreateRoleResult.lua"
dofile "scripts/msgs/Heartbeat.lua"
dofile "scripts/msgs/CreateMafiaResult.lua"
dofile "scripts/msgs/PVPHeartbeat.lua"
dofile "scripts/msgs/PVPTriggerSend.lua"
dofile "scripts/msgs/DBHeartbeat.lua"
dofile "scripts/msgs/ReloadLua.lua"
dofile "scripts/msgs/PVPCreateResult.lua"
dofile "scripts/msgs/PVPEnd.lua"
dofile "scripts/msgs/PVPMatchSuccess.lua"
dofile "scripts/msgs/PVPJoinRe.lua"
dofile "scripts/msgs/PVPEnterRe.lua"
dofile "scripts/msgs/PvpBegin.lua"
dofile "scripts/msgs/PvpEnd.lua"
dofile "scripts/msgs/PvpCancle.lua"
dofile "scripts/msgs/PvpError.lua"
dofile "scripts/msgs/PvpSpeed.lua"
dofile "scripts/msgs/PvpReset.lua"
dofile "scripts/msgs/SendNotice.lua"
dofile "scripts/msgs/TopListHeartBeat.lua"
dofile "scripts/msgs/PvpVideoID.lua"
dofile "scripts/msgs/PvpGetVideoErr.lua"
dofile "scripts/msgs/PvpGetVideo.lua"
dofile "scripts/msgs/SendMail.lua"
dofile "scripts/msgs/SendServerEvent.lua"
dofile "scripts/msgs/RoleUpdateServerEvent.lua"
dofile "scripts/msgs/OpenServer.lua"
dofile "scripts/msgs/MiscHeartBeat.lua"
dofile "scripts/msgs/PvpSeasonFinish.lua"
dofile "scripts/msgs/RoleUpdatePvpEndTime.lua"
dofile "scripts/msgs/RoleUpdateLevelTop.lua"
dofile "scripts/msgs/BroadcastPvpVideo.lua"
dofile "scripts/msgs/RoleUpdateTopList.lua"
dofile "scripts/msgs/PVPPause.lua"
dofile "scripts/msgs/PVPContinue.lua"
dofile "scripts/msgs/ChangeRoleName.lua"
dofile "scripts/msgs/ActiveCodeResult.lua"
dofile "scripts/msgs/PublicChatnew.lua"
dofile "scripts/msgs/PrivateChatnew.lua"
dofile "scripts/msgs/BroadCastPublicChat.lua"
dofile "scripts/msgs/JieYiUpdateReply.lua"
dofile "scripts/msgs/JieYiUpdateExit.lua"
dofile "scripts/msgs/FlowerGiftUpdate.lua"
dofile "scripts/msgs/HotPvpVideoHeartBeat.lua"
dofile "scripts/msgs/ServerRewardHeartBeat.lua"
dofile "scripts/msgs/CloseServer.lua"
dofile "scripts/msgs/GMCmd_GetChar.lua"
dofile "scripts/msgs/GMCmd_MailTextToPlayer.lua"
dofile "scripts/msgs/GMCmd_Bull.lua"
dofile "scripts/msgs/GMCmd_AddForbidLogin.lua"
dofile "scripts/msgs/GMCmd_MailToPlayer.lua"
dofile "scripts/msgs/Pay.lua"
dofile "scripts/msgs/TestMessage1.lua"
dofile "scripts/msgs/TestMessage2.lua"
dofile "scripts/msgs/TestMessage3.lua"
dofile "scripts/msgs/TestMessage4.lua"

dofile "scripts/serialize_message.lua"
dofile "scripts/prepare_others.lua"
dofile "scripts/deserialize_message.lua"

function InitMessageInMainThread()
	API_ResetMsgReceiver2()
	API_ReSetMsgLock()

	API_SetMsgReceiver2(1, "player")
	API_SetMsgReceiver2(2, "player")
	API_SetMsgReceiver2(3, "player")
	API_SetMsgReceiver2(4, "player")
	API_SetMsgReceiver2(5, "player")
	API_SetMsgReceiver2(6, "player")
	API_SetMsgReceiver2(7, "player")
	API_SetMsgReceiver2(8, "player")
	API_SetMsgReceiver2(9, "player")
	API_SetMsgReceiver2(10, "player")
	API_SetMsgReceiver2(11, "player")
	API_SetMsgReceiver2(12, "player")
	API_SetMsgReceiver2(13, "null")
	API_SetMsgReceiver2(14, "null")
	API_SetMsgReceiver2(15, "player")
	API_SetMsgReceiver2(16, "player")
	API_SetMsgReceiver2(17, "null")
	API_SetMsgReceiver2(18, "player")
	API_SetMsgReceiver2(19, "player")
	API_SetMsgReceiver2(20, "player")
	API_SetMsgReceiver2(21, "player")
	API_SetMsgReceiver2(22, "player")
	API_SetMsgReceiver2(23, "player")
	API_SetMsgReceiver2(24, "player")
	API_SetMsgReceiver2(25, "player")
	API_SetMsgReceiver2(26, "player")
	API_SetMsgReceiver2(27, "null")
	API_SetMsgReceiver2(28, "player")
	API_SetMsgReceiver2(29, "player")
	API_SetMsgReceiver2(30, "null")
	API_SetMsgReceiver2(31, "player")
	API_SetMsgReceiver2(32, "player")
	API_SetMsgReceiver2(33, "player")
	API_SetMsgReceiver2(34, "null")
	API_SetMsgReceiver2(35, "player")
	API_SetMsgReceiver2(36, "player")
	API_SetMsgReceiver2(37, "player")
	API_SetMsgReceiver2(38, "null")
	API_SetMsgReceiver2(39, "null")
	API_SetMsgReceiver2(40, "player")
	API_SetMsgReceiver2(41, "player")
	API_SetMsgReceiver2(42, "player")
	API_SetMsgReceiver2(43, "player")
	API_SetMsgReceiver2(44, "mafia")
	API_SetMsgReceiver2(45, "mafia")
	API_SetMsgReceiver2(46, "player")
	API_SetMsgReceiver2(47, "mafia")
	API_SetMsgReceiver2(48, "mafia")
	API_SetMsgReceiver2(49, "player")
	API_SetMsgReceiver2(50, "player")
	API_SetMsgReceiver2(51, "player")
	API_SetMsgReceiver2(52, "player")
	API_SetMsgReceiver2(53, "player")
	API_SetMsgReceiver2(54, "player")
	API_SetMsgReceiver2(55, "player")
	API_SetMsgReceiver2(56, "player")
	API_SetMsgReceiver2(57, "player")
	API_SetMsgReceiver2(58, "player")
	API_SetMsgReceiver2(59, "player")
	API_SetMsgReceiver2(60, "player")
	API_SetMsgReceiver2(61, "player")
	API_SetMsgReceiver2(62, "player")
	API_SetMsgReceiver2(63, "player")
	API_SetMsgReceiver2(64, "player")
	API_SetMsgReceiver2(65, "player")
	API_SetMsgReceiver2(66, "null")
	API_SetMsgReceiver2(67, "player")
	API_SetMsgReceiver2(68, "player")
	API_SetMsgReceiver2(69, "player")
	API_SetMsgReceiver2(70, "mafia")
	API_SetMsgReceiver2(71, "mafia")
	API_SetMsgReceiver2(72, "player")
	API_SetMsgReceiver2(73, "player")
	API_SetMsgReceiver2(81, "player")
	API_SetMsgReceiver2(82, "player")
	API_SetMsgReceiver2(83, "player")
	API_SetMsgReceiver2(84, "player")
	API_SetMsgReceiver2(11000, "player")
	API_SetMsgReceiver2(11001, "player")
	API_SetMsgReceiver2(11002, "player")
	API_SetMsgReceiver2(11003, "player")
	API_SetMsgReceiver2(11004, "player")
	API_SetMsgReceiver2(11005, "player")
	API_SetMsgReceiver2(10001, "player")
	API_SetMsgReceiver2(10002, "player")
	API_SetMsgReceiver2(10003, "player")
	API_SetMsgReceiver2(10004, "pvp")
	API_SetMsgReceiver2(10005, "pvp")
	API_SetMsgReceiver2(10006, "big")
	API_SetMsgReceiver2(10007, "big")
	API_SetMsgReceiver2(10008, "pvp")
	API_SetMsgReceiver2(10009, "pvp")
	API_SetMsgReceiver2(10010, "player")
	API_SetMsgReceiver2(10011, "player")
	API_SetMsgReceiver2(10012, "player")
	API_SetMsgReceiver2(10013, "player")
	API_SetMsgReceiver2(10014, "player")
	API_SetMsgReceiver2(10015, "player")
	API_SetMsgReceiver2(10016, "player")
	API_SetMsgReceiver2(10017, "player")
	API_SetMsgReceiver2(10018, "player")
	API_SetMsgReceiver2(10019, "player")
	API_SetMsgReceiver2(10020, "null")
	API_SetMsgReceiver2(10021, "player")
	API_SetMsgReceiver2(10022, "player")
	API_SetMsgReceiver2(10023, "player")
	API_SetMsgReceiver2(10024, "player")
	API_SetMsgReceiver2(10025, "null")
	API_SetMsgReceiver2(10026, "player")
	API_SetMsgReceiver2(10027, "big")
	API_SetMsgReceiver2(10028, "null")
	API_SetMsgReceiver2(10029, "null")
	API_SetMsgReceiver2(10030, "player")
	API_SetMsgReceiver2(10031, "player")
	API_SetMsgReceiver2(10032, "player")
	API_SetMsgReceiver2(10033, "player")
	API_SetMsgReceiver2(10034, "player")
	API_SetMsgReceiver2(10035, "player")
	API_SetMsgReceiver2(10036, "player")
	API_SetMsgReceiver2(10037, "player")
	API_SetMsgReceiver2(10300, "big")
	API_SetMsgReceiver2(10100, "player")
	API_SetMsgReceiver2(10101, "player")
	API_SetMsgReceiver2(10102, "player")
	API_SetMsgReceiver2(90001, "player")
	API_SetMsgReceiver2(90002, "mafia")
	API_SetMsgReceiver2(90003, "pvp")
	API_SetMsgReceiver2(90004, "big")
	API_SetMsgReceiver2(10200, "player")
	API_SetMsgReceiver2(10201, "player")
	API_SetMsgReceiver2(10220, "player")
	API_SetMsgReceiver2(10221, "null")
	API_SetMsgReceiver2(10222, "null")

	API_SetMsgLock(10001,"rolenamecache")
	API_SetMsgLock(26,"toplist_all_role")
	API_SetMsgLock(30,"toplist_all_role")
	API_SetMsgLock(16,"tongquetai")
	API_SetMsgLock(17,"tongquetai")
	API_SetMsgLock(18,"tongquetai")
	API_SetMsgLock(82,"server_reward")
	API_SetMsgLock(10222,"server_reward")
	API_SetMsgLock(10200,"jieyi_info")
	API_SetMsgLock(10201,"jieyi_info")
	API_SetMsgLock(10002,"chat_info")
	API_SetMsgLock(10102,"chat_info")
	API_SetMsgLock(4,"misc")
	API_SetMsgLock(10025,"misc")
	API_SetMsgLock(10026,"misc")
	API_SetMsgLock(10028,"misc")
	API_SetMsgLock(10029,"misc")
	API_SetMsgLock(10030,"misc")
	API_SetMsgLock(11003,"misc")
	API_SetMsgLock(6,"pvearena")
	API_SetMsgLock(7,"pvearena")
	API_SetMsgLock(8,"pvearena")
	API_SetMsgLock(9,"pvearena")
	API_SetMsgLock(11,"pvearena")
	API_SetMsgLock(12,"pvearena")
	API_SetMsgLock(13,"pvearena")
	API_SetMsgLock(14,"pvearena")
	API_SetMsgLock(10021,"hot_pvp_video")
	API_SetMsgLock(10221,"hot_pvp_video")
	API_SetMsgLock(34,"mafia_info")
	API_SetMsgLock(39,"mafia_info")
	API_SetMsgLock(5,"toplist")
	API_SetMsgLock(10,"toplist")
	API_SetMsgLock(23,"toplist")
	API_SetMsgLock(25,"toplist")
	API_SetMsgLock(27,"toplist")
	API_SetMsgLock(33,"toplist")
	API_SetMsgLock(38,"toplist")
	API_SetMsgLock(47,"toplist")
	API_SetMsgLock(49,"toplist")
	API_SetMsgLock(58,"toplist")
	API_SetMsgLock(59,"toplist")
	API_SetMsgLock(10003,"toplist")
	API_SetMsgLock(10014,"toplist")
	API_SetMsgLock(10020,"toplist")
	API_SetMsgLock(10029,"toplist")
	API_SetMsgLock(10031,"toplist")
	API_SetMsgLock(10033,"toplist")
	API_SetMsgLock(10036,"toplist")
	API_SetMsgLock(90001,"toplist")
	API_SetMsgLock(33,"mafia")
	API_SetMsgLock(41,"mafia")
	API_SetMsgLock(50,"mafia")
	API_SetMsgLock(55,"mafia")
	API_SetMsgLock(61,"yuezhan_info")
	API_SetMsgLock(62,"yuezhan_info")
	API_SetMsgLock(63,"yuezhan_info")
	API_SetMsgLock(66,"yuezhan_info")

end
