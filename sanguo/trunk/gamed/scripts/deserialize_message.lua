--DONT CHANGE ME!
local msg_list = {}
local player_msg_list = {}

function DeserializeAndProcessMessage(ud, api, is, ...)
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

	if msg_list[msg.__type__] ~= nil then
		msg_list[msg.__type__](is, is_idx, ud, api, msg, others)
	else
		error("wrong message type: "..msg.__type__)
	end
end

function _DeserializeAndProcessPlayerMessage(is, player, role, checksum)
	local msg = {}
	local is_idx = 1
	is_idx, msg.__type__ = Deserialize(is, is_idx, "number")

	if player_msg_list[msg.__type__] ~= nil then
		player_msg_list[msg.__type__](is, is_idx, player, role, msg, checksum)
	else
		error("wrong player message type: "..msg.__type__)
	end
end

--UpdateRoleInfo
msg_list[1] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["UpdateRoleInfo"] then
			API_Log("Err in deserialize message UpdateRoleInfo: strus has changed!")
			return
		end
	end
	is_idx, msg.id = Deserialize(is, is_idx, "string")
	is_idx, msg.name = Deserialize(is, is_idx, "string")
	is_idx, msg.photo = Deserialize(is, is_idx, "number")
	is_idx, msg.level = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_UpdateRoleInfo(player, role, msg, others)
end
player_msg_list[1] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["UpdateRoleInfo"] then
			API_Log("Err in deserialize message UpdateRoleInfo: strus has changed!")
			return
		end
	end
	is_idx, msg.id = Deserialize(is, is_idx, "string")
	is_idx, msg.name = Deserialize(is, is_idx, "string")
	is_idx, msg.photo = Deserialize(is, is_idx, "number")
	is_idx, msg.level = Deserialize(is, is_idx, "number")

	OnMessage_UpdateRoleInfo(player, role, msg, {})
end

--PublicChat
msg_list[2] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PublicChat"] then
			API_Log("Err in deserialize message PublicChat: strus has changed!")
			return
		end
	end
	is_idx, msg.src = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, msg.text_content = Deserialize(is, is_idx, "string")
	is_idx, msg.time = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_PublicChat(player, role, msg, others)
end
player_msg_list[2] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PublicChat"] then
			API_Log("Err in deserialize message PublicChat: strus has changed!")
			return
		end
	end
	is_idx, msg.src = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, msg.text_content = Deserialize(is, is_idx, "string")
	is_idx, msg.time = Deserialize(is, is_idx, "number")

	OnMessage_PublicChat(player, role, msg, {})
end

--MafiaAddMember
msg_list[3] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaAddMember"] then
			API_Log("Err in deserialize message MafiaAddMember: strus has changed!")
			return
		end
	end
	is_idx, msg.member_info = DeserializeStruct(is, is_idx, "MafiaMember")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_MafiaAddMember(player, role, msg, others)
end
player_msg_list[3] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaAddMember"] then
			API_Log("Err in deserialize message MafiaAddMember: strus has changed!")
			return
		end
	end
	is_idx, msg.member_info = DeserializeStruct(is, is_idx, "MafiaMember")

	OnMessage_MafiaAddMember(player, role, msg, {})
end

--CheckClientVersion
msg_list[4] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["CheckClientVersion"] then
			API_Log("Err in deserialize message CheckClientVersion: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_CheckClientVersion(player, role, msg, others)
end
player_msg_list[4] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["CheckClientVersion"] then
			API_Log("Err in deserialize message CheckClientVersion: strus has changed!")
			return
		end
	end

	OnMessage_CheckClientVersion(player, role, msg, {})
end

--RoleUpdatePveArenaTop
msg_list[5] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdatePveArenaTop"] then
			API_Log("Err in deserialize message RoleUpdatePveArenaTop: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_RoleUpdatePveArenaTop(player, role, msg, others)
end
player_msg_list[5] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdatePveArenaTop"] then
			API_Log("Err in deserialize message RoleUpdatePveArenaTop: strus has changed!")
			return
		end
	end

	OnMessage_RoleUpdatePveArenaTop(player, role, msg, {})
end

--RoleUpdatePveArenaMisc
msg_list[6] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdatePveArenaMisc"] then
			API_Log("Err in deserialize message RoleUpdatePveArenaMisc: strus has changed!")
			return
		end
	end
	is_idx, msg.last_rank = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_RoleUpdatePveArenaMisc(player, role, msg, others)
end
player_msg_list[6] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdatePveArenaMisc"] then
			API_Log("Err in deserialize message RoleUpdatePveArenaMisc: strus has changed!")
			return
		end
	end
	is_idx, msg.last_rank = Deserialize(is, is_idx, "number")

	OnMessage_RoleUpdatePveArenaMisc(player, role, msg, {})
end

--RoleUpdateDefencePlayerPveArenaInfo
msg_list[7] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdateDefencePlayerPveArenaInfo"] then
			API_Log("Err in deserialize message RoleUpdateDefencePlayerPveArenaInfo: strus has changed!")
			return
		end
	end
	is_idx, msg.id = Deserialize(is, is_idx, "string")
	is_idx, msg.name = Deserialize(is, is_idx, "string")
	is_idx, msg.level = Deserialize(is, is_idx, "number")
	is_idx, msg.photo = Deserialize(is, is_idx, "number")
	is_idx, msg.photo_frame = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	msg.badge_info = {}
	for i = 1, count do
		is_idx, msg.badge_info[i] = DeserializeStruct(is, is_idx, "PhotoInfo")
	end
	is_idx, msg.mafia_name = Deserialize(is, is_idx, "string")
	is_idx, msg.self_hero_info = Deserialize(is, is_idx, "string")
	is_idx, msg.oppo_hero_info = Deserialize(is, is_idx, "string")
	is_idx, msg.win_flag = Deserialize(is, is_idx, "number")
	is_idx, msg.operation = Deserialize(is, is_idx, "string")
	is_idx, msg.score = Deserialize(is, is_idx, "number")
	is_idx, msg.zhanli = Deserialize(is, is_idx, "number")
	is_idx, msg.reply_flag = Deserialize(is, is_idx, "number")
	is_idx, msg.exe_ver = Deserialize(is, is_idx, "string")
	is_idx, msg.data_ver = Deserialize(is, is_idx, "string")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_RoleUpdateDefencePlayerPveArenaInfo(player, role, msg, others)
end
player_msg_list[7] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdateDefencePlayerPveArenaInfo"] then
			API_Log("Err in deserialize message RoleUpdateDefencePlayerPveArenaInfo: strus has changed!")
			return
		end
	end
	is_idx, msg.id = Deserialize(is, is_idx, "string")
	is_idx, msg.name = Deserialize(is, is_idx, "string")
	is_idx, msg.level = Deserialize(is, is_idx, "number")
	is_idx, msg.photo = Deserialize(is, is_idx, "number")
	is_idx, msg.photo_frame = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	msg.badge_info = {}
	for i = 1, count do
		is_idx, msg.badge_info[i] = DeserializeStruct(is, is_idx, "PhotoInfo")
	end
	is_idx, msg.mafia_name = Deserialize(is, is_idx, "string")
	is_idx, msg.self_hero_info = Deserialize(is, is_idx, "string")
	is_idx, msg.oppo_hero_info = Deserialize(is, is_idx, "string")
	is_idx, msg.win_flag = Deserialize(is, is_idx, "number")
	is_idx, msg.operation = Deserialize(is, is_idx, "string")
	is_idx, msg.score = Deserialize(is, is_idx, "number")
	is_idx, msg.zhanli = Deserialize(is, is_idx, "number")
	is_idx, msg.reply_flag = Deserialize(is, is_idx, "number")
	is_idx, msg.exe_ver = Deserialize(is, is_idx, "string")
	is_idx, msg.data_ver = Deserialize(is, is_idx, "string")

	OnMessage_RoleUpdateDefencePlayerPveArenaInfo(player, role, msg, {})
end

--RoleUpdatePveArenaHeroInfo
msg_list[8] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdatePveArenaHeroInfo"] then
			API_Log("Err in deserialize message RoleUpdatePveArenaHeroInfo: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_RoleUpdatePveArenaHeroInfo(player, role, msg, others)
end
player_msg_list[8] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdatePveArenaHeroInfo"] then
			API_Log("Err in deserialize message RoleUpdatePveArenaHeroInfo: strus has changed!")
			return
		end
	end

	OnMessage_RoleUpdatePveArenaHeroInfo(player, role, msg, {})
end

--RoleUpdatePveArenaInfo
msg_list[9] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdatePveArenaInfo"] then
			API_Log("Err in deserialize message RoleUpdatePveArenaInfo: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_RoleUpdatePveArenaInfo(player, role, msg, others)
end
player_msg_list[9] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdatePveArenaInfo"] then
			API_Log("Err in deserialize message RoleUpdatePveArenaInfo: strus has changed!")
			return
		end
	end

	OnMessage_RoleUpdatePveArenaInfo(player, role, msg, {})
end

--ClearPveArenaTop
msg_list[10] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["ClearPveArenaTop"] then
			API_Log("Err in deserialize message ClearPveArenaTop: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_ClearPveArenaTop(player, role, msg, others)
end
player_msg_list[10] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["ClearPveArenaTop"] then
			API_Log("Err in deserialize message ClearPveArenaTop: strus has changed!")
			return
		end
	end

	OnMessage_ClearPveArenaTop(player, role, msg, {})
end

--ClearPveArenaMisc
msg_list[11] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["ClearPveArenaMisc"] then
			API_Log("Err in deserialize message ClearPveArenaMisc: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_ClearPveArenaMisc(player, role, msg, others)
end
player_msg_list[11] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["ClearPveArenaMisc"] then
			API_Log("Err in deserialize message ClearPveArenaMisc: strus has changed!")
			return
		end
	end

	OnMessage_ClearPveArenaMisc(player, role, msg, {})
end

--PrintPveArenaMisc
msg_list[12] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PrintPveArenaMisc"] then
			API_Log("Err in deserialize message PrintPveArenaMisc: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_PrintPveArenaMisc(player, role, msg, others)
end
player_msg_list[12] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PrintPveArenaMisc"] then
			API_Log("Err in deserialize message PrintPveArenaMisc: strus has changed!")
			return
		end
	end

	OnMessage_PrintPveArenaMisc(player, role, msg, {})
end

--PveArenaHeartBeat
msg_list[13] = 
function(is, is_idx, ud, api, msg, others, checksum)
	API = API_GetLuaAPISet(api)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PveArenaHeartBeat"] then
			API_Log("Err in deserialize message PveArenaHeartBeat: strus has changed!")
			return
		end
	end

	OnMessage_PveArenaHeartBeat(msg, others)
end

--PveArenaSendReward
msg_list[14] = 
function(is, is_idx, ud, api, msg, others, checksum)
	API = API_GetLuaAPISet(api)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PveArenaSendReward"] then
			API_Log("Err in deserialize message PveArenaSendReward: strus has changed!")
			return
		end
	end

	OnMessage_PveArenaSendReward(msg, others)
end

--ErrorInfo
msg_list[15] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["ErrorInfo"] then
			API_Log("Err in deserialize message ErrorInfo: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_ErrorInfo(player, role, msg, others)
end
player_msg_list[15] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["ErrorInfo"] then
			API_Log("Err in deserialize message ErrorInfo: strus has changed!")
			return
		end
	end

	OnMessage_ErrorInfo(player, role, msg, {})
end

--TongQueTaiCancle
msg_list[16] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TongQueTaiCancle"] then
			API_Log("Err in deserialize message TongQueTaiCancle: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_TongQueTaiCancle(player, role, msg, others)
end
player_msg_list[16] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TongQueTaiCancle"] then
			API_Log("Err in deserialize message TongQueTaiCancle: strus has changed!")
			return
		end
	end

	OnMessage_TongQueTaiCancle(player, role, msg, {})
end

--TongQueTaiHeartBeat
msg_list[17] = 
function(is, is_idx, ud, api, msg, others, checksum)
	API = API_GetLuaAPISet(api)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TongQueTaiHeartBeat"] then
			API_Log("Err in deserialize message TongQueTaiHeartBeat: strus has changed!")
			return
		end
	end

	OnMessage_TongQueTaiHeartBeat(msg, others)
end

--TongQueTaiMatchSuccess
msg_list[18] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TongQueTaiMatchSuccess"] then
			API_Log("Err in deserialize message TongQueTaiMatchSuccess: strus has changed!")
			return
		end
	end
	is_idx, msg.player_roleid1 = Deserialize(is, is_idx, "string")
	is_idx, msg.player_roleid2 = Deserialize(is, is_idx, "string")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_TongQueTaiMatchSuccess(player, role, msg, others)
end
player_msg_list[18] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TongQueTaiMatchSuccess"] then
			API_Log("Err in deserialize message TongQueTaiMatchSuccess: strus has changed!")
			return
		end
	end
	is_idx, msg.player_roleid1 = Deserialize(is, is_idx, "string")
	is_idx, msg.player_roleid2 = Deserialize(is, is_idx, "string")

	OnMessage_TongQueTaiMatchSuccess(player, role, msg, {})
end

--TongQueTaiNoticeRoleJoin
msg_list[19] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TongQueTaiNoticeRoleJoin"] then
			API_Log("Err in deserialize message TongQueTaiNoticeRoleJoin: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_TongQueTaiNoticeRoleJoin(player, role, msg, others)
end
player_msg_list[19] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TongQueTaiNoticeRoleJoin"] then
			API_Log("Err in deserialize message TongQueTaiNoticeRoleJoin: strus has changed!")
			return
		end
	end

	OnMessage_TongQueTaiNoticeRoleJoin(player, role, msg, {})
end

--TongQueTaiReload
msg_list[20] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TongQueTaiReload"] then
			API_Log("Err in deserialize message TongQueTaiReload: strus has changed!")
			return
		end
	end
	is_idx, msg.role_index = Deserialize(is, is_idx, "number")
	is_idx, msg.monster_index = Deserialize(is, is_idx, "number")
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_TongQueTaiReload(player, role, msg, others)
end
player_msg_list[20] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TongQueTaiReload"] then
			API_Log("Err in deserialize message TongQueTaiReload: strus has changed!")
			return
		end
	end
	is_idx, msg.role_index = Deserialize(is, is_idx, "number")
	is_idx, msg.monster_index = Deserialize(is, is_idx, "number")
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")

	OnMessage_TongQueTaiReload(player, role, msg, {})
end

--TongQueTaiFail
msg_list[21] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TongQueTaiFail"] then
			API_Log("Err in deserialize message TongQueTaiFail: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_TongQueTaiFail(player, role, msg, others)
end
player_msg_list[21] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TongQueTaiFail"] then
			API_Log("Err in deserialize message TongQueTaiFail: strus has changed!")
			return
		end
	end

	OnMessage_TongQueTaiFail(player, role, msg, {})
end

--RoleInfoInit
msg_list[22] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleInfoInit"] then
			API_Log("Err in deserialize message RoleInfoInit: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_RoleInfoInit(player, role, msg, others)
end
player_msg_list[22] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleInfoInit"] then
			API_Log("Err in deserialize message RoleInfoInit: strus has changed!")
			return
		end
	end

	OnMessage_RoleInfoInit(player, role, msg, {})
end

--TestDeleteTop
msg_list[23] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TestDeleteTop"] then
			API_Log("Err in deserialize message TestDeleteTop: strus has changed!")
			return
		end
	end
	is_idx, msg.id = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_TestDeleteTop(player, role, msg, others)
end
player_msg_list[23] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TestDeleteTop"] then
			API_Log("Err in deserialize message TestDeleteTop: strus has changed!")
			return
		end
	end
	is_idx, msg.id = Deserialize(is, is_idx, "number")

	OnMessage_TestDeleteTop(player, role, msg, {})
end

--DelFriend
msg_list[24] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["DelFriend"] then
			API_Log("Err in deserialize message DelFriend: strus has changed!")
			return
		end
	end
	is_idx, msg.roleid = Deserialize(is, is_idx, "string")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_DelFriend(player, role, msg, others)
end
player_msg_list[24] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["DelFriend"] then
			API_Log("Err in deserialize message DelFriend: strus has changed!")
			return
		end
	end
	is_idx, msg.roleid = Deserialize(is, is_idx, "string")

	OnMessage_DelFriend(player, role, msg, {})
end

--UpdateRoleMaShuScoreTop
msg_list[25] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["UpdateRoleMaShuScoreTop"] then
			API_Log("Err in deserialize message UpdateRoleMaShuScoreTop: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_UpdateRoleMaShuScoreTop(player, role, msg, others)
end
player_msg_list[25] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["UpdateRoleMaShuScoreTop"] then
			API_Log("Err in deserialize message UpdateRoleMaShuScoreTop: strus has changed!")
			return
		end
	end

	OnMessage_UpdateRoleMaShuScoreTop(player, role, msg, {})
end

--UpdateRoleMaShuScoreAllRoleTop
msg_list[26] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["UpdateRoleMaShuScoreAllRoleTop"] then
			API_Log("Err in deserialize message UpdateRoleMaShuScoreAllRoleTop: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_UpdateRoleMaShuScoreAllRoleTop(player, role, msg, others)
end
player_msg_list[26] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["UpdateRoleMaShuScoreAllRoleTop"] then
			API_Log("Err in deserialize message UpdateRoleMaShuScoreAllRoleTop: strus has changed!")
			return
		end
	end

	OnMessage_UpdateRoleMaShuScoreAllRoleTop(player, role, msg, {})
end

--DeleteTopList
msg_list[27] = 
function(is, is_idx, ud, api, msg, others, checksum)
	API = API_GetLuaAPISet(api)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["DeleteTopList"] then
			API_Log("Err in deserialize message DeleteTopList: strus has changed!")
			return
		end
	end
	is_idx, msg.id = Deserialize(is, is_idx, "number")

	OnMessage_DeleteTopList(msg, others)
end

--MaShuHelpMail
msg_list[28] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MaShuHelpMail"] then
			API_Log("Err in deserialize message MaShuHelpMail: strus has changed!")
			return
		end
	end
	is_idx, msg.role_name = Deserialize(is, is_idx, "string")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_MaShuHelpMail(player, role, msg, others)
end
player_msg_list[28] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MaShuHelpMail"] then
			API_Log("Err in deserialize message MaShuHelpMail: strus has changed!")
			return
		end
	end
	is_idx, msg.role_name = Deserialize(is, is_idx, "string")

	OnMessage_MaShuHelpMail(player, role, msg, {})
end

--MaShuUpdateRoleRank
msg_list[29] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MaShuUpdateRoleRank"] then
			API_Log("Err in deserialize message MaShuUpdateRoleRank: strus has changed!")
			return
		end
	end
	is_idx, msg.rank = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_MaShuUpdateRoleRank(player, role, msg, others)
end
player_msg_list[29] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MaShuUpdateRoleRank"] then
			API_Log("Err in deserialize message MaShuUpdateRoleRank: strus has changed!")
			return
		end
	end
	is_idx, msg.rank = Deserialize(is, is_idx, "number")

	OnMessage_MaShuUpdateRoleRank(player, role, msg, {})
end

--TopList_All_Role_HeartBeat
msg_list[30] = 
function(is, is_idx, ud, api, msg, others, checksum)
	API = API_GetLuaAPISet(api)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TopList_All_Role_HeartBeat"] then
			API_Log("Err in deserialize message TopList_All_Role_HeartBeat: strus has changed!")
			return
		end
	end

	OnMessage_TopList_All_Role_HeartBeat(msg, others)
end

--RoleLogout
msg_list[31] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleLogout"] then
			API_Log("Err in deserialize message RoleLogout: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_RoleLogout(player, role, msg, others)
end
player_msg_list[31] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleLogout"] then
			API_Log("Err in deserialize message RoleLogout: strus has changed!")
			return
		end
	end

	OnMessage_RoleLogout(player, role, msg, {})
end

--RoleUpdateFriendInfo
msg_list[32] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdateFriendInfo"] then
			API_Log("Err in deserialize message RoleUpdateFriendInfo: strus has changed!")
			return
		end
	end
	is_idx, msg.roleid = Deserialize(is, is_idx, "string")
	is_idx, msg.name = Deserialize(is, is_idx, "string")
	is_idx, msg.level = Deserialize(is, is_idx, "number")
	is_idx, msg.zhanli = Deserialize(is, is_idx, "number")
	is_idx, msg.online = Deserialize(is, is_idx, "number")
	is_idx, msg.mashu_score = Deserialize(is, is_idx, "number")
	is_idx, msg.photo = Deserialize(is, is_idx, "number")
	is_idx, msg.photo_frame = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	msg.badge_info = {}
	for i = 1, count do
		is_idx, msg.badge_info[i] = DeserializeStruct(is, is_idx, "PhotoInfo")
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_RoleUpdateFriendInfo(player, role, msg, others)
end
player_msg_list[32] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdateFriendInfo"] then
			API_Log("Err in deserialize message RoleUpdateFriendInfo: strus has changed!")
			return
		end
	end
	is_idx, msg.roleid = Deserialize(is, is_idx, "string")
	is_idx, msg.name = Deserialize(is, is_idx, "string")
	is_idx, msg.level = Deserialize(is, is_idx, "number")
	is_idx, msg.zhanli = Deserialize(is, is_idx, "number")
	is_idx, msg.online = Deserialize(is, is_idx, "number")
	is_idx, msg.mashu_score = Deserialize(is, is_idx, "number")
	is_idx, msg.photo = Deserialize(is, is_idx, "number")
	is_idx, msg.photo_frame = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	msg.badge_info = {}
	for i = 1, count do
		is_idx, msg.badge_info[i] = DeserializeStruct(is, is_idx, "PhotoInfo")
	end

	OnMessage_RoleUpdateFriendInfo(player, role, msg, {})
end

--RoleUpdateInfoMafiaTop
msg_list[33] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdateInfoMafiaTop"] then
			API_Log("Err in deserialize message RoleUpdateInfoMafiaTop: strus has changed!")
			return
		end
	end
	is_idx, msg.mafia_id = Deserialize(is, is_idx, "string")
	is_idx, msg.data = Deserialize(is, is_idx, "number")
	is_idx, msg.score = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_RoleUpdateInfoMafiaTop(player, role, msg, others)
end
player_msg_list[33] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdateInfoMafiaTop"] then
			API_Log("Err in deserialize message RoleUpdateInfoMafiaTop: strus has changed!")
			return
		end
	end
	is_idx, msg.mafia_id = Deserialize(is, is_idx, "string")
	is_idx, msg.data = Deserialize(is, is_idx, "number")
	is_idx, msg.score = Deserialize(is, is_idx, "number")

	OnMessage_RoleUpdateInfoMafiaTop(player, role, msg, {})
end

--UpdateMafiaInfoTop
msg_list[34] = 
function(is, is_idx, ud, api, msg, others, checksum)
	API = API_GetLuaAPISet(api)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["UpdateMafiaInfoTop"] then
			API_Log("Err in deserialize message UpdateMafiaInfoTop: strus has changed!")
			return
		end
	end
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
end

--MafiaAddNewApply
msg_list[35] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaAddNewApply"] then
			API_Log("Err in deserialize message MafiaAddNewApply: strus has changed!")
			return
		end
	end
	is_idx, msg.apply_info = DeserializeStruct(is, is_idx, "MafiaApplyRoleInfo")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_MafiaAddNewApply(player, role, msg, others)
end
player_msg_list[35] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaAddNewApply"] then
			API_Log("Err in deserialize message MafiaAddNewApply: strus has changed!")
			return
		end
	end
	is_idx, msg.apply_info = DeserializeStruct(is, is_idx, "MafiaApplyRoleInfo")

	OnMessage_MafiaAddNewApply(player, role, msg, {})
end

--MafiaDelNewApply
msg_list[36] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaDelNewApply"] then
			API_Log("Err in deserialize message MafiaDelNewApply: strus has changed!")
			return
		end
	end
	is_idx, msg.id = Deserialize(is, is_idx, "string")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_MafiaDelNewApply(player, role, msg, others)
end
player_msg_list[36] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaDelNewApply"] then
			API_Log("Err in deserialize message MafiaDelNewApply: strus has changed!")
			return
		end
	end
	is_idx, msg.id = Deserialize(is, is_idx, "string")

	OnMessage_MafiaDelNewApply(player, role, msg, {})
end

--MafiaDelMember
msg_list[37] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaDelMember"] then
			API_Log("Err in deserialize message MafiaDelMember: strus has changed!")
			return
		end
	end
	is_idx, msg.id = Deserialize(is, is_idx, "string")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_MafiaDelMember(player, role, msg, others)
end
player_msg_list[37] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaDelMember"] then
			API_Log("Err in deserialize message MafiaDelMember: strus has changed!")
			return
		end
	end
	is_idx, msg.id = Deserialize(is, is_idx, "string")

	OnMessage_MafiaDelMember(player, role, msg, {})
end

--MafiaDeleteTopList
msg_list[38] = 
function(is, is_idx, ud, api, msg, others, checksum)
	API = API_GetLuaAPISet(api)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaDeleteTopList"] then
			API_Log("Err in deserialize message MafiaDeleteTopList: strus has changed!")
			return
		end
	end
	is_idx, msg.id = Deserialize(is, is_idx, "number")

	OnMessage_MafiaDeleteTopList(msg, others)
end

--DeleteMafiaInfoTop
msg_list[39] = 
function(is, is_idx, ud, api, msg, others, checksum)
	API = API_GetLuaAPISet(api)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["DeleteMafiaInfoTop"] then
			API_Log("Err in deserialize message DeleteMafiaInfoTop: strus has changed!")
			return
		end
	end
	is_idx, msg.level = Deserialize(is, is_idx, "number")
	is_idx, msg.id = Deserialize(is, is_idx, "string")

	OnMessage_DeleteMafiaInfoTop(msg, others)
end

--MafiaUpdateInterfaceInfo
msg_list[40] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaUpdateInterfaceInfo"] then
			API_Log("Err in deserialize message MafiaUpdateInterfaceInfo: strus has changed!")
			return
		end
	end
	is_idx, msg.info = DeserializeStruct(is, is_idx, "MafiaInterfaceInfo")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_MafiaUpdateInterfaceInfo(player, role, msg, others)
end
player_msg_list[40] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaUpdateInterfaceInfo"] then
			API_Log("Err in deserialize message MafiaUpdateInterfaceInfo: strus has changed!")
			return
		end
	end
	is_idx, msg.info = DeserializeStruct(is, is_idx, "MafiaInterfaceInfo")

	OnMessage_MafiaUpdateInterfaceInfo(player, role, msg, {})
end

--RoleUpdateMafiaInfoLogin
msg_list[41] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdateMafiaInfoLogin"] then
			API_Log("Err in deserialize message RoleUpdateMafiaInfoLogin: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_RoleUpdateMafiaInfoLogin(player, role, msg, others)
end
player_msg_list[41] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdateMafiaInfoLogin"] then
			API_Log("Err in deserialize message RoleUpdateMafiaInfoLogin: strus has changed!")
			return
		end
	end

	OnMessage_RoleUpdateMafiaInfoLogin(player, role, msg, {})
end

--MafiaUpdateMember
msg_list[42] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaUpdateMember"] then
			API_Log("Err in deserialize message MafiaUpdateMember: strus has changed!")
			return
		end
	end
	is_idx, msg.member_info = DeserializeStruct(is, is_idx, "MafiaMember")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_MafiaUpdateMember(player, role, msg, others)
end
player_msg_list[42] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaUpdateMember"] then
			API_Log("Err in deserialize message MafiaUpdateMember: strus has changed!")
			return
		end
	end
	is_idx, msg.member_info = DeserializeStruct(is, is_idx, "MafiaMember")

	OnMessage_MafiaUpdateMember(player, role, msg, {})
end

--MafiaUpdateExp
msg_list[43] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaUpdateExp"] then
			API_Log("Err in deserialize message MafiaUpdateExp: strus has changed!")
			return
		end
	end
	is_idx, msg.jisi = Deserialize(is, is_idx, "number")
	is_idx, msg.exp = Deserialize(is, is_idx, "number")
	is_idx, msg.level = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_MafiaUpdateExp(player, role, msg, others)
end
player_msg_list[43] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaUpdateExp"] then
			API_Log("Err in deserialize message MafiaUpdateExp: strus has changed!")
			return
		end
	end
	is_idx, msg.jisi = Deserialize(is, is_idx, "number")
	is_idx, msg.exp = Deserialize(is, is_idx, "number")
	is_idx, msg.level = Deserialize(is, is_idx, "number")

	OnMessage_MafiaUpdateExp(player, role, msg, {})
end

--MafiaHeartBeat
msg_list[44] =
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaHeartBeat"] then
			API_Log("Err in deserialize message MafiaHeartBeat: strus has changed!")
			return
		end
	end
	is_idx, msg.now = Deserialize(is, is_idx, "number")

	local mafia = API_GetLuaMafia(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_MafiaHeartBeat(mafia, msg, others)
end

--RoleUpdateMafiaInfo
msg_list[45] =
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdateMafiaInfo"] then
			API_Log("Err in deserialize message RoleUpdateMafiaInfo: strus has changed!")
			return
		end
	end
	is_idx, msg.roleid = Deserialize(is, is_idx, "string")
	is_idx, msg.name = Deserialize(is, is_idx, "string")
	is_idx, msg.level = Deserialize(is, is_idx, "number")
	is_idx, msg.zhanli = Deserialize(is, is_idx, "number")
	is_idx, msg.online = Deserialize(is, is_idx, "number")
	is_idx, msg.photo = Deserialize(is, is_idx, "number")
	is_idx, msg.photo_frame = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	msg.badge_info = {}
	for i = 1, count do
		is_idx, msg.badge_info[i] = DeserializeStruct(is, is_idx, "PhotoInfo")
	end

	local mafia = API_GetLuaMafia(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_RoleUpdateMafiaInfo(mafia, msg, others)
end

--MafiaUpdateJiSi
msg_list[46] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaUpdateJiSi"] then
			API_Log("Err in deserialize message MafiaUpdateJiSi: strus has changed!")
			return
		end
	end
	is_idx, msg.jisi = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_MafiaUpdateJiSi(player, role, msg, others)
end
player_msg_list[46] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaUpdateJiSi"] then
			API_Log("Err in deserialize message MafiaUpdateJiSi: strus has changed!")
			return
		end
	end
	is_idx, msg.jisi = Deserialize(is, is_idx, "number")

	OnMessage_MafiaUpdateJiSi(player, role, msg, {})
end

--RoleUpdateMafiaMaShuScore
msg_list[47] =
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdateMafiaMaShuScore"] then
			API_Log("Err in deserialize message RoleUpdateMafiaMaShuScore: strus has changed!")
			return
		end
	end

	local mafia = API_GetLuaMafia(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_RoleUpdateMafiaMaShuScore(mafia, msg, others)
end

--SendMailToMafia
msg_list[48] =
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["SendMailToMafia"] then
			API_Log("Err in deserialize message SendMailToMafia: strus has changed!")
			return
		end
	end
	is_idx, msg.mail_id = Deserialize(is, is_idx, "number")
	is_idx, msg.arg1 = Deserialize(is, is_idx, "string")

	local mafia = API_GetLuaMafia(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_SendMailToMafia(mafia, msg, others)
end

--TestSendMailToMafia
msg_list[49] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TestSendMailToMafia"] then
			API_Log("Err in deserialize message TestSendMailToMafia: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_TestSendMailToMafia(player, role, msg, others)
end
player_msg_list[49] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TestSendMailToMafia"] then
			API_Log("Err in deserialize message TestSendMailToMafia: strus has changed!")
			return
		end
	end

	OnMessage_TestSendMailToMafia(player, role, msg, {})
end

--ChangeMafiaName
msg_list[50] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["ChangeMafiaName"] then
			API_Log("Err in deserialize message ChangeMafiaName: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")
	is_idx, msg.name = Deserialize(is, is_idx, "string")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_ChangeMafiaName(player, role, msg, others)
end
player_msg_list[50] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["ChangeMafiaName"] then
			API_Log("Err in deserialize message ChangeMafiaName: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")
	is_idx, msg.name = Deserialize(is, is_idx, "string")

	OnMessage_ChangeMafiaName(player, role, msg, {})
end

--AudienceGetList
msg_list[51] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["AudienceGetList"] then
			API_Log("Err in deserialize message AudienceGetList: strus has changed!")
			return
		end
	end
	is_idx, msg.fight_info = Deserialize(is, is_idx, "string")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_AudienceGetList(player, role, msg, others)
end
player_msg_list[51] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["AudienceGetList"] then
			API_Log("Err in deserialize message AudienceGetList: strus has changed!")
			return
		end
	end
	is_idx, msg.fight_info = Deserialize(is, is_idx, "string")

	OnMessage_AudienceGetList(player, role, msg, {})
end

--AudienceGetRoomInfo
msg_list[52] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["AudienceGetRoomInfo"] then
			API_Log("Err in deserialize message AudienceGetRoomInfo: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")
	is_idx, msg.room_id = Deserialize(is, is_idx, "number")
	is_idx, msg.fight_robot = Deserialize(is, is_idx, "number")
	is_idx, msg.robot_seed = Deserialize(is, is_idx, "number")
	is_idx, msg.robot_type = Deserialize(is, is_idx, "number")
	is_idx, msg.fight1_pvpinfo = Deserialize(is, is_idx, "string")
	is_idx, msg.fight2_pvpinfo = Deserialize(is, is_idx, "string")
	is_idx, msg.operation = Deserialize(is, is_idx, "string")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_AudienceGetRoomInfo(player, role, msg, others)
end
player_msg_list[52] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["AudienceGetRoomInfo"] then
			API_Log("Err in deserialize message AudienceGetRoomInfo: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")
	is_idx, msg.room_id = Deserialize(is, is_idx, "number")
	is_idx, msg.fight_robot = Deserialize(is, is_idx, "number")
	is_idx, msg.robot_seed = Deserialize(is, is_idx, "number")
	is_idx, msg.robot_type = Deserialize(is, is_idx, "number")
	is_idx, msg.fight1_pvpinfo = Deserialize(is, is_idx, "string")
	is_idx, msg.fight2_pvpinfo = Deserialize(is, is_idx, "string")
	is_idx, msg.operation = Deserialize(is, is_idx, "string")

	OnMessage_AudienceGetRoomInfo(player, role, msg, {})
end

--AudienceSendOperation
msg_list[53] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["AudienceSendOperation"] then
			API_Log("Err in deserialize message AudienceSendOperation: strus has changed!")
			return
		end
	end
	is_idx, msg.room_id = Deserialize(is, is_idx, "number")
	is_idx, msg.operation = Deserialize(is, is_idx, "string")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_AudienceSendOperation(player, role, msg, others)
end
player_msg_list[53] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["AudienceSendOperation"] then
			API_Log("Err in deserialize message AudienceSendOperation: strus has changed!")
			return
		end
	end
	is_idx, msg.room_id = Deserialize(is, is_idx, "number")
	is_idx, msg.operation = Deserialize(is, is_idx, "string")

	OnMessage_AudienceSendOperation(player, role, msg, {})
end

--AudienceFinishRoom
msg_list[54] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["AudienceFinishRoom"] then
			API_Log("Err in deserialize message AudienceFinishRoom: strus has changed!")
			return
		end
	end
	is_idx, msg.room_id = Deserialize(is, is_idx, "number")
	is_idx, msg.win_flag = Deserialize(is, is_idx, "number")
	is_idx, msg.reason = Deserialize(is, is_idx, "number")
	is_idx, msg.operation = Deserialize(is, is_idx, "string")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_AudienceFinishRoom(player, role, msg, others)
end
player_msg_list[54] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["AudienceFinishRoom"] then
			API_Log("Err in deserialize message AudienceFinishRoom: strus has changed!")
			return
		end
	end
	is_idx, msg.room_id = Deserialize(is, is_idx, "number")
	is_idx, msg.win_flag = Deserialize(is, is_idx, "number")
	is_idx, msg.reason = Deserialize(is, is_idx, "number")
	is_idx, msg.operation = Deserialize(is, is_idx, "string")

	OnMessage_AudienceFinishRoom(player, role, msg, {})
end

--TestMafiaLevelUp
msg_list[55] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TestMafiaLevelUp"] then
			API_Log("Err in deserialize message TestMafiaLevelUp: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_TestMafiaLevelUp(player, role, msg, others)
end
player_msg_list[55] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TestMafiaLevelUp"] then
			API_Log("Err in deserialize message TestMafiaLevelUp: strus has changed!")
			return
		end
	end

	OnMessage_TestMafiaLevelUp(player, role, msg, {})
end

--MafiaUpdateNoticeInfo
msg_list[56] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaUpdateNoticeInfo"] then
			API_Log("Err in deserialize message MafiaUpdateNoticeInfo: strus has changed!")
			return
		end
	end
	is_idx, msg.notice_info = DeserializeStruct(is, is_idx, "MafiaNoticeInfo")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_MafiaUpdateNoticeInfo(player, role, msg, others)
end
player_msg_list[56] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaUpdateNoticeInfo"] then
			API_Log("Err in deserialize message MafiaUpdateNoticeInfo: strus has changed!")
			return
		end
	end
	is_idx, msg.notice_info = DeserializeStruct(is, is_idx, "MafiaNoticeInfo")

	OnMessage_MafiaUpdateNoticeInfo(player, role, msg, {})
end

--MafiaBangZhuSendMail
msg_list[57] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaBangZhuSendMail"] then
			API_Log("Err in deserialize message MafiaBangZhuSendMail: strus has changed!")
			return
		end
	end
	is_idx, msg.id = Deserialize(is, is_idx, "string")
	is_idx, msg.name = Deserialize(is, is_idx, "string")
	is_idx, msg.subject = Deserialize(is, is_idx, "string")
	is_idx, msg.context = Deserialize(is, is_idx, "string")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_MafiaBangZhuSendMail(player, role, msg, others)
end
player_msg_list[57] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaBangZhuSendMail"] then
			API_Log("Err in deserialize message MafiaBangZhuSendMail: strus has changed!")
			return
		end
	end
	is_idx, msg.id = Deserialize(is, is_idx, "string")
	is_idx, msg.name = Deserialize(is, is_idx, "string")
	is_idx, msg.subject = Deserialize(is, is_idx, "string")
	is_idx, msg.context = Deserialize(is, is_idx, "string")

	OnMessage_MafiaBangZhuSendMail(player, role, msg, {})
end

--TopListUpdateInfo
msg_list[58] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TopListUpdateInfo"] then
			API_Log("Err in deserialize message TopListUpdateInfo: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_TopListUpdateInfo(player, role, msg, others)
end
player_msg_list[58] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TopListUpdateInfo"] then
			API_Log("Err in deserialize message TopListUpdateInfo: strus has changed!")
			return
		end
	end

	OnMessage_TopListUpdateInfo(player, role, msg, {})
end

--TopListInsertInfo
msg_list[59] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TopListInsertInfo"] then
			API_Log("Err in deserialize message TopListInsertInfo: strus has changed!")
			return
		end
	end
	is_idx, msg.typ = Deserialize(is, is_idx, "number")
	is_idx, msg.data = Deserialize(is, is_idx, "string")
	is_idx, msg.data2 = Deserialize(is, is_idx, "string")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_TopListInsertInfo(player, role, msg, others)
end
player_msg_list[59] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TopListInsertInfo"] then
			API_Log("Err in deserialize message TopListInsertInfo: strus has changed!")
			return
		end
	end
	is_idx, msg.typ = Deserialize(is, is_idx, "number")
	is_idx, msg.data = Deserialize(is, is_idx, "string")
	is_idx, msg.data2 = Deserialize(is, is_idx, "string")

	OnMessage_TopListInsertInfo(player, role, msg, {})
end

--ClientTimeRequest
msg_list[60] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["ClientTimeRequest"] then
			API_Log("Err in deserialize message ClientTimeRequest: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_ClientTimeRequest(player, role, msg, others)
end
player_msg_list[60] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["ClientTimeRequest"] then
			API_Log("Err in deserialize message ClientTimeRequest: strus has changed!")
			return
		end
	end

	OnMessage_ClientTimeRequest(player, role, msg, {})
end

--TestYueZhanCreate
msg_list[61] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TestYueZhanCreate"] then
			API_Log("Err in deserialize message TestYueZhanCreate: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_TestYueZhanCreate(player, role, msg, others)
end
player_msg_list[61] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TestYueZhanCreate"] then
			API_Log("Err in deserialize message TestYueZhanCreate: strus has changed!")
			return
		end
	end

	OnMessage_TestYueZhanCreate(player, role, msg, {})
end

--TestYueZhanJoin
msg_list[62] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TestYueZhanJoin"] then
			API_Log("Err in deserialize message TestYueZhanJoin: strus has changed!")
			return
		end
	end
	is_idx, msg.room_id = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_TestYueZhanJoin(player, role, msg, others)
end
player_msg_list[62] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TestYueZhanJoin"] then
			API_Log("Err in deserialize message TestYueZhanJoin: strus has changed!")
			return
		end
	end
	is_idx, msg.room_id = Deserialize(is, is_idx, "number")

	OnMessage_TestYueZhanJoin(player, role, msg, {})
end

--YueZhanEnd
msg_list[63] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["YueZhanEnd"] then
			API_Log("Err in deserialize message YueZhanEnd: strus has changed!")
			return
		end
	end
	is_idx, msg.reason = Deserialize(is, is_idx, "number")
	is_idx, msg.typ = Deserialize(is, is_idx, "number")
	is_idx, msg.room_id = Deserialize(is, is_idx, "number")
	is_idx, msg.video_flag = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_YueZhanEnd(player, role, msg, others)
end
player_msg_list[63] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["YueZhanEnd"] then
			API_Log("Err in deserialize message YueZhanEnd: strus has changed!")
			return
		end
	end
	is_idx, msg.reason = Deserialize(is, is_idx, "number")
	is_idx, msg.typ = Deserialize(is, is_idx, "number")
	is_idx, msg.room_id = Deserialize(is, is_idx, "number")
	is_idx, msg.video_flag = Deserialize(is, is_idx, "number")

	OnMessage_YueZhanEnd(player, role, msg, {})
end

--UpdateDanMuInfo
msg_list[64] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["UpdateDanMuInfo"] then
			API_Log("Err in deserialize message UpdateDanMuInfo: strus has changed!")
			return
		end
	end
	is_idx, msg.role_id = Deserialize(is, is_idx, "string")
	is_idx, msg.role_name = Deserialize(is, is_idx, "string")
	is_idx, msg.tick = Deserialize(is, is_idx, "number")
	is_idx, msg.danmu_info = Deserialize(is, is_idx, "string")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_UpdateDanMuInfo(player, role, msg, others)
end
player_msg_list[64] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["UpdateDanMuInfo"] then
			API_Log("Err in deserialize message UpdateDanMuInfo: strus has changed!")
			return
		end
	end
	is_idx, msg.role_id = Deserialize(is, is_idx, "string")
	is_idx, msg.role_name = Deserialize(is, is_idx, "string")
	is_idx, msg.tick = Deserialize(is, is_idx, "number")
	is_idx, msg.danmu_info = Deserialize(is, is_idx, "string")

	OnMessage_UpdateDanMuInfo(player, role, msg, {})
end

--YueZhanInfo
msg_list[65] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["YueZhanInfo"] then
			API_Log("Err in deserialize message YueZhanInfo: strus has changed!")
			return
		end
	end
	is_idx, msg.id = Deserialize(is, is_idx, "number")
	is_idx, msg.channel = Deserialize(is, is_idx, "number")
	is_idx, msg.typ = Deserialize(is, is_idx, "number")
	is_idx, msg.creater = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, msg.joiner = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, msg.announce = Deserialize(is, is_idx, "string")
	is_idx, msg.info_id = Deserialize(is, is_idx, "string")
	is_idx, msg.time = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_YueZhanInfo(player, role, msg, others)
end
player_msg_list[65] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["YueZhanInfo"] then
			API_Log("Err in deserialize message YueZhanInfo: strus has changed!")
			return
		end
	end
	is_idx, msg.id = Deserialize(is, is_idx, "number")
	is_idx, msg.channel = Deserialize(is, is_idx, "number")
	is_idx, msg.typ = Deserialize(is, is_idx, "number")
	is_idx, msg.creater = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, msg.joiner = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, msg.announce = Deserialize(is, is_idx, "string")
	is_idx, msg.info_id = Deserialize(is, is_idx, "string")
	is_idx, msg.time = Deserialize(is, is_idx, "number")

	OnMessage_YueZhanInfo(player, role, msg, {})
end

--YueZhanUpdateState
msg_list[66] = 
function(is, is_idx, ud, api, msg, others, checksum)
	API = API_GetLuaAPISet(api)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["YueZhanUpdateState"] then
			API_Log("Err in deserialize message YueZhanUpdateState: strus has changed!")
			return
		end
	end
	is_idx, msg.typ = Deserialize(is, is_idx, "number")
	is_idx, msg.room_id = Deserialize(is, is_idx, "number")
	is_idx, msg.info = Deserialize(is, is_idx, "string")

	OnMessage_YueZhanUpdateState(msg, others)
end

--KickOut
msg_list[67] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["KickOut"] then
			API_Log("Err in deserialize message KickOut: strus has changed!")
			return
		end
	end
	is_idx, msg.reason = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_KickOut(player, role, msg, others)
end
player_msg_list[67] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["KickOut"] then
			API_Log("Err in deserialize message KickOut: strus has changed!")
			return
		end
	end
	is_idx, msg.reason = Deserialize(is, is_idx, "number")

	OnMessage_KickOut(player, role, msg, {})
end

--MafiaDeclarationBroadCast
msg_list[68] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaDeclarationBroadCast"] then
			API_Log("Err in deserialize message MafiaDeclarationBroadCast: strus has changed!")
			return
		end
	end
	is_idx, msg.mafia_id = Deserialize(is, is_idx, "string")
	is_idx, msg.mafia_name = Deserialize(is, is_idx, "string")
	is_idx, msg.info = Deserialize(is, is_idx, "string")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_MafiaDeclarationBroadCast(player, role, msg, others)
end
player_msg_list[68] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaDeclarationBroadCast"] then
			API_Log("Err in deserialize message MafiaDeclarationBroadCast: strus has changed!")
			return
		end
	end
	is_idx, msg.mafia_id = Deserialize(is, is_idx, "string")
	is_idx, msg.mafia_name = Deserialize(is, is_idx, "string")
	is_idx, msg.info = Deserialize(is, is_idx, "string")

	OnMessage_MafiaDeclarationBroadCast(player, role, msg, {})
end

--ChongZhi
msg_list[69] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["ChongZhi"] then
			API_Log("Err in deserialize message ChongZhi: strus has changed!")
			return
		end
	end
	is_idx, msg.money = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_ChongZhi(player, role, msg, others)
end
player_msg_list[69] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["ChongZhi"] then
			API_Log("Err in deserialize message ChongZhi: strus has changed!")
			return
		end
	end
	is_idx, msg.money = Deserialize(is, is_idx, "number")

	OnMessage_ChongZhi(player, role, msg, {})
end

--MafiaChat
msg_list[70] =
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaChat"] then
			API_Log("Err in deserialize message MafiaChat: strus has changed!")
			return
		end
	end
	is_idx, msg.src = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, msg.time = Deserialize(is, is_idx, "number")
	is_idx, msg.text_content = Deserialize(is, is_idx, "string")
	is_idx, msg.speech_content = Deserialize(is, is_idx, "string")
	is_idx, msg.channel = Deserialize(is, is_idx, "number")
	is_idx, msg.chat_typ = Deserialize(is, is_idx, "number")

	local mafia = API_GetLuaMafia(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_MafiaChat(mafia, msg, others)
end

--MafiaYueZhan
msg_list[71] =
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MafiaYueZhan"] then
			API_Log("Err in deserialize message MafiaYueZhan: strus has changed!")
			return
		end
	end
	is_idx, msg.id = Deserialize(is, is_idx, "number")
	is_idx, msg.channel = Deserialize(is, is_idx, "number")
	is_idx, msg.typ = Deserialize(is, is_idx, "number")
	is_idx, msg.creater = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, msg.joiner = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, msg.announce = Deserialize(is, is_idx, "string")
	is_idx, msg.info_id = Deserialize(is, is_idx, "string")
	is_idx, msg.time = Deserialize(is, is_idx, "number")

	local mafia = API_GetLuaMafia(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_MafiaYueZhan(mafia, msg, others)
end

--AudienceUpdateNum
msg_list[72] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["AudienceUpdateNum"] then
			API_Log("Err in deserialize message AudienceUpdateNum: strus has changed!")
			return
		end
	end
	is_idx, msg.num = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_AudienceUpdateNum(player, role, msg, others)
end
player_msg_list[72] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["AudienceUpdateNum"] then
			API_Log("Err in deserialize message AudienceUpdateNum: strus has changed!")
			return
		end
	end
	is_idx, msg.num = Deserialize(is, is_idx, "number")

	OnMessage_AudienceUpdateNum(player, role, msg, {})
end

--TowerUpdateRoleRank
msg_list[73] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TowerUpdateRoleRank"] then
			API_Log("Err in deserialize message TowerUpdateRoleRank: strus has changed!")
			return
		end
	end
	is_idx, msg.rank = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_TowerUpdateRoleRank(player, role, msg, others)
end
player_msg_list[73] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TowerUpdateRoleRank"] then
			API_Log("Err in deserialize message TowerUpdateRoleRank: strus has changed!")
			return
		end
	end
	is_idx, msg.rank = Deserialize(is, is_idx, "number")

	OnMessage_TowerUpdateRoleRank(player, role, msg, {})
end

--TestFloat
msg_list[81] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TestFloat"] then
			API_Log("Err in deserialize message TestFloat: strus has changed!")
			return
		end
	end
	is_idx, msg.seed = Deserialize(is, is_idx, "number")
	is_idx, msg.count = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_TestFloat(player, role, msg, others)
end
player_msg_list[81] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TestFloat"] then
			API_Log("Err in deserialize message TestFloat: strus has changed!")
			return
		end
	end
	is_idx, msg.seed = Deserialize(is, is_idx, "number")
	is_idx, msg.count = Deserialize(is, is_idx, "number")

	OnMessage_TestFloat(player, role, msg, {})
end

--CheckServerReward
msg_list[82] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["CheckServerReward"] then
			API_Log("Err in deserialize message CheckServerReward: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_CheckServerReward(player, role, msg, others)
end
player_msg_list[82] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["CheckServerReward"] then
			API_Log("Err in deserialize message CheckServerReward: strus has changed!")
			return
		end
	end

	OnMessage_CheckServerReward(player, role, msg, {})
end

--SyncNetTime
msg_list[83] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["SyncNetTime"] then
			API_Log("Err in deserialize message SyncNetTime: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_SyncNetTime(player, role, msg, others)
end
player_msg_list[83] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["SyncNetTime"] then
			API_Log("Err in deserialize message SyncNetTime: strus has changed!")
			return
		end
	end

	OnMessage_SyncNetTime(player, role, msg, {})
end

--UpdateSpecialTask
msg_list[84] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["UpdateSpecialTask"] then
			API_Log("Err in deserialize message UpdateSpecialTask: strus has changed!")
			return
		end
	end
	is_idx, msg.hero_tupo = Deserialize(is, is_idx, "boolean")
	is_idx, msg.hero_star = Deserialize(is, is_idx, "boolean")
	is_idx, msg.weapon_level = Deserialize(is, is_idx, "boolean")
	is_idx, msg.equip_level = Deserialize(is, is_idx, "boolean")
	is_idx, msg.pverank = Deserialize(is, is_idx, "boolean")
	is_idx, msg.pvpgrade = Deserialize(is, is_idx, "boolean")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_UpdateSpecialTask(player, role, msg, others)
end
player_msg_list[84] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["UpdateSpecialTask"] then
			API_Log("Err in deserialize message UpdateSpecialTask: strus has changed!")
			return
		end
	end
	is_idx, msg.hero_tupo = Deserialize(is, is_idx, "boolean")
	is_idx, msg.hero_star = Deserialize(is, is_idx, "boolean")
	is_idx, msg.weapon_level = Deserialize(is, is_idx, "boolean")
	is_idx, msg.equip_level = Deserialize(is, is_idx, "boolean")
	is_idx, msg.pverank = Deserialize(is, is_idx, "boolean")
	is_idx, msg.pvpgrade = Deserialize(is, is_idx, "boolean")

	OnMessage_UpdateSpecialTask(player, role, msg, {})
end

--GMCmd_GetChar
msg_list[11000] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["GMCmd_GetChar"] then
			API_Log("Err in deserialize message GMCmd_GetChar: strus has changed!")
			return
		end
	end
	is_idx, msg.session_id = Deserialize(is, is_idx, "number")
	is_idx, msg.sid = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_GMCmd_GetChar(player, role, msg, others)
end
player_msg_list[11000] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["GMCmd_GetChar"] then
			API_Log("Err in deserialize message GMCmd_GetChar: strus has changed!")
			return
		end
	end
	is_idx, msg.session_id = Deserialize(is, is_idx, "number")
	is_idx, msg.sid = Deserialize(is, is_idx, "number")

	OnMessage_GMCmd_GetChar(player, role, msg, {})
end

--GMCmd_MailTextToPlayer
msg_list[11001] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["GMCmd_MailTextToPlayer"] then
			API_Log("Err in deserialize message GMCmd_MailTextToPlayer: strus has changed!")
			return
		end
	end
	is_idx, msg.mailtitle = Deserialize(is, is_idx, "string")
	is_idx, msg.mailcontent = Deserialize(is, is_idx, "string")
	is_idx, msg.session_id = Deserialize(is, is_idx, "number")
	is_idx, msg.sid = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_GMCmd_MailTextToPlayer(player, role, msg, others)
end
player_msg_list[11001] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["GMCmd_MailTextToPlayer"] then
			API_Log("Err in deserialize message GMCmd_MailTextToPlayer: strus has changed!")
			return
		end
	end
	is_idx, msg.mailtitle = Deserialize(is, is_idx, "string")
	is_idx, msg.mailcontent = Deserialize(is, is_idx, "string")
	is_idx, msg.session_id = Deserialize(is, is_idx, "number")
	is_idx, msg.sid = Deserialize(is, is_idx, "number")

	OnMessage_GMCmd_MailTextToPlayer(player, role, msg, {})
end

--GMCmd_Bull
msg_list[11002] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["GMCmd_Bull"] then
			API_Log("Err in deserialize message GMCmd_Bull: strus has changed!")
			return
		end
	end
	is_idx, msg.text = Deserialize(is, is_idx, "string")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_GMCmd_Bull(player, role, msg, others)
end
player_msg_list[11002] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["GMCmd_Bull"] then
			API_Log("Err in deserialize message GMCmd_Bull: strus has changed!")
			return
		end
	end
	is_idx, msg.text = Deserialize(is, is_idx, "string")

	OnMessage_GMCmd_Bull(player, role, msg, {})
end

--GMCmd_AddForbidLogin
msg_list[11003] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["GMCmd_AddForbidLogin"] then
			API_Log("Err in deserialize message GMCmd_AddForbidLogin: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_GMCmd_AddForbidLogin(player, role, msg, others)
end
player_msg_list[11003] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["GMCmd_AddForbidLogin"] then
			API_Log("Err in deserialize message GMCmd_AddForbidLogin: strus has changed!")
			return
		end
	end

	OnMessage_GMCmd_AddForbidLogin(player, role, msg, {})
end

--GMCmd_MailToPlayer
msg_list[11004] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["GMCmd_MailToPlayer"] then
			API_Log("Err in deserialize message GMCmd_MailToPlayer: strus has changed!")
			return
		end
	end
	is_idx, msg.mailid = Deserialize(is, is_idx, "number")
	is_idx, msg.session_id = Deserialize(is, is_idx, "number")
	is_idx, msg.sid = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_GMCmd_MailToPlayer(player, role, msg, others)
end
player_msg_list[11004] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["GMCmd_MailToPlayer"] then
			API_Log("Err in deserialize message GMCmd_MailToPlayer: strus has changed!")
			return
		end
	end
	is_idx, msg.mailid = Deserialize(is, is_idx, "number")
	is_idx, msg.session_id = Deserialize(is, is_idx, "number")
	is_idx, msg.sid = Deserialize(is, is_idx, "number")

	OnMessage_GMCmd_MailToPlayer(player, role, msg, {})
end

--Pay
msg_list[11005] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["Pay"] then
			API_Log("Err in deserialize message Pay: strus has changed!")
			return
		end
	end
	is_idx, msg.id = Deserialize(is, is_idx, "number")
	is_idx, msg.order = Deserialize(is, is_idx, "string")
	is_idx, msg.amount = Deserialize(is, is_idx, "number")
	is_idx, msg.sid = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_Pay(player, role, msg, others)
end
player_msg_list[11005] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["Pay"] then
			API_Log("Err in deserialize message Pay: strus has changed!")
			return
		end
	end
	is_idx, msg.id = Deserialize(is, is_idx, "number")
	is_idx, msg.order = Deserialize(is, is_idx, "string")
	is_idx, msg.amount = Deserialize(is, is_idx, "number")
	is_idx, msg.sid = Deserialize(is, is_idx, "number")

	OnMessage_Pay(player, role, msg, {})
end

--CreateRoleResult
msg_list[10001] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["CreateRoleResult"] then
			API_Log("Err in deserialize message CreateRoleResult: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_CreateRoleResult(player, role, msg, others)
end
player_msg_list[10001] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["CreateRoleResult"] then
			API_Log("Err in deserialize message CreateRoleResult: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")

	OnMessage_CreateRoleResult(player, role, msg, {})
end

--Heartbeat
msg_list[10002] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["Heartbeat"] then
			API_Log("Err in deserialize message Heartbeat: strus has changed!")
			return
		end
	end
	is_idx, msg.now = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_Heartbeat(player, role, msg, others)
end
player_msg_list[10002] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["Heartbeat"] then
			API_Log("Err in deserialize message Heartbeat: strus has changed!")
			return
		end
	end
	is_idx, msg.now = Deserialize(is, is_idx, "number")

	OnMessage_Heartbeat(player, role, msg, {})
end

--CreateMafiaResult
msg_list[10003] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["CreateMafiaResult"] then
			API_Log("Err in deserialize message CreateMafiaResult: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")
	is_idx, msg.create_time = Deserialize(is, is_idx, "number")
	is_idx, msg.name = Deserialize(is, is_idx, "string")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_CreateMafiaResult(player, role, msg, others)
end
player_msg_list[10003] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["CreateMafiaResult"] then
			API_Log("Err in deserialize message CreateMafiaResult: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")
	is_idx, msg.create_time = Deserialize(is, is_idx, "number")
	is_idx, msg.name = Deserialize(is, is_idx, "string")

	OnMessage_CreateMafiaResult(player, role, msg, {})
end

--PVPHeartbeat
msg_list[10004] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PVPHeartbeat"] then
			API_Log("Err in deserialize message PVPHeartbeat: strus has changed!")
			return
		end
	end
	is_idx, msg.now = Deserialize(is, is_idx, "number")

	local pvp = API_GetLuaPVP(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_PVPHeartbeat(pvp, msg, others)
end

--PVPTriggerSend
msg_list[10005] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PVPTriggerSend"] then
			API_Log("Err in deserialize message PVPTriggerSend: strus has changed!")
			return
		end
	end

	local pvp = API_GetLuaPVP(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_PVPTriggerSend(pvp, msg, others)
end

--DBHeartbeat
msg_list[10006] = 
function(is, is_idx, ud, api, msg, others, checksum)
	local playermap = CACHE.PlayerManager:GetInstance()
	API = API_GetLuaAPISet(api)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["DBHeartbeat"] then
			API_Log("Err in deserialize message DBHeartbeat: strus has changed!")
			return
		end
	end

	OnMessage_DBHeartbeat(playermap, msg)
end

--ReloadLua
msg_list[10007] = 
function(is, is_idx, ud, api, msg, others, checksum)
	local playermap = CACHE.PlayerManager:GetInstance()
	API = API_GetLuaAPISet(api)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["ReloadLua"] then
			API_Log("Err in deserialize message ReloadLua: strus has changed!")
			return
		end
	end

	OnMessage_ReloadLua(playermap, msg)
end

--PVPCreateResult
msg_list[10008] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PVPCreateResult"] then
			API_Log("Err in deserialize message PVPCreateResult: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")

	local pvp = API_GetLuaPVP(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_PVPCreateResult(pvp, msg, others)
end

--PVPEnd
msg_list[10009] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PVPEnd"] then
			API_Log("Err in deserialize message PVPEnd: strus has changed!")
			return
		end
	end
	is_idx, msg.reason = Deserialize(is, is_idx, "number")

	local pvp = API_GetLuaPVP(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_PVPEnd(pvp, msg, others)
end

--PVPMatchSuccess
msg_list[10010] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PVPMatchSuccess"] then
			API_Log("Err in deserialize message PVPMatchSuccess: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")
	is_idx, msg.index = Deserialize(is, is_idx, "number")
	is_idx, msg.time = Deserialize(is, is_idx, "number")
	is_idx, msg.room_id = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_PVPMatchSuccess(player, role, msg, others)
end
player_msg_list[10010] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PVPMatchSuccess"] then
			API_Log("Err in deserialize message PVPMatchSuccess: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")
	is_idx, msg.index = Deserialize(is, is_idx, "number")
	is_idx, msg.time = Deserialize(is, is_idx, "number")
	is_idx, msg.room_id = Deserialize(is, is_idx, "number")

	OnMessage_PVPMatchSuccess(player, role, msg, {})
end

--PVPJoinRe
msg_list[10011] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PVPJoinRe"] then
			API_Log("Err in deserialize message PVPJoinRe: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_PVPJoinRe(player, role, msg, others)
end
player_msg_list[10011] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PVPJoinRe"] then
			API_Log("Err in deserialize message PVPJoinRe: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")

	OnMessage_PVPJoinRe(player, role, msg, {})
end

--PVPEnterRe
msg_list[10012] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PVPEnterRe"] then
			API_Log("Err in deserialize message PVPEnterRe: strus has changed!")
			return
		end
	end
	is_idx, msg.role_pvpinfo = Deserialize(is, is_idx, "string")
	is_idx, msg.fight_pvpinfo = Deserialize(is, is_idx, "string")
	is_idx, msg.robot_flag = Deserialize(is, is_idx, "number")
	is_idx, msg.robot_seed = Deserialize(is, is_idx, "number")
	is_idx, msg.robot_type = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_PVPEnterRe(player, role, msg, others)
end
player_msg_list[10012] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PVPEnterRe"] then
			API_Log("Err in deserialize message PVPEnterRe: strus has changed!")
			return
		end
	end
	is_idx, msg.role_pvpinfo = Deserialize(is, is_idx, "string")
	is_idx, msg.fight_pvpinfo = Deserialize(is, is_idx, "string")
	is_idx, msg.robot_flag = Deserialize(is, is_idx, "number")
	is_idx, msg.robot_seed = Deserialize(is, is_idx, "number")
	is_idx, msg.robot_type = Deserialize(is, is_idx, "number")

	OnMessage_PVPEnterRe(player, role, msg, {})
end

--PvpBegin
msg_list[10013] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PvpBegin"] then
			API_Log("Err in deserialize message PvpBegin: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")
	is_idx, msg.start_time = Deserialize(is, is_idx, "number")
	is_idx, msg.ip = Deserialize(is, is_idx, "string")
	is_idx, msg.port = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_PvpBegin(player, role, msg, others)
end
player_msg_list[10013] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PvpBegin"] then
			API_Log("Err in deserialize message PvpBegin: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")
	is_idx, msg.start_time = Deserialize(is, is_idx, "number")
	is_idx, msg.ip = Deserialize(is, is_idx, "string")
	is_idx, msg.port = Deserialize(is, is_idx, "number")

	OnMessage_PvpBegin(player, role, msg, {})
end

--PvpEnd
msg_list[10014] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PvpEnd"] then
			API_Log("Err in deserialize message PvpEnd: strus has changed!")
			return
		end
	end
	is_idx, msg.reason = Deserialize(is, is_idx, "number")
	is_idx, msg.typ = Deserialize(is, is_idx, "number")
	is_idx, msg.score = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_PvpEnd(player, role, msg, others)
end
player_msg_list[10014] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PvpEnd"] then
			API_Log("Err in deserialize message PvpEnd: strus has changed!")
			return
		end
	end
	is_idx, msg.reason = Deserialize(is, is_idx, "number")
	is_idx, msg.typ = Deserialize(is, is_idx, "number")
	is_idx, msg.score = Deserialize(is, is_idx, "number")

	OnMessage_PvpEnd(player, role, msg, {})
end

--PvpCancle
msg_list[10015] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PvpCancle"] then
			API_Log("Err in deserialize message PvpCancle: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_PvpCancle(player, role, msg, others)
end
player_msg_list[10015] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PvpCancle"] then
			API_Log("Err in deserialize message PvpCancle: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")

	OnMessage_PvpCancle(player, role, msg, {})
end

--PvpError
msg_list[10016] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PvpError"] then
			API_Log("Err in deserialize message PvpError: strus has changed!")
			return
		end
	end
	is_idx, msg.result = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_PvpError(player, role, msg, others)
end
player_msg_list[10016] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PvpError"] then
			API_Log("Err in deserialize message PvpError: strus has changed!")
			return
		end
	end
	is_idx, msg.result = Deserialize(is, is_idx, "number")

	OnMessage_PvpError(player, role, msg, {})
end

--PvpSpeed
msg_list[10017] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PvpSpeed"] then
			API_Log("Err in deserialize message PvpSpeed: strus has changed!")
			return
		end
	end
	is_idx, msg.speed = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_PvpSpeed(player, role, msg, others)
end
player_msg_list[10017] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PvpSpeed"] then
			API_Log("Err in deserialize message PvpSpeed: strus has changed!")
			return
		end
	end
	is_idx, msg.speed = Deserialize(is, is_idx, "number")

	OnMessage_PvpSpeed(player, role, msg, {})
end

--PvpReset
msg_list[10018] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PvpReset"] then
			API_Log("Err in deserialize message PvpReset: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_PvpReset(player, role, msg, others)
end
player_msg_list[10018] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PvpReset"] then
			API_Log("Err in deserialize message PvpReset: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")

	OnMessage_PvpReset(player, role, msg, {})
end

--SendNotice
msg_list[10019] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["SendNotice"] then
			API_Log("Err in deserialize message SendNotice: strus has changed!")
			return
		end
	end
	is_idx, msg.notice_id = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	msg.notice_para = {}
	for i = 1, count do
		is_idx, msg.notice_para[i] = DeserializeStruct(is, is_idx, "NoticeParaInfo")
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_SendNotice(player, role, msg, others)
end
player_msg_list[10019] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["SendNotice"] then
			API_Log("Err in deserialize message SendNotice: strus has changed!")
			return
		end
	end
	is_idx, msg.notice_id = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	msg.notice_para = {}
	for i = 1, count do
		is_idx, msg.notice_para[i] = DeserializeStruct(is, is_idx, "NoticeParaInfo")
	end

	OnMessage_SendNotice(player, role, msg, {})
end

--TopListHeartBeat
msg_list[10020] = 
function(is, is_idx, ud, api, msg, others, checksum)
	API = API_GetLuaAPISet(api)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TopListHeartBeat"] then
			API_Log("Err in deserialize message TopListHeartBeat: strus has changed!")
			return
		end
	end

	OnMessage_TopListHeartBeat(msg, others)
end

--PvpVideoID
msg_list[10021] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PvpVideoID"] then
			API_Log("Err in deserialize message PvpVideoID: strus has changed!")
			return
		end
	end
	is_idx, msg.video_id = Deserialize(is, is_idx, "string")
	is_idx, msg.first_pvpinfo = Deserialize(is, is_idx, "string")
	is_idx, msg.second_pvpinfo = Deserialize(is, is_idx, "string")
	is_idx, msg.win_flag = Deserialize(is, is_idx, "number")
	is_idx, msg.match_pvp = Deserialize(is, is_idx, "number")
	is_idx, msg.score = Deserialize(is, is_idx, "number")
	is_idx, msg.duration = Deserialize(is, is_idx, "number")
	is_idx, msg.robot_flag = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_PvpVideoID(player, role, msg, others)
end
player_msg_list[10021] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PvpVideoID"] then
			API_Log("Err in deserialize message PvpVideoID: strus has changed!")
			return
		end
	end
	is_idx, msg.video_id = Deserialize(is, is_idx, "string")
	is_idx, msg.first_pvpinfo = Deserialize(is, is_idx, "string")
	is_idx, msg.second_pvpinfo = Deserialize(is, is_idx, "string")
	is_idx, msg.win_flag = Deserialize(is, is_idx, "number")
	is_idx, msg.match_pvp = Deserialize(is, is_idx, "number")
	is_idx, msg.score = Deserialize(is, is_idx, "number")
	is_idx, msg.duration = Deserialize(is, is_idx, "number")
	is_idx, msg.robot_flag = Deserialize(is, is_idx, "number")

	OnMessage_PvpVideoID(player, role, msg, {})
end

--PvpGetVideoErr
msg_list[10022] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PvpGetVideoErr"] then
			API_Log("Err in deserialize message PvpGetVideoErr: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_PvpGetVideoErr(player, role, msg, others)
end
player_msg_list[10022] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PvpGetVideoErr"] then
			API_Log("Err in deserialize message PvpGetVideoErr: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")

	OnMessage_PvpGetVideoErr(player, role, msg, {})
end

--PvpGetVideo
msg_list[10023] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PvpGetVideo"] then
			API_Log("Err in deserialize message PvpGetVideo: strus has changed!")
			return
		end
	end
	is_idx, msg.first = Deserialize(is, is_idx, "string")
	is_idx, msg.second = Deserialize(is, is_idx, "string")
	is_idx, msg.first_pvpinfo = Deserialize(is, is_idx, "string")
	is_idx, msg.second_pvpinfo = Deserialize(is, is_idx, "string")
	is_idx, msg.operation = Deserialize(is, is_idx, "string")
	is_idx, msg.win_flag = Deserialize(is, is_idx, "number")
	is_idx, msg.robot_flag = Deserialize(is, is_idx, "number")
	is_idx, msg.robot_seed = Deserialize(is, is_idx, "number")
	is_idx, msg.robot_type = Deserialize(is, is_idx, "number")
	is_idx, msg.pvp_ver = Deserialize(is, is_idx, "number")
	is_idx, msg.exe_ver = Deserialize(is, is_idx, "string")
	is_idx, msg.data_ver = Deserialize(is, is_idx, "string")
	is_idx, msg.danmu_info = Deserialize(is, is_idx, "string")
	is_idx, msg.video_id = Deserialize(is, is_idx, "string")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_PvpGetVideo(player, role, msg, others)
end
player_msg_list[10023] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PvpGetVideo"] then
			API_Log("Err in deserialize message PvpGetVideo: strus has changed!")
			return
		end
	end
	is_idx, msg.first = Deserialize(is, is_idx, "string")
	is_idx, msg.second = Deserialize(is, is_idx, "string")
	is_idx, msg.first_pvpinfo = Deserialize(is, is_idx, "string")
	is_idx, msg.second_pvpinfo = Deserialize(is, is_idx, "string")
	is_idx, msg.operation = Deserialize(is, is_idx, "string")
	is_idx, msg.win_flag = Deserialize(is, is_idx, "number")
	is_idx, msg.robot_flag = Deserialize(is, is_idx, "number")
	is_idx, msg.robot_seed = Deserialize(is, is_idx, "number")
	is_idx, msg.robot_type = Deserialize(is, is_idx, "number")
	is_idx, msg.pvp_ver = Deserialize(is, is_idx, "number")
	is_idx, msg.exe_ver = Deserialize(is, is_idx, "string")
	is_idx, msg.data_ver = Deserialize(is, is_idx, "string")
	is_idx, msg.danmu_info = Deserialize(is, is_idx, "string")
	is_idx, msg.video_id = Deserialize(is, is_idx, "string")

	OnMessage_PvpGetVideo(player, role, msg, {})
end

--SendMail
msg_list[10024] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["SendMail"] then
			API_Log("Err in deserialize message SendMail: strus has changed!")
			return
		end
	end
	is_idx, msg.mail_id = Deserialize(is, is_idx, "number")
	is_idx, msg.mafia_mail_id = Deserialize(is, is_idx, "number")
	is_idx, msg.arg1 = Deserialize(is, is_idx, "string")
	is_idx, msg.title = Deserialize(is, is_idx, "string")
	is_idx, msg.content = Deserialize(is, is_idx, "string")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_SendMail(player, role, msg, others)
end
player_msg_list[10024] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["SendMail"] then
			API_Log("Err in deserialize message SendMail: strus has changed!")
			return
		end
	end
	is_idx, msg.mail_id = Deserialize(is, is_idx, "number")
	is_idx, msg.mafia_mail_id = Deserialize(is, is_idx, "number")
	is_idx, msg.arg1 = Deserialize(is, is_idx, "string")
	is_idx, msg.title = Deserialize(is, is_idx, "string")
	is_idx, msg.content = Deserialize(is, is_idx, "string")

	OnMessage_SendMail(player, role, msg, {})
end

--SendServerEvent
msg_list[10025] = 
function(is, is_idx, ud, api, msg, others, checksum)
	API = API_GetLuaAPISet(api)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["SendServerEvent"] then
			API_Log("Err in deserialize message SendServerEvent: strus has changed!")
			return
		end
	end
	is_idx, msg.event_type = Deserialize(is, is_idx, "number")
	is_idx, msg.end_time = Deserialize(is, is_idx, "number")

	OnMessage_SendServerEvent(msg, others)
end

--RoleUpdateServerEvent
msg_list[10026] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdateServerEvent"] then
			API_Log("Err in deserialize message RoleUpdateServerEvent: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_RoleUpdateServerEvent(player, role, msg, others)
end
player_msg_list[10026] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdateServerEvent"] then
			API_Log("Err in deserialize message RoleUpdateServerEvent: strus has changed!")
			return
		end
	end

	OnMessage_RoleUpdateServerEvent(player, role, msg, {})
end

--OpenServer
msg_list[10027] = 
function(is, is_idx, ud, api, msg, others, checksum)
	local playermap = CACHE.PlayerManager:GetInstance()
	API = API_GetLuaAPISet(api)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["OpenServer"] then
			API_Log("Err in deserialize message OpenServer: strus has changed!")
			return
		end
	end

	OnMessage_OpenServer(playermap, msg)
end

--MiscHeartBeat
msg_list[10028] = 
function(is, is_idx, ud, api, msg, others, checksum)
	API = API_GetLuaAPISet(api)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["MiscHeartBeat"] then
			API_Log("Err in deserialize message MiscHeartBeat: strus has changed!")
			return
		end
	end

	OnMessage_MiscHeartBeat(msg, others)
end

--PvpSeasonFinish
msg_list[10029] = 
function(is, is_idx, ud, api, msg, others, checksum)
	API = API_GetLuaAPISet(api)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PvpSeasonFinish"] then
			API_Log("Err in deserialize message PvpSeasonFinish: strus has changed!")
			return
		end
	end

	OnMessage_PvpSeasonFinish(msg, others)
end

--RoleUpdatePvpEndTime
msg_list[10030] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdatePvpEndTime"] then
			API_Log("Err in deserialize message RoleUpdatePvpEndTime: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_RoleUpdatePvpEndTime(player, role, msg, others)
end
player_msg_list[10030] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdatePvpEndTime"] then
			API_Log("Err in deserialize message RoleUpdatePvpEndTime: strus has changed!")
			return
		end
	end

	OnMessage_RoleUpdatePvpEndTime(player, role, msg, {})
end

--RoleUpdateLevelTop
msg_list[10031] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdateLevelTop"] then
			API_Log("Err in deserialize message RoleUpdateLevelTop: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_RoleUpdateLevelTop(player, role, msg, others)
end
player_msg_list[10031] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdateLevelTop"] then
			API_Log("Err in deserialize message RoleUpdateLevelTop: strus has changed!")
			return
		end
	end

	OnMessage_RoleUpdateLevelTop(player, role, msg, {})
end

--BroadcastPvpVideo
msg_list[10032] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["BroadcastPvpVideo"] then
			API_Log("Err in deserialize message BroadcastPvpVideo: strus has changed!")
			return
		end
	end
	is_idx, msg.typ = Deserialize(is, is_idx, "number")
	is_idx, msg.src = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, msg.content = Deserialize(is, is_idx, "string")
	is_idx, msg.video_id = Deserialize(is, is_idx, "string")
	is_idx, msg.player1 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
	is_idx, msg.player2 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
	is_idx, msg.time = Deserialize(is, is_idx, "number")
	is_idx, msg.win_flag = Deserialize(is, is_idx, "number")
	is_idx, msg.channel = Deserialize(is, is_idx, "number")
	is_idx, msg.match_pvp = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_BroadcastPvpVideo(player, role, msg, others)
end
player_msg_list[10032] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["BroadcastPvpVideo"] then
			API_Log("Err in deserialize message BroadcastPvpVideo: strus has changed!")
			return
		end
	end
	is_idx, msg.typ = Deserialize(is, is_idx, "number")
	is_idx, msg.src = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, msg.content = Deserialize(is, is_idx, "string")
	is_idx, msg.video_id = Deserialize(is, is_idx, "string")
	is_idx, msg.player1 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
	is_idx, msg.player2 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
	is_idx, msg.time = Deserialize(is, is_idx, "number")
	is_idx, msg.win_flag = Deserialize(is, is_idx, "number")
	is_idx, msg.channel = Deserialize(is, is_idx, "number")
	is_idx, msg.match_pvp = Deserialize(is, is_idx, "number")

	OnMessage_BroadcastPvpVideo(player, role, msg, {})
end

--RoleUpdateTopList
msg_list[10033] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdateTopList"] then
			API_Log("Err in deserialize message RoleUpdateTopList: strus has changed!")
			return
		end
	end
	is_idx, msg.top_type = Deserialize(is, is_idx, "number")
	is_idx, msg.data = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_RoleUpdateTopList(player, role, msg, others)
end
player_msg_list[10033] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["RoleUpdateTopList"] then
			API_Log("Err in deserialize message RoleUpdateTopList: strus has changed!")
			return
		end
	end
	is_idx, msg.top_type = Deserialize(is, is_idx, "number")
	is_idx, msg.data = Deserialize(is, is_idx, "number")

	OnMessage_RoleUpdateTopList(player, role, msg, {})
end

--PVPPause
msg_list[10034] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PVPPause"] then
			API_Log("Err in deserialize message PVPPause: strus has changed!")
			return
		end
	end
	is_idx, msg.pause_tick = Deserialize(is, is_idx, "number")
	is_idx, msg.role_id = Deserialize(is, is_idx, "string")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	msg.cmds = {}
	for i = 1, count do
		is_idx, msg.cmds[i] = Deserialize(is, is_idx, "string")
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_PVPPause(player, role, msg, others)
end
player_msg_list[10034] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PVPPause"] then
			API_Log("Err in deserialize message PVPPause: strus has changed!")
			return
		end
	end
	is_idx, msg.pause_tick = Deserialize(is, is_idx, "number")
	is_idx, msg.role_id = Deserialize(is, is_idx, "string")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	msg.cmds = {}
	for i = 1, count do
		is_idx, msg.cmds[i] = Deserialize(is, is_idx, "string")
	end

	OnMessage_PVPPause(player, role, msg, {})
end

--PVPContinue
msg_list[10035] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PVPContinue"] then
			API_Log("Err in deserialize message PVPContinue: strus has changed!")
			return
		end
	end
	is_idx, msg.continue_time = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_PVPContinue(player, role, msg, others)
end
player_msg_list[10035] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PVPContinue"] then
			API_Log("Err in deserialize message PVPContinue: strus has changed!")
			return
		end
	end
	is_idx, msg.continue_time = Deserialize(is, is_idx, "number")

	OnMessage_PVPContinue(player, role, msg, {})
end

--ChangeRoleName
msg_list[10036] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["ChangeRoleName"] then
			API_Log("Err in deserialize message ChangeRoleName: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")
	is_idx, msg.name = Deserialize(is, is_idx, "string")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_ChangeRoleName(player, role, msg, others)
end
player_msg_list[10036] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["ChangeRoleName"] then
			API_Log("Err in deserialize message ChangeRoleName: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")
	is_idx, msg.name = Deserialize(is, is_idx, "string")

	OnMessage_ChangeRoleName(player, role, msg, {})
end

--ActiveCodeResult
msg_list[10037] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["ActiveCodeResult"] then
			API_Log("Err in deserialize message ActiveCodeResult: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")
	is_idx, msg.type = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_ActiveCodeResult(player, role, msg, others)
end
player_msg_list[10037] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["ActiveCodeResult"] then
			API_Log("Err in deserialize message ActiveCodeResult: strus has changed!")
			return
		end
	end
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")
	is_idx, msg.type = Deserialize(is, is_idx, "number")

	OnMessage_ActiveCodeResult(player, role, msg, {})
end

--CloseServer
msg_list[10300] = 
function(is, is_idx, ud, api, msg, others, checksum)
	local playermap = CACHE.PlayerManager:GetInstance()
	API = API_GetLuaAPISet(api)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["CloseServer"] then
			API_Log("Err in deserialize message CloseServer: strus has changed!")
			return
		end
	end
	is_idx, msg.sid = Deserialize(is, is_idx, "number")

	OnMessage_CloseServer(playermap, msg)
end

--PublicChatnew
msg_list[10100] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PublicChatnew"] then
			API_Log("Err in deserialize message PublicChatnew: strus has changed!")
			return
		end
	end
	is_idx, msg.src = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, msg.time = Deserialize(is, is_idx, "number")
	is_idx, msg.text_content = Deserialize(is, is_idx, "string")
	is_idx, msg.speech_content = Deserialize(is, is_idx, "string")
	is_idx, msg.channel = Deserialize(is, is_idx, "number")
	is_idx, msg.chat_typ = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_PublicChatnew(player, role, msg, others)
end
player_msg_list[10100] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PublicChatnew"] then
			API_Log("Err in deserialize message PublicChatnew: strus has changed!")
			return
		end
	end
	is_idx, msg.src = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, msg.time = Deserialize(is, is_idx, "number")
	is_idx, msg.text_content = Deserialize(is, is_idx, "string")
	is_idx, msg.speech_content = Deserialize(is, is_idx, "string")
	is_idx, msg.channel = Deserialize(is, is_idx, "number")
	is_idx, msg.chat_typ = Deserialize(is, is_idx, "number")

	OnMessage_PublicChatnew(player, role, msg, {})
end

--PrivateChatnew
msg_list[10101] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PrivateChatnew"] then
			API_Log("Err in deserialize message PrivateChatnew: strus has changed!")
			return
		end
	end
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
	is_idx, msg.typ = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_PrivateChatnew(player, role, msg, others)
end
player_msg_list[10101] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["PrivateChatnew"] then
			API_Log("Err in deserialize message PrivateChatnew: strus has changed!")
			return
		end
	end
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
	is_idx, msg.typ = Deserialize(is, is_idx, "number")

	OnMessage_PrivateChatnew(player, role, msg, {})
end

--BroadCastPublicChat
msg_list[10102] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["BroadCastPublicChat"] then
			API_Log("Err in deserialize message BroadCastPublicChat: strus has changed!")
			return
		end
	end
	is_idx, msg.time = Deserialize(is, is_idx, "number")
	is_idx, msg.text_content = Deserialize(is, is_idx, "string")
	is_idx, msg.speech_content = Deserialize(is, is_idx, "string")
	is_idx, msg.channel = Deserialize(is, is_idx, "number")
	is_idx, msg.chat_typ = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_BroadCastPublicChat(player, role, msg, others)
end
player_msg_list[10102] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["BroadCastPublicChat"] then
			API_Log("Err in deserialize message BroadCastPublicChat: strus has changed!")
			return
		end
	end
	is_idx, msg.time = Deserialize(is, is_idx, "number")
	is_idx, msg.text_content = Deserialize(is, is_idx, "string")
	is_idx, msg.speech_content = Deserialize(is, is_idx, "string")
	is_idx, msg.channel = Deserialize(is, is_idx, "number")
	is_idx, msg.chat_typ = Deserialize(is, is_idx, "number")

	OnMessage_BroadCastPublicChat(player, role, msg, {})
end

--TestMessage1
msg_list[90001] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TestMessage1"] then
			API_Log("Err in deserialize message TestMessage1: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_TestMessage1(player, role, msg, others)
end
player_msg_list[90001] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TestMessage1"] then
			API_Log("Err in deserialize message TestMessage1: strus has changed!")
			return
		end
	end

	OnMessage_TestMessage1(player, role, msg, {})
end

--TestMessage2
msg_list[90002] =
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TestMessage2"] then
			API_Log("Err in deserialize message TestMessage2: strus has changed!")
			return
		end
	end

	local mafia = API_GetLuaMafia(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_TestMessage2(mafia, msg, others)
end

--TestMessage3
msg_list[90003] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TestMessage3"] then
			API_Log("Err in deserialize message TestMessage3: strus has changed!")
			return
		end
	end

	local pvp = API_GetLuaPVP(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_TestMessage3(pvp, msg, others)
end

--TestMessage4
msg_list[90004] = 
function(is, is_idx, ud, api, msg, others, checksum)
	local playermap = CACHE.PlayerManager:GetInstance()
	API = API_GetLuaAPISet(api)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["TestMessage4"] then
			API_Log("Err in deserialize message TestMessage4: strus has changed!")
			return
		end
	end

	OnMessage_TestMessage4(playermap, msg)
end

--JieYiUpdateReply
msg_list[10200] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["JieYiUpdateReply"] then
			API_Log("Err in deserialize message JieYiUpdateReply: strus has changed!")
			return
		end
	end
	is_idx, msg.id = Deserialize(is, is_idx, "string")
	is_idx, msg.typ = Deserialize(is, is_idx, "number")
	is_idx, msg.name = Deserialize(is, is_idx, "string")
	is_idx, msg.role_id = Deserialize(is, is_idx, "string")
	is_idx, msg.agreement = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_JieYiUpdateReply(player, role, msg, others)
end
player_msg_list[10200] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["JieYiUpdateReply"] then
			API_Log("Err in deserialize message JieYiUpdateReply: strus has changed!")
			return
		end
	end
	is_idx, msg.id = Deserialize(is, is_idx, "string")
	is_idx, msg.typ = Deserialize(is, is_idx, "number")
	is_idx, msg.name = Deserialize(is, is_idx, "string")
	is_idx, msg.role_id = Deserialize(is, is_idx, "string")
	is_idx, msg.agreement = Deserialize(is, is_idx, "number")

	OnMessage_JieYiUpdateReply(player, role, msg, {})
end

--JieYiUpdateExit
msg_list[10201] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["JieYiUpdateExit"] then
			API_Log("Err in deserialize message JieYiUpdateExit: strus has changed!")
			return
		end
	end
	is_idx, msg.id = Deserialize(is, is_idx, "string")
	is_idx, msg.typ = Deserialize(is, is_idx, "number")
	is_idx, msg.name = Deserialize(is, is_idx, "string")
	is_idx, msg.brother_id = Deserialize(is, is_idx, "string")
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_JieYiUpdateExit(player, role, msg, others)
end
player_msg_list[10201] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["JieYiUpdateExit"] then
			API_Log("Err in deserialize message JieYiUpdateExit: strus has changed!")
			return
		end
	end
	is_idx, msg.id = Deserialize(is, is_idx, "string")
	is_idx, msg.typ = Deserialize(is, is_idx, "number")
	is_idx, msg.name = Deserialize(is, is_idx, "string")
	is_idx, msg.brother_id = Deserialize(is, is_idx, "string")
	is_idx, msg.retcode = Deserialize(is, is_idx, "number")

	OnMessage_JieYiUpdateExit(player, role, msg, {})
end

--FlowerGiftUpdate
msg_list[10220] = 
function(is, is_idx, ud, api, msg, others, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["FlowerGiftUpdate"] then
			API_Log("Err in deserialize message FlowerGiftUpdate: strus has changed!")
			return
		end
	end

	local player = API_GetLuaPlayer(ud)
	local role = API_GetLuaRole(ud)
	API = API_GetLuaAPISet(api)
	OnMessage_FlowerGiftUpdate(player, role, msg, others)
end
player_msg_list[10220] = 
function(is, is_idx, player, role, msg, checksum)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["FlowerGiftUpdate"] then
			API_Log("Err in deserialize message FlowerGiftUpdate: strus has changed!")
			return
		end
	end

	OnMessage_FlowerGiftUpdate(player, role, msg, {})
end

--HotPvpVideoHeartBeat
msg_list[10221] = 
function(is, is_idx, ud, api, msg, others, checksum)
	API = API_GetLuaAPISet(api)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["HotPvpVideoHeartBeat"] then
			API_Log("Err in deserialize message HotPvpVideoHeartBeat: strus has changed!")
			return
		end
	end

	OnMessage_HotPvpVideoHeartBeat(msg, others)
end

--ServerRewardHeartBeat
msg_list[10222] = 
function(is, is_idx, ud, api, msg, others, checksum)
	API = API_GetLuaAPISet(api)
	if checksum ~= nil then
		if checksum ~= G_CHECKSUM_M["ServerRewardHeartBeat"] then
			API_Log("Err in deserialize message ServerRewardHeartBeat: strus has changed!")
			return
		end
	end

	OnMessage_ServerRewardHeartBeat(msg, others)
end



