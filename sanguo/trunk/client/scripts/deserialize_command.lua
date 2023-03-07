--DONT CHANGE ME!

local cmd_list = {}

function DeserializeAndProcessCommand(ud, api, is, ...)
	local player = nil
	local role = nil
	if not API_IsNULL(ud) then player=API_GetLuaPlayer(ud) end
	if not API_IsNULL(ud) then role=API_GetLuaRole(ud) end
	if API_GetLuaAPISet~=nil then API = API_GetLuaAPISet(api) end

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
			PrepareOthers4Command(others,k-(1+extra_roles_size+1+extra_mafias_size+1+extra_pvps_size),v)
		end
	end

	local cmd = {}
	local is_idx = 1
	is_idx, cmd.__type__ = Deserialize(is, is_idx, "number")

	if cmd_list[cmd.__type__] ~= nil then
		cmd_list[cmd.__type__](is, is_idx, player, role, cmd, others)
	else
		error("wrong command type: "..cmd.__type__)
	end
end


--EnterInstance_Re
cmd_list[8] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.inst_tid = Deserialize(is, is_idx, "number")
	is_idx, cmd.seed = Deserialize(is, is_idx, "number")

	OnCommand_EnterInstance_Re(player, role, cmd, others)
end

--CompleteInstance_Re
cmd_list[10] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.inst_tid = Deserialize(is, is_idx, "number")
	is_idx, cmd.score = Deserialize(is, is_idx, "number")
	is_idx, cmd.star = Deserialize(is, is_idx, "number")
	is_idx, cmd.rewards = DeserializeStruct(is, is_idx, "SweepInstanceData")
	is_idx, cmd.first_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.first_finish = Deserialize(is, is_idx, "number")

	OnCommand_CompleteInstance_Re(player, role, cmd, others)
end

--SyncRoleInfo
cmd_list[11] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_SyncRoleInfo(player, role, cmd, others)
end

--PVPInvite
cmd_list[10301] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.src = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, cmd.mode = Deserialize(is, is_idx, "number")

	OnCommand_PVPInvite(player, role, cmd, others)
end

--PVPPrepare
cmd_list[10303] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "number")
	is_idx, cmd.player1 = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, cmd.player2 = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, cmd.N = Deserialize(is, is_idx, "number")
	is_idx, cmd.mode = Deserialize(is, is_idx, "number")
	is_idx, cmd.p2p_magic = Deserialize(is, is_idx, "number")
	is_idx, cmd.p2p_peer_ip = Deserialize(is, is_idx, "string")
	is_idx, cmd.p2p_peer_port = Deserialize(is, is_idx, "number")

	OnCommand_PVPPrepare(player, role, cmd, others)
end

--PVPBegin
cmd_list[10305] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.fight_start_time = Deserialize(is, is_idx, "number")
	is_idx, cmd.ip = Deserialize(is, is_idx, "string")
	is_idx, cmd.port = Deserialize(is, is_idx, "number")
	is_idx, cmd.seed = Deserialize(is, is_idx, "number")

	OnCommand_PVPBegin(player, role, cmd, others)
end

--PVPOperation
cmd_list[10306] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.client_tick = Deserialize(is, is_idx, "number")
	is_idx, cmd.op = Deserialize(is, is_idx, "string")
	is_idx, cmd.crc_tick = Deserialize(is, is_idx, "number")
	is_idx, cmd.crc = Deserialize(is, is_idx, "string")

	OnCommand_PVPOperation(player, role, cmd, others)
end

--PVPOperationSet
cmd_list[10307] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.client_tick = Deserialize(is, is_idx, "number")
	is_idx, cmd.player1_op = Deserialize(is, is_idx, "string")
	is_idx, cmd.player2_op = Deserialize(is, is_idx, "string")

	OnCommand_PVPOperationSet(player, role, cmd, others)
end

--PVPEnd
cmd_list[10308] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.result = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.pvp_typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.star = Deserialize(is, is_idx, "number")
	is_idx, cmd.win_count = Deserialize(is, is_idx, "number")
	is_idx, cmd.score = Deserialize(is, is_idx, "number")
	is_idx, cmd.duration = Deserialize(is, is_idx, "number")

	OnCommand_PVPEnd(player, role, cmd, others)
end

--PVPError
cmd_list[10309] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.result = Deserialize(is, is_idx, "number")

	OnCommand_PVPError(player, role, cmd, others)
end

--PVPPeerLatency
cmd_list[10310] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.latency = Deserialize(is, is_idx, "number")

	OnCommand_PVPPeerLatency(player, role, cmd, others)
end

--PVPPause
cmd_list[10311] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.pause_tick = Deserialize(is, is_idx, "number")
	is_idx, cmd.role_id = Deserialize(is, is_idx, "string")

	OnCommand_PVPPause(player, role, cmd, others)
end

--PVPContinue
cmd_list[10313] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.fight_continue_time = Deserialize(is, is_idx, "number")

	OnCommand_PVPContinue(player, role, cmd, others)
end

--PVPSendAutoVoice
cmd_list[10314] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.voice_id = Deserialize(is, is_idx, "number")

	OnCommand_PVPSendAutoVoice(player, role, cmd, others)
end

--PVPOperationRival
cmd_list[10315] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.tick = Deserialize(is, is_idx, "number")
	is_idx, cmd.op = Deserialize(is, is_idx, "string")
	is_idx, cmd.confirm_tick = Deserialize(is, is_idx, "number")

	OnCommand_PVPOperationRival(player, role, cmd, others)
end

--PVPOperationReset
cmd_list[10316] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.tick = Deserialize(is, is_idx, "number")
	is_idx, cmd.op = Deserialize(is, is_idx, "string")

	OnCommand_PVPOperationReset(player, role, cmd, others)
end

--UpdateHaveFinishBattle
cmd_list[10318] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.battle_id = {}
	for i = 1, count do
		is_idx, cmd.battle_id[i] = Deserialize(is, is_idx, "number")
	end

	OnCommand_UpdateHaveFinishBattle(player, role, cmd, others)
end

--PVPDumpOP
cmd_list[10319] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_PVPDumpOP(player, role, cmd, others)
end

--RoleNameQuery_Re
cmd_list[10322] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.pattern = Deserialize(is, is_idx, "string")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.results = {}
	for i = 1, count do
		is_idx, cmd.results[i] = DeserializeStruct(is, is_idx, "RoleBrief")
	end
	is_idx, cmd.reason = Deserialize(is, is_idx, "number")

	OnCommand_RoleNameQuery_Re(player, role, cmd, others)
end

--BuyRefreshShopTimes_Re
cmd_list[10324] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.shop_id = Deserialize(is, is_idx, "number")

	OnCommand_BuyRefreshShopTimes_Re(player, role, cmd, others)
end

--GetShopRecoveryTime_Re
cmd_list[10326] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.shop_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.refresh_times = Deserialize(is, is_idx, "number")
	is_idx, cmd.recovery_time = Deserialize(is, is_idx, "number")

	OnCommand_GetShopRecoveryTime_Re(player, role, cmd, others)
end

--GetActivityReward_Re
cmd_list[10328] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.activity_id = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.rewards = {}
	for i = 1, count do
		is_idx, cmd.rewards[i] = DeserializeStruct(is, is_idx, "Item")
	end

	OnCommand_GetActivityReward_Re(player, role, cmd, others)
end

--GetJiaNianHuaInfo_Re
cmd_list[10330] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.join_flag = Deserialize(is, is_idx, "boolean")

	OnCommand_GetJiaNianHuaInfo_Re(player, role, cmd, others)
end

--GetClientLocalTime
cmd_list[10331] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.server_ms = Deserialize(is, is_idx, "number")

	OnCommand_GetClientLocalTime(player, role, cmd, others)
end

--SweepInstance_Re
cmd_list[101] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.info = {}
	for i = 1, count do
		is_idx, cmd.info[i] = DeserializeStruct(is, is_idx, "SweepInstanceData")
	end
	is_idx, cmd.info2 = DeserializeStruct(is, is_idx, "SweepInstanceData")

	OnCommand_SweepInstance_Re(player, role, cmd, others)
end

--GetBackPack_Re
cmd_list[103] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.info = {}
	for i = 1, count do
		is_idx, cmd.info[i] = DeserializeStruct(is, is_idx, "Item")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.weaponitems = {}
	for i = 1, count do
		is_idx, cmd.weaponitems[i] = DeserializeStruct(is, is_idx, "WeaponItem")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.equipmentitems = {}
	for i = 1, count do
		is_idx, cmd.equipmentitems[i] = DeserializeStruct(is, is_idx, "EquipmentItem")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.skinitems = {}
	for i = 1, count do
		is_idx, cmd.skinitems[i] = DeserializeStruct(is, is_idx, "SkinItem")
	end

	OnCommand_GetBackPack_Re(player, role, cmd, others)
end

--GetInstance_Re
cmd_list[105] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.info = {}
	for i = 1, count do
		is_idx, cmd.info[i] = DeserializeStruct(is, is_idx, "InstanceInfo")
	end

	OnCommand_GetInstance_Re(player, role, cmd, others)
end

--Role_Mon_Exp
cmd_list[106] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.level = Deserialize(is, is_idx, "number")
	is_idx, cmd.exp = Deserialize(is, is_idx, "string")
	is_idx, cmd.money = Deserialize(is, is_idx, "number")
	is_idx, cmd.yuanbao = Deserialize(is, is_idx, "number")
	is_idx, cmd.vp = Deserialize(is, is_idx, "number")

	OnCommand_Role_Mon_Exp(player, role, cmd, others)
end

--BuyVp_Re
cmd_list[108] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.num = Deserialize(is, is_idx, "number")

	OnCommand_BuyVp_Re(player, role, cmd, others)
end

--BuyInstanceCount_Re
cmd_list[110] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_BuyInstanceCount_Re(player, role, cmd, others)
end

--RoleCommonLimit
cmd_list[111] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.tid = Deserialize(is, is_idx, "number")
	is_idx, cmd.count = Deserialize(is, is_idx, "number")

	OnCommand_RoleCommonLimit(player, role, cmd, others)
end

--ChongZhi_Re
cmd_list[114] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.chongzhi = Deserialize(is, is_idx, "number")

	OnCommand_ChongZhi_Re(player, role, cmd, others)
end

--TaskFinish_Re
cmd_list[116] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.task_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.rewards = DeserializeStruct(is, is_idx, "SweepInstanceData")

	OnCommand_TaskFinish_Re(player, role, cmd, others)
end

--Task_Condition
cmd_list[117] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.tid = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.condition = {}
	for i = 1, count do
		is_idx, cmd.condition[i] = DeserializeStruct(is, is_idx, "Condition")
	end

	OnCommand_Task_Condition(player, role, cmd, others)
end

--BuyHero_Re
cmd_list[120] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_BuyHero_Re(player, role, cmd, others)
end

--HeroList_Re
cmd_list[121] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero_hall = DeserializeStruct(is, is_idx, "RoleHero")

	OnCommand_HeroList_Re(player, role, cmd, others)
end

--AddHero
cmd_list[123] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero_hall = DeserializeStruct(is, is_idx, "RoleHero")
	is_idx, cmd.flag = Deserialize(is, is_idx, "number")

	OnCommand_AddHero(player, role, cmd, others)
end

--UpdateHeroInfo
cmd_list[124] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero_hall = DeserializeStruct(is, is_idx, "RoleHero")

	OnCommand_UpdateHeroInfo(player, role, cmd, others)
end

--UseItem_Re
cmd_list[125] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_UseItem_Re(player, role, cmd, others)
end

--One_Level_Up_Re
cmd_list[127] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_One_Level_Up_Re(player, role, cmd, others)
end

--Hero_Up_Grade_Re
cmd_list[129] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")

	OnCommand_Hero_Up_Grade_Re(player, role, cmd, others)
end

--ErrorInfo
cmd_list[130] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.error_id = Deserialize(is, is_idx, "number")

	OnCommand_ErrorInfo(player, role, cmd, others)
end

--BuyHorse_Re
cmd_list[132] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_BuyHorse_Re(player, role, cmd, others)
end

--AddHorse
cmd_list[133] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.horse = DeserializeStruct(is, is_idx, "RoleHorse")

	OnCommand_AddHorse(player, role, cmd, others)
end

--GetLastHero_Re
cmd_list[135] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.info = {}
	for i = 1, count do
		is_idx, cmd.info[i] = Deserialize(is, is_idx, "number")
	end

	OnCommand_GetLastHero_Re(player, role, cmd, others)
end

--PvpJoin_Re
cmd_list[137] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.time = Deserialize(is, is_idx, "number")

	OnCommand_PvpJoin_Re(player, role, cmd, others)
end

--PvpMatchSuccess
cmd_list[138] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.index = Deserialize(is, is_idx, "number")

	OnCommand_PvpMatchSuccess(player, role, cmd, others)
end

--PvpEnter_Re
cmd_list[140] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.player1 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
	is_idx, cmd.player2 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
	is_idx, cmd.N = Deserialize(is, is_idx, "number")
	is_idx, cmd.mode = Deserialize(is, is_idx, "number")
	is_idx, cmd.p2p_magic = Deserialize(is, is_idx, "number")
	is_idx, cmd.p2p_peer_ip = Deserialize(is, is_idx, "string")
	is_idx, cmd.p2p_peer_port = Deserialize(is, is_idx, "number")
	is_idx, cmd.robot_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.robot_seed = Deserialize(is, is_idx, "number")
	is_idx, cmd.robot_type = Deserialize(is, is_idx, "number")

	OnCommand_PvpEnter_Re(player, role, cmd, others)
end

--PvpCancle_Re
cmd_list[142] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_PvpCancle_Re(player, role, cmd, others)
end

--PvpSpeed
cmd_list[143] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.speed = Deserialize(is, is_idx, "number")

	OnCommand_PvpSpeed(player, role, cmd, others)
end

--SendNotice
cmd_list[145] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.notice_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.time = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.notice_para = {}
	for i = 1, count do
		is_idx, cmd.notice_para[i] = DeserializeStruct(is, is_idx, "NoticeParaInfo")
	end

	OnCommand_SendNotice(player, role, cmd, others)
end

--UpdateTask
cmd_list[146] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.current = {}
	for i = 1, count do
		is_idx, cmd.current[i] = DeserializeStruct(is, is_idx, "RoleCurrentTask")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.finish = {}
	for i = 1, count do
		is_idx, cmd.finish[i] = Deserialize(is, is_idx, "number")
	end

	OnCommand_UpdateTask(player, role, cmd, others)
end

--FinishedTask
cmd_list[147] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.finish = {}
	for i = 1, count do
		is_idx, cmd.finish[i] = Deserialize(is, is_idx, "number")
	end

	OnCommand_FinishedTask(player, role, cmd, others)
end

--ItemCountChange
cmd_list[149] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.itemid = Deserialize(is, is_idx, "number")
	is_idx, cmd.count = Deserialize(is, is_idx, "number")

	OnCommand_ItemCountChange(player, role, cmd, others)
end

--HeroUpgradeSkill_Re
cmd_list[151] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_HeroUpgradeSkill_Re(player, role, cmd, others)
end

--GetHeroComments_Re
cmd_list[153] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.comment = {}
	for i = 1, count do
		is_idx, cmd.comment[i] = DeserializeStruct(is, is_idx, "HeroComment")
	end
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")

	OnCommand_GetHeroComments_Re(player, role, cmd, others)
end

--AgreeHeroComments_Re
cmd_list[155] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.role_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.time_stamp = Deserialize(is, is_idx, "number")

	OnCommand_AgreeHeroComments_Re(player, role, cmd, others)
end

--WriteHeroComments_Re
cmd_list[157] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")

	OnCommand_WriteHeroComments_Re(player, role, cmd, others)
end

--ReWriteHeroComments_Re
cmd_list[159] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")

	OnCommand_ReWriteHeroComments_Re(player, role, cmd, others)
end

--UpdateHeroSkillPoint
cmd_list[160] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.point = Deserialize(is, is_idx, "number")

	OnCommand_UpdateHeroSkillPoint(player, role, cmd, others)
end

--GetVPRefreshTime_Re
cmd_list[162] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.refresh_time = Deserialize(is, is_idx, "number")

	OnCommand_GetVPRefreshTime_Re(player, role, cmd, others)
end

--GetSkillPointRefreshTime_Re
cmd_list[164] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.refresh_time = Deserialize(is, is_idx, "number")

	OnCommand_GetSkillPointRefreshTime_Re(player, role, cmd, others)
end

--BuySkillPoint_Re
cmd_list[167] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.point = Deserialize(is, is_idx, "number")

	OnCommand_BuySkillPoint_Re(player, role, cmd, others)
end

--UpdatePvpVideo
cmd_list[168] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.video = Deserialize(is, is_idx, "string")
	is_idx, cmd.player1 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
	is_idx, cmd.player2 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
	is_idx, cmd.win_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.time = Deserialize(is, is_idx, "number")
	is_idx, cmd.match_pvp = Deserialize(is, is_idx, "number")

	OnCommand_UpdatePvpVideo(player, role, cmd, others)
end

--GetVideo_Re
cmd_list[170] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.player1 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
	is_idx, cmd.player2 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
	is_idx, cmd.operation = DeserializeStruct(is, is_idx, "PvpVideo")
	is_idx, cmd.win_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.robot_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.robot_seed = Deserialize(is, is_idx, "number")
	is_idx, cmd.robot_type = Deserialize(is, is_idx, "number")
	is_idx, cmd.exe_ver = Deserialize(is, is_idx, "string")
	is_idx, cmd.data_ver = Deserialize(is, is_idx, "string")
	is_idx, cmd.video_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.pvp_ver = Deserialize(is, is_idx, "number")

	OnCommand_GetVideo_Re(player, role, cmd, others)
end

--PrivateChatHistory
cmd_list[171] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.private_chat = {}
	for i = 1, count do
		is_idx, cmd.private_chat[i] = DeserializeStruct(is, is_idx, "ChatInfo")
	end

	OnCommand_PrivateChatHistory(player, role, cmd, others)
end

--AddBlackList_Re
cmd_list[173] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.roleinfo = DeserializeStruct(is, is_idx, "RoleBrief")

	OnCommand_AddBlackList_Re(player, role, cmd, others)
end

--DelBlackList_Re
cmd_list[175] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.roleid = Deserialize(is, is_idx, "string")

	OnCommand_DelBlackList_Re(player, role, cmd, others)
end

--SeeAnotherRole_Re
cmd_list[177] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.roleinfo = DeserializeStruct(is, is_idx, "AnotherRoleData")

	OnCommand_SeeAnotherRole_Re(player, role, cmd, others)
end

--ReadMail_Re
cmd_list[180] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_ReadMail_Re(player, role, cmd, others)
end

--GetAttachment_Re
cmd_list[182] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_GetAttachment_Re(player, role, cmd, others)
end

--UpdateMail
cmd_list[183] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.mail_info = DeserializeStruct(is, is_idx, "MailInfo")

	OnCommand_UpdateMail(player, role, cmd, others)
end

--UpdatePvpEndTime
cmd_list[184] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.end_time = Deserialize(is, is_idx, "number")

	OnCommand_UpdatePvpEndTime(player, role, cmd, others)
end

--UpdateHeroPvpInfo
cmd_list[185] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.hero_pvpinfo = {}
	for i = 1, count do
		is_idx, cmd.hero_pvpinfo[i] = DeserializeStruct(is, is_idx, "HeroPvpInfoData")
	end

	OnCommand_UpdateHeroPvpInfo(player, role, cmd, others)
end

--DeleteTask
cmd_list[186] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.task_id = Deserialize(is, is_idx, "number")

	OnCommand_DeleteTask(player, role, cmd, others)
end

--BroadcastPvpVideo_Re
cmd_list[188] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.src = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, cmd.content = Deserialize(is, is_idx, "string")
	is_idx, cmd.video_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.player1 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
	is_idx, cmd.player2 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
	is_idx, cmd.time = Deserialize(is, is_idx, "number")
	is_idx, cmd.win_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.channel = Deserialize(is, is_idx, "number")
	is_idx, cmd.match_pvp = Deserialize(is, is_idx, "number")

	OnCommand_BroadcastPvpVideo_Re(player, role, cmd, others)
end

--ChangeHeroSelectSkill_Re
cmd_list[190] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.skill_id = {}
	for i = 1, count do
		is_idx, cmd.skill_id[i] = Deserialize(is, is_idx, "number")
	end

	OnCommand_ChangeHeroSelectSkill_Re(player, role, cmd, others)
end

--UpdatePvpInfo
cmd_list[191] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.join_count = Deserialize(is, is_idx, "number")
	is_idx, cmd.win_count = Deserialize(is, is_idx, "number")

	OnCommand_UpdatePvpInfo(player, role, cmd, others)
end

--UpdateRep
cmd_list[192] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.rep_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.rep_num = Deserialize(is, is_idx, "number")

	OnCommand_UpdateRep(player, role, cmd, others)
end

--MallBuyItem_Re
cmd_list[194] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.item = {}
	for i = 1, count do
		is_idx, cmd.item[i] = DeserializeStruct(is, is_idx, "Item")
	end

	OnCommand_MallBuyItem_Re(player, role, cmd, others)
end

--UpdatePvpStar
cmd_list[195] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.star = Deserialize(is, is_idx, "number")

	OnCommand_UpdatePvpStar(player, role, cmd, others)
end

--UpdateHeroSoul
cmd_list[197] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.soul_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.soul_num = Deserialize(is, is_idx, "number")

	OnCommand_UpdateHeroSoul(player, role, cmd, others)
end

--LevelUpHeroStar_Re
cmd_list[199] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_LevelUpHeroStar_Re(player, role, cmd, others)
end

--ClearHeroPvpInfo
cmd_list[200] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_ClearHeroPvpInfo(player, role, cmd, others)
end

--UpdateMysteryShopInfo
cmd_list[201] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.shop_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.refresh_time = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.shop_item = {}
	for i = 1, count do
		is_idx, cmd.shop_item[i] = DeserializeStruct(is, is_idx, "MysteryShopItem")
	end

	OnCommand_UpdateMysteryShopInfo(player, role, cmd, others)
end

--MysteryShopBuyItem_Re
cmd_list[203] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.shop_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.position = Deserialize(is, is_idx, "number")
	is_idx, cmd.item_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.item_num = Deserialize(is, is_idx, "number")
	is_idx, cmd.buy_count = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.item = {}
	for i = 1, count do
		is_idx, cmd.item[i] = DeserializeStruct(is, is_idx, "Item")
	end

	OnCommand_MysteryShopBuyItem_Re(player, role, cmd, others)
end

--RefreshMysteryShop_Re
cmd_list[205] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.shop_id = Deserialize(is, is_idx, "number")

	OnCommand_RefreshMysteryShop_Re(player, role, cmd, others)
end

--ResetBattleField_Re
cmd_list[207] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.battle_info = DeserializeStruct(is, is_idx, "BattleInfo")

	OnCommand_ResetBattleField_Re(player, role, cmd, others)
end

--BattleFieldBegin_Re
cmd_list[209] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")

	OnCommand_BattleFieldBegin_Re(player, role, cmd, others)
end

--BattleFieldMove_Re
cmd_list[211] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.src_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.src_position = Deserialize(is, is_idx, "number")
	is_idx, cmd.dst_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.dst_position = Deserialize(is, is_idx, "number")

	OnCommand_BattleFieldMove_Re(player, role, cmd, others)
end

--BattleFieldJoinBattle_Re
cmd_list[213] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.npc_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.seed = Deserialize(is, is_idx, "number")

	OnCommand_BattleFieldJoinBattle_Re(player, role, cmd, others)
end

--BattleFieldFinishBattle_Re
cmd_list[215] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.win_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.fail_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.npc_id = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.heros = {}
	for i = 1, count do
		is_idx, cmd.heros[i] = DeserializeStruct(is, is_idx, "BattleHeroInfo")
	end
	is_idx, cmd.rewards = DeserializeStruct(is, is_idx, "SweepInstanceData")

	OnCommand_BattleFieldFinishBattle_Re(player, role, cmd, others)
end

--BattleFieldEnd
cmd_list[216] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.win_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.rewards = DeserializeStruct(is, is_idx, "SweepInstanceData")

	OnCommand_BattleFieldEnd(player, role, cmd, others)
end

--BattleFieldGetPrize_Re
cmd_list[218] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.rewards = DeserializeStruct(is, is_idx, "SweepInstanceData")

	OnCommand_BattleFieldGetPrize_Re(player, role, cmd, others)
end

--SetInstanceHeroInfo_Re
cmd_list[220] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.heros = {}
	for i = 1, count do
		is_idx, cmd.heros[i] = Deserialize(is, is_idx, "number")
	end
	is_idx, cmd.horse = Deserialize(is, is_idx, "number")

	OnCommand_SetInstanceHeroInfo_Re(player, role, cmd, others)
end

--Lottery_Re
cmd_list[222] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.lottery_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.cost_type = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.reward_ids = {}
	for i = 1, count do
		is_idx, cmd.reward_ids[i] = DeserializeStruct(is, is_idx, "LotteryRewardInfo")
	end

	OnCommand_Lottery_Re(player, role, cmd, others)
end

--GetBattleFieldInfo_Re
cmd_list[224] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.battle_info = DeserializeStruct(is, is_idx, "BattleInfo")

	OnCommand_GetBattleFieldInfo_Re(player, role, cmd, others)
end

--ChangeBattleState
cmd_list[225] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.state = Deserialize(is, is_idx, "number")

	OnCommand_ChangeBattleState(player, role, cmd, others)
end

--BattleFieldCancel_Re
cmd_list[227] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.position = Deserialize(is, is_idx, "number")

	OnCommand_BattleFieldCancel_Re(player, role, cmd, others)
end

--BattleFieldGetEvent_Re
cmd_list[229] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.event = {}
	for i = 1, count do
		is_idx, cmd.event[i] = Deserialize(is, is_idx, "number")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.event_info = {}
	for i = 1, count do
		is_idx, cmd.event_info[i] = DeserializeStruct(is, is_idx, "BattleEventInfo")
	end

	OnCommand_BattleFieldGetEvent_Re(player, role, cmd, others)
end

--BattleFieldCapturedPosition
cmd_list[230] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.position_info = DeserializeStruct(is, is_idx, "BattlePositionInfo")
	is_idx, cmd.event = Deserialize(is, is_idx, "number")
	is_idx, cmd.event_info = DeserializeStruct(is, is_idx, "BattleEventInfo")

	OnCommand_BattleFieldCapturedPosition(player, role, cmd, others)
end

--GetCurBattleField_Re
cmd_list[232] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.state = Deserialize(is, is_idx, "number")

	OnCommand_GetCurBattleField_Re(player, role, cmd, others)
end

--BattleFieldFinishEvent_Re
cmd_list[234] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.join_battle_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.event = Deserialize(is, is_idx, "number")

	OnCommand_BattleFieldFinishEvent_Re(player, role, cmd, others)
end

--GiveUpCurBattleField_Re
cmd_list[236] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_GiveUpCurBattleField_Re(player, role, cmd, others)
end

--GetRefreshTime_Re
cmd_list[238] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.last_refreshtime = Deserialize(is, is_idx, "number")

	OnCommand_GetRefreshTime_Re(player, role, cmd, others)
end

--DailySign_Re
cmd_list[240] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.item = {}
	for i = 1, count do
		is_idx, cmd.item[i] = DeserializeStruct(is, is_idx, "Item")
	end
	is_idx, cmd.sign_date = Deserialize(is, is_idx, "number")
	is_idx, cmd.today_flag = Deserialize(is, is_idx, "number")

	OnCommand_DailySign_Re(player, role, cmd, others)
end

--GetMyPveArenaInfo_Re
cmd_list[242] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.score = Deserialize(is, is_idx, "number")
	is_idx, cmd.rank = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.defence_hero = {}
	for i = 1, count do
		is_idx, cmd.defence_hero[i] = Deserialize(is, is_idx, "number")
	end
	is_idx, cmd.last_attack_time = Deserialize(is, is_idx, "number")
	is_idx, cmd.pve_refreshtime = Deserialize(is, is_idx, "number")

	OnCommand_GetMyPveArenaInfo_Re(player, role, cmd, others)
end

--GetOtherPveArenaInfo_Re
cmd_list[244] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.info = DeserializeStruct(is, is_idx, "PveArenaFighterInfo")

	OnCommand_GetOtherPveArenaInfo_Re(player, role, cmd, others)
end

--GetFighterInfo_Re
cmd_list[246] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.fightinfo = {}
	for i = 1, count do
		is_idx, cmd.fightinfo[i] = DeserializeStruct(is, is_idx, "PveArenaFighterInfo")
	end

	OnCommand_GetFighterInfo_Re(player, role, cmd, others)
end

--PveArenaJoinBattle_Re
cmd_list[248] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.last_attack_time = Deserialize(is, is_idx, "number")
	is_idx, cmd.self_info = DeserializeStruct(is, is_idx, "RolePveArenaInfo")
	is_idx, cmd.role_info = DeserializeStruct(is, is_idx, "PveArenaFighterInfo")
	is_idx, cmd.seed = Deserialize(is, is_idx, "number")

	OnCommand_PveArenaJoinBattle_Re(player, role, cmd, others)
end

--PveArenaEndBattle_Re
cmd_list[250] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.win_type = Deserialize(is, is_idx, "number")
	is_idx, cmd.score_change = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.item = {}
	for i = 1, count do
		is_idx, cmd.item[i] = DeserializeStruct(is, is_idx, "Item")
	end

	OnCommand_PveArenaEndBattle_Re(player, role, cmd, others)
end

--PveArenaResetTime_Re
cmd_list[252] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.last_time = Deserialize(is, is_idx, "number")

	OnCommand_PveArenaResetTime_Re(player, role, cmd, others)
end

--PveArenaResetCount_Re
cmd_list[254] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_PveArenaResetCount_Re(player, role, cmd, others)
end

--ChallengeRoleByItem_Re
cmd_list[256] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.self_info = DeserializeStruct(is, is_idx, "RolePveArenaInfo")
	is_idx, cmd.role_info = DeserializeStruct(is, is_idx, "PveArenaFighterInfo")

	OnCommand_ChallengeRoleByItem_Re(player, role, cmd, others)
end

--GetPveArenaHistory_Re
cmd_list[258] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.hisroty_info = {}
	for i = 1, count do
		is_idx, cmd.hisroty_info[i] = DeserializeStruct(is, is_idx, "RolePveArenaHistoryInfo")
	end
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_GetPveArenaHistory_Re(player, role, cmd, others)
end

--GetPveArenaOperation_Re
cmd_list[260] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.self_hero_info = DeserializeStruct(is, is_idx, "RolePveArenaInfo")
	is_idx, cmd.oppo_hero_info = DeserializeStruct(is, is_idx, "RolePveArenaInfo")
	is_idx, cmd.operation = DeserializeStruct(is, is_idx, "PveArenaOperation")
	is_idx, cmd.exe_ver = Deserialize(is, is_idx, "string")
	is_idx, cmd.data_ver = Deserialize(is, is_idx, "string")

	OnCommand_GetPveArenaOperation_Re(player, role, cmd, others)
end

--SetPveArenaHero_Re
cmd_list[262] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_SetPveArenaHero_Re(player, role, cmd, others)
end

--ResetSkilllevel_Re
cmd_list[264] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_ResetSkilllevel_Re(player, role, cmd, others)
end

--WeaponEquip_Re
cmd_list[266] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.hero = Deserialize(is, is_idx, "number")
	is_idx, cmd.weapon_id = Deserialize(is, is_idx, "number")

	OnCommand_WeaponEquip_Re(player, role, cmd, others)
end

--WeaponLevelUp_Re
cmd_list[268] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.hero = Deserialize(is, is_idx, "number")
	is_idx, cmd.weapon_id = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.weapon_cost_ids = {}
	for i = 1, count do
		is_idx, cmd.weapon_cost_ids[i] = Deserialize(is, is_idx, "number")
	end
	is_idx, cmd.level = Deserialize(is, is_idx, "number")
	is_idx, cmd.exp = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.skill_id = {}
	for i = 1, count do
		is_idx, cmd.skill_id[i] = Deserialize(is, is_idx, "number")
	end

	OnCommand_WeaponLevelUp_Re(player, role, cmd, others)
end

--WeaponStrength_Re
cmd_list[270] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.hero = Deserialize(is, is_idx, "number")
	is_idx, cmd.weapon_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.weapon_skill = Deserialize(is, is_idx, "number")

	OnCommand_WeaponStrength_Re(player, role, cmd, others)
end

--WeaponDecompose_Re
cmd_list[272] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.money = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.item_info = {}
	for i = 1, count do
		is_idx, cmd.item_info[i] = DeserializeStruct(is, is_idx, "Item")
	end

	OnCommand_WeaponDecompose_Re(player, role, cmd, others)
end

--WeaponUnequip_Re
cmd_list[274] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_WeaponUnequip_Re(player, role, cmd, others)
end

--WeaponAdd
cmd_list[275] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.weapon_info = DeserializeStruct(is, is_idx, "WeaponItem")
	is_idx, cmd.show_panel = Deserialize(is, is_idx, "boolean")

	OnCommand_WeaponAdd(player, role, cmd, others)
end

--WeaponDel
cmd_list[276] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "number")

	OnCommand_WeaponDel(player, role, cmd, others)
end

--WeaponUpdate
cmd_list[277] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.weapon_info = DeserializeStruct(is, is_idx, "WeaponItem")

	OnCommand_WeaponUpdate(player, role, cmd, others)
end

--LotteryUpdate
cmd_list[278] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.flag = Deserialize(is, is_idx, "number")

	OnCommand_LotteryUpdate(player, role, cmd, others)
end

--WuZheShiLianGetDifficultyInfo_Re
cmd_list[280] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.cur_difficulty = Deserialize(is, is_idx, "number")
	is_idx, cmd.high_difficulty = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.difficulty_info = {}
	for i = 1, count do
		is_idx, cmd.difficulty_info[i] = DeserializeStruct(is, is_idx, "DifficultyInfo")
	end

	OnCommand_WuZheShiLianGetDifficultyInfo_Re(player, role, cmd, others)
end

--WuZheShiLianSelectDifficulty_Re
cmd_list[282] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.cur_diffculty = Deserialize(is, is_idx, "number")

	OnCommand_WuZheShiLianSelectDifficulty_Re(player, role, cmd, others)
end

--WuZheShiLianGetOpponentInfo_Re
cmd_list[284] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.opponent_info = {}
	for i = 1, count do
		is_idx, cmd.opponent_info[i] = DeserializeStruct(is, is_idx, "OpponentInfo")
	end

	OnCommand_WuZheShiLianGetOpponentInfo_Re(player, role, cmd, others)
end

--WuZheShiLianGetHeroInfo_Re
cmd_list[286] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.dead_hero = {}
	for i = 1, count do
		is_idx, cmd.dead_hero[i] = Deserialize(is, is_idx, "number")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.injured_hero = {}
	for i = 1, count do
		is_idx, cmd.injured_hero[i] = DeserializeStruct(is, is_idx, "InjuredHeroInfo")
	end

	OnCommand_WuZheShiLianGetHeroInfo_Re(player, role, cmd, others)
end

--WuZheShiLianJoinBattle_Re
cmd_list[288] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.seed = Deserialize(is, is_idx, "number")

	OnCommand_WuZheShiLianJoinBattle_Re(player, role, cmd, others)
end

--WuZheShiLianFinishBattle_Re
cmd_list[290] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.money = Deserialize(is, is_idx, "number")

	OnCommand_WuZheShiLianFinishBattle_Re(player, role, cmd, others)
end

--WuZheShiLianReset_Re
cmd_list[292] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_WuZheShiLianReset_Re(player, role, cmd, others)
end

--PveArenaUpdateVideoFlag
cmd_list[293] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.video_flag = Deserialize(is, is_idx, "number")

	OnCommand_PveArenaUpdateVideoFlag(player, role, cmd, others)
end

--WuZheShiLianGetReward_Re
cmd_list[295] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")
	is_idx, cmd.stage = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.rewards = {}
	for i = 1, count do
		is_idx, cmd.rewards[i] = DeserializeStruct(is, is_idx, "Item")
	end

	OnCommand_WuZheShiLianGetReward_Re(player, role, cmd, others)
end

--WuZheShiLianSweep_Re
cmd_list[297] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_WuZheShiLianSweep_Re(player, role, cmd, others)
end

--EquipmentEquip_Re
cmd_list[302] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.hero = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.equipment_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.cost_flag = Deserialize(is, is_idx, "number")

	OnCommand_EquipmentEquip_Re(player, role, cmd, others)
end

--EquipmentLevelUp_Re
cmd_list[304] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.hero = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.equipment_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.crit_flag = Deserialize(is, is_idx, "number")

	OnCommand_EquipmentLevelUp_Re(player, role, cmd, others)
end

--EquipmentGradeUp_Re
cmd_list[306] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.hero = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.equipment_id = Deserialize(is, is_idx, "number")

	OnCommand_EquipmentGradeUp_Re(player, role, cmd, others)
end

--EquipmentRefinable_Re
cmd_list[308] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.hero = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.equipment_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.refinable_typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.refinable_count = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.tmp_refinable_pro = {}
	for i = 1, count do
		is_idx, cmd.tmp_refinable_pro[i] = DeserializeStruct(is, is_idx, "RefinableData")
	end

	OnCommand_EquipmentRefinable_Re(player, role, cmd, others)
end

--EquipmentDecompose_Re
cmd_list[310] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.equipment_id = {}
	for i = 1, count do
		is_idx, cmd.equipment_id[i] = Deserialize(is, is_idx, "number")
	end
	is_idx, cmd.money = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.item_info = {}
	for i = 1, count do
		is_idx, cmd.item_info[i] = DeserializeStruct(is, is_idx, "Item")
	end

	OnCommand_EquipmentDecompose_Re(player, role, cmd, others)
end

--EquipmentUnequip_Re
cmd_list[312] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.hero = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.cost_flag = Deserialize(is, is_idx, "number")

	OnCommand_EquipmentUnequip_Re(player, role, cmd, others)
end

--EquipmentAdd
cmd_list[313] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.equipment_info = DeserializeStruct(is, is_idx, "EquipmentItem")

	OnCommand_EquipmentAdd(player, role, cmd, others)
end

--EquipmentDel
cmd_list[314] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "number")

	OnCommand_EquipmentDel(player, role, cmd, others)
end

--EquipmentUpdate
cmd_list[315] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.equipment_info = DeserializeStruct(is, is_idx, "EquipmentItem")

	OnCommand_EquipmentUpdate(player, role, cmd, others)
end

--EquipmentRefinableSave_Re
cmd_list[317] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.hero = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.equipment_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.save_flag = Deserialize(is, is_idx, "number")

	OnCommand_EquipmentRefinableSave_Re(player, role, cmd, others)
end

--EquipmentEasyLevelUp_Re
cmd_list[319] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.hero = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.equipment_id = {}
	for i = 1, count do
		is_idx, cmd.equipment_id[i] = Deserialize(is, is_idx, "number")
	end
	is_idx, cmd.money = Deserialize(is, is_idx, "number")

	OnCommand_EquipmentEasyLevelUp_Re(player, role, cmd, others)
end

--TongQueTaiSetHeroInfo_Re
cmd_list[352] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.hero = {}
	for i = 1, count do
		is_idx, cmd.hero[i] = Deserialize(is, is_idx, "number")
	end

	OnCommand_TongQueTaiSetHeroInfo_Re(player, role, cmd, others)
end

--TongQueTaiBeginMatch_Re
cmd_list[354] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")
	is_idx, cmd.double_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.auto_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_TongQueTaiBeginMatch_Re(player, role, cmd, others)
end

--TongQueTaiCancleMatch_Re
cmd_list[356] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_TongQueTaiCancleMatch_Re(player, role, cmd, others)
end

--TongQueTaiMatchSuccess
cmd_list[357] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.join_index = Deserialize(is, is_idx, "number")
	is_idx, cmd.monster_index = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.player_info = {}
	for i = 1, count do
		is_idx, cmd.player_info[i] = DeserializeStruct(is, is_idx, "TongQueTaiPlayerInfo")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.monster_info = {}
	for i = 1, count do
		is_idx, cmd.monster_info[i] = DeserializeStruct(is, is_idx, "TongQueTaiMonsterInfo")
	end

	OnCommand_TongQueTaiMatchSuccess(player, role, cmd, others)
end

--TongQueTaiNoticeRoleJoin
cmd_list[358] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_TongQueTaiNoticeRoleJoin(player, role, cmd, others)
end

--TongQueTaiJoin_Re
cmd_list[360] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.role_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.seed = Deserialize(is, is_idx, "number")

	OnCommand_TongQueTaiJoin_Re(player, role, cmd, others)
end

--TongQueTaiOperation_Re
cmd_list[362] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.operation = {}
	for i = 1, count do
		is_idx, cmd.operation[i] = DeserializeStruct(is, is_idx, "TongQueTaiOperation")
	end

	OnCommand_TongQueTaiOperation_Re(player, role, cmd, others)
end

--TongQueTaiFinish_Re
cmd_list[364] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.win_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.monster_index = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.hero_info = {}
	for i = 1, count do
		is_idx, cmd.hero_info[i] = DeserializeStruct(is, is_idx, "TongQueTaiMonsterState")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.monster_info = {}
	for i = 1, count do
		is_idx, cmd.monster_info[i] = DeserializeStruct(is, is_idx, "TongQueTaiMonsterState")
	end

	OnCommand_TongQueTaiFinish_Re(player, role, cmd, others)
end

--TongQueTaiReward
cmd_list[365] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_TongQueTaiReward(player, role, cmd, others)
end

--TongQueTaiSpeed_Re
cmd_list[367] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.role_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.speed = Deserialize(is, is_idx, "number")

	OnCommand_TongQueTaiSpeed_Re(player, role, cmd, others)
end

--TongQueTaiLoad_Re
cmd_list[369] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.role_id = Deserialize(is, is_idx, "string")

	OnCommand_TongQueTaiLoad_Re(player, role, cmd, others)
end

--TongQueTaiReLoad
cmd_list[370] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.role_index = Deserialize(is, is_idx, "number")
	is_idx, cmd.monster_index = Deserialize(is, is_idx, "number")
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_TongQueTaiReLoad(player, role, cmd, others)
end

--TongQueTaiEnd
cmd_list[371] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_TongQueTaiEnd(player, role, cmd, others)
end

--TongQueTaiGetReward_Re
cmd_list[373] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.double_flag = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.reward = {}
	for i = 1, count do
		is_idx, cmd.reward[i] = DeserializeStruct(is, is_idx, "Item")
	end

	OnCommand_TongQueTaiGetReward_Re(player, role, cmd, others)
end

--TongQueTaiGetInfo_Re
cmd_list[375] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.hero = {}
	for i = 1, count do
		is_idx, cmd.hero[i] = Deserialize(is, is_idx, "number")
	end
	is_idx, cmd.reward_flag = Deserialize(is, is_idx, "number")

	OnCommand_TongQueTaiGetInfo_Re(player, role, cmd, others)
end

--BattleFieldGetRoundStateInfo_Re
cmd_list[402] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.round_state = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.event_info = {}
	for i = 1, count do
		is_idx, cmd.event_info[i] = DeserializeStruct(is, is_idx, "BattleEventInfo")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.npc_info = {}
	for i = 1, count do
		is_idx, cmd.npc_info[i] = DeserializeStruct(is, is_idx, "BattleFieldNpcMoveInfo")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.info_history = {}
	for i = 1, count do
		is_idx, cmd.info_history[i] = Deserialize(is, is_idx, "number")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.move_pos = {}
	for i = 1, count do
		is_idx, cmd.move_pos[i] = DeserializeStruct(is, is_idx, "MovePos")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.morale_change = {}
	for i = 1, count do
		is_idx, cmd.morale_change[i] = DeserializeStruct(is, is_idx, "MoraleData")
	end
	is_idx, cmd.cur_morale = Deserialize(is, is_idx, "number")

	OnCommand_BattleFieldGetRoundStateInfo_Re(player, role, cmd, others)
end

--BattleFieldUpdateRoundState
cmd_list[403] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.round_num = Deserialize(is, is_idx, "number")
	is_idx, cmd.round_state = Deserialize(is, is_idx, "number")

	OnCommand_BattleFieldUpdateRoundState(player, role, cmd, others)
end

--BattleFieldRoundCount_Re
cmd_list[405] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")

	OnCommand_BattleFieldRoundCount_Re(player, role, cmd, others)
end

--BackPackUseItem_Re
cmd_list[422] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.item_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.item_num = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.items = {}
	for i = 1, count do
		is_idx, cmd.items[i] = DeserializeStruct(is, is_idx, "Item")
	end

	OnCommand_BackPackUseItem_Re(player, role, cmd, others)
end

--TemporaryBackPackGetInfo_Re
cmd_list[424] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.items = {}
	for i = 1, count do
		is_idx, cmd.items[i] = DeserializeStruct(is, is_idx, "TemporaryBackPackData")
	end

	OnCommand_TemporaryBackPackGetInfo_Re(player, role, cmd, others)
end

--TemporaryBackPackReceiveItem_Re
cmd_list[426] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.id = Deserialize(is, is_idx, "number")

	OnCommand_TemporaryBackPackReceiveItem_Re(player, role, cmd, others)
end

--TemporaryBackPackUpdate
cmd_list[427] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.item = DeserializeStruct(is, is_idx, "TemporaryBackPackData")

	OnCommand_TemporaryBackPackUpdate(player, role, cmd, others)
end

--HeroAddStar_Re
cmd_list[429] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.star = Deserialize(is, is_idx, "number")

	OnCommand_HeroAddStar_Re(player, role, cmd, others)
end

--PveArenaUpdateInfo
cmd_list[430] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.defence_hero = {}
	for i = 1, count do
		is_idx, cmd.defence_hero[i] = Deserialize(is, is_idx, "number")
	end

	OnCommand_PveArenaUpdateInfo(player, role, cmd, others)
end

--UpdateLotteryInfo
cmd_list[431] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.lottery_info = {}
	for i = 1, count do
		is_idx, cmd.lottery_info[i] = DeserializeStruct(is, is_idx, "LotteryInfo")
	end

	OnCommand_UpdateLotteryInfo(player, role, cmd, others)
end

--GetRankPveArenaInfo_Re
cmd_list[433] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.info = DeserializeStruct(is, is_idx, "PveArenaFighterInfo")

	OnCommand_GetRankPveArenaInfo_Re(player, role, cmd, others)
end

--ChangeLotterySelect_Re
cmd_list[435] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.lottery_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.select_id = Deserialize(is, is_idx, "number")

	OnCommand_ChangeLotterySelect_Re(player, role, cmd, others)
end

--LegionGetInfo_Re
cmd_list[501] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.junxueguan_level = Deserialize(is, is_idx, "number")

	OnCommand_LegionGetInfo_Re(player, role, cmd, others)
end

--LegionJunXueGuanGetInfo_Re
cmd_list[503] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.info = {}
	for i = 1, count do
		is_idx, cmd.info[i] = DeserializeStruct(is, is_idx, "LegionJunXueGuanData")
	end

	OnCommand_LegionJunXueGuanGetInfo_Re(player, role, cmd, others)
end

--LegionJunXueZhuanJingLevelUp_Re
cmd_list[505] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.id = Deserialize(is, is_idx, "number")
	is_idx, cmd.level = Deserialize(is, is_idx, "number")
	is_idx, cmd.xiangmu_open = Deserialize(is, is_idx, "number")
	is_idx, cmd.xiangmu_id = Deserialize(is, is_idx, "number")

	OnCommand_LegionJunXueZhuanJingLevelUp_Re(player, role, cmd, others)
end

--LegionLearnJunXueXiangMu_Re
cmd_list[507] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.id = Deserialize(is, is_idx, "number")
	is_idx, cmd.learn_id = Deserialize(is, is_idx, "number")

	OnCommand_LegionLearnJunXueXiangMu_Re(player, role, cmd, others)
end

--LegionAddJunXueGuanInfo
cmd_list[508] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.info = DeserializeStruct(is, is_idx, "LegionJunXueGuanData")

	OnCommand_LegionAddJunXueGuanInfo(player, role, cmd, others)
end

--LegionOpenJunXueGuan
cmd_list[509] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.level = Deserialize(is, is_idx, "number")

	OnCommand_LegionOpenJunXueGuan(player, role, cmd, others)
end

--LegionActivationZhuanJing_Re
cmd_list[511] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.id = Deserialize(is, is_idx, "number")
	is_idx, cmd.info = DeserializeStruct(is, is_idx, "LegionJunXueGuanData")

	OnCommand_LegionActivationZhuanJing_Re(player, role, cmd, others)
end

--LegionDecomposeWuHun_Re
cmd_list[513] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.item = {}
	for i = 1, count do
		is_idx, cmd.item[i] = DeserializeStruct(is, is_idx, "Item")
	end
	is_idx, cmd.count = Deserialize(is, is_idx, "number")

	OnCommand_LegionDecomposeWuHun_Re(player, role, cmd, others)
end

--GetRoleInfo_Re
cmd_list[1000002] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.info = DeserializeStruct(is, is_idx, "RoleInfo")
	is_idx, cmd.openservertime = Deserialize(is, is_idx, "number")

	OnCommand_GetRoleInfo_Re(player, role, cmd, others)
end

--CreateRole_Re
cmd_list[1000004] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.info = DeserializeStruct(is, is_idx, "RoleInfo")

	OnCommand_CreateRole_Re(player, role, cmd, others)
end

--MaShuGetRoleInfo_Re
cmd_list[601] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.rank = Deserialize(is, is_idx, "number")
	is_idx, cmd.yestaday_rank = Deserialize(is, is_idx, "number")
	is_idx, cmd.today_score = Deserialize(is, is_idx, "number")
	is_idx, cmd.hisroty_score = Deserialize(is, is_idx, "number")
	is_idx, cmd.today_stage = Deserialize(is, is_idx, "number")
	is_idx, cmd.history_stage = Deserialize(is, is_idx, "number")
	is_idx, cmd.get_prize_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.hero_info = DeserializeStruct(is, is_idx, "MaShuHeroInfo")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.friend_info = {}
	for i = 1, count do
		is_idx, cmd.friend_info[i] = DeserializeStruct(is, is_idx, "MaShuFriendInfo")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.buff_info = {}
	for i = 1, count do
		is_idx, cmd.buff_info[i] = DeserializeStruct(is, is_idx, "MaShuBuffInfo")
	end
	is_idx, cmd.fight_friend = DeserializeStruct(is, is_idx, "MaShuFightFriendInfo")

	OnCommand_MaShuGetRoleInfo_Re(player, role, cmd, others)
end

--MaShuSelectFriendToHelp_Re
cmd_list[603] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.roleid = Deserialize(is, is_idx, "string")

	OnCommand_MaShuSelectFriendToHelp_Re(player, role, cmd, others)
end

--MaShuGetBuff_Re
cmd_list[605] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.id = Deserialize(is, is_idx, "number")
	is_idx, cmd.buff_info = DeserializeStruct(is, is_idx, "MaShuBuffInfo")

	OnCommand_MaShuGetBuff_Re(player, role, cmd, others)
end

--MaShuBegin_Re
cmd_list[607] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.id = Deserialize(is, is_idx, "number")
	is_idx, cmd.seed = Deserialize(is, is_idx, "number")
	is_idx, cmd.scene = Deserialize(is, is_idx, "number")

	OnCommand_MaShuBegin_Re(player, role, cmd, others)
end

--MaShuGetPrize_Re
cmd_list[609] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.stage = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.item = {}
	for i = 1, count do
		is_idx, cmd.item[i] = DeserializeStruct(is, is_idx, "Item")
	end
	is_idx, cmd.money = Deserialize(is, is_idx, "number")

	OnCommand_MaShuGetPrize_Re(player, role, cmd, others)
end

--MaShuUpdateScore_Re
cmd_list[611] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.score = Deserialize(is, is_idx, "number")

	OnCommand_MaShuUpdateScore_Re(player, role, cmd, others)
end

--MaShuEnd_Re
cmd_list[613] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.id = Deserialize(is, is_idx, "number")
	is_idx, cmd.score = Deserialize(is, is_idx, "number")
	is_idx, cmd.stage = Deserialize(is, is_idx, "number")
	is_idx, cmd.box_num = Deserialize(is, is_idx, "number")
	is_idx, cmd.money = Deserialize(is, is_idx, "number")
	is_idx, cmd.item = DeserializeStruct(is, is_idx, "TemporaryBackPackData")
	is_idx, cmd.server_money = Deserialize(is, is_idx, "number")
	is_idx, cmd.last_rank = Deserialize(is, is_idx, "number")
	is_idx, cmd.cur_rank = Deserialize(is, is_idx, "number")

	OnCommand_MaShuEnd_Re(player, role, cmd, others)
end

--MaShuGetRankPrize_Re
cmd_list[615] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.item = DeserializeStruct(is, is_idx, "TemporaryBackPackData")
	is_idx, cmd.yestaday_rank = Deserialize(is, is_idx, "number")
	is_idx, cmd.get_prize_flag = Deserialize(is, is_idx, "number")

	OnCommand_MaShuGetRankPrize_Re(player, role, cmd, others)
end

--MaShuUpdateRoleInfo
cmd_list[616] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.rank = Deserialize(is, is_idx, "number")
	is_idx, cmd.yestaday_rank = Deserialize(is, is_idx, "number")
	is_idx, cmd.today_score = Deserialize(is, is_idx, "number")
	is_idx, cmd.today_stage = Deserialize(is, is_idx, "number")
	is_idx, cmd.get_prize_flag = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.friend_info = {}
	for i = 1, count do
		is_idx, cmd.friend_info[i] = DeserializeStruct(is, is_idx, "MaShuFriendInfo")
	end

	OnCommand_MaShuUpdateRoleInfo(player, role, cmd, others)
end

--JieYiGetRoleInfo_Re
cmd_list[652] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "string")
	is_idx, cmd.name = Deserialize(is, is_idx, "string")
	is_idx, cmd.level = Deserialize(is, is_idx, "number")
	is_idx, cmd.exp = Deserialize(is, is_idx, "number")
	is_idx, cmd.cur_operate_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.cur_operate_typ = Deserialize(is, is_idx, "number")

	OnCommand_JieYiGetRoleInfo_Re(player, role, cmd, others)
end

--JieYiUpdateRoleInfo
cmd_list[653] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "string")
	is_idx, cmd.name = Deserialize(is, is_idx, "string")

	OnCommand_JieYiUpdateRoleInfo(player, role, cmd, others)
end

--JieYiGetInfo_Re
cmd_list[655] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "string")
	is_idx, cmd.name = Deserialize(is, is_idx, "string")
	is_idx, cmd.level = Deserialize(is, is_idx, "number")
	is_idx, cmd.exp = Deserialize(is, is_idx, "number")
	is_idx, cmd.bossinfo = DeserializeStruct(is, is_idx, "JieYiInfo")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.brotherinfo = {}
	for i = 1, count do
		is_idx, cmd.brotherinfo[i] = DeserializeStruct(is, is_idx, "JieYiInfo")
	end
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")

	OnCommand_JieYiGetInfo_Re(player, role, cmd, others)
end

--JieYiUpdateInfo
cmd_list[656] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_JieYiUpdateInfo(player, role, cmd, others)
end

--JieYiCreate_Re
cmd_list[658] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.cur_operate_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.cur_operate_typ = Deserialize(is, is_idx, "number")

	OnCommand_JieYiCreate_Re(player, role, cmd, others)
end

--JieYiInviteRole_Re
cmd_list[660] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.role_id = Deserialize(is, is_idx, "string")

	OnCommand_JieYiInviteRole_Re(player, role, cmd, others)
end

--JieYiInvite_Re
cmd_list[661] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.id = Deserialize(is, is_idx, "string")
	is_idx, cmd.name = Deserialize(is, is_idx, "string")

	OnCommand_JieYiInvite_Re(player, role, cmd, others)
end

--JieYiReply_Re
cmd_list[663] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "string")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.role_id = Deserialize(is, is_idx, "string")

	OnCommand_JieYiReply_Re(player, role, cmd, others)
end

--JieYiOperateInvite_Re
cmd_list[665] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "string")
	is_idx, cmd.name = Deserialize(is, is_idx, "string")
	is_idx, cmd.role_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_JieYiOperateInvite_Re(player, role, cmd, others)
end

--JieYiLastCreate_Re
cmd_list[667] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "string")
	is_idx, cmd.name = Deserialize(is, is_idx, "string")
	is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")

	OnCommand_JieYiLastCreate_Re(player, role, cmd, others)
end

--JieYiLastOperate_Re
cmd_list[669] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "string")
	is_idx, cmd.name = Deserialize(is, is_idx, "string")
	is_idx, cmd.role_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_JieYiLastOperate_Re(player, role, cmd, others)
end

--JieYiResult
cmd_list[670] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "string")
	is_idx, cmd.name = Deserialize(is, is_idx, "string")
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_JieYiResult(player, role, cmd, others)
end

--JieYiGetInviteInfo_Re
cmd_list[672] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.invite_member = {}
	for i = 1, count do
		is_idx, cmd.invite_member[i] = Deserialize(is, is_idx, "string")
	end

	OnCommand_JieYiGetInviteInfo_Re(player, role, cmd, others)
end

--JieYiCancelInviteRole_Re
cmd_list[674] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "string")
	is_idx, cmd.name = Deserialize(is, is_idx, "string")
	is_idx, cmd.brother_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_JieYiCancelInviteRole_Re(player, role, cmd, others)
end

--JieYiExpelBrother_Re
cmd_list[676] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "string")
	is_idx, cmd.name = Deserialize(is, is_idx, "string")
	is_idx, cmd.brother_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_JieYiExpelBrother_Re(player, role, cmd, others)
end

--JieYiDisolve_Re
cmd_list[677] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_JieYiDisolve_Re(player, role, cmd, others)
end

--JieYiExitCurrentJieYi_Re
cmd_list[679] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "string")
	is_idx, cmd.name = Deserialize(is, is_idx, "string")
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.brother_id = Deserialize(is, is_idx, "string")

	OnCommand_JieYiExitCurrentJieYi_Re(player, role, cmd, others)
end

--AudienceGetList_Re
cmd_list[701] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd._fight_info = {}
	for i = 1, count do
		is_idx, cmd._fight_info[i] = DeserializeStruct(is, is_idx, "FightInfo")
	end

	OnCommand_AudienceGetList_Re(player, role, cmd, others)
end

--AudienceGetOperation_Re
cmd_list[703] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.room_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.robot_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.robot_seed = Deserialize(is, is_idx, "number")
	is_idx, cmd.robot_type = Deserialize(is, is_idx, "number")
	is_idx, cmd.player1 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
	is_idx, cmd.player2 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
	is_idx, cmd.operation = DeserializeStruct(is, is_idx, "PvpVideo")

	OnCommand_AudienceGetOperation_Re(player, role, cmd, others)
end

--AudienceSendOperation
cmd_list[704] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.room_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.operation = DeserializeStruct(is, is_idx, "PvpVideo")

	OnCommand_AudienceSendOperation(player, role, cmd, others)
end

--AudienceFinishRoom
cmd_list[706] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.room_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.win_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.reason = Deserialize(is, is_idx, "number")
	is_idx, cmd.operation = DeserializeStruct(is, is_idx, "PvpVideo")

	OnCommand_AudienceFinishRoom(player, role, cmd, others)
end

--AudienceUpdateNum
cmd_list[707] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.num = Deserialize(is, is_idx, "number")

	OnCommand_AudienceUpdateNum(player, role, cmd, others)
end

--PhotoSetPhoto_Re
cmd_list[731] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.photo_id = Deserialize(is, is_idx, "number")

	OnCommand_PhotoSetPhoto_Re(player, role, cmd, others)
end

--PhotoSetPhotoFrame_Re
cmd_list[733] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.photoframe_id = Deserialize(is, is_idx, "number")

	OnCommand_PhotoSetPhotoFrame_Re(player, role, cmd, others)
end

--PhotoUpdatePhotoInfo
cmd_list[736] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.photo_info = {}
	for i = 1, count do
		is_idx, cmd.photo_info[i] = DeserializeStruct(is, is_idx, "PhotoInfo")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.photoframe_info = {}
	for i = 1, count do
		is_idx, cmd.photoframe_info[i] = DeserializeStruct(is, is_idx, "PhotoInfo")
	end

	OnCommand_PhotoUpdatePhotoInfo(player, role, cmd, others)
end

--PhotoUpdateBadgeInfo
cmd_list[737] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.add_flag = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.badge_info = {}
	for i = 1, count do
		is_idx, cmd.badge_info[i] = DeserializeStruct(is, is_idx, "PhotoInfo")
	end

	OnCommand_PhotoUpdateBadgeInfo(player, role, cmd, others)
end

--YueZhanCreate_Re
cmd_list[752] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.room_id = Deserialize(is, is_idx, "number")

	OnCommand_YueZhanCreate_Re(player, role, cmd, others)
end

--YueZhanJoin_Re
cmd_list[754] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.room_id = Deserialize(is, is_idx, "number")

	OnCommand_YueZhanJoin_Re(player, role, cmd, others)
end

--YueZhanCancel_Re
cmd_list[756] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.room_id = Deserialize(is, is_idx, "number")

	OnCommand_YueZhanCancel_Re(player, role, cmd, others)
end

--DanMuInfo
cmd_list[758] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.info = DeserializeStruct(is, is_idx, "DanMuDataVector")

	OnCommand_DanMuInfo(player, role, cmd, others)
end

--YueZhanInfo
cmd_list[759] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "number")
	is_idx, cmd.channel = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.creater = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, cmd.joiner = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, cmd.announce = Deserialize(is, is_idx, "string")
	is_idx, cmd.info_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.time = Deserialize(is, is_idx, "number")

	OnCommand_YueZhanInfo(player, role, cmd, others)
end

--GetFlowerInfo_Re
cmd_list[801] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.info = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, cmd.lingering = Deserialize(is, is_idx, "number")
	is_idx, cmd.flower_count = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.flowergift_info = {}
	for i = 1, count do
		is_idx, cmd.flowergift_info[i] = DeserializeStruct(is, is_idx, "FlowerGiftInfo")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.sendflowergift_info = {}
	for i = 1, count do
		is_idx, cmd.sendflowergift_info[i] = DeserializeStruct(is, is_idx, "FlowerGiftInfo")
	end
	is_idx, cmd.recive_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.title_id = Deserialize(is, is_idx, "number")

	OnCommand_GetFlowerInfo_Re(player, role, cmd, others)
end

--UpdateFlowerGiftInfo
cmd_list[807] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_UpdateFlowerGiftInfo(player, role, cmd, others)
end

--SendFlowerGift_Re
cmd_list[808] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.count = Deserialize(is, is_idx, "number")
	is_idx, cmd.time = Deserialize(is, is_idx, "number")
	is_idx, cmd.src = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, cmd.dest = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, cmd.mask = Deserialize(is, is_idx, "number")

	OnCommand_SendFlowerGift_Re(player, role, cmd, others)
end

--FlowerGiftTipsClear_Re
cmd_list[810] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.flag = Deserialize(is, is_idx, "number")

	OnCommand_FlowerGiftTipsClear_Re(player, role, cmd, others)
end

--TeXingGetInfo_Re
cmd_list[822] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.texing_info = {}
	for i = 1, count do
		is_idx, cmd.texing_info[i] = Deserialize(is, is_idx, "number")
	end

	OnCommand_TeXingGetInfo_Re(player, role, cmd, others)
end

--TeXingUpdateInfo
cmd_list[823] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.texing_add = {}
	for i = 1, count do
		is_idx, cmd.texing_add[i] = Deserialize(is, is_idx, "number")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.texing_del = {}
	for i = 1, count do
		is_idx, cmd.texing_del[i] = Deserialize(is, is_idx, "number")
	end

	OnCommand_TeXingUpdateInfo(player, role, cmd, others)
end

--ChongZhi
cmd_list[831] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.yuanbao = Deserialize(is, is_idx, "number")
	is_idx, cmd.extra_yuanbao = Deserialize(is, is_idx, "number")
	is_idx, cmd.fudai_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.fudai_time = Deserialize(is, is_idx, "number")

	OnCommand_ChongZhi(player, role, cmd, others)
end

--UpdateFuDaiTime
cmd_list[832] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.fudai_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.fudai_time = Deserialize(is, is_idx, "number")

	OnCommand_UpdateFuDaiTime(player, role, cmd, others)
end

--FuDaiGetReward_Re
cmd_list[834] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.fudai_flag = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.item = {}
	for i = 1, count do
		is_idx, cmd.item[i] = DeserializeStruct(is, is_idx, "Item")
	end

	OnCommand_FuDaiGetReward_Re(player, role, cmd, others)
end

--DailySignUpdate
cmd_list[841] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.sign_date = Deserialize(is, is_idx, "number")
	is_idx, cmd.today_flag = Deserialize(is, is_idx, "number")

	OnCommand_DailySignUpdate(player, role, cmd, others)
end

--TowerGetInfo_Re
cmd_list[852] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")
	is_idx, cmd.cur_layer = Deserialize(is, is_idx, "number")
	is_idx, cmd.all_star = Deserialize(is, is_idx, "number")
	is_idx, cmd.cur_star = Deserialize(is, is_idx, "number")
	is_idx, cmd.sweep_layer = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.buff = {}
	for i = 1, count do
		is_idx, cmd.buff[i] = Deserialize(is, is_idx, "number")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.dead_hero = {}
	for i = 1, count do
		is_idx, cmd.dead_hero[i] = Deserialize(is, is_idx, "number")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.injured_hero = {}
	for i = 1, count do
		is_idx, cmd.injured_hero[i] = DeserializeStruct(is, is_idx, "ShiLianHeroInfo")
	end
	is_idx, cmd.yestaday_difficulty = Deserialize(is, is_idx, "number")
	is_idx, cmd.yestaday_rank = Deserialize(is, is_idx, "number")
	is_idx, cmd.get_prize_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.rank = Deserialize(is, is_idx, "number")
	is_idx, cmd.history_best_layer = Deserialize(is, is_idx, "number")
	is_idx, cmd.history_best_star = Deserialize(is, is_idx, "number")

	OnCommand_TowerGetInfo_Re(player, role, cmd, others)
end

--TowerSelectDifficulty_Re
cmd_list[854] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")
	is_idx, cmd.layer = Deserialize(is, is_idx, "number")

	OnCommand_TowerSelectDifficulty_Re(player, role, cmd, others)
end

--TowerGetLayerInfo_Re
cmd_list[856] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.layer = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.buff_list = {}
	for i = 1, count do
		is_idx, cmd.buff_list[i] = Deserialize(is, is_idx, "number")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.buff_buy_flag = {}
	for i = 1, count do
		is_idx, cmd.buff_buy_flag[i] = Deserialize(is, is_idx, "number")
	end
	is_idx, cmd.army_difficulty = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.cur_army = {}
	for i = 1, count do
		is_idx, cmd.cur_army[i] = DeserializeStruct(is, is_idx, "TowerArmyInfoList")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.cur_army_ids = {}
	for i = 1, count do
		is_idx, cmd.cur_army_ids[i] = Deserialize(is, is_idx, "number")
	end
	is_idx, cmd.sweep_layer = Deserialize(is, is_idx, "number")

	OnCommand_TowerGetLayerInfo_Re(player, role, cmd, others)
end

--TowerSelectArmyInfo_Re
cmd_list[858] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")

	OnCommand_TowerSelectArmyInfo_Re(player, role, cmd, others)
end

--TowerOpenBox_Re
cmd_list[861] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.layer = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.item = {}
	for i = 1, count do
		is_idx, cmd.item[i] = DeserializeStruct(is, is_idx, "Item")
	end

	OnCommand_TowerOpenBox_Re(player, role, cmd, others)
end

--TowerBuyBuff_Re
cmd_list[863] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.layer = Deserialize(is, is_idx, "number")
	is_idx, cmd.id = Deserialize(is, is_idx, "number")
	is_idx, cmd.cur_star = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.hero = {}
	for i = 1, count do
		is_idx, cmd.hero[i] = DeserializeStruct(is, is_idx, "ShiLianHeroInfo")
	end

	OnCommand_TowerBuyBuff_Re(player, role, cmd, others)
end

--TowerJoinBattle_Re
cmd_list[865] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.layer = Deserialize(is, is_idx, "number")

	OnCommand_TowerJoinBattle_Re(player, role, cmd, others)
end

--TowerEndBattle_Re
cmd_list[867] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.win_flag = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.hero = {}
	for i = 1, count do
		is_idx, cmd.hero[i] = DeserializeStruct(is, is_idx, "ShiLianHeroInfo")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.army = {}
	for i = 1, count do
		is_idx, cmd.army[i] = DeserializeStruct(is, is_idx, "ShiLianHeroInfo")
	end
	is_idx, cmd.all_star = Deserialize(is, is_idx, "number")
	is_idx, cmd.cur_star = Deserialize(is, is_idx, "number")
	is_idx, cmd.history_best_layer = Deserialize(is, is_idx, "number")
	is_idx, cmd.history_best_star = Deserialize(is, is_idx, "number")

	OnCommand_TowerEndBattle_Re(player, role, cmd, others)
end

--TowerGetRankPrize_Re
cmd_list[869] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.item = DeserializeStruct(is, is_idx, "TemporaryBackPackData")
	is_idx, cmd.yestaday_rank = Deserialize(is, is_idx, "number")
	is_idx, cmd.yestaday_difficulty = Deserialize(is, is_idx, "number")
	is_idx, cmd.get_prize_flag = Deserialize(is, is_idx, "number")

	OnCommand_TowerGetRankPrize_Re(player, role, cmd, others)
end

--TowerUpdateRoleInfo
cmd_list[870] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")

	OnCommand_TowerUpdateRoleInfo(player, role, cmd, others)
end

--TowerSweep_Re
cmd_list[872] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.layer = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.hero = {}
	for i = 1, count do
		is_idx, cmd.hero[i] = DeserializeStruct(is, is_idx, "ShiLianHeroInfo")
	end
	is_idx, cmd.all_star = Deserialize(is, is_idx, "number")
	is_idx, cmd.cur_star = Deserialize(is, is_idx, "number")
	is_idx, cmd.cur_rank = Deserialize(is, is_idx, "number")
	is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")

	OnCommand_TowerSweep_Re(player, role, cmd, others)
end

--DaTiGetInfo_Re
cmd_list[901] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.cur_num = Deserialize(is, is_idx, "number")
	is_idx, cmd.cur_right_num = Deserialize(is, is_idx, "number")
	is_idx, cmd.today_reward = Deserialize(is, is_idx, "number")
	is_idx, cmd.exp = Deserialize(is, is_idx, "number")
	is_idx, cmd.yuanbao = Deserialize(is, is_idx, "number")
	is_idx, cmd.use_time = Deserialize(is, is_idx, "number")
	is_idx, cmd.history_right_num = Deserialize(is, is_idx, "number")
	is_idx, cmd.history_use_time = Deserialize(is, is_idx, "number")

	OnCommand_DaTiGetInfo_Re(player, role, cmd, others)
end

--DaTiUpdateInfo
cmd_list[902] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.cur_num = Deserialize(is, is_idx, "number")
	is_idx, cmd.cur_right_num = Deserialize(is, is_idx, "number")
	is_idx, cmd.today_reward = Deserialize(is, is_idx, "number")
	is_idx, cmd.exp = Deserialize(is, is_idx, "number")
	is_idx, cmd.yuanbao = Deserialize(is, is_idx, "number")
	is_idx, cmd.use_time = Deserialize(is, is_idx, "number")
	is_idx, cmd.history_right_num = Deserialize(is, is_idx, "number")
	is_idx, cmd.history_use_time = Deserialize(is, is_idx, "number")

	OnCommand_DaTiUpdateInfo(player, role, cmd, others)
end

--DaTiAnswer_Re
cmd_list[904] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.num = Deserialize(is, is_idx, "number")
	is_idx, cmd.right_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.exp = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.item = {}
	for i = 1, count do
		is_idx, cmd.item[i] = DeserializeStruct(is, is_idx, "Item")
	end

	OnCommand_DaTiAnswer_Re(player, role, cmd, others)
end

--DaTiOpenBox_Re
cmd_list[906] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.exp = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.item = {}
	for i = 1, count do
		is_idx, cmd.item[i] = DeserializeStruct(is, is_idx, "Item")
	end

	OnCommand_DaTiOpenBox_Re(player, role, cmd, others)
end

--SkinEquip_Re
cmd_list[911] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.skinid = Deserialize(is, is_idx, "number")

	OnCommand_SkinEquip_Re(player, role, cmd, others)
end

--SkinBuy_Re
cmd_list[913] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.skinid = Deserialize(is, is_idx, "number")

	OnCommand_SkinBuy_Re(player, role, cmd, others)
end

--SkinTimeOut_Re
cmd_list[915] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.skinid = Deserialize(is, is_idx, "number")

	OnCommand_SkinTimeOut_Re(player, role, cmd, others)
end

--SkinUpdateInfo
cmd_list[916] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.addflag = Deserialize(is, is_idx, "number")
	is_idx, cmd.skinid = Deserialize(is, is_idx, "number")
	is_idx, cmd.time = Deserialize(is, is_idx, "number")
	is_idx, cmd.item = DeserializeStruct(is, is_idx, "Item")

	OnCommand_SkinUpdateInfo(player, role, cmd, others)
end

--WeaponMakeGetInfo_Re
cmd_list[921] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.num = Deserialize(is, is_idx, "number")
	is_idx, cmd.time = Deserialize(is, is_idx, "number")
	is_idx, cmd.level = Deserialize(is, is_idx, "number")
	is_idx, cmd.exp = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.weapon_active = {}
	for i = 1, count do
		is_idx, cmd.weapon_active[i] = Deserialize(is, is_idx, "number")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.weapon_not_active = {}
	for i = 1, count do
		is_idx, cmd.weapon_not_active[i] = Deserialize(is, is_idx, "number")
	end

	OnCommand_WeaponMakeGetInfo_Re(player, role, cmd, others)
end

--WeaponMake_Re
cmd_list[923] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.cost_type = Deserialize(is, is_idx, "number")
	is_idx, cmd.lottery_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.num = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.item = {}
	for i = 1, count do
		is_idx, cmd.item[i] = DeserializeStruct(is, is_idx, "Item")
	end

	OnCommand_WeaponMake_Re(player, role, cmd, others)
end

--WeaponMakeGetStone_Re
cmd_list[925] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.time = Deserialize(is, is_idx, "number")

	OnCommand_WeaponMakeGetStone_Re(player, role, cmd, others)
end

--WeaponMakeActive_Re
cmd_list[927] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.item_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.exp = Deserialize(is, is_idx, "number")

	OnCommand_WeaponMakeActive_Re(player, role, cmd, others)
end

--WeaponMakeLevelUp_Re
cmd_list[929] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.level = Deserialize(is, is_idx, "number")

	OnCommand_WeaponMakeLevelUp_Re(player, role, cmd, others)
end

--WeaponForge_Re
cmd_list[932] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.weapon_info = DeserializeStruct(is, is_idx, "WeaponItem")

	OnCommand_WeaponForge_Re(player, role, cmd, others)
end

--WeaponResetSkill_Re
cmd_list[934] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.reset_time = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.skill_pro = {}
	for i = 1, count do
		is_idx, cmd.skill_pro[i] = DeserializeStruct(is, is_idx, "WeaponSkill")
	end

	OnCommand_WeaponResetSkill_Re(player, role, cmd, others)
end

--WeaponForgeGetInfo_Re
cmd_list[936] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.today = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.reset_time = Deserialize(is, is_idx, "number")
	is_idx, cmd.weapon_info = DeserializeStruct(is, is_idx, "WeaponItem")

	OnCommand_WeaponForgeGetInfo_Re(player, role, cmd, others)
end

--TestFloat
cmd_list[941] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.seed = Deserialize(is, is_idx, "number")
	is_idx, cmd.count = Deserialize(is, is_idx, "number")

	OnCommand_TestFloat(player, role, cmd, others)
end

--MilitaryGetInfo_Re
cmd_list[951] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.stage_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.stage_difficult = Deserialize(is, is_idx, "number")
	is_idx, cmd.horse_id = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.stage_info = {}
	for i = 1, count do
		is_idx, cmd.stage_info[i] = DeserializeStruct(is, is_idx, "MilitaryStageInfo")
	end

	OnCommand_MilitaryGetInfo_Re(player, role, cmd, others)
end

--MilitarySweep_Re
cmd_list[953] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.stage_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.cd = Deserialize(is, is_idx, "number")
	is_idx, cmd.times = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.item = {}
	for i = 1, count do
		is_idx, cmd.item[i] = DeserializeStruct(is, is_idx, "Item")
	end
	is_idx, cmd.exp = Deserialize(is, is_idx, "number")

	OnCommand_MilitarySweep_Re(player, role, cmd, others)
end

--MilitaryJoinBattle_Re
cmd_list[955] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.stage_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.difficult = Deserialize(is, is_idx, "number")

	OnCommand_MilitaryJoinBattle_Re(player, role, cmd, others)
end

--MilitaryEndBattle_Re
cmd_list[957] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.reward_param = Deserialize(is, is_idx, "number")
	is_idx, cmd.hurt = Deserialize(is, is_idx, "number")
	is_idx, cmd.record = Deserialize(is, is_idx, "number")
	is_idx, cmd.stage_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.difficult = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.item = {}
	for i = 1, count do
		is_idx, cmd.item[i] = DeserializeStruct(is, is_idx, "Item")
	end
	is_idx, cmd.exp = Deserialize(is, is_idx, "number")

	OnCommand_MilitaryEndBattle_Re(player, role, cmd, others)
end

--MilitaryUpdateInfo
cmd_list[958] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.stage_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.stage_difficult = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.stage_info = {}
	for i = 1, count do
		is_idx, cmd.stage_info[i] = DeserializeStruct(is, is_idx, "MilitaryStageInfo")
	end

	OnCommand_MilitaryUpdateInfo(player, role, cmd, others)
end

--HotPvpVideoList_Re
cmd_list[1002] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.list = {}
	for i = 1, count do
		is_idx, cmd.list[i] = DeserializeStruct(is, is_idx, "HotPvpVideo")
	end

	OnCommand_HotPvpVideoList_Re(player, role, cmd, others)
end

--ZhanliGetInfo_Re
cmd_list[1021] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.zhanli = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.members = {}
	for i = 1, count do
		is_idx, cmd.members[i] = DeserializeStruct(is, is_idx, "TopListData")
	end

	OnCommand_ZhanliGetInfo_Re(player, role, cmd, others)
end

--GetActiveCodeRward_Re
cmd_list[1031] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.item = {}
	for i = 1, count do
		is_idx, cmd.item[i] = DeserializeStruct(is, is_idx, "Item")
	end

	OnCommand_GetActiveCodeRward_Re(player, role, cmd, others)
end

--PveArenaUpdateRefreshTime
cmd_list[1040] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.pve_refreshtime = Deserialize(is, is_idx, "number")

	OnCommand_PveArenaUpdateRefreshTime(player, role, cmd, others)
end

--ChangeRoleName_Re
cmd_list[19999] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.name = Deserialize(is, is_idx, "string")

	OnCommand_ChangeRoleName_Re(player, role, cmd, others)
end

--TopListGet_Re
cmd_list[20001] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.top_type = Deserialize(is, is_idx, "number")
	is_idx, cmd.top_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.members = {}
	for i = 1, count do
		is_idx, cmd.members[i] = DeserializeStruct(is, is_idx, "TopListData")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.reward_info = {}
	for i = 1, count do
		is_idx, cmd.reward_info[i] = Deserialize(is, is_idx, "number")
	end

	OnCommand_TopListGet_Re(player, role, cmd, others)
end

--GMcmd_Bull
cmd_list[99996] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.text = Deserialize(is, is_idx, "string")

	OnCommand_GMcmd_Bull(player, role, cmd, others)
end

--GMCommand_Re
cmd_list[99998] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "string")
	is_idx, cmd.arg1 = Deserialize(is, is_idx, "string")
	is_idx, cmd.arg2 = Deserialize(is, is_idx, "string")
	is_idx, cmd.arg3 = Deserialize(is, is_idx, "string")
	is_idx, cmd.arg4 = Deserialize(is, is_idx, "string")

	OnCommand_GMCommand_Re(player, role, cmd, others)
end

--PrivateChat
cmd_list[10003] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.src = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, cmd.dest = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.text_content = Deserialize(is, is_idx, "string")
	is_idx, cmd.speech_content = Deserialize(is, is_idx, "string")
	is_idx, cmd.time = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")

	OnCommand_PrivateChat(player, role, cmd, others)
end

--PublicChat
cmd_list[10004] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.src = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, cmd.text_content = Deserialize(is, is_idx, "string")
	is_idx, cmd.speech_content = Deserialize(is, is_idx, "string")
	is_idx, cmd.time = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.channel = Deserialize(is, is_idx, "number")

	OnCommand_PublicChat(player, role, cmd, others)
end

--RoleForbidTalk
cmd_list[10005] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.begintime = Deserialize(is, is_idx, "number")
	is_idx, cmd.time = Deserialize(is, is_idx, "number")
	is_idx, cmd.nitifytouser = Deserialize(is, is_idx, "string")

	OnCommand_RoleForbidTalk(player, role, cmd, others)
end

--ListFriends_Re
cmd_list[10007] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.friends = {}
	for i = 1, count do
		is_idx, cmd.friends[i] = DeserializeStruct(is, is_idx, "Friend")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.requests = {}
	for i = 1, count do
		is_idx, cmd.requests[i] = DeserializeStruct(is, is_idx, "Friend")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.black_list = {}
	for i = 1, count do
		is_idx, cmd.black_list[i] = DeserializeStruct(is, is_idx, "RoleBrief")
	end

	OnCommand_ListFriends_Re(player, role, cmd, others)
end

--FriendRequest_Re
cmd_list[10009] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")

	OnCommand_FriendRequest_Re(player, role, cmd, others)
end

--FriendAddRequest
cmd_list[10010] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.requests = DeserializeStruct(is, is_idx, "Friend")

	OnCommand_FriendAddRequest(player, role, cmd, others)
end

--FriendReply_Re
cmd_list[10012] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.src_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.accept = Deserialize(is, is_idx, "boolean")

	OnCommand_FriendReply_Re(player, role, cmd, others)
end

--NewFriend
cmd_list[10013] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.friend = DeserializeStruct(is, is_idx, "Friend")

	OnCommand_NewFriend(player, role, cmd, others)
end

--RemoveFriend_Re
cmd_list[10015] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")

	OnCommand_RemoveFriend_Re(player, role, cmd, others)
end

--FriendDelRequest
cmd_list[10016] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.role_id = Deserialize(is, is_idx, "string")

	OnCommand_FriendDelRequest(player, role, cmd, others)
end

--FriendUpdateInfo
cmd_list[10017] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.friend_info = DeserializeStruct(is, is_idx, "Friend")

	OnCommand_FriendUpdateInfo(player, role, cmd, others)
end

--MafiaGet_Re
cmd_list[10102] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.mafia = DeserializeStruct(is, is_idx, "Mafia")

	OnCommand_MafiaGet_Re(player, role, cmd, others)
end

--MafiaCreate_Re
cmd_list[10104] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.mafia = DeserializeStruct(is, is_idx, "Mafia")

	OnCommand_MafiaCreate_Re(player, role, cmd, others)
end

--MafiaList_Re
cmd_list[10106] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.mafia_info = {}
	for i = 1, count do
		is_idx, cmd.mafia_info[i] = DeserializeStruct(is, is_idx, "MafiaBrief")
	end

	OnCommand_MafiaList_Re(player, role, cmd, others)
end

--MafiaGetSelfInfo_Re
cmd_list[10108] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.mafia_info = DeserializeStruct(is, is_idx, "MafiaSelfInfo")

	OnCommand_MafiaGetSelfInfo_Re(player, role, cmd, others)
end

--MafiaUpdateSelfInfo
cmd_list[10109] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.mafia_info = DeserializeStruct(is, is_idx, "MafiaSelfInfo")

	OnCommand_MafiaUpdateSelfInfo(player, role, cmd, others)
end

--MafiaApply_Re
cmd_list[10111] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.id = Deserialize(is, is_idx, "string")

	OnCommand_MafiaApply_Re(player, role, cmd, others)
end

--MafiaQuit_Re
cmd_list[10113] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_MafiaQuit_Re(player, role, cmd, others)
end

--MafiaGetApplyList_Re
cmd_list[10115] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.apply_info = {}
	for i = 1, count do
		is_idx, cmd.apply_info[i] = DeserializeStruct(is, is_idx, "MafiaApplyRoleInfo")
	end

	OnCommand_MafiaGetApplyList_Re(player, role, cmd, others)
end

--MafiaOperateApplyList_Re
cmd_list[10117] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.accept = Deserialize(is, is_idx, "number")
	is_idx, cmd.role_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.mafia_id = Deserialize(is, is_idx, "string")

	OnCommand_MafiaOperateApplyList_Re(player, role, cmd, others)
end

--MafiaSetLevelLimit_Re
cmd_list[10119] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.level = Deserialize(is, is_idx, "number")
	is_idx, cmd.need_approval = Deserialize(is, is_idx, "number")

	OnCommand_MafiaSetLevelLimit_Re(player, role, cmd, others)
end

--MafiaSetAnnounce_Re
cmd_list[10121] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.announce = Deserialize(is, is_idx, "string")

	OnCommand_MafiaSetAnnounce_Re(player, role, cmd, others)
end

--MafiaKickout_Re
cmd_list[10123] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.role_id = Deserialize(is, is_idx, "string")

	OnCommand_MafiaKickout_Re(player, role, cmd, others)
end

--MafiaUpdateApplyList
cmd_list[10124] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.del_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.apply_info = DeserializeStruct(is, is_idx, "MafiaApplyRoleInfo")

	OnCommand_MafiaUpdateApplyList(player, role, cmd, others)
end

--MafiaUpdateMafiaInfo
cmd_list[10125] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.info = DeserializeStruct(is, is_idx, "MafiaInterfaceInfo")

	OnCommand_MafiaUpdateMafiaInfo(player, role, cmd, others)
end

--MafiaUpdateExp
cmd_list[10126] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.exp = Deserialize(is, is_idx, "number")
	is_idx, cmd.level = Deserialize(is, is_idx, "number")
	is_idx, cmd.jisi = Deserialize(is, is_idx, "number")

	OnCommand_MafiaUpdateExp(player, role, cmd, others)
end

--MafiaUpdateMemberInfo
cmd_list[10127] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.member = DeserializeStruct(is, is_idx, "MafiaMember")

	OnCommand_MafiaUpdateMemberInfo(player, role, cmd, others)
end

--MafiaUpdateNoticeInfo
cmd_list[10128] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.notice_info = DeserializeStruct(is, is_idx, "MafiaNoticeInfo")

	OnCommand_MafiaUpdateNoticeInfo(player, role, cmd, others)
end

--MafiaChangeMenberPosition_Re
cmd_list[10130] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.position = Deserialize(is, is_idx, "number")
	is_idx, cmd.role_id = Deserialize(is, is_idx, "string")

	OnCommand_MafiaChangeMenberPosition_Re(player, role, cmd, others)
end

--MafiaShanRang_Re
cmd_list[10132] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.role_id = Deserialize(is, is_idx, "string")

	OnCommand_MafiaShanRang_Re(player, role, cmd, others)
end

--MafiaJiSi_Re
cmd_list[10134] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.jisi_typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

	OnCommand_MafiaJiSi_Re(player, role, cmd, others)
end

--MafiaDeclaration_Re
cmd_list[10136] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.declaration = Deserialize(is, is_idx, "string")
	is_idx, cmd.broadcast_flag = Deserialize(is, is_idx, "number")

	OnCommand_MafiaDeclaration_Re(player, role, cmd, others)
end

--MafiaChangeName_Re
cmd_list[10138] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.name = Deserialize(is, is_idx, "string")

	OnCommand_MafiaChangeName_Re(player, role, cmd, others)
end

--MafiaSeeInfo_Re
cmd_list[10140] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.mafia_info = DeserializeStruct(is, is_idx, "MafiaBrief")

	OnCommand_MafiaSeeInfo_Re(player, role, cmd, others)
end

--MafiaBangZhuSendMail_Re
cmd_list[10142] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
	is_idx, cmd.subject = Deserialize(is, is_idx, "string")
	is_idx, cmd.context = Deserialize(is, is_idx, "string")

	OnCommand_MafiaBangZhuSendMail_Re(player, role, cmd, others)
end

--MafiaDeclarationBroadCast
cmd_list[10143] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.mafia_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.mafia_name = Deserialize(is, is_idx, "string")
	is_idx, cmd.info = Deserialize(is, is_idx, "string")
	is_idx, cmd.time = Deserialize(is, is_idx, "number")

	OnCommand_MafiaDeclarationBroadCast(player, role, cmd, others)
end

--Ping_Re
cmd_list[10202] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.client_send_time = Deserialize(is, is_idx, "number")

	OnCommand_Ping_Re(player, role, cmd, others)
end

--UDPPing_Re
cmd_list[10204] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.client_send_time = Deserialize(is, is_idx, "number")

	OnCommand_UDPPing_Re(player, role, cmd, others)
end

--UDPClientTimeRequest
cmd_list[10205] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_UDPClientTimeRequest(player, role, cmd, others)
end


