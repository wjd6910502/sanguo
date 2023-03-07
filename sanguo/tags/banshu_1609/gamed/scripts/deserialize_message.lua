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
		is_idx, msg.text_content = Deserialize(is, is_idx, "string")
		is_idx, msg.time = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_PublicChat(player, role, msg, others)
	elseif msg.__type__ == 3 then
		--MafiaAddMember
		is_idx, msg.member_info = DeserializeStruct(is, is_idx, "MafiaMember")

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
	elseif msg.__type__ == 22 then
		--RoleInfoInit

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_RoleInfoInit(player, role, msg, others)
	elseif msg.__type__ == 23 then
		--TestDeleteTop
		is_idx, msg.id = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_TestDeleteTop(player, role, msg, others)
	elseif msg.__type__ == 24 then
		--DelFriend
		is_idx, msg.roleid = Deserialize(is, is_idx, "string")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_DelFriend(player, role, msg, others)
	elseif msg.__type__ == 25 then
		--UpdateRoleMaShuScoreTop

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_UpdateRoleMaShuScoreTop(player, role, msg, others)
	elseif msg.__type__ == 26 then
		--UpdateRoleMaShuScoreAllRoleTop

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_UpdateRoleMaShuScoreAllRoleTop(player, role, msg, others)
	elseif msg.__type__ == 27 then
		--DeleteTopList
		is_idx, msg.id = Deserialize(is, is_idx, "number")

		OnMessage_DeleteTopList(msg, others)
	elseif msg.__type__ == 28 then
		--MaShuHelpMail
		is_idx, msg.role_name = Deserialize(is, is_idx, "string")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_MaShuHelpMail(player, role, msg, others)
	elseif msg.__type__ == 29 then
		--MaShuUpdateRoleRank
		is_idx, msg.rank = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_MaShuUpdateRoleRank(player, role, msg, others)
	elseif msg.__type__ == 30 then
		--TopList_All_Role_HeartBeat

		OnMessage_TopList_All_Role_HeartBeat(msg, others)
	elseif msg.__type__ == 31 then
		--RoleLogout

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_RoleLogout(player, role, msg, others)
	elseif msg.__type__ == 32 then
		--RoleUpdateFriendInfo
		is_idx, msg.roleid = Deserialize(is, is_idx, "string")
		is_idx, msg.level = Deserialize(is, is_idx, "number")
		is_idx, msg.zhanli = Deserialize(is, is_idx, "number")
		is_idx, msg.online = Deserialize(is, is_idx, "number")
		is_idx, msg.mashu_score = Deserialize(is, is_idx, "number")
		is_idx, msg.photo = Deserialize(is, is_idx, "number")
		is_idx, msg.photo_frame = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		msg.badge_info = {}
		for i = 1, count do
			is_idx, msg.badge_info[i] = DeserializeStruct(is, is_idx, "PhotoInfo")
		end

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_RoleUpdateFriendInfo(player, role, msg, others)
	elseif msg.__type__ == 33 then
		--RoleUpdateInfoMafiaTop
		is_idx, msg.mafia_id = Deserialize(is, is_idx, "string")
		is_idx, msg.data = Deserialize(is, is_idx, "number")
		is_idx, msg.score = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_RoleUpdateInfoMafiaTop(player, role, msg, others)
	elseif msg.__type__ == 34 then
		--UpdateMafiaInfoTop
		is_idx, msg.level_flag = Deserialize(is, is_idx, "number")
		is_idx, msg.id = Deserialize(is, is_idx, "string")
		is_idx, msg.name = Deserialize(is, is_idx, "string")
		is_idx, msg.announce = Deserialize(is, is_idx, "string")
		is_idx, msg.declaration = Deserialize(is, is_idx, "string")
		is_idx, msg.level = Deserialize(is, is_idx, "number")
		is_idx, msg.boss_id = Deserialize(is, is_idx, "string")
		is_idx, msg.boss_name = Deserialize(is, is_idx, "string")
		is_idx, msg.level_limit = Deserialize(is, is_idx, "number")
		is_idx, msg.num = Deserialize(is, is_idx, "number")

		OnMessage_UpdateMafiaInfoTop(msg, others)
	elseif msg.__type__ == 35 then
		--MafiaAddNewApply
		is_idx, msg.apply_info = DeserializeStruct(is, is_idx, "MafiaApplyRoleInfo")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_MafiaAddNewApply(player, role, msg, others)
	elseif msg.__type__ == 36 then
		--MafiaDelNewApply
		is_idx, msg.id = Deserialize(is, is_idx, "string")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_MafiaDelNewApply(player, role, msg, others)
	elseif msg.__type__ == 37 then
		--MafiaDelMember
		is_idx, msg.id = Deserialize(is, is_idx, "string")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_MafiaDelMember(player, role, msg, others)
	elseif msg.__type__ == 38 then
		--MafiaDeleteTopList
		is_idx, msg.id = Deserialize(is, is_idx, "number")

		OnMessage_MafiaDeleteTopList(msg, others)
	elseif msg.__type__ == 39 then
		--DeleteMafiaInfoTop
		is_idx, msg.level = Deserialize(is, is_idx, "number")
		is_idx, msg.id = Deserialize(is, is_idx, "string")

		OnMessage_DeleteMafiaInfoTop(msg, others)
	elseif msg.__type__ == 40 then
		--MafiaUpdateInterfaceInfo
		is_idx, msg.info = DeserializeStruct(is, is_idx, "MafiaInterfaceInfo")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_MafiaUpdateInterfaceInfo(player, role, msg, others)
	elseif msg.__type__ == 41 then
		--RoleUpdateMafiaInfoLogin

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_RoleUpdateMafiaInfoLogin(player, role, msg, others)
	elseif msg.__type__ == 42 then
		--MafiaUpdateMember
		is_idx, msg.member_info = DeserializeStruct(is, is_idx, "MafiaMember")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_MafiaUpdateMember(player, role, msg, others)
	elseif msg.__type__ == 43 then
		--MafiaUpdateExp
		is_idx, msg.jisi = Deserialize(is, is_idx, "number")
		is_idx, msg.exp = Deserialize(is, is_idx, "number")
		is_idx, msg.level = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_MafiaUpdateExp(player, role, msg, others)
	elseif msg.__type__ == 44 then
		--MafiaHeartBeat
		is_idx, msg.now = Deserialize(is, is_idx, "number")

		local mafia = API_GetLuaMafia(ud)
		OnMessage_MafiaHeartBeat(mafia, msg, others)
	elseif msg.__type__ == 45 then
		--RoleUpdateMafiaInfo
		is_idx, msg.roleid = Deserialize(is, is_idx, "string")
		is_idx, msg.level = Deserialize(is, is_idx, "number")
		is_idx, msg.zhanli = Deserialize(is, is_idx, "number")
		is_idx, msg.online = Deserialize(is, is_idx, "number")

		local mafia = API_GetLuaMafia(ud)
		OnMessage_RoleUpdateMafiaInfo(mafia, msg, others)
	elseif msg.__type__ == 46 then
		--MafiaUpdateJiSi
		is_idx, msg.jisi = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_MafiaUpdateJiSi(player, role, msg, others)
	elseif msg.__type__ == 47 then
		--RoleUpdateMafiaMaShuScore

		local mafia = API_GetLuaMafia(ud)
		OnMessage_RoleUpdateMafiaMaShuScore(mafia, msg, others)
	elseif msg.__type__ == 48 then
		--SendMailToMafia
		is_idx, msg.mail_id = Deserialize(is, is_idx, "number")

		local mafia = API_GetLuaMafia(ud)
		OnMessage_SendMailToMafia(mafia, msg, others)
	elseif msg.__type__ == 49 then
		--TestSendMailToMafia

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_TestSendMailToMafia(player, role, msg, others)
	elseif msg.__type__ == 50 then
		--ChangeMafiaName
		is_idx, msg.retcode = Deserialize(is, is_idx, "number")
		is_idx, msg.name = Deserialize(is, is_idx, "string")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_ChangeMafiaName(player, role, msg, others)
	elseif msg.__type__ == 51 then
		--AudienceGetList
		is_idx, msg.fight_info = Deserialize(is, is_idx, "string")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_AudienceGetList(player, role, msg, others)
	elseif msg.__type__ == 52 then
		--AudienceGetRoomInfo
		is_idx, msg.retcode = Deserialize(is, is_idx, "number")
		is_idx, msg.room_id = Deserialize(is, is_idx, "number")
		is_idx, msg.fight_robot = Deserialize(is, is_idx, "number")
		is_idx, msg.robot_seed = Deserialize(is, is_idx, "number")
		is_idx, msg.fight1_pvpinfo = Deserialize(is, is_idx, "string")
		is_idx, msg.fight2_pvpinfo = Deserialize(is, is_idx, "string")
		is_idx, msg.operation = Deserialize(is, is_idx, "string")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_AudienceGetRoomInfo(player, role, msg, others)
	elseif msg.__type__ == 53 then
		--AudienceSendOperation
		is_idx, msg.room_id = Deserialize(is, is_idx, "number")
		is_idx, msg.operation = Deserialize(is, is_idx, "string")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_AudienceSendOperation(player, role, msg, others)
	elseif msg.__type__ == 54 then
		--AudienceFinishRoom
		is_idx, msg.room_id = Deserialize(is, is_idx, "number")
		is_idx, msg.win_flag = Deserialize(is, is_idx, "number")
		is_idx, msg.reason = Deserialize(is, is_idx, "number")
		is_idx, msg.operation = Deserialize(is, is_idx, "string")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_AudienceFinishRoom(player, role, msg, others)
	elseif msg.__type__ == 55 then
		--TestMafiaLevelUp

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_TestMafiaLevelUp(player, role, msg, others)
	elseif msg.__type__ == 56 then
		--MafiaUpdateNoticeInfo
		is_idx, msg.notice_info = DeserializeStruct(is, is_idx, "MafiaNoticeInfo")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_MafiaUpdateNoticeInfo(player, role, msg, others)
	elseif msg.__type__ == 57 then
		--MafiaBangZhuSendMail
		is_idx, msg.id = Deserialize(is, is_idx, "string")
		is_idx, msg.name = Deserialize(is, is_idx, "string")
		is_idx, msg.subject = Deserialize(is, is_idx, "string")
		is_idx, msg.context = Deserialize(is, is_idx, "string")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_MafiaBangZhuSendMail(player, role, msg, others)
	elseif msg.__type__ == 58 then
		--TopListUpdateInfo

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_TopListUpdateInfo(player, role, msg, others)
	elseif msg.__type__ == 59 then
		--TopListInsertInfo
		is_idx, msg.typ = Deserialize(is, is_idx, "number")
		is_idx, msg.data = Deserialize(is, is_idx, "string")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_TopListInsertInfo(player, role, msg, others)
	elseif msg.__type__ == 60 then
		--ClientTimeRequest

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_ClientTimeRequest(player, role, msg, others)
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
	elseif msg.__type__ == 10003 then
		--CreateMafiaResult
		is_idx, msg.retcode = Deserialize(is, is_idx, "number")
		is_idx, msg.create_time = Deserialize(is, is_idx, "number")
		is_idx, msg.name = Deserialize(is, is_idx, "string")

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
			is_idx, msg.notice_para[i] = DeserializeStruct(is, is_idx, "NoticeParaInfo")
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
	elseif msg.__type__ == 10100 then
		--PublicChatnew
		is_idx, msg.id = Deserialize(is, is_idx, "string")
		is_idx, msg.name = Deserialize(is, is_idx, "string")
		is_idx, msg.photo = Deserialize(is, is_idx, "number")
		is_idx, msg.level = Deserialize(is, is_idx, "number")
		is_idx, msg.mafia_id = Deserialize(is, is_idx, "string")
		is_idx, msg.mafia_name = Deserialize(is, is_idx, "string")
		is_idx, msg.time = Deserialize(is, is_idx, "number")
		is_idx, msg.text_content = Deserialize(is, is_idx, "string")
		is_idx, msg.speech_content = Deserialize(is, is_idx, "string")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_PublicChatnew(player, role, msg, others)
	elseif msg.__type__ == 10101 then
		--PrivateChatnew
		is_idx, msg.id = Deserialize(is, is_idx, "string")
		is_idx, msg.name = Deserialize(is, is_idx, "string")
		is_idx, msg.photo = Deserialize(is, is_idx, "number")
		is_idx, msg.level = Deserialize(is, is_idx, "number")
		is_idx, msg.mafia_id = Deserialize(is, is_idx, "string")
		is_idx, msg.mafia_name = Deserialize(is, is_idx, "string")
		is_idx, msg.time = Deserialize(is, is_idx, "number")
		is_idx, msg.text_content = Deserialize(is, is_idx, "string")
		is_idx, msg.speech_content = Deserialize(is, is_idx, "string")
		is_idx, msg.dest_id = Deserialize(is, is_idx, "string")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_PrivateChatnew(player, role, msg, others)
	elseif msg.__type__ == 90001 then
		--TestMessage1

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_TestMessage1(player, role, msg, others)
	elseif msg.__type__ == 90002 then
		--TestMessage2

		local mafia = API_GetLuaMafia(ud)
		OnMessage_TestMessage2(mafia, msg, others)
	elseif msg.__type__ == 90003 then
		--TestMessage3

		local pvp = API_GetLuaPVP(ud)
		OnMessage_TestMessage3(pvp, msg, others)
	elseif msg.__type__ == 90004 then
		local playermap = CACHE.PlayerManager:GetInstance()
		--TestMessage4

		OnMessage_TestMessage4(playermap, msg)
	elseif msg.__type__ == 10200 then
		--JieYiUpdateReply
		is_idx, msg.id = Deserialize(is, is_idx, "string")
		is_idx, msg.typ = Deserialize(is, is_idx, "number")
		is_idx, msg.name = Deserialize(is, is_idx, "string")
		is_idx, msg.role_id = Deserialize(is, is_idx, "string")
		is_idx, msg.agreement = Deserialize(is, is_idx, "number")

		local player = API_GetLuaPlayer(ud)
		local role = API_GetLuaRole(ud)
		OnMessage_JieYiUpdateReply(player, role, msg, others)

	end
end

