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


--EnterInstance
cmd_list[7] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.inst_tid = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.heros = {}
	for i = 1, count do
		is_idx, cmd.heros[i] = Deserialize(is, is_idx, "number")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.req_heros = {}
	for i = 1, count do
		is_idx, cmd.req_heros[i] = Deserialize(is, is_idx, "number")
	end

	OnCommand_EnterInstance(player, role, cmd, others)
end

--CompleteInstance
cmd_list[9] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.inst_tid = Deserialize(is, is_idx, "number")
	is_idx, cmd.flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.score = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.heros = {}
	for i = 1, count do
		is_idx, cmd.heros[i] = Deserialize(is, is_idx, "number")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.req_heros = {}
	for i = 1, count do
		is_idx, cmd.req_heros[i] = Deserialize(is, is_idx, "number")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.operations = {}
	for i = 1, count do
		is_idx, cmd.operations[i] = DeserializeStruct(is, is_idx, "PVEOperation")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.star = {}
	for i = 1, count do
		is_idx, cmd.star[i] = DeserializeStruct(is, is_idx, "Instance_Star_Condition")
	end
	is_idx, cmd.moneypiles = Deserialize(is, is_idx, "number")
	is_idx, cmd.chests = Deserialize(is, is_idx, "number")

	OnCommand_CompleteInstance(player, role, cmd, others)
end

--OPStat
cmd_list[12] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.opset_count = Deserialize(is, is_idx, "number")
	is_idx, cmd.op_count = Deserialize(is, is_idx, "number")

	OnCommand_OPStat(player, role, cmd, others)
end

--PVPInvite
cmd_list[10301] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.src = DeserializeStruct(is, is_idx, "RoleBrief")
	is_idx, cmd.mode = Deserialize(is, is_idx, "number")

	OnCommand_PVPInvite(player, role, cmd, others)
end

--PVPReply
cmd_list[10302] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.src_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.accept = Deserialize(is, is_idx, "boolean")

	OnCommand_PVPReply(player, role, cmd, others)
end

--PVPReady
cmd_list[10304] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_PVPReady(player, role, cmd, others)
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

--PVPPeerLatency
cmd_list[10310] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.latency = Deserialize(is, is_idx, "number")

	OnCommand_PVPPeerLatency(player, role, cmd, others)
end

--PVPPause_Re
cmd_list[10312] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.index = Deserialize(is, is_idx, "number")

	OnCommand_PVPPause_Re(player, role, cmd, others)
end

--PVPSendAutoVoice
cmd_list[10314] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.voice_id = Deserialize(is, is_idx, "number")

	OnCommand_PVPSendAutoVoice(player, role, cmd, others)
end

--PVPOperationCommit
cmd_list[10317] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_PVPOperationCommit(player, role, cmd, others)
end

--RoleNameQuery
cmd_list[10321] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.pattern = Deserialize(is, is_idx, "string")
	is_idx, cmd.reason = Deserialize(is, is_idx, "number")

	OnCommand_RoleNameQuery(player, role, cmd, others)
end

--BuyRefreshShopTimes
cmd_list[10323] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.shop_id = Deserialize(is, is_idx, "number")

	OnCommand_BuyRefreshShopTimes(player, role, cmd, others)
end

--GetShopRecoveryTime
cmd_list[10325] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.shop_id = Deserialize(is, is_idx, "number")

	OnCommand_GetShopRecoveryTime(player, role, cmd, others)
end

--GetActivityReward
cmd_list[10327] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.activity_id = Deserialize(is, is_idx, "number")

	OnCommand_GetActivityReward(player, role, cmd, others)
end

--GetJiaNianHuaInfo
cmd_list[10329] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_GetJiaNianHuaInfo(player, role, cmd, others)
end

--GetClientLocalTime_Re
cmd_list[10332] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.server_ms = Deserialize(is, is_idx, "number")
	is_idx, cmd.client_ms = Deserialize(is, is_idx, "number")

	OnCommand_GetClientLocalTime_Re(player, role, cmd, others)
end

--SweepInstance
cmd_list[100] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.instance = Deserialize(is, is_idx, "number")
	is_idx, cmd.count = Deserialize(is, is_idx, "number")

	OnCommand_SweepInstance(player, role, cmd, others)
end

--GetBackPack
cmd_list[102] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_GetBackPack(player, role, cmd, others)
end

--GetInstance
cmd_list[104] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_GetInstance(player, role, cmd, others)
end

--BuyVp
cmd_list[107] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_BuyVp(player, role, cmd, others)
end

--BuyInstanceCount
cmd_list[109] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.inst_tid = Deserialize(is, is_idx, "number")

	OnCommand_BuyInstanceCount(player, role, cmd, others)
end

--TaskFinish
cmd_list[115] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.task_id = Deserialize(is, is_idx, "number")

	OnCommand_TaskFinish(player, role, cmd, others)
end

--Client_User_Define
cmd_list[118] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.user_key = Deserialize(is, is_idx, "number")
	is_idx, cmd.user_value = Deserialize(is, is_idx, "string")

	OnCommand_Client_User_Define(player, role, cmd, others)
end

--BuyHero
cmd_list[119] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.tid = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")

	OnCommand_BuyHero(player, role, cmd, others)
end

--UseItem
cmd_list[122] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.tid = Deserialize(is, is_idx, "number")
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.count = Deserialize(is, is_idx, "number")

	OnCommand_UseItem(player, role, cmd, others)
end

--One_Level_Up
cmd_list[126] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.item = {}
	for i = 1, count do
		is_idx, cmd.item[i] = DeserializeStruct(is, is_idx, "Item")
	end

	OnCommand_One_Level_Up(player, role, cmd, others)
end

--Hero_Up_Grade
cmd_list[128] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")

	OnCommand_Hero_Up_Grade(player, role, cmd, others)
end

--BuyHorse
cmd_list[131] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.tid = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")

	OnCommand_BuyHorse(player, role, cmd, others)
end

--GetLastHero
cmd_list[134] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_GetLastHero(player, role, cmd, others)
end

--PvpJoin
cmd_list[136] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.heroinfo = {}
	for i = 1, count do
		is_idx, cmd.heroinfo[i] = Deserialize(is, is_idx, "number")
	end

	OnCommand_PvpJoin(player, role, cmd, others)
end

--PvpEnter
cmd_list[139] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.index = Deserialize(is, is_idx, "number")
	is_idx, cmd.flag = Deserialize(is, is_idx, "number")

	OnCommand_PvpEnter(player, role, cmd, others)
end

--PvpCancle
cmd_list[141] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_PvpCancle(player, role, cmd, others)
end

--PvpSpeed
cmd_list[143] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.speed = Deserialize(is, is_idx, "number")

	OnCommand_PvpSpeed(player, role, cmd, others)
end

--ResetRoleInfo
cmd_list[144] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_ResetRoleInfo(player, role, cmd, others)
end

--GetTask
cmd_list[148] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_GetTask(player, role, cmd, others)
end

--HeroUpgradeSkill
cmd_list[150] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.skill_info = {}
	for i = 1, count do
		is_idx, cmd.skill_info[i] = DeserializeStruct(is, is_idx, "UpgradeSkillInfo")
	end

	OnCommand_HeroUpgradeSkill(player, role, cmd, others)
end

--GetHeroComments
cmd_list[152] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")

	OnCommand_GetHeroComments(player, role, cmd, others)
end

--AgreeHeroComments
cmd_list[154] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.role_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.time_stamp = Deserialize(is, is_idx, "number")

	OnCommand_AgreeHeroComments(player, role, cmd, others)
end

--WriteHeroComments
cmd_list[156] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.comments = Deserialize(is, is_idx, "string")

	OnCommand_WriteHeroComments(player, role, cmd, others)
end

--ReWriteHeroComments
cmd_list[158] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.comments = Deserialize(is, is_idx, "string")

	OnCommand_ReWriteHeroComments(player, role, cmd, others)
end

--GetVPRefreshTime
cmd_list[161] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_GetVPRefreshTime(player, role, cmd, others)
end

--GetSkillPointRefreshTime
cmd_list[163] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_GetSkillPointRefreshTime(player, role, cmd, others)
end

--RoleLogin
cmd_list[165] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_RoleLogin(player, role, cmd, others)
end

--BuySkillPoint
cmd_list[166] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_BuySkillPoint(player, role, cmd, others)
end

--GetVideo
cmd_list[169] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.video_id = Deserialize(is, is_idx, "string")

	OnCommand_GetVideo(player, role, cmd, others)
end

--AddBlackList
cmd_list[172] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.roleid = Deserialize(is, is_idx, "string")

	OnCommand_AddBlackList(player, role, cmd, others)
end

--DelBlackList
cmd_list[174] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.roleid = Deserialize(is, is_idx, "string")

	OnCommand_DelBlackList(player, role, cmd, others)
end

--SeeAnotherRole
cmd_list[176] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.roleid = Deserialize(is, is_idx, "string")

	OnCommand_SeeAnotherRole(player, role, cmd, others)
end

--GetPrivateChatHistory
cmd_list[178] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_GetPrivateChatHistory(player, role, cmd, others)
end

--ReadMail
cmd_list[179] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.mail_id = Deserialize(is, is_idx, "number")

	OnCommand_ReadMail(player, role, cmd, others)
end

--GetAttachment
cmd_list[181] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.mail_id = Deserialize(is, is_idx, "number")

	OnCommand_GetAttachment(player, role, cmd, others)
end

--BroadcastPvpVideo
cmd_list[187] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.video_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.content = Deserialize(is, is_idx, "string")
	is_idx, cmd.channel = Deserialize(is, is_idx, "number")

	OnCommand_BroadcastPvpVideo(player, role, cmd, others)
end

--ChangeHeroSelectSkill
cmd_list[189] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.skill_id = {}
	for i = 1, count do
		is_idx, cmd.skill_id[i] = Deserialize(is, is_idx, "number")
	end

	OnCommand_ChangeHeroSelectSkill(player, role, cmd, others)
end

--MallBuyItem
cmd_list[193] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.item_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.item_num = Deserialize(is, is_idx, "number")

	OnCommand_MallBuyItem(player, role, cmd, others)
end

--LevelUpHeroStar
cmd_list[198] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")

	OnCommand_LevelUpHeroStar(player, role, cmd, others)
end

--MysteryShopBuyItem
cmd_list[202] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.shop_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.position = Deserialize(is, is_idx, "number")
	is_idx, cmd.item_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.item_num = Deserialize(is, is_idx, "number")

	OnCommand_MysteryShopBuyItem(player, role, cmd, others)
end

--RefreshMysteryShop
cmd_list[204] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.shop_id = Deserialize(is, is_idx, "number")

	OnCommand_RefreshMysteryShop(player, role, cmd, others)
end

--ResetBattleField
cmd_list[206] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")

	OnCommand_ResetBattleField(player, role, cmd, others)
end

--BattleFieldBegin
cmd_list[208] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.heros = {}
	for i = 1, count do
		is_idx, cmd.heros[i] = DeserializeStruct(is, is_idx, "BattleHeroInfo")
	end

	OnCommand_BattleFieldBegin(player, role, cmd, others)
end

--BattleFieldMove
cmd_list[210] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.src_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.src_position = Deserialize(is, is_idx, "number")
	is_idx, cmd.dst_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.dst_position = Deserialize(is, is_idx, "number")

	OnCommand_BattleFieldMove(player, role, cmd, others)
end

--BattleFieldJoinBattle
cmd_list[212] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.npc_id = Deserialize(is, is_idx, "number")

	OnCommand_BattleFieldJoinBattle(player, role, cmd, others)
end

--BattleFieldFinishBattle
cmd_list[214] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.win_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.npc_id = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.heros = {}
	for i = 1, count do
		is_idx, cmd.heros[i] = DeserializeStruct(is, is_idx, "BattleHeroInfo")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.operations = {}
	for i = 1, count do
		is_idx, cmd.operations[i] = DeserializeStruct(is, is_idx, "PVEOperation")
	end

	OnCommand_BattleFieldFinishBattle(player, role, cmd, others)
end

--BattleFieldGetPrize
cmd_list[217] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")

	OnCommand_BattleFieldGetPrize(player, role, cmd, others)
end

--SetInstanceHeroInfo
cmd_list[219] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.heros = {}
	for i = 1, count do
		is_idx, cmd.heros[i] = Deserialize(is, is_idx, "number")
	end
	is_idx, cmd.horse = Deserialize(is, is_idx, "number")

	OnCommand_SetInstanceHeroInfo(player, role, cmd, others)
end

--Lottery
cmd_list[221] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.lottery_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.cost_type = Deserialize(is, is_idx, "number")

	OnCommand_Lottery(player, role, cmd, others)
end

--GetBattleFieldInfo
cmd_list[223] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")

	OnCommand_GetBattleFieldInfo(player, role, cmd, others)
end

--BattleFieldCancel
cmd_list[226] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")

	OnCommand_BattleFieldCancel(player, role, cmd, others)
end

--BattleFieldGetEvent
cmd_list[228] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")

	OnCommand_BattleFieldGetEvent(player, role, cmd, others)
end

--GetCurBattleField
cmd_list[231] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_GetCurBattleField(player, role, cmd, others)
end

--BattleFieldFinishEvent
cmd_list[233] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")

	OnCommand_BattleFieldFinishEvent(player, role, cmd, others)
end

--GiveUpCurBattleField
cmd_list[235] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_GiveUpCurBattleField(player, role, cmd, others)
end

--GetRefreshTime
cmd_list[237] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")

	OnCommand_GetRefreshTime(player, role, cmd, others)
end

--DailySign
cmd_list[239] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")

	OnCommand_DailySign(player, role, cmd, others)
end

--GetMyPveArenaInfo
cmd_list[241] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_GetMyPveArenaInfo(player, role, cmd, others)
end

--GetOtherPveArenaInfo
cmd_list[243] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.roleid = Deserialize(is, is_idx, "string")

	OnCommand_GetOtherPveArenaInfo(player, role, cmd, others)
end

--GetFighterInfo
cmd_list[245] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_GetFighterInfo(player, role, cmd, others)
end

--PveArenaJoinBattle
cmd_list[247] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.rank = Deserialize(is, is_idx, "number")

	OnCommand_PveArenaJoinBattle(player, role, cmd, others)
end

--PveArenaEndBattle
cmd_list[249] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.win_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.win_type = Deserialize(is, is_idx, "number")
	is_idx, cmd.replay_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.operation = DeserializeStruct(is, is_idx, "PveArenaOperation")

	OnCommand_PveArenaEndBattle(player, role, cmd, others)
end

--PveArenaResetTime
cmd_list[251] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_PveArenaResetTime(player, role, cmd, others)
end

--PveArenaResetCount
cmd_list[253] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_PveArenaResetCount(player, role, cmd, others)
end

--ChallengeRoleByItem
cmd_list[255] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.roleid = Deserialize(is, is_idx, "string")
	is_idx, cmd.name = Deserialize(is, is_idx, "string")

	OnCommand_ChallengeRoleByItem(player, role, cmd, others)
end

--GetPveArenaHistory
cmd_list[257] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_GetPveArenaHistory(player, role, cmd, others)
end

--GetPveArenaOperation
cmd_list[259] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "number")

	OnCommand_GetPveArenaOperation(player, role, cmd, others)
end

--SetPveArenaHero
cmd_list[261] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.heros = {}
	for i = 1, count do
		is_idx, cmd.heros[i] = Deserialize(is, is_idx, "number")
	end

	OnCommand_SetPveArenaHero(player, role, cmd, others)
end

--ResetSkilllevel
cmd_list[263] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")

	OnCommand_ResetSkilllevel(player, role, cmd, others)
end

--WeaponEquip
cmd_list[265] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero = Deserialize(is, is_idx, "number")
	is_idx, cmd.weapon_id = Deserialize(is, is_idx, "number")

	OnCommand_WeaponEquip(player, role, cmd, others)
end

--WeaponLevelUp
cmd_list[267] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero = Deserialize(is, is_idx, "number")
	is_idx, cmd.weapon_id = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.weapon_cost_ids = {}
	for i = 1, count do
		is_idx, cmd.weapon_cost_ids[i] = Deserialize(is, is_idx, "number")
	end

	OnCommand_WeaponLevelUp(player, role, cmd, others)
end

--WeaponStrength
cmd_list[269] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero = Deserialize(is, is_idx, "number")
	is_idx, cmd.weapon_id = Deserialize(is, is_idx, "number")

	OnCommand_WeaponStrength(player, role, cmd, others)
end

--WeaponDecompose
cmd_list[271] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.weapon_id = Deserialize(is, is_idx, "number")

	OnCommand_WeaponDecompose(player, role, cmd, others)
end

--WeaponUnequip
cmd_list[273] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero = Deserialize(is, is_idx, "number")

	OnCommand_WeaponUnequip(player, role, cmd, others)
end

--WuZheShiLianGetDifficultyInfo
cmd_list[279] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_WuZheShiLianGetDifficultyInfo(player, role, cmd, others)
end

--WuZheShiLianSelectDifficulty
cmd_list[281] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")

	OnCommand_WuZheShiLianSelectDifficulty(player, role, cmd, others)
end

--WuZheShiLianGetOpponentInfo
cmd_list[283] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")

	OnCommand_WuZheShiLianGetOpponentInfo(player, role, cmd, others)
end

--WuZheShiLianGetHeroInfo
cmd_list[285] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_WuZheShiLianGetHeroInfo(player, role, cmd, others)
end

--WuZheShiLianJoinBattle
cmd_list[287] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")
	is_idx, cmd.stage = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.heros = {}
	for i = 1, count do
		is_idx, cmd.heros[i] = Deserialize(is, is_idx, "number")
	end

	OnCommand_WuZheShiLianJoinBattle(player, role, cmd, others)
end

--WuZheShiLianFinishBattle
cmd_list[289] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")
	is_idx, cmd.stage = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.hero = {}
	for i = 1, count do
		is_idx, cmd.hero[i] = DeserializeStruct(is, is_idx, "ShiLianHeroInfo")
	end
	is_idx, cmd.opponent = DeserializeStruct(is, is_idx, "OpponentInfo")
	is_idx, cmd.winflag = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.operations = {}
	for i = 1, count do
		is_idx, cmd.operations[i] = DeserializeStruct(is, is_idx, "PVEOperation")
	end

	OnCommand_WuZheShiLianFinishBattle(player, role, cmd, others)
end

--WuZheShiLianReset
cmd_list[291] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_WuZheShiLianReset(player, role, cmd, others)
end

--WuZheShiLianGetReward
cmd_list[294] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")
	is_idx, cmd.stage = Deserialize(is, is_idx, "number")

	OnCommand_WuZheShiLianGetReward(player, role, cmd, others)
end

--WuZheShiLianSweep
cmd_list[296] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")

	OnCommand_WuZheShiLianSweep(player, role, cmd, others)
end

--EquipmentEquip
cmd_list[301] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.equipment_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.cost_flag = Deserialize(is, is_idx, "number")

	OnCommand_EquipmentEquip(player, role, cmd, others)
end

--EquipmentLevelUp
cmd_list[303] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.equipment_id = Deserialize(is, is_idx, "number")

	OnCommand_EquipmentLevelUp(player, role, cmd, others)
end

--EquipmentGradeUp
cmd_list[305] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.equipment_id = Deserialize(is, is_idx, "number")

	OnCommand_EquipmentGradeUp(player, role, cmd, others)
end

--EquipmentRefinable
cmd_list[307] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.equipment_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.refinable_typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.refinable_count = Deserialize(is, is_idx, "number")

	OnCommand_EquipmentRefinable(player, role, cmd, others)
end

--EquipmentDecompose
cmd_list[309] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.equipment_id = {}
	for i = 1, count do
		is_idx, cmd.equipment_id[i] = Deserialize(is, is_idx, "number")
	end

	OnCommand_EquipmentDecompose(player, role, cmd, others)
end

--EquipmentUnequip
cmd_list[311] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.cost_flag = Deserialize(is, is_idx, "number")

	OnCommand_EquipmentUnequip(player, role, cmd, others)
end

--EquipmentRefinableSave
cmd_list[316] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero = Deserialize(is, is_idx, "number")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.equipment_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.save_flag = Deserialize(is, is_idx, "number")

	OnCommand_EquipmentRefinableSave(player, role, cmd, others)
end

--EquipmentEasyLevelUp
cmd_list[318] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero = Deserialize(is, is_idx, "number")

	OnCommand_EquipmentEasyLevelUp(player, role, cmd, others)
end

--TongQueTaiSetHeroInfo
cmd_list[351] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.hero = {}
	for i = 1, count do
		is_idx, cmd.hero[i] = Deserialize(is, is_idx, "number")
	end

	OnCommand_TongQueTaiSetHeroInfo(player, role, cmd, others)
end

--TongQueTaiBeginMatch
cmd_list[353] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")
	is_idx, cmd.double_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.auto_flag = Deserialize(is, is_idx, "number")

	OnCommand_TongQueTaiBeginMatch(player, role, cmd, others)
end

--TongQueTaiCancleMatch
cmd_list[355] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")

	OnCommand_TongQueTaiCancleMatch(player, role, cmd, others)
end

--TongQueTaiJoin
cmd_list[359] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.role_id1 = Deserialize(is, is_idx, "string")
	is_idx, cmd.role_id2 = Deserialize(is, is_idx, "string")

	OnCommand_TongQueTaiJoin(player, role, cmd, others)
end

--TongQueTaiOperation
cmd_list[361] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.operation = {}
	for i = 1, count do
		is_idx, cmd.operation[i] = DeserializeStruct(is, is_idx, "TongQueTaiOperation")
	end
	is_idx, cmd.role_id1 = Deserialize(is, is_idx, "string")
	is_idx, cmd.role_id2 = Deserialize(is, is_idx, "string")

	OnCommand_TongQueTaiOperation(player, role, cmd, others)
end

--TongQueTaiFinish
cmd_list[363] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.win_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.role_id1 = Deserialize(is, is_idx, "string")
	is_idx, cmd.role_id2 = Deserialize(is, is_idx, "string")
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
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.operations = {}
	for i = 1, count do
		is_idx, cmd.operations[i] = DeserializeStruct(is, is_idx, "PVEOperation")
	end

	OnCommand_TongQueTaiFinish(player, role, cmd, others)
end

--TongQueTaiSpeed
cmd_list[366] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.speed = Deserialize(is, is_idx, "number")
	is_idx, cmd.role_id1 = Deserialize(is, is_idx, "string")
	is_idx, cmd.role_id2 = Deserialize(is, is_idx, "string")

	OnCommand_TongQueTaiSpeed(player, role, cmd, others)
end

--TongQueTaiLoad
cmd_list[368] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.role_id1 = Deserialize(is, is_idx, "string")
	is_idx, cmd.role_id2 = Deserialize(is, is_idx, "string")

	OnCommand_TongQueTaiLoad(player, role, cmd, others)
end

--TongQueTaiGetReward
cmd_list[372] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_TongQueTaiGetReward(player, role, cmd, others)
end

--TongQueTaiGetInfo
cmd_list[374] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_TongQueTaiGetInfo(player, role, cmd, others)
end

--BattleFieldGetRoundStateInfo
cmd_list[401] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.round_state = Deserialize(is, is_idx, "number")

	OnCommand_BattleFieldGetRoundStateInfo(player, role, cmd, others)
end

--BattleFieldRoundCount
cmd_list[404] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")

	OnCommand_BattleFieldRoundCount(player, role, cmd, others)
end

--BackPackUseItem
cmd_list[421] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.item_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.item_num = Deserialize(is, is_idx, "number")

	OnCommand_BackPackUseItem(player, role, cmd, others)
end

--TemporaryBackPackGetInfo
cmd_list[423] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_TemporaryBackPackGetInfo(player, role, cmd, others)
end

--TemporaryBackPackReceiveItem
cmd_list[425] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "number")

	OnCommand_TemporaryBackPackReceiveItem(player, role, cmd, others)
end

--HeroAddStar
cmd_list[428] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")

	OnCommand_HeroAddStar(player, role, cmd, others)
end

--GetRankPveArenaInfo
cmd_list[432] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.rank = Deserialize(is, is_idx, "number")

	OnCommand_GetRankPveArenaInfo(player, role, cmd, others)
end

--ChangeLotterySelect
cmd_list[434] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.lottery_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.select_id = Deserialize(is, is_idx, "number")

	OnCommand_ChangeLotterySelect(player, role, cmd, others)
end

--LegionGetInfo
cmd_list[500] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_LegionGetInfo(player, role, cmd, others)
end

--LegionJunXueGuanGetInfo
cmd_list[502] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_LegionJunXueGuanGetInfo(player, role, cmd, others)
end

--LegionJunXueZhuanJingLevelUp
cmd_list[504] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "number")

	OnCommand_LegionJunXueZhuanJingLevelUp(player, role, cmd, others)
end

--LegionLearnJunXueXiangMu
cmd_list[506] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "number")
	is_idx, cmd.learn_id = Deserialize(is, is_idx, "number")

	OnCommand_LegionLearnJunXueXiangMu(player, role, cmd, others)
end

--LegionActivationZhuanJing
cmd_list[510] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "number")

	OnCommand_LegionActivationZhuanJing(player, role, cmd, others)
end

--LegionDecomposeWuHun
cmd_list[512] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.item = {}
	for i = 1, count do
		is_idx, cmd.item[i] = DeserializeStruct(is, is_idx, "Item")
	end

	OnCommand_LegionDecomposeWuHun(player, role, cmd, others)
end

--GetRoleInfo
cmd_list[1000001] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_GetRoleInfo(player, role, cmd, others)
end

--CreateRole
cmd_list[1000003] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.name = Deserialize(is, is_idx, "string")
	is_idx, cmd.photo = Deserialize(is, is_idx, "number")
	is_idx, cmd.sex = Deserialize(is, is_idx, "number")

	OnCommand_CreateRole(player, role, cmd, others)
end

--ReportClientVersion
cmd_list[1000005] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.client_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.exe_ver = Deserialize(is, is_idx, "string")
	is_idx, cmd.data_ver = Deserialize(is, is_idx, "string")

	OnCommand_ReportClientVersion(player, role, cmd, others)
end

--MaShuGetRoleInfo
cmd_list[600] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_MaShuGetRoleInfo(player, role, cmd, others)
end

--MaShuSelectFriendToHelp
cmd_list[602] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.roleid = Deserialize(is, is_idx, "string")

	OnCommand_MaShuSelectFriendToHelp(player, role, cmd, others)
end

--MaShuGetBuff
cmd_list[604] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "number")

	OnCommand_MaShuGetBuff(player, role, cmd, others)
end

--MaShuBegin
cmd_list[606] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "number")

	OnCommand_MaShuBegin(player, role, cmd, others)
end

--MaShuGetPrize
cmd_list[608] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.stage = Deserialize(is, is_idx, "number")

	OnCommand_MaShuGetPrize(player, role, cmd, others)
end

--MaShuUpdateScore
cmd_list[610] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.score = Deserialize(is, is_idx, "number")

	OnCommand_MaShuUpdateScore(player, role, cmd, others)
end

--MaShuEnd
cmd_list[612] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "number")
	is_idx, cmd.score = Deserialize(is, is_idx, "number")
	is_idx, cmd.stage = Deserialize(is, is_idx, "number")
	is_idx, cmd.box_num = Deserialize(is, is_idx, "number")
	is_idx, cmd.money = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.operations = {}
	for i = 1, count do
		is_idx, cmd.operations[i] = DeserializeStruct(is, is_idx, "PVEOperation")
	end

	OnCommand_MaShuEnd(player, role, cmd, others)
end

--MaShuGetRankPrize
cmd_list[614] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_MaShuGetRankPrize(player, role, cmd, others)
end

--JieYiGetRoleInfo
cmd_list[651] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_JieYiGetRoleInfo(player, role, cmd, others)
end

--JieYiGetInfo
cmd_list[654] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "string")

	OnCommand_JieYiGetInfo(player, role, cmd, others)
end

--JieYiCreate
cmd_list[657] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.name = Deserialize(is, is_idx, "string")

	OnCommand_JieYiCreate(player, role, cmd, others)
end

--JieYiInviteRole
cmd_list[659] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.id = Deserialize(is, is_idx, "string")
	is_idx, cmd.name = Deserialize(is, is_idx, "string")
	is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")

	OnCommand_JieYiInviteRole(player, role, cmd, others)
end

--JieYiReply
cmd_list[662] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.id = Deserialize(is, is_idx, "string")
	is_idx, cmd.name = Deserialize(is, is_idx, "string")
	is_idx, cmd.agreement = Deserialize(is, is_idx, "number")
	is_idx, cmd.boss_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.brother_id = Deserialize(is, is_idx, "string")

	OnCommand_JieYiReply(player, role, cmd, others)
end

--JieYiOperateInvite
cmd_list[664] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.id = Deserialize(is, is_idx, "string")
	is_idx, cmd.name = Deserialize(is, is_idx, "string")
	is_idx, cmd.agreement = Deserialize(is, is_idx, "number")
	is_idx, cmd.boss_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.brother_id = Deserialize(is, is_idx, "string")

	OnCommand_JieYiOperateInvite(player, role, cmd, others)
end

--JieYiLastCreate
cmd_list[666] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "string")
	is_idx, cmd.name = Deserialize(is, is_idx, "string")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.boss_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.brother_id = Deserialize(is, is_idx, "string")

	OnCommand_JieYiLastCreate(player, role, cmd, others)
end

--JieYiLastOperate
cmd_list[668] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.agreement = Deserialize(is, is_idx, "number")
	is_idx, cmd.id = Deserialize(is, is_idx, "string")
	is_idx, cmd.name = Deserialize(is, is_idx, "string")
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.boss_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.brother_id = Deserialize(is, is_idx, "string")

	OnCommand_JieYiLastOperate(player, role, cmd, others)
end

--JieYiGetInviteInfo
cmd_list[671] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_JieYiGetInviteInfo(player, role, cmd, others)
end

--JieYiCancelInviteRole
cmd_list[673] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "string")
	is_idx, cmd.name = Deserialize(is, is_idx, "string")
	is_idx, cmd.brother_id = Deserialize(is, is_idx, "string")

	OnCommand_JieYiCancelInviteRole(player, role, cmd, others)
end

--JieYiExpelBrother
cmd_list[675] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "string")
	is_idx, cmd.name = Deserialize(is, is_idx, "string")
	is_idx, cmd.brother_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.brother_otherid = Deserialize(is, is_idx, "string")

	OnCommand_JieYiExpelBrother(player, role, cmd, others)
end

--JieYiExitCurrentJieYi
cmd_list[678] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "string")
	is_idx, cmd.name = Deserialize(is, is_idx, "string")
	is_idx, cmd.brother_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.brother_otherid = Deserialize(is, is_idx, "string")

	OnCommand_JieYiExitCurrentJieYi(player, role, cmd, others)
end

--AudienceGetList
cmd_list[700] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_AudienceGetList(player, role, cmd, others)
end

--AudienceGetOperation
cmd_list[702] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.room_id = Deserialize(is, is_idx, "number")

	OnCommand_AudienceGetOperation(player, role, cmd, others)
end

--AudienceLeaveRoom
cmd_list[705] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.room_id = Deserialize(is, is_idx, "number")

	OnCommand_AudienceLeaveRoom(player, role, cmd, others)
end

--PhotoSetPhoto
cmd_list[730] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.photo_id = Deserialize(is, is_idx, "number")

	OnCommand_PhotoSetPhoto(player, role, cmd, others)
end

--PhotoSetPhotoFrame
cmd_list[732] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.photoframe_id = Deserialize(is, is_idx, "number")

	OnCommand_PhotoSetPhotoFrame(player, role, cmd, others)
end

--YueZhanCreate
cmd_list[751] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.channel = Deserialize(is, is_idx, "number")
	is_idx, cmd.announce = Deserialize(is, is_idx, "string")

	OnCommand_YueZhanCreate(player, role, cmd, others)
end

--YueZhanJoin
cmd_list[753] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.room_id = Deserialize(is, is_idx, "number")

	OnCommand_YueZhanJoin(player, role, cmd, others)
end

--YueZhanCancel
cmd_list[755] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.room_id = Deserialize(is, is_idx, "number")

	OnCommand_YueZhanCancel(player, role, cmd, others)
end

--YueZhanDanMu
cmd_list[757] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.pvp_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.video_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.tick = Deserialize(is, is_idx, "number")
	is_idx, cmd.word_info = Deserialize(is, is_idx, "string")

	OnCommand_YueZhanDanMu(player, role, cmd, others)
end

--GetFlowerInfo
cmd_list[800] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "string")

	OnCommand_GetFlowerInfo(player, role, cmd, others)
end

--SendFlowerGift
cmd_list[806] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")

	OnCommand_SendFlowerGift(player, role, cmd, others)
end

--FlowerGiftTipsClear
cmd_list[809] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_FlowerGiftTipsClear(player, role, cmd, others)
end

--TeXingGetInfo
cmd_list[821] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_TeXingGetInfo(player, role, cmd, others)
end

--FuDaiGetReward
cmd_list[833] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.fudai_flag = Deserialize(is, is_idx, "number")

	OnCommand_FuDaiGetReward(player, role, cmd, others)
end

--TowerGetInfo
cmd_list[851] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_TowerGetInfo(player, role, cmd, others)
end

--TowerSelectDifficulty
cmd_list[853] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")

	OnCommand_TowerSelectDifficulty(player, role, cmd, others)
end

--TowerGetLayerInfo
cmd_list[855] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.layer = Deserialize(is, is_idx, "number")

	OnCommand_TowerGetLayerInfo(player, role, cmd, others)
end

--TowerSelectArmyInfo
cmd_list[857] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")

	OnCommand_TowerSelectArmyInfo(player, role, cmd, others)
end

--TowerSetArmyInfo
cmd_list[859] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.army_info = {}
	for i = 1, count do
		is_idx, cmd.army_info[i] = DeserializeStruct(is, is_idx, "TowerArmyInfo")
	end

	OnCommand_TowerSetArmyInfo(player, role, cmd, others)
end

--TowerOpenBox
cmd_list[860] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.layer = Deserialize(is, is_idx, "number")

	OnCommand_TowerOpenBox(player, role, cmd, others)
end

--TowerBuyBuff
cmd_list[862] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.layer = Deserialize(is, is_idx, "number")
	is_idx, cmd.id = Deserialize(is, is_idx, "number")
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")

	OnCommand_TowerBuyBuff(player, role, cmd, others)
end

--TowerJoinBattle
cmd_list[864] = 
function(is, is_idx, player, role, cmd, others)
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.hero = {}
	for i = 1, count do
		is_idx, cmd.hero[i] = Deserialize(is, is_idx, "number")
	end

	OnCommand_TowerJoinBattle(player, role, cmd, others)
end

--TowerEndBattle
cmd_list[866] = 
function(is, is_idx, player, role, cmd, others)
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
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.star = {}
	for i = 1, count do
		is_idx, cmd.star[i] = DeserializeStruct(is, is_idx, "Instance_Star_Condition")
	end
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.operations = {}
	for i = 1, count do
		is_idx, cmd.operations[i] = DeserializeStruct(is, is_idx, "PVEOperation")
	end

	OnCommand_TowerEndBattle(player, role, cmd, others)
end

--TowerGetRankPrize
cmd_list[868] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_TowerGetRankPrize(player, role, cmd, others)
end

--TowerSweep
cmd_list[871] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.layer = Deserialize(is, is_idx, "number")
	is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")

	OnCommand_TowerSweep(player, role, cmd, others)
end

--DaTiGetInfo
cmd_list[900] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_DaTiGetInfo(player, role, cmd, others)
end

--DaTiAnswer
cmd_list[903] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.num = Deserialize(is, is_idx, "number")
	is_idx, cmd.right_flag = Deserialize(is, is_idx, "number")
	is_idx, cmd.use_time = Deserialize(is, is_idx, "number")

	OnCommand_DaTiAnswer(player, role, cmd, others)
end

--DaTiOpenBox
cmd_list[905] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_DaTiOpenBox(player, role, cmd, others)
end

--DaTiUseTime
cmd_list[907] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.use_time = Deserialize(is, is_idx, "number")

	OnCommand_DaTiUseTime(player, role, cmd, others)
end

--SkinEquip
cmd_list[910] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.skinid = Deserialize(is, is_idx, "number")

	OnCommand_SkinEquip(player, role, cmd, others)
end

--SkinBuy
cmd_list[912] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.skinid = Deserialize(is, is_idx, "number")

	OnCommand_SkinBuy(player, role, cmd, others)
end

--SkinTimeOut
cmd_list[914] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.skinid = Deserialize(is, is_idx, "number")

	OnCommand_SkinTimeOut(player, role, cmd, others)
end

--WeaponMakeGetInfo
cmd_list[920] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_WeaponMakeGetInfo(player, role, cmd, others)
end

--WeaponMake
cmd_list[922] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")
	is_idx, cmd.cost_type = Deserialize(is, is_idx, "number")
	is_idx, cmd.lottery_id = Deserialize(is, is_idx, "number")

	OnCommand_WeaponMake(player, role, cmd, others)
end

--WeaponMakeGetStone
cmd_list[924] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_WeaponMakeGetStone(player, role, cmd, others)
end

--WeaponMakeActive
cmd_list[926] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.item_id = Deserialize(is, is_idx, "number")

	OnCommand_WeaponMakeActive(player, role, cmd, others)
end

--WeaponMakeLevelUp
cmd_list[928] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_WeaponMakeLevelUp(player, role, cmd, others)
end

--WeaponForge
cmd_list[931] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")

	OnCommand_WeaponForge(player, role, cmd, others)
end

--WeaponResetSkill
cmd_list[933] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.typ = Deserialize(is, is_idx, "number")

	OnCommand_WeaponResetSkill(player, role, cmd, others)
end

--WeaponForgeGetInfo
cmd_list[935] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_WeaponForgeGetInfo(player, role, cmd, others)
end

--TestFloat_Re
cmd_list[942] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.seed = Deserialize(is, is_idx, "number")
	is_idx, cmd.count = Deserialize(is, is_idx, "number")
	is_idx, cmd.result = Deserialize(is, is_idx, "string")

	OnCommand_TestFloat_Re(player, role, cmd, others)
end

--MilitaryGetInfo
cmd_list[950] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_MilitaryGetInfo(player, role, cmd, others)
end

--MilitarySweep
cmd_list[952] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.stage_id = Deserialize(is, is_idx, "number")

	OnCommand_MilitarySweep(player, role, cmd, others)
end

--MilitaryJoinBattle
cmd_list[954] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.stage_id = Deserialize(is, is_idx, "number")
	is_idx, cmd.difficult = Deserialize(is, is_idx, "number")

	OnCommand_MilitaryJoinBattle(player, role, cmd, others)
end

--MilitaryEndBattle
cmd_list[956] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.reward_param = Deserialize(is, is_idx, "number")
	is_idx, cmd.hurt = Deserialize(is, is_idx, "number")
	local count = 0
	is_idx, count = Deserialize(is, is_idx, "number");
	cmd.operations = {}
	for i = 1, count do
		is_idx, cmd.operations[i] = DeserializeStruct(is, is_idx, "PVEOperation")
	end

	OnCommand_MilitaryEndBattle(player, role, cmd, others)
end

--HotPvpVideoList
cmd_list[1001] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.seq_max = Deserialize(is, is_idx, "number")

	OnCommand_HotPvpVideoList(player, role, cmd, others)
end

--HotPvpVideoGet
cmd_list[1003] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.seq = Deserialize(is, is_idx, "number")

	OnCommand_HotPvpVideoGet(player, role, cmd, others)
end

--ZhanliGetInfo
cmd_list[1020] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_ZhanliGetInfo(player, role, cmd, others)
end

--GetActiveCodeRward
cmd_list[1030] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.code = Deserialize(is, is_idx, "string")

	OnCommand_GetActiveCodeRward(player, role, cmd, others)
end

--ChangeRoleName
cmd_list[19998] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.name = Deserialize(is, is_idx, "string")

	OnCommand_ChangeRoleName(player, role, cmd, others)
end

--TopListGet
cmd_list[20000] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.top_type = Deserialize(is, is_idx, "number")
	is_idx, cmd.top_flag = Deserialize(is, is_idx, "number")

	OnCommand_TopListGet(player, role, cmd, others)
end

--GMCommand
cmd_list[99997] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.gm_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.typ = Deserialize(is, is_idx, "string")
	is_idx, cmd.arg1 = Deserialize(is, is_idx, "string")
	is_idx, cmd.arg2 = Deserialize(is, is_idx, "string")
	is_idx, cmd.arg3 = Deserialize(is, is_idx, "string")
	is_idx, cmd.arg4 = Deserialize(is, is_idx, "string")

	OnCommand_GMCommand(player, role, cmd, others)
end

--DebugCommand
cmd_list[99999] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.typ = Deserialize(is, is_idx, "string")
	is_idx, cmd.count1 = Deserialize(is, is_idx, "number")
	is_idx, cmd.count2 = Deserialize(is, is_idx, "number")
	is_idx, cmd.count3 = Deserialize(is, is_idx, "number")
	is_idx, cmd.count4 = Deserialize(is, is_idx, "number")

	OnCommand_DebugCommand(player, role, cmd, others)
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

--ListFriends
cmd_list[10006] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_ListFriends(player, role, cmd, others)
end

--FriendRequest
cmd_list[10008] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")

	OnCommand_FriendRequest(player, role, cmd, others)
end

--FriendReply
cmd_list[10011] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.src_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.accept = Deserialize(is, is_idx, "boolean")

	OnCommand_FriendReply(player, role, cmd, others)
end

--RemoveFriend
cmd_list[10014] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")

	OnCommand_RemoveFriend(player, role, cmd, others)
end

--MafiaGet
cmd_list[10101] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_MafiaGet(player, role, cmd, others)
end

--MafiaCreate
cmd_list[10103] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.name = Deserialize(is, is_idx, "string")
	is_idx, cmd.flag = Deserialize(is, is_idx, "number")

	OnCommand_MafiaCreate(player, role, cmd, others)
end

--MafiaList
cmd_list[10105] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_MafiaList(player, role, cmd, others)
end

--MafiaGetSelfInfo
cmd_list[10107] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_MafiaGetSelfInfo(player, role, cmd, others)
end

--MafiaApply
cmd_list[10110] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.id = Deserialize(is, is_idx, "string")

	OnCommand_MafiaApply(player, role, cmd, others)
end

--MafiaQuit
cmd_list[10112] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_MafiaQuit(player, role, cmd, others)
end

--MafiaGetApplyList
cmd_list[10114] = 
function(is, is_idx, player, role, cmd, others)

	OnCommand_MafiaGetApplyList(player, role, cmd, others)
end

--MafiaOperateApplyList
cmd_list[10116] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.accept = Deserialize(is, is_idx, "number")
	is_idx, cmd.role_id = Deserialize(is, is_idx, "string")
	is_idx, cmd.mafia_id = Deserialize(is, is_idx, "string")

	OnCommand_MafiaOperateApplyList(player, role, cmd, others)
end

--MafiaSetLevelLimit
cmd_list[10118] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.level = Deserialize(is, is_idx, "number")
	is_idx, cmd.need_approval = Deserialize(is, is_idx, "number")

	OnCommand_MafiaSetLevelLimit(player, role, cmd, others)
end

--MafiaSetAnnounce
cmd_list[10120] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.announce = Deserialize(is, is_idx, "string")

	OnCommand_MafiaSetAnnounce(player, role, cmd, others)
end

--MafiaKickout
cmd_list[10122] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.role_id = Deserialize(is, is_idx, "string")

	OnCommand_MafiaKickout(player, role, cmd, others)
end

--MafiaChangeMenberPosition
cmd_list[10129] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.position = Deserialize(is, is_idx, "number")
	is_idx, cmd.role_id = Deserialize(is, is_idx, "string")

	OnCommand_MafiaChangeMenberPosition(player, role, cmd, others)
end

--MafiaShanRang
cmd_list[10131] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.role_id = Deserialize(is, is_idx, "string")

	OnCommand_MafiaShanRang(player, role, cmd, others)
end

--MafiaJiSi
cmd_list[10133] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.jisi_typ = Deserialize(is, is_idx, "number")

	OnCommand_MafiaJiSi(player, role, cmd, others)
end

--MafiaDeclaration
cmd_list[10135] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.declaration = Deserialize(is, is_idx, "string")
	is_idx, cmd.broadcast_flag = Deserialize(is, is_idx, "number")

	OnCommand_MafiaDeclaration(player, role, cmd, others)
end

--MafiaChangeName
cmd_list[10137] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.name = Deserialize(is, is_idx, "string")

	OnCommand_MafiaChangeName(player, role, cmd, others)
end

--MafiaSeeInfo
cmd_list[10139] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.mafia_id = Deserialize(is, is_idx, "string")

	OnCommand_MafiaSeeInfo(player, role, cmd, others)
end

--MafiaBangZhuSendMail
cmd_list[10141] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.subject = Deserialize(is, is_idx, "string")
	is_idx, cmd.context = Deserialize(is, is_idx, "string")

	OnCommand_MafiaBangZhuSendMail(player, role, cmd, others)
end

--Ping
cmd_list[10201] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.client_send_time = Deserialize(is, is_idx, "number")

	OnCommand_Ping(player, role, cmd, others)
end

--UDPPing
cmd_list[10203] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.client_send_time = Deserialize(is, is_idx, "number")

	OnCommand_UDPPing(player, role, cmd, others)
end

--UDPClientTimeRequest_Re
cmd_list[10206] = 
function(is, is_idx, player, role, cmd, others)
	is_idx, cmd.local_time = Deserialize(is, is_idx, "number")
	is_idx, cmd.server_time = Deserialize(is, is_idx, "number")

	OnCommand_UDPClientTimeRequest_Re(player, role, cmd, others)
end


