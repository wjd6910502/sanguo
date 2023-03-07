--DONT CHANGE ME!

function SerializeMessage(msg)
	local os = {}

	if false then
		--never to here
	elseif msg.__type__ == "TestMessage1" then
		Serialize(os, 90001)
	elseif msg.__type__ == "UpdateRoleInfo" then
		Serialize(os, 1)
		Serialize(os, msg.id)
		Serialize(os, msg.name)
		Serialize(os, msg.photo)
		Serialize(os, msg.level)
	elseif msg.__type__ == "PublicChat" then
		Serialize(os, 2)
		__SerializeStruct(os, "RoleBrief", msg.src)
		Serialize(os, msg.content)
		Serialize(os, msg.time)
	elseif msg.__type__ == "MafiaAddMember" then
		Serialize(os, 3)
		__SerializeStruct(os, "RoleBrief", msg.member)
	elseif msg.__type__ == "CheckClientVersion" then
		Serialize(os, 4)
	elseif msg.__type__ == "RoleUpdatePveArenaTop" then
		Serialize(os, 5)
	elseif msg.__type__ == "RoleUpdatePveArenaMisc" then
		Serialize(os, 6)
	elseif msg.__type__ == "RoleUpdateDefencePlayerPveArenaInfo" then
		Serialize(os, 7)
		Serialize(os, msg.id)
		Serialize(os, msg.name)
		Serialize(os, msg.level)
		Serialize(os, msg.mafia_name)
		Serialize(os, msg.self_hero_info)
		Serialize(os, msg.oppo_hero_info)
		Serialize(os, msg.win_flag)
		Serialize(os, msg.operation)
		Serialize(os, msg.score)
		Serialize(os, msg.reply_flag)
		Serialize(os, msg.exe_ver)
		Serialize(os, msg.data_ver)
	elseif msg.__type__ == "RoleUpdatePveArenaHeroInfo" then
		Serialize(os, 8)
	elseif msg.__type__ == "RoleUpdatePveArenaInfo" then
		Serialize(os, 9)
	elseif msg.__type__ == "ClearPveArenaTop" then
		Serialize(os, 10)
	elseif msg.__type__ == "ClearPveArenaMisc" then
		Serialize(os, 11)
	elseif msg.__type__ == "PrintPveArenaMisc" then
		Serialize(os, 12)
	elseif msg.__type__ == "PveArenaHeartBeat" then
		Serialize(os, 13)
	elseif msg.__type__ == "PveArenaSendReward" then
		Serialize(os, 14)
	elseif msg.__type__ == "ErrorInfo" then
		Serialize(os, 15)
	elseif msg.__type__ == "TongQueTaiCancle" then
		Serialize(os, 16)
	elseif msg.__type__ == "TongQueTaiHeartBeat" then
		Serialize(os, 17)
	elseif msg.__type__ == "TongQueTaiMatchSuccess" then
		Serialize(os, 18)
		Serialize(os, msg.player_roleid1)
		Serialize(os, msg.player_roleid2)
	elseif msg.__type__ == "TongQueTaiNoticeRoleJoin" then
		Serialize(os, 19)
	elseif msg.__type__ == "TongQueTaiReload" then
		Serialize(os, 20)
		Serialize(os, msg.role_index)
		Serialize(os, msg.monster_index)
		Serialize(os, msg.retcode)
	elseif msg.__type__ == "TongQueTaiFail" then
		Serialize(os, 21)
	elseif msg.__type__ == "DBHeartbeat" then
		Serialize(os, 10006)
	elseif msg.__type__ == "ReloadLua" then
		Serialize(os, 10007)
	elseif msg.__type__ == "PVPCreateResult" then
		Serialize(os, 10008)
		Serialize(os, msg.retcode)
	elseif msg.__type__ == "PVPEnd" then
		Serialize(os, 10009)
		Serialize(os, msg.reason)
	elseif msg.__type__ == "PVPMatchSuccess" then
		Serialize(os, 10010)
		Serialize(os, msg.retcode)
		Serialize(os, msg.index)
		Serialize(os, msg.time)
	elseif msg.__type__ == "PVPJoinRe" then
		Serialize(os, 10011)
		Serialize(os, msg.retcode)
	elseif msg.__type__ == "PVPEnterRe" then
		Serialize(os, 10012)
		Serialize(os, msg.role_pvpinfo)
		Serialize(os, msg.fight_pvpinfo)
		Serialize(os, msg.robot_flag)
		Serialize(os, msg.robot_seed)
	elseif msg.__type__ == "PvpBegin" then
		Serialize(os, 10013)
		Serialize(os, msg.retcode)
		Serialize(os, msg.start_time)
		Serialize(os, msg.ip)
		Serialize(os, msg.port)
	elseif msg.__type__ == "PvpEnd" then
		Serialize(os, 10014)
		Serialize(os, msg.reason)
		Serialize(os, msg.typ)
		Serialize(os, msg.score)
	elseif msg.__type__ == "PvpCancle" then
		Serialize(os, 10015)
		Serialize(os, msg.retcode)
	elseif msg.__type__ == "PvpError" then
		Serialize(os, 10016)
		Serialize(os, msg.result)
	elseif msg.__type__ == "PvpSpeed" then
		Serialize(os, 10017)
		Serialize(os, msg.speed)
	elseif msg.__type__ == "PvpReset" then
		Serialize(os, 10018)
		Serialize(os, msg.retcode)
	elseif msg.__type__ == "SendNotice" then
		Serialize(os, 10019)
		Serialize(os, msg.notice_id)
		if msg.notice_para==nil then
			Serialize(os, 0)
		else
			Serialize(os, #msg.notice_para)
			for i = 1, #msg.notice_para do
				Serialize(os, msg.notice_para[i])
			end
		end
	elseif msg.__type__ == "TopListHeartBeat" then
		Serialize(os, 10020)
	elseif msg.__type__ == "PvpVideoID" then
		Serialize(os, 10021)
		Serialize(os, msg.video_id)
		Serialize(os, msg.first_pvpinfo)
		Serialize(os, msg.second_pvpinfo)
		Serialize(os, msg.win_flag)
	elseif msg.__type__ == "PvpGetVideoErr" then
		Serialize(os, 10022)
		Serialize(os, msg.retcode)
	elseif msg.__type__ == "PvpGetVideo" then
		Serialize(os, 10023)
		Serialize(os, msg.first)
		Serialize(os, msg.second)
		Serialize(os, msg.first_pvpinfo)
		Serialize(os, msg.second_pvpinfo)
		Serialize(os, msg.operation)
		Serialize(os, msg.win_flag)
		Serialize(os, msg.robot_flag)
		Serialize(os, msg.robot_seed)
		Serialize(os, msg.exe_ver)
		Serialize(os, msg.data_ver)
	elseif msg.__type__ == "SendMail" then
		Serialize(os, 10024)
		Serialize(os, msg.mail_id)
		Serialize(os, msg.arg1)
	elseif msg.__type__ == "SendServerEvent" then
		Serialize(os, 10025)
		Serialize(os, msg.event_type)
		Serialize(os, msg.end_time)
	elseif msg.__type__ == "RoleUpdateServerEvent" then
		Serialize(os, 10026)
	elseif msg.__type__ == "OpenServer" then
		Serialize(os, 10027)
	elseif msg.__type__ == "MiscHeartBeat" then
		Serialize(os, 10028)
	elseif msg.__type__ == "PvpSeasonFinish" then
		Serialize(os, 10029)
	elseif msg.__type__ == "RoleUpdatePvpEndTime" then
		Serialize(os, 10030)
	elseif msg.__type__ == "RoleUpdateLevelTop" then
		Serialize(os, 10031)
	elseif msg.__type__ == "BroadcastPvpVideo" then
		Serialize(os, 10032)
		Serialize(os, msg.typ)
		__SerializeStruct(os, "RoleBrief", msg.src)
		Serialize(os, msg.content)
		Serialize(os, msg.video_id)
		__SerializeStruct(os, "RoleClientPVPInfo", msg.player1)
		__SerializeStruct(os, "RoleClientPVPInfo", msg.player2)
		Serialize(os, msg.time)
		Serialize(os, msg.win_flag)
	elseif msg.__type__ == "RoleUpdateTopList" then
		Serialize(os, 10033)
		Serialize(os, msg.top_type)
		Serialize(os, msg.data)
	elseif msg.__type__ == "TestMessage3" then
		Serialize(os, 90003)
	elseif msg.__type__ == "TestMessage4" then
		Serialize(os, 90004)
	elseif msg.__type__ == "CreateRoleResult" then
		Serialize(os, 10001)
		Serialize(os, msg.retcode)
	elseif msg.__type__ == "Heartbeat" then
		Serialize(os, 10002)
		Serialize(os, msg.now)
	elseif msg.__type__ == "TestMessage2" then
		Serialize(os, 90002)
	elseif msg.__type__ == "CreateMafiaResult" then
		Serialize(os, 10003)
		Serialize(os, msg.retcode)
	elseif msg.__type__ == "PVPHeartbeat" then
		Serialize(os, 10004)
		Serialize(os, msg.now)
	elseif msg.__type__ == "PVPTriggerSend" then
		Serialize(os, 10005)

	end

	return table.concat(os)
end

