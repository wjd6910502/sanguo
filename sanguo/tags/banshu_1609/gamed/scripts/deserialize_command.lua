--DONT CHANGE ME!

function DeserializeAndProcessCommand(ud, is, ...)
	if not API_IsNULL(ud) then player=API_GetLuaPlayer(ud) end
	if not API_IsNULL(ud) then role=API_GetLuaRole(ud) end

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

	if false then
		--never to here
	elseif cmd.__type__ == 7 then
		--EnterInstance
		is_idx, cmd.inst_tid = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.heros = {}
		for i = 1, count do
			is_idx, cmd.heros[i] = Deserialize(is, is_idx, "number")
		end
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.req_heros = {}
		for i = 1, count do
			is_idx, cmd.req_heros[i] = Deserialize(is, is_idx, "number")
		end

		OnCommand_EnterInstance(player, role, cmd, others)
	elseif cmd.__type__ == 9 then
		--CompleteInstance
		is_idx, cmd.inst_tid = Deserialize(is, is_idx, "number")
		is_idx, cmd.flag = Deserialize(is, is_idx, "number")
		is_idx, cmd.score = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.heros = {}
		for i = 1, count do
			is_idx, cmd.heros[i] = Deserialize(is, is_idx, "number")
		end
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.req_heros = {}
		for i = 1, count do
			is_idx, cmd.req_heros[i] = Deserialize(is, is_idx, "number")
		end
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.operations = {}
		for i = 1, count do
			is_idx, cmd.operations[i] = DeserializeStruct(is, is_idx, "PVEOperation")
		end
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.star = {}
		for i = 1, count do
			is_idx, cmd.star[i] = DeserializeStruct(is, is_idx, "Instance_Star_Condition")
		end

		OnCommand_CompleteInstance(player, role, cmd, others)
	elseif cmd.__type__ == 12 then
		--OPStat
		is_idx, cmd.opset_count = Deserialize(is, is_idx, "number")
		is_idx, cmd.op_count = Deserialize(is, is_idx, "number")

		OnCommand_OPStat(player, role, cmd, others)
	elseif cmd.__type__ == 10301 then
		--PVPInvite
		is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.src = DeserializeStruct(is, is_idx, "RoleBrief")
		is_idx, cmd.mode = Deserialize(is, is_idx, "number")

		OnCommand_PVPInvite(player, role, cmd, others)
	elseif cmd.__type__ == 10302 then
		--PVPReply
		is_idx, cmd.src_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.accept = Deserialize(is, is_idx, "boolean")

		OnCommand_PVPReply(player, role, cmd, others)
	elseif cmd.__type__ == 10304 then
		--PVPReady

		OnCommand_PVPReady(player, role, cmd, others)
	elseif cmd.__type__ == 10306 then
		--PVPOperation
		is_idx, cmd.client_tick = Deserialize(is, is_idx, "number")
		is_idx, cmd.op = Deserialize(is, is_idx, "string")
		is_idx, cmd.crc = Deserialize(is, is_idx, "string")

		OnCommand_PVPOperation(player, role, cmd, others)
	elseif cmd.__type__ == 10308 then
		--PVPEnd
		is_idx, cmd.result = Deserialize(is, is_idx, "number")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.pvp_typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.star = Deserialize(is, is_idx, "number")
		is_idx, cmd.win_count = Deserialize(is, is_idx, "number")

		OnCommand_PVPEnd(player, role, cmd, others)
	elseif cmd.__type__ == 10310 then
		--PVPPeerLatency
		is_idx, cmd.latency = Deserialize(is, is_idx, "number")

		OnCommand_PVPPeerLatency(player, role, cmd, others)
	elseif cmd.__type__ == 100 then
		--SweepInstance
		is_idx, cmd.instance = Deserialize(is, is_idx, "number")
		is_idx, cmd.count = Deserialize(is, is_idx, "number")

		OnCommand_SweepInstance(player, role, cmd, others)
	elseif cmd.__type__ == 102 then
		--GetBackPack

		OnCommand_GetBackPack(player, role, cmd, others)
	elseif cmd.__type__ == 104 then
		--GetInstance

		OnCommand_GetInstance(player, role, cmd, others)
	elseif cmd.__type__ == 107 then
		--BuyVp

		OnCommand_BuyVp(player, role, cmd, others)
	elseif cmd.__type__ == 109 then
		--BuyInstanceCount
		is_idx, cmd.inst_tid = Deserialize(is, is_idx, "number")

		OnCommand_BuyInstanceCount(player, role, cmd, others)
	elseif cmd.__type__ == 115 then
		--TaskFinish
		is_idx, cmd.task_id = Deserialize(is, is_idx, "number")

		OnCommand_TaskFinish(player, role, cmd, others)
	elseif cmd.__type__ == 118 then
		--Client_User_Define
		is_idx, cmd.user_key = Deserialize(is, is_idx, "number")
		is_idx, cmd.user_value = Deserialize(is, is_idx, "string")

		OnCommand_Client_User_Define(player, role, cmd, others)
	elseif cmd.__type__ == 119 then
		--BuyHero
		is_idx, cmd.tid = Deserialize(is, is_idx, "number")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")

		OnCommand_BuyHero(player, role, cmd, others)
	elseif cmd.__type__ == 122 then
		--UseItem
		is_idx, cmd.tid = Deserialize(is, is_idx, "number")
		is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.count = Deserialize(is, is_idx, "number")

		OnCommand_UseItem(player, role, cmd, others)
	elseif cmd.__type__ == 126 then
		--One_Level_Up
		is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.item = {}
		for i = 1, count do
			is_idx, cmd.item[i] = DeserializeStruct(is, is_idx, "Item")
		end

		OnCommand_One_Level_Up(player, role, cmd, others)
	elseif cmd.__type__ == 128 then
		--Hero_Up_Grade
		is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")

		OnCommand_Hero_Up_Grade(player, role, cmd, others)
	elseif cmd.__type__ == 131 then
		--BuyHorse
		is_idx, cmd.tid = Deserialize(is, is_idx, "number")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")

		OnCommand_BuyHorse(player, role, cmd, others)
	elseif cmd.__type__ == 134 then
		--GetLastHero

		OnCommand_GetLastHero(player, role, cmd, others)
	elseif cmd.__type__ == 136 then
		--PvpJoin
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.heroinfo = {}
		for i = 1, count do
			is_idx, cmd.heroinfo[i] = Deserialize(is, is_idx, "number")
		end

		OnCommand_PvpJoin(player, role, cmd, others)
	elseif cmd.__type__ == 139 then
		--PvpEnter
		is_idx, cmd.index = Deserialize(is, is_idx, "number")
		is_idx, cmd.flag = Deserialize(is, is_idx, "number")

		OnCommand_PvpEnter(player, role, cmd, others)
	elseif cmd.__type__ == 141 then
		--PvpCancle

		OnCommand_PvpCancle(player, role, cmd, others)
	elseif cmd.__type__ == 143 then
		--PvpSpeed
		is_idx, cmd.speed = Deserialize(is, is_idx, "number")

		OnCommand_PvpSpeed(player, role, cmd, others)
	elseif cmd.__type__ == 144 then
		--ResetRoleInfo

		OnCommand_ResetRoleInfo(player, role, cmd, others)
	elseif cmd.__type__ == 148 then
		--GetTask

		OnCommand_GetTask(player, role, cmd, others)
	elseif cmd.__type__ == 150 then
		--HeroUpgradeSkill
		is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.skill_info = {}
		for i = 1, count do
			is_idx, cmd.skill_info[i] = DeserializeStruct(is, is_idx, "UpgradeSkillInfo")
		end

		OnCommand_HeroUpgradeSkill(player, role, cmd, others)
	elseif cmd.__type__ == 152 then
		--GetHeroComments
		is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")

		OnCommand_GetHeroComments(player, role, cmd, others)
	elseif cmd.__type__ == 154 then
		--AgreeHeroComments
		is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.role_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.time_stamp = Deserialize(is, is_idx, "number")

		OnCommand_AgreeHeroComments(player, role, cmd, others)
	elseif cmd.__type__ == 156 then
		--WriteHeroComments
		is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.comments = Deserialize(is, is_idx, "string")

		OnCommand_WriteHeroComments(player, role, cmd, others)
	elseif cmd.__type__ == 158 then
		--ReWriteHeroComments
		is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.comments = Deserialize(is, is_idx, "string")

		OnCommand_ReWriteHeroComments(player, role, cmd, others)
	elseif cmd.__type__ == 161 then
		--GetVPRefreshTime

		OnCommand_GetVPRefreshTime(player, role, cmd, others)
	elseif cmd.__type__ == 163 then
		--GetSkillPointRefreshTime

		OnCommand_GetSkillPointRefreshTime(player, role, cmd, others)
	elseif cmd.__type__ == 165 then
		--RoleLogin

		OnCommand_RoleLogin(player, role, cmd, others)
	elseif cmd.__type__ == 166 then
		--BuySkillPoint

		OnCommand_BuySkillPoint(player, role, cmd, others)
	elseif cmd.__type__ == 169 then
		--GetVideo
		is_idx, cmd.video_id = Deserialize(is, is_idx, "string")

		OnCommand_GetVideo(player, role, cmd, others)
	elseif cmd.__type__ == 172 then
		--AddBlackList
		is_idx, cmd.roleid = Deserialize(is, is_idx, "string")

		OnCommand_AddBlackList(player, role, cmd, others)
	elseif cmd.__type__ == 174 then
		--DelBlackList
		is_idx, cmd.roleid = Deserialize(is, is_idx, "string")

		OnCommand_DelBlackList(player, role, cmd, others)
	elseif cmd.__type__ == 176 then
		--SeeAnotherRole
		is_idx, cmd.roleid = Deserialize(is, is_idx, "string")

		OnCommand_SeeAnotherRole(player, role, cmd, others)
	elseif cmd.__type__ == 178 then
		--GetPrivateChatHistory

		OnCommand_GetPrivateChatHistory(player, role, cmd, others)
	elseif cmd.__type__ == 179 then
		--ReadMail
		is_idx, cmd.mail_id = Deserialize(is, is_idx, "number")

		OnCommand_ReadMail(player, role, cmd, others)
	elseif cmd.__type__ == 181 then
		--GetAttachment
		is_idx, cmd.mail_id = Deserialize(is, is_idx, "number")

		OnCommand_GetAttachment(player, role, cmd, others)
	elseif cmd.__type__ == 187 then
		--BroadcastPvpVideo
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.video_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.content = Deserialize(is, is_idx, "string")

		OnCommand_BroadcastPvpVideo(player, role, cmd, others)
	elseif cmd.__type__ == 189 then
		--ChangeHeroSelectSkill
		is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.skill_id = {}
		for i = 1, count do
			is_idx, cmd.skill_id[i] = Deserialize(is, is_idx, "number")
		end

		OnCommand_ChangeHeroSelectSkill(player, role, cmd, others)
	elseif cmd.__type__ == 193 then
		--MallBuyItem
		is_idx, cmd.item_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.item_num = Deserialize(is, is_idx, "number")

		OnCommand_MallBuyItem(player, role, cmd, others)
	elseif cmd.__type__ == 198 then
		--LevelUpHeroStar
		is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")

		OnCommand_LevelUpHeroStar(player, role, cmd, others)
	elseif cmd.__type__ == 202 then
		--MysteryShopBuyItem
		is_idx, cmd.shop_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.position = Deserialize(is, is_idx, "number")
		is_idx, cmd.item_id = Deserialize(is, is_idx, "number")

		OnCommand_MysteryShopBuyItem(player, role, cmd, others)
	elseif cmd.__type__ == 204 then
		--RefreshMysteryShop
		is_idx, cmd.shop_id = Deserialize(is, is_idx, "number")

		OnCommand_RefreshMysteryShop(player, role, cmd, others)
	elseif cmd.__type__ == 206 then
		--ResetBattleField
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")

		OnCommand_ResetBattleField(player, role, cmd, others)
	elseif cmd.__type__ == 208 then
		--BattleFieldBegin
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.heros = {}
		for i = 1, count do
			is_idx, cmd.heros[i] = DeserializeStruct(is, is_idx, "BattleHeroInfo")
		end

		OnCommand_BattleFieldBegin(player, role, cmd, others)
	elseif cmd.__type__ == 210 then
		--BattleFieldMove
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.src_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.src_position = Deserialize(is, is_idx, "number")
		is_idx, cmd.dst_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.dst_position = Deserialize(is, is_idx, "number")

		OnCommand_BattleFieldMove(player, role, cmd, others)
	elseif cmd.__type__ == 212 then
		--BattleFieldJoinBattle
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.npc_id = Deserialize(is, is_idx, "number")

		OnCommand_BattleFieldJoinBattle(player, role, cmd, others)
	elseif cmd.__type__ == 214 then
		--BattleFieldFinishBattle
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.win_flag = Deserialize(is, is_idx, "number")
		is_idx, cmd.npc_id = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.heros = {}
		for i = 1, count do
			is_idx, cmd.heros[i] = DeserializeStruct(is, is_idx, "BattleHeroInfo")
		end
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.operations = {}
		for i = 1, count do
			is_idx, cmd.operations[i] = DeserializeStruct(is, is_idx, "PVEOperation")
		end

		OnCommand_BattleFieldFinishBattle(player, role, cmd, others)
	elseif cmd.__type__ == 217 then
		--BattleFieldGetPrize
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")

		OnCommand_BattleFieldGetPrize(player, role, cmd, others)
	elseif cmd.__type__ == 219 then
		--SetInstanceHeroInfo
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.heros = {}
		for i = 1, count do
			is_idx, cmd.heros[i] = Deserialize(is, is_idx, "number")
		end
		is_idx, cmd.horse = Deserialize(is, is_idx, "number")

		OnCommand_SetInstanceHeroInfo(player, role, cmd, others)
	elseif cmd.__type__ == 221 then
		--Lottery
		is_idx, cmd.lottery_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.cost_type = Deserialize(is, is_idx, "number")

		OnCommand_Lottery(player, role, cmd, others)
	elseif cmd.__type__ == 223 then
		--GetBattleFieldInfo
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")

		OnCommand_GetBattleFieldInfo(player, role, cmd, others)
	elseif cmd.__type__ == 226 then
		--BattleFieldCancel
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")

		OnCommand_BattleFieldCancel(player, role, cmd, others)
	elseif cmd.__type__ == 228 then
		--BattleFieldGetEvent
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")

		OnCommand_BattleFieldGetEvent(player, role, cmd, others)
	elseif cmd.__type__ == 231 then
		--GetCurBattleField

		OnCommand_GetCurBattleField(player, role, cmd, others)
	elseif cmd.__type__ == 233 then
		--BattleFieldFinishEvent
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")

		OnCommand_BattleFieldFinishEvent(player, role, cmd, others)
	elseif cmd.__type__ == 235 then
		--GiveUpCurBattleField

		OnCommand_GiveUpCurBattleField(player, role, cmd, others)
	elseif cmd.__type__ == 237 then
		--GetRefreshTime
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")

		OnCommand_GetRefreshTime(player, role, cmd, others)
	elseif cmd.__type__ == 239 then
		--DailySign
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")

		OnCommand_DailySign(player, role, cmd, others)
	elseif cmd.__type__ == 241 then
		--GetMyPveArenaInfo

		OnCommand_GetMyPveArenaInfo(player, role, cmd, others)
	elseif cmd.__type__ == 243 then
		--GetOtherPveArenaInfo
		is_idx, cmd.roleid = Deserialize(is, is_idx, "string")

		OnCommand_GetOtherPveArenaInfo(player, role, cmd, others)
	elseif cmd.__type__ == 245 then
		--GetFighterInfo

		OnCommand_GetFighterInfo(player, role, cmd, others)
	elseif cmd.__type__ == 247 then
		--PveArenaJoinBattle
		is_idx, cmd.rank = Deserialize(is, is_idx, "number")

		OnCommand_PveArenaJoinBattle(player, role, cmd, others)
	elseif cmd.__type__ == 249 then
		--PveArenaEndBattle
		is_idx, cmd.win_flag = Deserialize(is, is_idx, "number")
		is_idx, cmd.operation = DeserializeStruct(is, is_idx, "PveArenaOperation")

		OnCommand_PveArenaEndBattle(player, role, cmd, others)
	elseif cmd.__type__ == 251 then
		--PveArenaResetTime

		OnCommand_PveArenaResetTime(player, role, cmd, others)
	elseif cmd.__type__ == 253 then
		--PveArenaResetCount

		OnCommand_PveArenaResetCount(player, role, cmd, others)
	elseif cmd.__type__ == 255 then
		--ChallengeRoleByItem
		is_idx, cmd.roleid = Deserialize(is, is_idx, "string")
		is_idx, cmd.name = Deserialize(is, is_idx, "string")

		OnCommand_ChallengeRoleByItem(player, role, cmd, others)
	elseif cmd.__type__ == 257 then
		--GetPveArenaHistory

		OnCommand_GetPveArenaHistory(player, role, cmd, others)
	elseif cmd.__type__ == 259 then
		--GetPveArenaOperation
		is_idx, cmd.id = Deserialize(is, is_idx, "number")

		OnCommand_GetPveArenaOperation(player, role, cmd, others)
	elseif cmd.__type__ == 261 then
		--SetPveArenaHero
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.heros = {}
		for i = 1, count do
			is_idx, cmd.heros[i] = Deserialize(is, is_idx, "number")
		end

		OnCommand_SetPveArenaHero(player, role, cmd, others)
	elseif cmd.__type__ == 263 then
		--ResetSkilllevel
		is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")

		OnCommand_ResetSkilllevel(player, role, cmd, others)
	elseif cmd.__type__ == 265 then
		--WeaponEquip
		is_idx, cmd.hero = Deserialize(is, is_idx, "number")
		is_idx, cmd.weapon_id = Deserialize(is, is_idx, "number")

		OnCommand_WeaponEquip(player, role, cmd, others)
	elseif cmd.__type__ == 267 then
		--WeaponLevelUp
		is_idx, cmd.hero = Deserialize(is, is_idx, "number")
		is_idx, cmd.weapon_id = Deserialize(is, is_idx, "number")

		OnCommand_WeaponLevelUp(player, role, cmd, others)
	elseif cmd.__type__ == 269 then
		--WeaponStrength
		is_idx, cmd.hero = Deserialize(is, is_idx, "number")
		is_idx, cmd.weapon_id = Deserialize(is, is_idx, "number")

		OnCommand_WeaponStrength(player, role, cmd, others)
	elseif cmd.__type__ == 271 then
		--WeaponDecompose
		is_idx, cmd.weapon_id = Deserialize(is, is_idx, "number")

		OnCommand_WeaponDecompose(player, role, cmd, others)
	elseif cmd.__type__ == 273 then
		--WeaponUnequip
		is_idx, cmd.hero = Deserialize(is, is_idx, "number")

		OnCommand_WeaponUnequip(player, role, cmd, others)
	elseif cmd.__type__ == 279 then
		--WuZheShiLianGetDifficultyInfo

		OnCommand_WuZheShiLianGetDifficultyInfo(player, role, cmd, others)
	elseif cmd.__type__ == 281 then
		--WuZheShiLianSelectDifficulty
		is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")

		OnCommand_WuZheShiLianSelectDifficulty(player, role, cmd, others)
	elseif cmd.__type__ == 283 then
		--WuZheShiLianGetOpponentInfo
		is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")

		OnCommand_WuZheShiLianGetOpponentInfo(player, role, cmd, others)
	elseif cmd.__type__ == 285 then
		--WuZheShiLianGetHeroInfo

		OnCommand_WuZheShiLianGetHeroInfo(player, role, cmd, others)
	elseif cmd.__type__ == 287 then
		--WuZheShiLianJoinBattle
		is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")
		is_idx, cmd.stage = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.heros = {}
		for i = 1, count do
			is_idx, cmd.heros[i] = Deserialize(is, is_idx, "number")
		end

		OnCommand_WuZheShiLianJoinBattle(player, role, cmd, others)
	elseif cmd.__type__ == 289 then
		--WuZheShiLianFinishBattle
		is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")
		is_idx, cmd.stage = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.hero = {}
		for i = 1, count do
			is_idx, cmd.hero[i] = DeserializeStruct(is, is_idx, "ShiLianHeroInfo")
		end
		is_idx, cmd.opponent = DeserializeStruct(is, is_idx, "OpponentInfo")
		is_idx, cmd.winflag = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.operations = {}
		for i = 1, count do
			is_idx, cmd.operations[i] = DeserializeStruct(is, is_idx, "PVEOperation")
		end

		OnCommand_WuZheShiLianFinishBattle(player, role, cmd, others)
	elseif cmd.__type__ == 291 then
		--WuZheShiLianReset

		OnCommand_WuZheShiLianReset(player, role, cmd, others)
	elseif cmd.__type__ == 294 then
		--WuZheShiLianGetReward
		is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")
		is_idx, cmd.stage = Deserialize(is, is_idx, "number")

		OnCommand_WuZheShiLianGetReward(player, role, cmd, others)
	elseif cmd.__type__ == 296 then
		--WuZheShiLianSweep
		is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")

		OnCommand_WuZheShiLianSweep(player, role, cmd, others)
	elseif cmd.__type__ == 301 then
		--EquipmentEquip
		is_idx, cmd.hero = Deserialize(is, is_idx, "number")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.equipment_id = Deserialize(is, is_idx, "number")

		OnCommand_EquipmentEquip(player, role, cmd, others)
	elseif cmd.__type__ == 303 then
		--EquipmentLevelUp
		is_idx, cmd.hero = Deserialize(is, is_idx, "number")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.equipment_id = Deserialize(is, is_idx, "number")

		OnCommand_EquipmentLevelUp(player, role, cmd, others)
	elseif cmd.__type__ == 305 then
		--EquipmentGradeUp
		is_idx, cmd.hero = Deserialize(is, is_idx, "number")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.equipment_id = Deserialize(is, is_idx, "number")

		OnCommand_EquipmentGradeUp(player, role, cmd, others)
	elseif cmd.__type__ == 307 then
		--EquipmentRefinable
		is_idx, cmd.hero = Deserialize(is, is_idx, "number")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.equipment_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.refinable_typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.refinable_count = Deserialize(is, is_idx, "number")

		OnCommand_EquipmentRefinable(player, role, cmd, others)
	elseif cmd.__type__ == 309 then
		--EquipmentDecompose
		is_idx, cmd.equipment_id = Deserialize(is, is_idx, "number")

		OnCommand_EquipmentDecompose(player, role, cmd, others)
	elseif cmd.__type__ == 311 then
		--EquipmentUnequip
		is_idx, cmd.hero = Deserialize(is, is_idx, "number")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")

		OnCommand_EquipmentUnequip(player, role, cmd, others)
	elseif cmd.__type__ == 316 then
		--EquipmentRefinableSave
		is_idx, cmd.hero = Deserialize(is, is_idx, "number")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.equipment_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.save_flag = Deserialize(is, is_idx, "number")

		OnCommand_EquipmentRefinableSave(player, role, cmd, others)
	elseif cmd.__type__ == 351 then
		--TongQueTaiSetHeroInfo
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.hero = {}
		for i = 1, count do
			is_idx, cmd.hero[i] = Deserialize(is, is_idx, "number")
		end

		OnCommand_TongQueTaiSetHeroInfo(player, role, cmd, others)
	elseif cmd.__type__ == 353 then
		--TongQueTaiBeginMatch
		is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")
		is_idx, cmd.double_flag = Deserialize(is, is_idx, "number")
		is_idx, cmd.auto_flag = Deserialize(is, is_idx, "number")

		OnCommand_TongQueTaiBeginMatch(player, role, cmd, others)
	elseif cmd.__type__ == 355 then
		--TongQueTaiCancleMatch
		is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")

		OnCommand_TongQueTaiCancleMatch(player, role, cmd, others)
	elseif cmd.__type__ == 359 then
		--TongQueTaiJoin
		is_idx, cmd.role_id1 = Deserialize(is, is_idx, "string")
		is_idx, cmd.role_id2 = Deserialize(is, is_idx, "string")

		OnCommand_TongQueTaiJoin(player, role, cmd, others)
	elseif cmd.__type__ == 361 then
		--TongQueTaiOperation
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.operation = {}
		for i = 1, count do
			is_idx, cmd.operation[i] = DeserializeStruct(is, is_idx, "TongQueTaiOperation")
		end
		is_idx, cmd.role_id1 = Deserialize(is, is_idx, "string")
		is_idx, cmd.role_id2 = Deserialize(is, is_idx, "string")

		OnCommand_TongQueTaiOperation(player, role, cmd, others)
	elseif cmd.__type__ == 363 then
		--TongQueTaiFinish
		is_idx, cmd.win_flag = Deserialize(is, is_idx, "number")
		is_idx, cmd.role_id1 = Deserialize(is, is_idx, "string")
		is_idx, cmd.role_id2 = Deserialize(is, is_idx, "string")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.hero_info = {}
		for i = 1, count do
			is_idx, cmd.hero_info[i] = DeserializeStruct(is, is_idx, "TongQueTaiMonsterState")
		end
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.monster_info = {}
		for i = 1, count do
			is_idx, cmd.monster_info[i] = DeserializeStruct(is, is_idx, "TongQueTaiMonsterState")
		end
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.operations = {}
		for i = 1, count do
			is_idx, cmd.operations[i] = DeserializeStruct(is, is_idx, "PVEOperation")
		end

		OnCommand_TongQueTaiFinish(player, role, cmd, others)
	elseif cmd.__type__ == 366 then
		--TongQueTaiSpeed
		is_idx, cmd.speed = Deserialize(is, is_idx, "number")
		is_idx, cmd.role_id1 = Deserialize(is, is_idx, "string")
		is_idx, cmd.role_id2 = Deserialize(is, is_idx, "string")

		OnCommand_TongQueTaiSpeed(player, role, cmd, others)
	elseif cmd.__type__ == 368 then
		--TongQueTaiLoad
		is_idx, cmd.role_id1 = Deserialize(is, is_idx, "string")
		is_idx, cmd.role_id2 = Deserialize(is, is_idx, "string")

		OnCommand_TongQueTaiLoad(player, role, cmd, others)
	elseif cmd.__type__ == 372 then
		--TongQueTaiGetReward

		OnCommand_TongQueTaiGetReward(player, role, cmd, others)
	elseif cmd.__type__ == 374 then
		--TongQueTaiGetInfo

		OnCommand_TongQueTaiGetInfo(player, role, cmd, others)
	elseif cmd.__type__ == 401 then
		--BattleFieldGetRoundStateInfo
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.round_state = Deserialize(is, is_idx, "number")

		OnCommand_BattleFieldGetRoundStateInfo(player, role, cmd, others)
	elseif cmd.__type__ == 404 then
		--BattleFieldRoundCount
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")

		OnCommand_BattleFieldRoundCount(player, role, cmd, others)
	elseif cmd.__type__ == 421 then
		--BackPackUseItem
		is_idx, cmd.item_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.item_num = Deserialize(is, is_idx, "number")

		OnCommand_BackPackUseItem(player, role, cmd, others)
	elseif cmd.__type__ == 423 then
		--TemporaryBackPackGetInfo

		OnCommand_TemporaryBackPackGetInfo(player, role, cmd, others)
	elseif cmd.__type__ == 425 then
		--TemporaryBackPackReceiveItem
		is_idx, cmd.id = Deserialize(is, is_idx, "number")

		OnCommand_TemporaryBackPackReceiveItem(player, role, cmd, others)
	elseif cmd.__type__ == 500 then
		--LegionGetInfo

		OnCommand_LegionGetInfo(player, role, cmd, others)
	elseif cmd.__type__ == 502 then
		--LegionJunXueGuanGetInfo

		OnCommand_LegionJunXueGuanGetInfo(player, role, cmd, others)
	elseif cmd.__type__ == 504 then
		--LegionJunXueZhuanJingLevelUp
		is_idx, cmd.id = Deserialize(is, is_idx, "number")

		OnCommand_LegionJunXueZhuanJingLevelUp(player, role, cmd, others)
	elseif cmd.__type__ == 506 then
		--LegionLearnJunXueXiangMu
		is_idx, cmd.id = Deserialize(is, is_idx, "number")
		is_idx, cmd.learn_id = Deserialize(is, is_idx, "number")

		OnCommand_LegionLearnJunXueXiangMu(player, role, cmd, others)
	elseif cmd.__type__ == 510 then
		--LegionActivationZhuanJing
		is_idx, cmd.id = Deserialize(is, is_idx, "number")

		OnCommand_LegionActivationZhuanJing(player, role, cmd, others)
	elseif cmd.__type__ == 512 then
		--LegionDecomposeWuHun
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.item = {}
		for i = 1, count do
			is_idx, cmd.item[i] = DeserializeStruct(is, is_idx, "Item")
		end

		OnCommand_LegionDecomposeWuHun(player, role, cmd, others)
	elseif cmd.__type__ == 1000001 then
		--GetRoleInfo

		OnCommand_GetRoleInfo(player, role, cmd, others)
	elseif cmd.__type__ == 1000003 then
		--CreateRole
		is_idx, cmd.name = Deserialize(is, is_idx, "string")
		is_idx, cmd.photo = Deserialize(is, is_idx, "number")
		is_idx, cmd.sex = Deserialize(is, is_idx, "number")

		OnCommand_CreateRole(player, role, cmd, others)
	elseif cmd.__type__ == 1000005 then
		--ReportClientVersion
		is_idx, cmd.client_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.exe_ver = Deserialize(is, is_idx, "string")
		is_idx, cmd.data_ver = Deserialize(is, is_idx, "string")

		OnCommand_ReportClientVersion(player, role, cmd, others)
	elseif cmd.__type__ == 600 then
		--MaShuGetRoleInfo

		OnCommand_MaShuGetRoleInfo(player, role, cmd, others)
	elseif cmd.__type__ == 602 then
		--MaShuSelectFriendToHelp
		is_idx, cmd.roleid = Deserialize(is, is_idx, "string")

		OnCommand_MaShuSelectFriendToHelp(player, role, cmd, others)
	elseif cmd.__type__ == 604 then
		--MaShuGetBuff
		is_idx, cmd.id = Deserialize(is, is_idx, "number")

		OnCommand_MaShuGetBuff(player, role, cmd, others)
	elseif cmd.__type__ == 606 then
		--MaShuBegin
		is_idx, cmd.id = Deserialize(is, is_idx, "number")

		OnCommand_MaShuBegin(player, role, cmd, others)
	elseif cmd.__type__ == 608 then
		--MaShuGetPrize
		is_idx, cmd.stage = Deserialize(is, is_idx, "number")

		OnCommand_MaShuGetPrize(player, role, cmd, others)
	elseif cmd.__type__ == 610 then
		--MaShuUpdateScore
		is_idx, cmd.score = Deserialize(is, is_idx, "number")

		OnCommand_MaShuUpdateScore(player, role, cmd, others)
	elseif cmd.__type__ == 612 then
		--MaShuEnd
		is_idx, cmd.id = Deserialize(is, is_idx, "number")
		is_idx, cmd.score = Deserialize(is, is_idx, "number")
		is_idx, cmd.stage = Deserialize(is, is_idx, "number")
		is_idx, cmd.box_num = Deserialize(is, is_idx, "number")
		is_idx, cmd.money = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.operations = {}
		for i = 1, count do
			is_idx, cmd.operations[i] = DeserializeStruct(is, is_idx, "PVEOperation")
		end

		OnCommand_MaShuEnd(player, role, cmd, others)
	elseif cmd.__type__ == 614 then
		--MaShuGetRankPrize

		OnCommand_MaShuGetRankPrize(player, role, cmd, others)
	elseif cmd.__type__ == 651 then
		--JieYiGetRoleInfo

		OnCommand_JieYiGetRoleInfo(player, role, cmd, others)
	elseif cmd.__type__ == 654 then
		--JieYiGetInfo
		is_idx, cmd.id = Deserialize(is, is_idx, "string")

		OnCommand_JieYiGetInfo(player, role, cmd, others)
	elseif cmd.__type__ == 657 then
		--JieYiCreate
		is_idx, cmd.name = Deserialize(is, is_idx, "string")

		OnCommand_JieYiCreate(player, role, cmd, others)
	elseif cmd.__type__ == 659 then
		--JieYiInviteRole
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.id = Deserialize(is, is_idx, "string")
		is_idx, cmd.name = Deserialize(is, is_idx, "string")
		is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")

		OnCommand_JieYiInviteRole(player, role, cmd, others)
	elseif cmd.__type__ == 662 then
		--JieYiReply
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.id = Deserialize(is, is_idx, "string")
		is_idx, cmd.name = Deserialize(is, is_idx, "string")
		is_idx, cmd.agreement = Deserialize(is, is_idx, "number")
		is_idx, cmd.boss_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.brother_id = Deserialize(is, is_idx, "string")

		OnCommand_JieYiReply(player, role, cmd, others)
	elseif cmd.__type__ == 664 then
		--JieYiOperateInvite
		is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.id = Deserialize(is, is_idx, "string")
		is_idx, cmd.name = Deserialize(is, is_idx, "string")
		is_idx, cmd.agreement = Deserialize(is, is_idx, "number")
		is_idx, cmd.boss_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.brother_id = Deserialize(is, is_idx, "string")

		OnCommand_JieYiOperateInvite(player, role, cmd, others)
	elseif cmd.__type__ == 666 then
		--JieYiLastCreate
		is_idx, cmd.id = Deserialize(is, is_idx, "string")
		is_idx, cmd.name = Deserialize(is, is_idx, "string")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.boss_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.brother_id = Deserialize(is, is_idx, "string")

		OnCommand_JieYiLastCreate(player, role, cmd, others)
	elseif cmd.__type__ == 668 then
		--JieYiLastOperate
		is_idx, cmd.agreement = Deserialize(is, is_idx, "number")
		is_idx, cmd.id = Deserialize(is, is_idx, "string")
		is_idx, cmd.name = Deserialize(is, is_idx, "string")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.boss_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.brother_id = Deserialize(is, is_idx, "string")

		OnCommand_JieYiLastOperate(player, role, cmd, others)
	elseif cmd.__type__ == 671 then
		--JieYiGetInviteInfo

		OnCommand_JieYiGetInviteInfo(player, role, cmd, others)
	elseif cmd.__type__ == 673 then
		--JieYiCancelInviteRole
		is_idx, cmd.id = Deserialize(is, is_idx, "string")
		is_idx, cmd.name = Deserialize(is, is_idx, "string")
		is_idx, cmd.brother_id = Deserialize(is, is_idx, "string")

		OnCommand_JieYiCancelInviteRole(player, role, cmd, others)
	elseif cmd.__type__ == 675 then
		--JieYiExpelBrother
		is_idx, cmd.id = Deserialize(is, is_idx, "string")
		is_idx, cmd.name = Deserialize(is, is_idx, "string")
		is_idx, cmd.brother_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.brother_otherid = Deserialize(is, is_idx, "string")

		OnCommand_JieYiExpelBrother(player, role, cmd, others)
	elseif cmd.__type__ == 678 then
		--JieYiExitCurrentJieYi
		is_idx, cmd.id = Deserialize(is, is_idx, "string")
		is_idx, cmd.name = Deserialize(is, is_idx, "string")
		is_idx, cmd.brother_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.brother_otherid = Deserialize(is, is_idx, "string")

		OnCommand_JieYiExitCurrentJieYi(player, role, cmd, others)
	elseif cmd.__type__ == 700 then
		--AudienceGetList

		OnCommand_AudienceGetList(player, role, cmd, others)
	elseif cmd.__type__ == 702 then
		--AudienceGetOperation
		is_idx, cmd.room_id = Deserialize(is, is_idx, "number")

		OnCommand_AudienceGetOperation(player, role, cmd, others)
	elseif cmd.__type__ == 705 then
		--AudienceLeaveRoom
		is_idx, cmd.room_id = Deserialize(is, is_idx, "number")

		OnCommand_AudienceLeaveRoom(player, role, cmd, others)
	elseif cmd.__type__ == 730 then
		--PhotoSetPhoto
		is_idx, cmd.photo_id = Deserialize(is, is_idx, "number")

		OnCommand_PhotoSetPhoto(player, role, cmd, others)
	elseif cmd.__type__ == 732 then
		--PhotoSetPhotoFrame
		is_idx, cmd.photoframe_id = Deserialize(is, is_idx, "number")

		OnCommand_PhotoSetPhotoFrame(player, role, cmd, others)
	elseif cmd.__type__ == 20000 then
		--TopListGet
		is_idx, cmd.top_type = Deserialize(is, is_idx, "number")
		is_idx, cmd.top_flag = Deserialize(is, is_idx, "number")

		OnCommand_TopListGet(player, role, cmd, others)
	elseif cmd.__type__ == 99999 then
		--DebugCommand
		is_idx, cmd.typ = Deserialize(is, is_idx, "string")
		is_idx, cmd.count1 = Deserialize(is, is_idx, "number")
		is_idx, cmd.count2 = Deserialize(is, is_idx, "number")
		is_idx, cmd.count3 = Deserialize(is, is_idx, "number")
		is_idx, cmd.count4 = Deserialize(is, is_idx, "number")

		OnCommand_DebugCommand(player, role, cmd, others)
	elseif cmd.__type__ == 10003 then
		--PrivateChat
		is_idx, cmd.src = DeserializeStruct(is, is_idx, "RoleBrief")
		is_idx, cmd.dest = DeserializeStruct(is, is_idx, "RoleBrief")
		is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.text_content = Deserialize(is, is_idx, "string")
		is_idx, cmd.speech_content = Deserialize(is, is_idx, "string")
		is_idx, cmd.time = Deserialize(is, is_idx, "number")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")

		OnCommand_PrivateChat(player, role, cmd, others)
	elseif cmd.__type__ == 10004 then
		--PublicChat
		is_idx, cmd.src = DeserializeStruct(is, is_idx, "RoleBrief")
		is_idx, cmd.text_content = Deserialize(is, is_idx, "string")
		is_idx, cmd.speech_content = Deserialize(is, is_idx, "string")
		is_idx, cmd.time = Deserialize(is, is_idx, "number")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")

		OnCommand_PublicChat(player, role, cmd, others)
	elseif cmd.__type__ == 10006 then
		--ListFriends

		OnCommand_ListFriends(player, role, cmd, others)
	elseif cmd.__type__ == 10008 then
		--FriendRequest
		is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")

		OnCommand_FriendRequest(player, role, cmd, others)
	elseif cmd.__type__ == 10011 then
		--FriendReply
		is_idx, cmd.src_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.accept = Deserialize(is, is_idx, "boolean")

		OnCommand_FriendReply(player, role, cmd, others)
	elseif cmd.__type__ == 10014 then
		--RemoveFriend
		is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")

		OnCommand_RemoveFriend(player, role, cmd, others)
	elseif cmd.__type__ == 10101 then
		--MafiaGet

		OnCommand_MafiaGet(player, role, cmd, others)
	elseif cmd.__type__ == 10103 then
		--MafiaCreate
		is_idx, cmd.name = Deserialize(is, is_idx, "string")
		is_idx, cmd.flag = Deserialize(is, is_idx, "number")

		OnCommand_MafiaCreate(player, role, cmd, others)
	elseif cmd.__type__ == 10105 then
		--MafiaList

		OnCommand_MafiaList(player, role, cmd, others)
	elseif cmd.__type__ == 10107 then
		--MafiaGetSelfInfo

		OnCommand_MafiaGetSelfInfo(player, role, cmd, others)
	elseif cmd.__type__ == 10110 then
		--MafiaApply
		is_idx, cmd.id = Deserialize(is, is_idx, "string")

		OnCommand_MafiaApply(player, role, cmd, others)
	elseif cmd.__type__ == 10112 then
		--MafiaQuit

		OnCommand_MafiaQuit(player, role, cmd, others)
	elseif cmd.__type__ == 10114 then
		--MafiaGetApplyList

		OnCommand_MafiaGetApplyList(player, role, cmd, others)
	elseif cmd.__type__ == 10116 then
		--MafiaOperateApplyList
		is_idx, cmd.accept = Deserialize(is, is_idx, "number")
		is_idx, cmd.role_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.mafia_id = Deserialize(is, is_idx, "string")

		OnCommand_MafiaOperateApplyList(player, role, cmd, others)
	elseif cmd.__type__ == 10118 then
		--MafiaSetLevelLimit
		is_idx, cmd.level = Deserialize(is, is_idx, "number")
		is_idx, cmd.need_approval = Deserialize(is, is_idx, "number")

		OnCommand_MafiaSetLevelLimit(player, role, cmd, others)
	elseif cmd.__type__ == 10120 then
		--MafiaSetAnnounce
		is_idx, cmd.announce = Deserialize(is, is_idx, "string")

		OnCommand_MafiaSetAnnounce(player, role, cmd, others)
	elseif cmd.__type__ == 10122 then
		--MafiaKickout
		is_idx, cmd.role_id = Deserialize(is, is_idx, "string")

		OnCommand_MafiaKickout(player, role, cmd, others)
	elseif cmd.__type__ == 10129 then
		--MafiaChangeMenberPosition
		is_idx, cmd.position = Deserialize(is, is_idx, "number")
		is_idx, cmd.role_id = Deserialize(is, is_idx, "string")

		OnCommand_MafiaChangeMenberPosition(player, role, cmd, others)
	elseif cmd.__type__ == 10131 then
		--MafiaShanRang
		is_idx, cmd.role_id = Deserialize(is, is_idx, "string")

		OnCommand_MafiaShanRang(player, role, cmd, others)
	elseif cmd.__type__ == 10133 then
		--MafiaJiSi
		is_idx, cmd.jisi_typ = Deserialize(is, is_idx, "number")

		OnCommand_MafiaJiSi(player, role, cmd, others)
	elseif cmd.__type__ == 10135 then
		--MafiaDeclaration
		is_idx, cmd.declaration = Deserialize(is, is_idx, "string")

		OnCommand_MafiaDeclaration(player, role, cmd, others)
	elseif cmd.__type__ == 10137 then
		--MafiaChangeName
		is_idx, cmd.name = Deserialize(is, is_idx, "string")

		OnCommand_MafiaChangeName(player, role, cmd, others)
	elseif cmd.__type__ == 10139 then
		--MafiaSeeInfo
		is_idx, cmd.mafia_id = Deserialize(is, is_idx, "string")

		OnCommand_MafiaSeeInfo(player, role, cmd, others)
	elseif cmd.__type__ == 10141 then
		--MafiaBangZhuSendMail
		is_idx, cmd.subject = Deserialize(is, is_idx, "string")
		is_idx, cmd.context = Deserialize(is, is_idx, "string")

		OnCommand_MafiaBangZhuSendMail(player, role, cmd, others)
	elseif cmd.__type__ == 10201 then
		--Ping
		is_idx, cmd.client_send_time = Deserialize(is, is_idx, "number")

		OnCommand_Ping(player, role, cmd, others)
	elseif cmd.__type__ == 10203 then
		--UDPPing
		is_idx, cmd.client_send_time = Deserialize(is, is_idx, "number")

		OnCommand_UDPPing(player, role, cmd, others)
	elseif cmd.__type__ == 10206 then
		--UDPClientTimeRequest_Re
		is_idx, cmd.local_time = Deserialize(is, is_idx, "number")
		is_idx, cmd.server_time = Deserialize(is, is_idx, "number")

		OnCommand_UDPClientTimeRequest_Re(player, role, cmd, others)

	end
end

