--DONT CHANGE ME!

function DeserializeAndProcessMessage(ud, is, ...)
	local others = {}
	others.roles = {}
	others.mafias = {}
	others.pvps = {}
	local extra_roles_size = 0
	local extra_mafias_size = 0
	local extra_pvps_size = 0
	local arg = {...}
	for k,v in ipairs(arg) do
		if k==1 then
			--extra roles size
			extra_roles_size = v
		elseif k<=1+extra_roles_size then
			--extra roles
			v = API_GetLuaRole(v)
			others.roles[v._roledata._base._id:ToStr()] = v
		elseif k==1+extra_roles_size+1 then
			--extra mafias size
			extra_mafias_size = v
		elseif k<=1+extra_roles_size+1+extra_mafias_size then
			--extra mafias
			v = API_GetLuaMafia(v)
			others.mafias[v._data._id:ToStr()] = v
		elseif k==1+extra_roles_size+1+extra_mafias_size+1 then
			--extra pvps size
			extra_pvps_size = v
		elseif k<=1+extra_roles_size+1+extra_mafias_size+1+extra_pvps_size then
			--extra pvps
			v = API_GetLuaPVP(v)
			others.pvps[v._data._id] = v
		else
			PrepareOthers4Message(others,k-(1+extra_roles_size+1+extra_mafias_size+1+extra_pvps_size),v)
		end
	end

	local msg = {}
	local is_idx = 1
	is_idx, msg.__type__ = Deserialize(is, is_idx, "number")

	if false then
		--never to here
	elseif msg.__type__ == 90001 then
		--TestMessage1

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_TestMessage1(player, role, msg, others)
	elseif msg.__type__ == 1 then
		--UpdateRoleInfo
		is_idx, msg.id = Deserialize(is, is_idx, "string")
		is_idx, msg.name = Deserialize(is, is_idx, "string")
		is_idx, msg.photo = Deserialize(is, is_idx, "number")
		is_idx, msg.level = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_UpdateRoleInfo(player, role, msg, others)
	elseif msg.__type__ == 2 then
		--PublicChat
		is_idx, msg.src = DeserializeStruct(is, is_idx, "RoleBrief")
		is_idx, msg.content = Deserialize(is, is_idx, "string")
		is_idx, msg.time = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_PublicChat(player, role, msg, others)
	elseif msg.__type__ == 3 then
		--MafiaAddMember
		is_idx, msg.member = DeserializeStruct(is, is_idx, "RoleBrief")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_MafiaAddMember(player, role, msg, others)
	elseif msg.__type__ == 4 then
		--CheckClientVersion

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_CheckClientVersion(player, role, msg, others)
	elseif msg.__type__ == 5 then
		--RoleUpdatePveArenaTop

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_RoleUpdatePveArenaTop(player, role, msg, others)
	elseif msg.__type__ == 6 then
		--RoleUpdatePveArenaMisc

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_RoleUpdatePveArenaMisc(player, role, msg, others)
	elseif msg.__type__ == 7 then
		--RoleUpdateDefencePlayerPveArenaInfo
		is_idx, msg.id = Deserialize(is, is_idx, "string")
		is_idx, msg.name = Deserialize(is, is_idx, "string")
		is_idx, msg.level = Deserialize(is, is_idx, "number")
		is_idx, msg.mafia_name = Deserialize(is, is_idx, "string")
		is_idx, msg.self_hero_info = Deserialize(is, is_idx, "string")
		is_idx, msg.oppo_hero_info = Deserialize(is, is_idx, "string")
		is_idx, msg.win_flag = Deserialize(is, is_idx, "number")
		is_idx, msg.operation = Deserialize(is, is_idx, "string")
		is_idx, msg.score = Deserialize(is, is_idx, "number")
		is_idx, msg.reply_flag = Deserialize(is, is_idx, "number")
		is_idx, msg.exe_ver = Deserialize(is, is_idx, "string")
		is_idx, msg.data_ver = Deserialize(is, is_idx, "string")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_RoleUpdateDefencePlayerPveArenaInfo(player, role, msg, others)
	elseif msg.__type__ == 8 then
		--RoleUpdatePveArenaHeroInfo

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_RoleUpdatePveArenaHeroInfo(player, role, msg, others)
	elseif msg.__type__ == 9 then
		--RoleUpdatePveArenaInfo

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_RoleUpdatePveArenaInfo(player, role, msg, others)
	elseif msg.__type__ == 10 then
		--ClearPveArenaTop

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_ClearPveArenaTop(player, role, msg, others)
	elseif msg.__type__ == 11 then
		--ClearPveArenaMisc

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_ClearPveArenaMisc(player, role, msg, others)
	elseif msg.__type__ == 12 then
		--PrintPveArenaMisc

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_PrintPveArenaMisc(player, role, msg, others)
	elseif msg.__type__ == 13 then
		--PveArenaHeartBeat

		OnMessage_PveArenaHeartBeat(msg, others)
	elseif msg.__type__ == 14 then
		--PveArenaSendReward

		OnMessage_PveArenaSendReward(msg, others)
	elseif msg.__type__ == 15 then
		--ErrorInfo

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_ErrorInfo(player, role, msg, others)
	elseif msg.__type__ == 16 then
		--TongQueTaiCancle

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_TongQueTaiCancle(player, role, msg, others)
	elseif msg.__type__ == 17 then
		--TongQueTaiHeartBeat

		OnMessage_TongQueTaiHeartBeat(msg, others)
	elseif msg.__type__ == 18 then
		--TongQueTaiMatchSuccess
		is_idx, msg.player_roleid1 = Deserialize(is, is_idx, "string")
		is_idx, msg.player_roleid2 = Deserialize(is, is_idx, "string")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_TongQueTaiMatchSuccess(player, role, msg, others)
	elseif msg.__type__ == 19 then
		--TongQueTaiNoticeRoleJoin

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_TongQueTaiNoticeRoleJoin(player, role, msg, others)
	elseif msg.__type__ == 20 then
		--TongQueTaiReload
		is_idx, msg.role_index = Deserialize(is, is_idx, "number")
		is_idx, msg.monster_index = Deserialize(is, is_idx, "number")
		is_idx, msg.retcode = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_TongQueTaiReload(player, role, msg, others)
	elseif msg.__type__ == 21 then
		--TongQueTaiFail

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_TongQueTaiFail(player, role, msg, others)
	elseif msg.__type__ == 10006 then
		local playermap = CACHE.PlayerManager:GetInstance()
		--DBHeartbeat

		OnMessage_DBHeartbeat(playermap, msg)
	elseif msg.__type__ == 10007 then
		local playermap = CACHE.PlayerManager:GetInstance()
		--ReloadLua

		OnMessage_ReloadLua(playermap, msg)
	elseif msg.__type__ == 10008 then
		--PVPCreateResult
		is_idx, msg.retcode = Deserialize(is, is_idx, "number")

		local pvp = API_GetLuaPVP(ud)
		OnMessage_PVPCreateResult(pvp, msg, others)
	elseif msg.__type__ == 10009 then
		--PVPEnd
		is_idx, msg.reason = Deserialize(is, is_idx, "number")

		local pvp = API_GetLuaPVP(ud)
		OnMessage_PVPEnd(pvp, msg, others)
	elseif msg.__type__ == 10010 then
		--PVPMatchSuccess
		is_idx, msg.retcode = Deserialize(is, is_idx, "number")
		is_idx, msg.index = Deserialize(is, is_idx, "number")
		is_idx, msg.time = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_PVPMatchSuccess(player, role, msg, others)
	elseif msg.__type__ == 10011 then
		--PVPJoinRe
		is_idx, msg.retcode = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_PVPJoinRe(player, role, msg, others)
	elseif msg.__type__ == 10012 then
		--PVPEnterRe
		is_idx, msg.role_pvpinfo = Deserialize(is, is_idx, "string")
		is_idx, msg.fight_pvpinfo = Deserialize(is, is_idx, "string")
		is_idx, msg.robot_flag = Deserialize(is, is_idx, "number")
		is_idx, msg.robot_seed = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_PVPEnterRe(player, role, msg, others)
	elseif msg.__type__ == 10013 then
		--PvpBegin
		is_idx, msg.retcode = Deserialize(is, is_idx, "number")
		is_idx, msg.start_time = Deserialize(is, is_idx, "number")
		is_idx, msg.ip = Deserialize(is, is_idx, "string")
		is_idx, msg.port = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_PvpBegin(player, role, msg, others)
	elseif msg.__type__ == 10014 then
		--PvpEnd
		is_idx, msg.reason = Deserialize(is, is_idx, "number")
		is_idx, msg.typ = Deserialize(is, is_idx, "number")
		is_idx, msg.score = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_PvpEnd(player, role, msg, others)
	elseif msg.__type__ == 10015 then
		--PvpCancle
		is_idx, msg.retcode = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_PvpCancle(player, role, msg, others)
	elseif msg.__type__ == 10016 then
		--PvpError
		is_idx, msg.result = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_PvpError(player, role, msg, others)
	elseif msg.__type__ == 10017 then
		--PvpSpeed
		is_idx, msg.speed = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_PvpSpeed(player, role, msg, others)
	elseif msg.__type__ == 10018 then
		--PvpReset
		is_idx, msg.retcode = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_PvpReset(player, role, msg, others)
	elseif msg.__type__ == 10019 then
		--SendNotice
		is_idx, msg.notice_id = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		msg.notice_para = {}
		for i = 1, count do
			is_idx, msg.notice_para[i] = Deserialize(is, is_idx, "string")
		end

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_SendNotice(player, role, msg, others)
	elseif msg.__type__ == 10020 then
		--TopListHeartBeat

		OnMessage_TopListHeartBeat(msg, others)
	elseif msg.__type__ == 10021 then
		--PvpVideoID
		is_idx, msg.video_id = Deserialize(is, is_idx, "string")
		is_idx, msg.first_pvpinfo = Deserialize(is, is_idx, "string")
		is_idx, msg.second_pvpinfo = Deserialize(is, is_idx, "string")
		is_idx, msg.win_flag = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_PvpVideoID(player, role, msg, others)
	elseif msg.__type__ == 10022 then
		--PvpGetVideoErr
		is_idx, msg.retcode = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_PvpGetVideoErr(player, role, msg, others)
	elseif msg.__type__ == 10023 then
		--PvpGetVideo
		is_idx, msg.first = Deserialize(is, is_idx, "string")
		is_idx, msg.second = Deserialize(is, is_idx, "string")
		is_idx, msg.first_pvpinfo = Deserialize(is, is_idx, "string")
		is_idx, msg.second_pvpinfo = Deserialize(is, is_idx, "string")
		is_idx, msg.operation = Deserialize(is, is_idx, "string")
		is_idx, msg.win_flag = Deserialize(is, is_idx, "number")
		is_idx, msg.robot_flag = Deserialize(is, is_idx, "number")
		is_idx, msg.robot_seed = Deserialize(is, is_idx, "number")
		is_idx, msg.exe_ver = Deserialize(is, is_idx, "string")
		is_idx, msg.data_ver = Deserialize(is, is_idx, "string")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_PvpGetVideo(player, role, msg, others)
	elseif msg.__type__ == 10024 then
		--SendMail
		is_idx, msg.mail_id = Deserialize(is, is_idx, "number")
		is_idx, msg.arg1 = Deserialize(is, is_idx, "string")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_SendMail(player, role, msg, others)
	elseif msg.__type__ == 10025 then
		--SendServerEvent
		is_idx, msg.event_type = Deserialize(is, is_idx, "number")
		is_idx, msg.end_time = Deserialize(is, is_idx, "number")

		OnMessage_SendServerEvent(msg, others)
	elseif msg.__type__ == 10026 then
		--RoleUpdateServerEvent

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_RoleUpdateServerEvent(player, role, msg, others)
	elseif msg.__type__ == 10027 then
		local playermap = CACHE.PlayerManager:GetInstance()
		--OpenServer

		OnMessage_OpenServer(playermap, msg)
	elseif msg.__type__ == 10028 then
		--MiscHeartBeat

		OnMessage_MiscHeartBeat(msg, others)
	elseif msg.__type__ == 10029 then
		--PvpSeasonFinish

		OnMessage_PvpSeasonFinish(msg, others)
	elseif msg.__type__ == 10030 then
		--RoleUpdatePvpEndTime

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_RoleUpdatePvpEndTime(player, role, msg, others)
	elseif msg.__type__ == 10031 then
		--RoleUpdateLevelTop

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_RoleUpdateLevelTop(player, role, msg, others)
	elseif msg.__type__ == 10032 then
		--BroadcastPvpVideo
		is_idx, msg.typ = Deserialize(is, is_idx, "number")
		is_idx, msg.src = DeserializeStruct(is, is_idx, "RoleBrief")
		is_idx, msg.content = Deserialize(is, is_idx, "string")
		is_idx, msg.video_id = Deserialize(is, is_idx, "string")
		is_idx, msg.player1 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
		is_idx, msg.player2 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
		is_idx, msg.time = Deserialize(is, is_idx, "number")
		is_idx, msg.win_flag = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_BroadcastPvpVideo(player, role, msg, others)
	elseif msg.__type__ == 10033 then
		--RoleUpdateTopList
		is_idx, msg.top_type = Deserialize(is, is_idx, "number")
		is_idx, msg.data = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_RoleUpdateTopList(player, role, msg, others)
	elseif msg.__type__ == 90003 then
		--TestMessage3

		local pvp = API_GetLuaPVP(ud)
		OnMessage_TestMessage3(pvp, msg, others)
	elseif msg.__type__ == 90004 then
		local playermap = CACHE.PlayerManager:GetInstance()
		--TestMessage4

		OnMessage_TestMessage4(playermap, msg)
	elseif msg.__type__ == 10001 then
		--CreateRoleResult
		is_idx, msg.retcode = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_CreateRoleResult(player, role, msg, others)
	elseif msg.__type__ == 10002 then
		--Heartbeat
		is_idx, msg.now = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_Heartbeat(player, role, msg, others)
	elseif msg.__type__ == 90002 then
		--TestMessage2

		local mafia = API_GetLuaMafia(ud)
		OnMessage_TestMessage2(mafia, msg, others)
	elseif msg.__type__ == 10003 then
		--CreateMafiaResult
		is_idx, msg.retcode = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_CreateMafiaResult(player, role, msg, others)
	elseif msg.__type__ == 10004 then
		--PVPHeartbeat
		is_idx, msg.now = Deserialize(is, is_idx, "number")

		local pvp = API_GetLuaPVP(ud)
		OnMessage_PVPHeartbeat(pvp, msg, others)
	elseif msg.__type__ == 10005 then
		--PVPTriggerSend

		local pvp = API_GetLuaPVP(ud)
		OnMessage_PVPTriggerSend(pvp, msg, others)

	end
end

