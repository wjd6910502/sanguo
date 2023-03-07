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
			others.mafias[v._id:ToStr()] = v
		elseif k==1+extra_roles_size+1+extra_mafias_size+1 then
			--extra pvps size
			extra_pvps_size = v
		elseif k<=1+extra_roles_size+1+extra_mafias_size+1+extra_pvps_size then
			--extra pvps
			v = API_GetLuaPVP(v)
			others.pvps[v._data._id] = v
		elseif k==1+extra_roles_size+1+extra_mafias_size+1+extra_pvps_size+1 then
			--extra top
			v = API_GetLuaTopManager(v)
			others.top = v
		elseif k==1+extra_roles_size+1+extra_mafias_size+1+extra_pvps_size+1+1 then
			--extra MiscManager
			v = API_GetLuaMiscManager(v)
			others.mist = v
		end
	end

	local cmd = {}
	local is_idx = 1
	is_idx, cmd.__type__ = Deserialize(is, is_idx, "number")

	if false then
		--never to here
	elseif cmd.__type__ == 1 then
		--GetVersion

		OnCommand_GetVersion(player, role, cmd, others)
	elseif cmd.__type__ == 3 then
		--GetRoleInfo

		OnCommand_GetRoleInfo(player, role, cmd, others)
	elseif cmd.__type__ == 5 then
		--CreateRole
		is_idx, cmd.name = Deserialize(is, is_idx, "string")
		is_idx, cmd.photo = Deserialize(is, is_idx, "number")

		OnCommand_CreateRole(player, role, cmd, others)
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
	elseif cmd.__type__ == 20000 then
		--TopListGet
		is_idx, cmd.top_type = Deserialize(is, is_idx, "number")
		is_idx, cmd.top_flag = Deserialize(is, is_idx, "number")

		OnCommand_TopListGet(player, role, cmd, others)
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
		is_idx, cmd.skill_id = Deserialize(is, is_idx, "number")

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
	elseif cmd.__type__ == 10003 then
		--PrivateChat
		is_idx, cmd.src = DeserializeStruct(is, is_idx, "RoleBrief")
		is_idx, cmd.dest = DeserializeStruct(is, is_idx, "RoleBrief")
		is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.content = Deserialize(is, is_idx, "string")
		is_idx, cmd.time = Deserialize(is, is_idx, "number")

		OnCommand_PrivateChat(player, role, cmd, others)
	elseif cmd.__type__ == 10004 then
		--PublicChat
		is_idx, cmd.src = DeserializeStruct(is, is_idx, "RoleBrief")
		is_idx, cmd.content = Deserialize(is, is_idx, "string")
		is_idx, cmd.time = Deserialize(is, is_idx, "number")

		OnCommand_PublicChat(player, role, cmd, others)
	elseif cmd.__type__ == 10006 then
		--ListFriends

		OnCommand_ListFriends(player, role, cmd, others)
	elseif cmd.__type__ == 10008 then
		--FriendRequest
		is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.src = DeserializeStruct(is, is_idx, "Friend")

		OnCommand_FriendRequest(player, role, cmd, others)
	elseif cmd.__type__ == 10009 then
		--FriendReply
		is_idx, cmd.src_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.accept = Deserialize(is, is_idx, "boolean")

		OnCommand_FriendReply(player, role, cmd, others)
	elseif cmd.__type__ == 10101 then
		--MafiaGet

		OnCommand_MafiaGet(player, role, cmd, others)
	elseif cmd.__type__ == 10103 then
		--MafiaCreate
		is_idx, cmd.name = Deserialize(is, is_idx, "string")
		is_idx, cmd.flag = Deserialize(is, is_idx, "number")

		OnCommand_MafiaCreate(player, role, cmd, others)
	elseif cmd.__type__ == 10105 then
		--MafiaInvite
		is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.src = DeserializeStruct(is, is_idx, "RoleBrief")

		OnCommand_MafiaInvite(player, role, cmd, others)
	elseif cmd.__type__ == 10106 then
		--MafiaReply
		is_idx, cmd.src_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.accept = Deserialize(is, is_idx, "boolean")

		OnCommand_MafiaReply(player, role, cmd, others)
	elseif cmd.__type__ == 10109 then
		--MafiaKickout
		is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")

		OnCommand_MafiaKickout(player, role, cmd, others)
	elseif cmd.__type__ == 10112 then
		--MafiaQuit

		OnCommand_MafiaQuit(player, role, cmd, others)
	elseif cmd.__type__ == 10114 then
		--MafiaDestory

		OnCommand_MafiaDestory(player, role, cmd, others)
	elseif cmd.__type__ == 10116 then
		--MafiaAnnounce
		is_idx, cmd.announce = Deserialize(is, is_idx, "string")

		OnCommand_MafiaAnnounce(player, role, cmd, others)
	elseif cmd.__type__ == 99999 then
		--DebugCommand
		is_idx, cmd.typ = Deserialize(is, is_idx, "string")
		is_idx, cmd.count1 = Deserialize(is, is_idx, "number")
		is_idx, cmd.count2 = Deserialize(is, is_idx, "number")
		is_idx, cmd.count3 = Deserialize(is, is_idx, "number")
		is_idx, cmd.count4 = Deserialize(is, is_idx, "number")

		OnCommand_DebugCommand(player, role, cmd, others)
	elseif cmd.__type__ == 10401 then
		--ReportClientVersion
		is_idx, cmd.client_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.exe_ver = Deserialize(is, is_idx, "string")
		is_idx, cmd.data_ver = Deserialize(is, is_idx, "string")

		OnCommand_ReportClientVersion(player, role, cmd, others)
	elseif cmd.__type__ == 10201 then
		--Ping
		is_idx, cmd.client_send_time = Deserialize(is, is_idx, "number")

		OnCommand_Ping(player, role, cmd, others)
	elseif cmd.__type__ == 10203 then
		--UDPPing
		is_idx, cmd.client_send_time = Deserialize(is, is_idx, "number")

		OnCommand_UDPPing(player, role, cmd, others)

	end
end

