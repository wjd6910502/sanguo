--DONT CHANGE ME!

dofile "scripts/base64.lua"
dofile "scripts/serialize.lua"
dofile "scripts/serialize_struct.lua"
dofile "scripts/deserialize_struct.lua"
dofile "scripts/common.lua"
dofile "scripts/util.lua"

dofile "scripts/msgs/UpdateRoleInfo.lua"
dofile "scripts/msgs/PublicChat.lua"
dofile "scripts/msgs/MafiaAddMember.lua"
dofile "scripts/msgs/CheckClientVersion.lua"
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
dofile "scripts/msgs/TestMessage1.lua"
dofile "scripts/msgs/TestMessage2.lua"
dofile "scripts/msgs/TestMessage3.lua"
dofile "scripts/msgs/TestMessage4.lua"

dofile "scripts/serialize_message.lua"
dofile "scripts/deserialize_message.lua"

function InitMessageInMainThread()
	API_ResetMsgReceiver2()
	API_ResetMsgLockToplist()
	API_ResetMsgLockMisc()

	API_SetMsgReceiver2(1, "player")
	API_SetMsgReceiver2(2, "player")
	API_SetMsgReceiver2(3, "player")
	API_SetMsgReceiver2(4, "player")
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
	API_SetMsgReceiver2(10020, "toplist")
	API_SetMsgReceiver2(10021, "player")
	API_SetMsgReceiver2(10022, "player")
	API_SetMsgReceiver2(10023, "player")
	API_SetMsgReceiver2(10024, "player")
	API_SetMsgReceiver2(10025, "mist")
	API_SetMsgReceiver2(10026, "player")
	API_SetMsgReceiver2(10027, "big")
	API_SetMsgReceiver2(10028, "mist")
	API_SetMsgReceiver2(10029, "mist")
	API_SetMsgReceiver2(10030, "player")
	API_SetMsgReceiver2(10031, "player")
	API_SetMsgReceiver2(10032, "player")
	API_SetMsgReceiver2(10033, "player")
	API_SetMsgReceiver2(90001, "player")
	API_SetMsgReceiver2(90002, "mafia")
	API_SetMsgReceiver2(90003, "toplist")
	API_SetMsgReceiver2(90004, "big")
	API_SetMsgLockToplist(90001)
	API_SetMsgLockToplist(10033)
	API_SetMsgLockToplist(10029)
	API_SetMsgLockToplist(10014)
	API_SetMsgLockToplist(10031)
	API_SetMsgLockMisc(10026)
	API_SetMsgLockMisc(4)
	API_SetMsgLockMisc(10030)

end

