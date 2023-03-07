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
	elseif cmd.__type__ == 513 then
		--LegionDecomposeWuHun_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.item = {}
		for i = 1, count do
			is_idx, cmd.item[i] = DeserializeStruct(is, is_idx, "Item")
		end
		is_idx, cmd.count = Deserialize(is, is_idx, "number")

		OnCommand_LegionDecomposeWuHun_Re(player, role, cmd, others)
	elseif cmd.__type__ == 8 then
		--EnterInstance_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.inst_tid = Deserialize(is, is_idx, "number")
		is_idx, cmd.seed = Deserialize(is, is_idx, "number")

		OnCommand_EnterInstance_Re(player, role, cmd, others)
	elseif cmd.__type__ == 10 then
		--CompleteInstance_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.inst_tid = Deserialize(is, is_idx, "number")
		is_idx, cmd.score = Deserialize(is, is_idx, "number")
		is_idx, cmd.star = Deserialize(is, is_idx, "number")
		is_idx, cmd.rewards = DeserializeStruct(is, is_idx, "SweepInstanceData")
		is_idx, cmd.first_flag = Deserialize(is, is_idx, "number")

		OnCommand_CompleteInstance_Re(player, role, cmd, others)
	elseif cmd.__type__ == 11 then
		--SyncRoleInfo

		OnCommand_SyncRoleInfo(player, role, cmd, others)
	elseif cmd.__type__ == 10015 then
		--RemoveFriend_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")

		OnCommand_RemoveFriend_Re(player, role, cmd, others)
	elseif cmd.__type__ == 20001 then
		--TopListGet_Re
		is_idx, cmd.top_type = Deserialize(is, is_idx, "number")
		is_idx, cmd.top_flag = Deserialize(is, is_idx, "number")
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.members = {}
		for i = 1, count do
			is_idx, cmd.members[i] = DeserializeStruct(is, is_idx, "TopListData")
		end

		OnCommand_TopListGet_Re(player, role, cmd, others)
	elseif cmd.__type__ == 615 then
		--MaShuGetRankPrize_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.item = DeserializeStruct(is, is_idx, "TemporaryBackPackData")
		is_idx, cmd.yestaday_rank = Deserialize(is, is_idx, "number")
		is_idx, cmd.get_prize_flag = Deserialize(is, is_idx, "number")

		OnCommand_MaShuGetRankPrize_Re(player, role, cmd, others)
	elseif cmd.__type__ == 10009 then
		--FriendRequest_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")

		OnCommand_FriendRequest_Re(player, role, cmd, others)
	elseif cmd.__type__ == 10301 then
		--PVPInvite
		is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.src = DeserializeStruct(is, is_idx, "RoleBrief")
		is_idx, cmd.mode = Deserialize(is, is_idx, "number")

		OnCommand_PVPInvite(player, role, cmd, others)
	elseif cmd.__type__ == 10303 then
		--PVPPrepare
		is_idx, cmd.id = Deserialize(is, is_idx, "number")
		is_idx, cmd.player1 = DeserializeStruct(is, is_idx, "RoleBrief")
		is_idx, cmd.player2 = DeserializeStruct(is, is_idx, "RoleBrief")
		is_idx, cmd.N = Deserialize(is, is_idx, "number")
		is_idx, cmd.mode = Deserialize(is, is_idx, "number")
		is_idx, cmd.p2p_magic = Deserialize(is, is_idx, "number")
		is_idx, cmd.p2p_peer_ip = Deserialize(is, is_idx, "string")
		is_idx, cmd.p2p_peer_port = Deserialize(is, is_idx, "number")

		OnCommand_PVPPrepare(player, role, cmd, others)
	elseif cmd.__type__ == 10305 then
		--PVPBegin
		is_idx, cmd.fight_start_time = Deserialize(is, is_idx, "number")
		is_idx, cmd.ip = Deserialize(is, is_idx, "string")
		is_idx, cmd.port = Deserialize(is, is_idx, "number")

		OnCommand_PVPBegin(player, role, cmd, others)
	elseif cmd.__type__ == 10306 then
		--PVPOperation
		is_idx, cmd.client_tick = Deserialize(is, is_idx, "number")
		is_idx, cmd.op = Deserialize(is, is_idx, "string")
		is_idx, cmd.crc = Deserialize(is, is_idx, "string")

		OnCommand_PVPOperation(player, role, cmd, others)
	elseif cmd.__type__ == 10307 then
		--PVPOperationSet
		is_idx, cmd.client_tick = Deserialize(is, is_idx, "number")
		is_idx, cmd.player1_op = Deserialize(is, is_idx, "string")
		is_idx, cmd.player2_op = Deserialize(is, is_idx, "string")

		OnCommand_PVPOperationSet(player, role, cmd, others)
	elseif cmd.__type__ == 10308 then
		--PVPEnd
		is_idx, cmd.result = Deserialize(is, is_idx, "number")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.pvp_typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.star = Deserialize(is, is_idx, "number")
		is_idx, cmd.win_count = Deserialize(is, is_idx, "number")

		OnCommand_PVPEnd(player, role, cmd, others)
	elseif cmd.__type__ == 10309 then
		--PVPError
		is_idx, cmd.result = Deserialize(is, is_idx, "number")

		OnCommand_PVPError(player, role, cmd, others)
	elseif cmd.__type__ == 10310 then
		--PVPPeerLatency
		is_idx, cmd.latency = Deserialize(is, is_idx, "number")

		OnCommand_PVPPeerLatency(player, role, cmd, others)
	elseif cmd.__type__ == 10010 then
		--FriendAddRequest
		is_idx, cmd.requests = DeserializeStruct(is, is_idx, "Friend")

		OnCommand_FriendAddRequest(player, role, cmd, others)
	elseif cmd.__type__ == 601 then
		--MaShuGetRoleInfo_Re
		is_idx, cmd.rank = Deserialize(is, is_idx, "number")
		is_idx, cmd.yestaday_rank = Deserialize(is, is_idx, "number")
		is_idx, cmd.today_score = Deserialize(is, is_idx, "number")
		is_idx, cmd.hisroty_score = Deserialize(is, is_idx, "number")
		is_idx, cmd.today_stage = Deserialize(is, is_idx, "number")
		is_idx, cmd.history_stage = Deserialize(is, is_idx, "number")
		is_idx, cmd.get_prize_flag = Deserialize(is, is_idx, "number")
		is_idx, cmd.hero_info = DeserializeStruct(is, is_idx, "MaShuHeroInfo")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.friend_info = {}
		for i = 1, count do
			is_idx, cmd.friend_info[i] = DeserializeStruct(is, is_idx, "MaShuFriendInfo")
		end
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.buff_info = {}
		for i = 1, count do
			is_idx, cmd.buff_info[i] = DeserializeStruct(is, is_idx, "MaShuBuffInfo")
		end
		is_idx, cmd.fight_friend = DeserializeStruct(is, is_idx, "MaShuFightFriendInfo")

		OnCommand_MaShuGetRoleInfo_Re(player, role, cmd, others)
	elseif cmd.__type__ == 603 then
		--MaShuSelectFriendToHelp_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.roleid = Deserialize(is, is_idx, "string")

		OnCommand_MaShuSelectFriendToHelp_Re(player, role, cmd, others)
	elseif cmd.__type__ == 605 then
		--MaShuGetBuff_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.id = Deserialize(is, is_idx, "number")
		is_idx, cmd.buff_info = DeserializeStruct(is, is_idx, "MaShuBuffInfo")

		OnCommand_MaShuGetBuff_Re(player, role, cmd, others)
	elseif cmd.__type__ == 607 then
		--MaShuBegin_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.id = Deserialize(is, is_idx, "number")

		OnCommand_MaShuBegin_Re(player, role, cmd, others)
	elseif cmd.__type__ == 609 then
		--MaShuGetPrize_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.stage = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.item = {}
		for i = 1, count do
			is_idx, cmd.item[i] = DeserializeStruct(is, is_idx, "Item")
		end
		is_idx, cmd.money = Deserialize(is, is_idx, "number")

		OnCommand_MaShuGetPrize_Re(player, role, cmd, others)
	elseif cmd.__type__ == 611 then
		--MaShuUpdateScore_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.score = Deserialize(is, is_idx, "number")

		OnCommand_MaShuUpdateScore_Re(player, role, cmd, others)
	elseif cmd.__type__ == 101 then
		--SweepInstance_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.info = {}
		for i = 1, count do
			is_idx, cmd.info[i] = DeserializeStruct(is, is_idx, "SweepInstanceData")
		end
		is_idx, cmd.info2 = DeserializeStruct(is, is_idx, "SweepInstanceData")

		OnCommand_SweepInstance_Re(player, role, cmd, others)
	elseif cmd.__type__ == 103 then
		--GetBackPack_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.info = {}
		for i = 1, count do
			is_idx, cmd.info[i] = DeserializeStruct(is, is_idx, "Item")
		end
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.weaponitems = {}
		for i = 1, count do
			is_idx, cmd.weaponitems[i] = DeserializeStruct(is, is_idx, "WeaponItem")
		end
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.equipmentitems = {}
		for i = 1, count do
			is_idx, cmd.equipmentitems[i] = DeserializeStruct(is, is_idx, "EquipmentItem")
		end

		OnCommand_GetBackPack_Re(player, role, cmd, others)
	elseif cmd.__type__ == 105 then
		--GetInstance_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.info = {}
		for i = 1, count do
			is_idx, cmd.info[i] = DeserializeStruct(is, is_idx, "InstanceInfo")
		end

		OnCommand_GetInstance_Re(player, role, cmd, others)
	elseif cmd.__type__ == 106 then
		--Role_Mon_Exp
		is_idx, cmd.level = Deserialize(is, is_idx, "number")
		is_idx, cmd.exp = Deserialize(is, is_idx, "string")
		is_idx, cmd.money = Deserialize(is, is_idx, "number")
		is_idx, cmd.yuanbao = Deserialize(is, is_idx, "number")
		is_idx, cmd.vp = Deserialize(is, is_idx, "number")

		OnCommand_Role_Mon_Exp(player, role, cmd, others)
	elseif cmd.__type__ == 108 then
		--BuyVp_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.num = Deserialize(is, is_idx, "number")

		OnCommand_BuyVp_Re(player, role, cmd, others)
	elseif cmd.__type__ == 110 then
		--BuyInstanceCount_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_BuyInstanceCount_Re(player, role, cmd, others)
	elseif cmd.__type__ == 111 then
		--RoleCommonLimit
		is_idx, cmd.tid = Deserialize(is, is_idx, "number")
		is_idx, cmd.count = Deserialize(is, is_idx, "number")

		OnCommand_RoleCommonLimit(player, role, cmd, others)
	elseif cmd.__type__ == 616 then
		--MaShuUpdateRoleInfo
		is_idx, cmd.rank = Deserialize(is, is_idx, "number")
		is_idx, cmd.yestaday_rank = Deserialize(is, is_idx, "number")
		is_idx, cmd.today_score = Deserialize(is, is_idx, "number")
		is_idx, cmd.hisroty_score = Deserialize(is, is_idx, "number")
		is_idx, cmd.today_stage = Deserialize(is, is_idx, "number")
		is_idx, cmd.history_stage = Deserialize(is, is_idx, "number")
		is_idx, cmd.get_prize_flag = Deserialize(is, is_idx, "number")
		is_idx, cmd.hero_info = DeserializeStruct(is, is_idx, "MaShuHeroInfo")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.friend_info = {}
		for i = 1, count do
			is_idx, cmd.friend_info[i] = DeserializeStruct(is, is_idx, "MaShuFriendInfo")
		end
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.buff_info = {}
		for i = 1, count do
			is_idx, cmd.buff_info[i] = DeserializeStruct(is, is_idx, "MaShuBuffInfo")
		end
		is_idx, cmd.fight_friend = DeserializeStruct(is, is_idx, "MaShuFightFriendInfo")

		OnCommand_MaShuUpdateRoleInfo(player, role, cmd, others)
	elseif cmd.__type__ == 114 then
		--ChongZhi_Re
		is_idx, cmd.chongzhi = Deserialize(is, is_idx, "number")

		OnCommand_ChongZhi_Re(player, role, cmd, others)
	elseif cmd.__type__ == 116 then
		--TaskFinish_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.task_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.rewards = DeserializeStruct(is, is_idx, "SweepInstanceData")

		OnCommand_TaskFinish_Re(player, role, cmd, others)
	elseif cmd.__type__ == 117 then
		--Task_Condition
		is_idx, cmd.tid = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.condition = {}
		for i = 1, count do
			is_idx, cmd.condition[i] = DeserializeStruct(is, is_idx, "Condition")
		end

		OnCommand_Task_Condition(player, role, cmd, others)
	elseif cmd.__type__ == 120 then
		--BuyHero_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_BuyHero_Re(player, role, cmd, others)
	elseif cmd.__type__ == 121 then
		--HeroList_Re
		is_idx, cmd.hero_hall = DeserializeStruct(is, is_idx, "RoleHero")

		OnCommand_HeroList_Re(player, role, cmd, others)
	elseif cmd.__type__ == 123 then
		--AddHero
		is_idx, cmd.hero_hall = DeserializeStruct(is, is_idx, "RoleHero")
		is_idx, cmd.flag = Deserialize(is, is_idx, "number")

		OnCommand_AddHero(player, role, cmd, others)
	elseif cmd.__type__ == 124 then
		--UpdateHeroInfo
		is_idx, cmd.hero_hall = DeserializeStruct(is, is_idx, "RoleHero")

		OnCommand_UpdateHeroInfo(player, role, cmd, others)
	elseif cmd.__type__ == 125 then
		--UseItem_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_UseItem_Re(player, role, cmd, others)
	elseif cmd.__type__ == 127 then
		--One_Level_Up_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_One_Level_Up_Re(player, role, cmd, others)
	elseif cmd.__type__ == 129 then
		--Hero_Up_Grade_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_Hero_Up_Grade_Re(player, role, cmd, others)
	elseif cmd.__type__ == 130 then
		--ErrorInfo
		is_idx, cmd.error_id = Deserialize(is, is_idx, "number")

		OnCommand_ErrorInfo(player, role, cmd, others)
	elseif cmd.__type__ == 132 then
		--BuyHorse_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_BuyHorse_Re(player, role, cmd, others)
	elseif cmd.__type__ == 133 then
		--AddHorse
		is_idx, cmd.horse = DeserializeStruct(is, is_idx, "RoleHorse")

		OnCommand_AddHorse(player, role, cmd, others)
	elseif cmd.__type__ == 135 then
		--GetLastHero_Re
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.info = {}
		for i = 1, count do
			is_idx, cmd.info[i] = Deserialize(is, is_idx, "number")
		end

		OnCommand_GetLastHero_Re(player, role, cmd, others)
	elseif cmd.__type__ == 137 then
		--PvpJoin_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.time = Deserialize(is, is_idx, "number")

		OnCommand_PvpJoin_Re(player, role, cmd, others)
	elseif cmd.__type__ == 138 then
		--PvpMatchSuccess
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.index = Deserialize(is, is_idx, "number")

		OnCommand_PvpMatchSuccess(player, role, cmd, others)
	elseif cmd.__type__ == 140 then
		--PvpEnter_Re
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

		OnCommand_PvpEnter_Re(player, role, cmd, others)
	elseif cmd.__type__ == 142 then
		--PvpCancle_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_PvpCancle_Re(player, role, cmd, others)
	elseif cmd.__type__ == 143 then
		--PvpSpeed
		is_idx, cmd.speed = Deserialize(is, is_idx, "number")

		OnCommand_PvpSpeed(player, role, cmd, others)
	elseif cmd.__type__ == 145 then
		--SendNotice
		is_idx, cmd.notice_id = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.notice_para = {}
		for i = 1, count do
			is_idx, cmd.notice_para[i] = Deserialize(is, is_idx, "string")
		end

		OnCommand_SendNotice(player, role, cmd, others)
	elseif cmd.__type__ == 146 then
		--CurrentTask
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.current = {}
		for i = 1, count do
			is_idx, cmd.current[i] = DeserializeStruct(is, is_idx, "RoleCurrentTask")
		end

		OnCommand_CurrentTask(player, role, cmd, others)
	elseif cmd.__type__ == 147 then
		--FinishedTask
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.finish = {}
		for i = 1, count do
			is_idx, cmd.finish[i] = Deserialize(is, is_idx, "number")
		end

		OnCommand_FinishedTask(player, role, cmd, others)
	elseif cmd.__type__ == 149 then
		--ItemCountChange
		is_idx, cmd.itemid = Deserialize(is, is_idx, "number")
		is_idx, cmd.count = Deserialize(is, is_idx, "number")

		OnCommand_ItemCountChange(player, role, cmd, others)
	elseif cmd.__type__ == 151 then
		--HeroUpgradeSkill_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_HeroUpgradeSkill_Re(player, role, cmd, others)
	elseif cmd.__type__ == 153 then
		--GetHeroComments_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.comment = {}
		for i = 1, count do
			is_idx, cmd.comment[i] = DeserializeStruct(is, is_idx, "HeroComment")
		end
		is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")

		OnCommand_GetHeroComments_Re(player, role, cmd, others)
	elseif cmd.__type__ == 155 then
		--AgreeHeroComments_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.role_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.time_stamp = Deserialize(is, is_idx, "number")

		OnCommand_AgreeHeroComments_Re(player, role, cmd, others)
	elseif cmd.__type__ == 157 then
		--WriteHeroComments_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")

		OnCommand_WriteHeroComments_Re(player, role, cmd, others)
	elseif cmd.__type__ == 159 then
		--ReWriteHeroComments_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")

		OnCommand_ReWriteHeroComments_Re(player, role, cmd, others)
	elseif cmd.__type__ == 160 then
		--UpdateHeroSkillPoint
		is_idx, cmd.point = Deserialize(is, is_idx, "number")

		OnCommand_UpdateHeroSkillPoint(player, role, cmd, others)
	elseif cmd.__type__ == 162 then
		--GetVPRefreshTime_Re
		is_idx, cmd.refresh_time = Deserialize(is, is_idx, "number")

		OnCommand_GetVPRefreshTime_Re(player, role, cmd, others)
	elseif cmd.__type__ == 164 then
		--GetSkillPointRefreshTime_Re
		is_idx, cmd.refresh_time = Deserialize(is, is_idx, "number")

		OnCommand_GetSkillPointRefreshTime_Re(player, role, cmd, others)
	elseif cmd.__type__ == 167 then
		--BuySkillPoint_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.point = Deserialize(is, is_idx, "number")

		OnCommand_BuySkillPoint_Re(player, role, cmd, others)
	elseif cmd.__type__ == 168 then
		--UpdatePvpVideo
		is_idx, cmd.video = Deserialize(is, is_idx, "string")
		is_idx, cmd.player1 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
		is_idx, cmd.player2 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
		is_idx, cmd.win_flag = Deserialize(is, is_idx, "number")
		is_idx, cmd.time = Deserialize(is, is_idx, "number")

		OnCommand_UpdatePvpVideo(player, role, cmd, others)
	elseif cmd.__type__ == 170 then
		--GetVideo_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.player1 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
		is_idx, cmd.player2 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
		is_idx, cmd.operation = DeserializeStruct(is, is_idx, "PvpVideo")
		is_idx, cmd.win_flag = Deserialize(is, is_idx, "number")
		is_idx, cmd.robot_flag = Deserialize(is, is_idx, "number")
		is_idx, cmd.robot_seed = Deserialize(is, is_idx, "number")
		is_idx, cmd.exe_ver = Deserialize(is, is_idx, "string")
		is_idx, cmd.data_ver = Deserialize(is, is_idx, "string")

		OnCommand_GetVideo_Re(player, role, cmd, others)
	elseif cmd.__type__ == 171 then
		--PrivateChatHistory
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.private_chat = {}
		for i = 1, count do
			is_idx, cmd.private_chat[i] = DeserializeStruct(is, is_idx, "ChatInfo")
		end

		OnCommand_PrivateChatHistory(player, role, cmd, others)
	elseif cmd.__type__ == 173 then
		--AddBlackList_Re
		is_idx, cmd.roleinfo = DeserializeStruct(is, is_idx, "RoleBase")

		OnCommand_AddBlackList_Re(player, role, cmd, others)
	elseif cmd.__type__ == 175 then
		--DelBlackList_Re
		is_idx, cmd.roleid = Deserialize(is, is_idx, "string")

		OnCommand_DelBlackList_Re(player, role, cmd, others)
	elseif cmd.__type__ == 177 then
		--SeeAnotherRole_Re
		is_idx, cmd.roleinfo = DeserializeStruct(is, is_idx, "AnotherRoleData")

		OnCommand_SeeAnotherRole_Re(player, role, cmd, others)
	elseif cmd.__type__ == 180 then
		--ReadMail_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_ReadMail_Re(player, role, cmd, others)
	elseif cmd.__type__ == 182 then
		--GetAttachment_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_GetAttachment_Re(player, role, cmd, others)
	elseif cmd.__type__ == 183 then
		--UpdateMail
		is_idx, cmd.mail_info = DeserializeStruct(is, is_idx, "MailInfo")

		OnCommand_UpdateMail(player, role, cmd, others)
	elseif cmd.__type__ == 184 then
		--UpdatePvpEndTime
		is_idx, cmd.end_time = Deserialize(is, is_idx, "number")

		OnCommand_UpdatePvpEndTime(player, role, cmd, others)
	elseif cmd.__type__ == 185 then
		--UpdateHeroPvpInfo
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.hero_pvpinfo = {}
		for i = 1, count do
			is_idx, cmd.hero_pvpinfo[i] = DeserializeStruct(is, is_idx, "HeroPvpInfoData")
		end

		OnCommand_UpdateHeroPvpInfo(player, role, cmd, others)
	elseif cmd.__type__ == 186 then
		--DeleteTask
		is_idx, cmd.task_id = Deserialize(is, is_idx, "number")

		OnCommand_DeleteTask(player, role, cmd, others)
	elseif cmd.__type__ == 188 then
		--BroadcastPvpVideo_Re
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.src = DeserializeStruct(is, is_idx, "RoleBrief")
		is_idx, cmd.content = Deserialize(is, is_idx, "string")
		is_idx, cmd.video_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.player1 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
		is_idx, cmd.player2 = DeserializeStruct(is, is_idx, "RoleClientPVPInfo")
		is_idx, cmd.time = Deserialize(is, is_idx, "number")
		is_idx, cmd.win_flag = Deserialize(is, is_idx, "number")

		OnCommand_BroadcastPvpVideo_Re(player, role, cmd, others)
	elseif cmd.__type__ == 190 then
		--ChangeHeroSelectSkill_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.skill_id = {}
		for i = 1, count do
			is_idx, cmd.skill_id[i] = Deserialize(is, is_idx, "number")
		end

		OnCommand_ChangeHeroSelectSkill_Re(player, role, cmd, others)
	elseif cmd.__type__ == 191 then
		--UpdatePvpInfo
		is_idx, cmd.join_count = Deserialize(is, is_idx, "number")
		is_idx, cmd.win_count = Deserialize(is, is_idx, "number")

		OnCommand_UpdatePvpInfo(player, role, cmd, others)
	elseif cmd.__type__ == 192 then
		--UpdateRep
		is_idx, cmd.rep_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.rep_num = Deserialize(is, is_idx, "number")

		OnCommand_UpdateRep(player, role, cmd, others)
	elseif cmd.__type__ == 194 then
		--MallBuyItem_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.item = {}
		for i = 1, count do
			is_idx, cmd.item[i] = DeserializeStruct(is, is_idx, "Item")
		end

		OnCommand_MallBuyItem_Re(player, role, cmd, others)
	elseif cmd.__type__ == 195 then
		--UpdatePvpStar
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.star = Deserialize(is, is_idx, "number")

		OnCommand_UpdatePvpStar(player, role, cmd, others)
	elseif cmd.__type__ == 197 then
		--UpdateHeroSoul
		is_idx, cmd.soul_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.soul_num = Deserialize(is, is_idx, "number")

		OnCommand_UpdateHeroSoul(player, role, cmd, others)
	elseif cmd.__type__ == 199 then
		--LevelUpHeroStar_Re
		is_idx, cmd.hero_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_LevelUpHeroStar_Re(player, role, cmd, others)
	elseif cmd.__type__ == 200 then
		--ClearHeroPvpInfo

		OnCommand_ClearHeroPvpInfo(player, role, cmd, others)
	elseif cmd.__type__ == 201 then
		--UpdateMysteryShopInfo
		is_idx, cmd.shop_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.refresh_time = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.shop_item = {}
		for i = 1, count do
			is_idx, cmd.shop_item[i] = DeserializeStruct(is, is_idx, "MysteryShopItem")
		end

		OnCommand_UpdateMysteryShopInfo(player, role, cmd, others)
	elseif cmd.__type__ == 203 then
		--MysteryShopBuyItem_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.shop_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.position = Deserialize(is, is_idx, "number")
		is_idx, cmd.item_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.buy_count = Deserialize(is, is_idx, "number")

		OnCommand_MysteryShopBuyItem_Re(player, role, cmd, others)
	elseif cmd.__type__ == 205 then
		--RefreshMysteryShop_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.shop_id = Deserialize(is, is_idx, "number")

		OnCommand_RefreshMysteryShop_Re(player, role, cmd, others)
	elseif cmd.__type__ == 207 then
		--ResetBattleField_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.battle_info = DeserializeStruct(is, is_idx, "BattleInfo")

		OnCommand_ResetBattleField_Re(player, role, cmd, others)
	elseif cmd.__type__ == 209 then
		--BattleFieldBegin_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")

		OnCommand_BattleFieldBegin_Re(player, role, cmd, others)
	elseif cmd.__type__ == 211 then
		--BattleFieldMove_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.src_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.src_position = Deserialize(is, is_idx, "number")
		is_idx, cmd.dst_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.dst_position = Deserialize(is, is_idx, "number")

		OnCommand_BattleFieldMove_Re(player, role, cmd, others)
	elseif cmd.__type__ == 213 then
		--BattleFieldJoinBattle_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.npc_id = Deserialize(is, is_idx, "number")

		OnCommand_BattleFieldJoinBattle_Re(player, role, cmd, others)
	elseif cmd.__type__ == 215 then
		--BattleFieldFinishBattle_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.win_flag = Deserialize(is, is_idx, "number")
		is_idx, cmd.fail_flag = Deserialize(is, is_idx, "number")
		is_idx, cmd.npc_id = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.heros = {}
		for i = 1, count do
			is_idx, cmd.heros[i] = DeserializeStruct(is, is_idx, "BattleHeroInfo")
		end
		is_idx, cmd.rewards = DeserializeStruct(is, is_idx, "SweepInstanceData")

		OnCommand_BattleFieldFinishBattle_Re(player, role, cmd, others)
	elseif cmd.__type__ == 216 then
		--BattleFieldEnd
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.win_flag = Deserialize(is, is_idx, "number")
		is_idx, cmd.rewards = DeserializeStruct(is, is_idx, "SweepInstanceData")

		OnCommand_BattleFieldEnd(player, role, cmd, others)
	elseif cmd.__type__ == 218 then
		--BattleFieldGetPrize_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.rewards = DeserializeStruct(is, is_idx, "SweepInstanceData")

		OnCommand_BattleFieldGetPrize_Re(player, role, cmd, others)
	elseif cmd.__type__ == 220 then
		--SetInstanceHeroInfo_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.heros = {}
		for i = 1, count do
			is_idx, cmd.heros[i] = Deserialize(is, is_idx, "number")
		end
		is_idx, cmd.horse = Deserialize(is, is_idx, "number")

		OnCommand_SetInstanceHeroInfo_Re(player, role, cmd, others)
	elseif cmd.__type__ == 222 then
		--Lottery_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.lottery_id = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.reward_ids = {}
		for i = 1, count do
			is_idx, cmd.reward_ids[i] = DeserializeStruct(is, is_idx, "LotteryRewardInfo")
		end

		OnCommand_Lottery_Re(player, role, cmd, others)
	elseif cmd.__type__ == 224 then
		--GetBattleFieldInfo_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.battle_info = DeserializeStruct(is, is_idx, "BattleInfo")

		OnCommand_GetBattleFieldInfo_Re(player, role, cmd, others)
	elseif cmd.__type__ == 225 then
		--ChangeBattleState
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.state = Deserialize(is, is_idx, "number")

		OnCommand_ChangeBattleState(player, role, cmd, others)
	elseif cmd.__type__ == 227 then
		--BattleFieldCancel_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.position = Deserialize(is, is_idx, "number")

		OnCommand_BattleFieldCancel_Re(player, role, cmd, others)
	elseif cmd.__type__ == 229 then
		--BattleFieldGetEvent_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.event = {}
		for i = 1, count do
			is_idx, cmd.event[i] = Deserialize(is, is_idx, "number")
		end
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.event_info = {}
		for i = 1, count do
			is_idx, cmd.event_info[i] = DeserializeStruct(is, is_idx, "BattleEventInfo")
		end

		OnCommand_BattleFieldGetEvent_Re(player, role, cmd, others)
	elseif cmd.__type__ == 230 then
		--BattleFieldCapturedPosition
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.position_info = DeserializeStruct(is, is_idx, "BattlePositionInfo")
		is_idx, cmd.event = Deserialize(is, is_idx, "number")
		is_idx, cmd.event_info = DeserializeStruct(is, is_idx, "BattleEventInfo")

		OnCommand_BattleFieldCapturedPosition(player, role, cmd, others)
	elseif cmd.__type__ == 232 then
		--GetCurBattleField_Re
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.state = Deserialize(is, is_idx, "number")

		OnCommand_GetCurBattleField_Re(player, role, cmd, others)
	elseif cmd.__type__ == 234 then
		--BattleFieldFinishEvent_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.join_battle_flag = Deserialize(is, is_idx, "number")
		is_idx, cmd.event = Deserialize(is, is_idx, "number")

		OnCommand_BattleFieldFinishEvent_Re(player, role, cmd, others)
	elseif cmd.__type__ == 236 then
		--GiveUpCurBattleField_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_GiveUpCurBattleField_Re(player, role, cmd, others)
	elseif cmd.__type__ == 238 then
		--GetRefreshTime_Re
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.last_refreshtime = Deserialize(is, is_idx, "number")

		OnCommand_GetRefreshTime_Re(player, role, cmd, others)
	elseif cmd.__type__ == 240 then
		--DailySign_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.item = DeserializeStruct(is, is_idx, "Item")

		OnCommand_DailySign_Re(player, role, cmd, others)
	elseif cmd.__type__ == 242 then
		--GetMyPveArenaInfo_Re
		is_idx, cmd.score = Deserialize(is, is_idx, "number")
		is_idx, cmd.rank = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.defence_hero = {}
		for i = 1, count do
			is_idx, cmd.defence_hero[i] = Deserialize(is, is_idx, "number")
		end
		is_idx, cmd.last_attack_time = Deserialize(is, is_idx, "number")

		OnCommand_GetMyPveArenaInfo_Re(player, role, cmd, others)
	elseif cmd.__type__ == 244 then
		--GetOtherPveArenaInfo_Re
		is_idx, cmd.info = DeserializeStruct(is, is_idx, "PveArenaFighterInfo")

		OnCommand_GetOtherPveArenaInfo_Re(player, role, cmd, others)
	elseif cmd.__type__ == 246 then
		--GetFighterInfo_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.fightinfo = {}
		for i = 1, count do
			is_idx, cmd.fightinfo[i] = DeserializeStruct(is, is_idx, "PveArenaFighterInfo")
		end

		OnCommand_GetFighterInfo_Re(player, role, cmd, others)
	elseif cmd.__type__ == 248 then
		--PveArenaJoinBattle_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.last_attack_time = Deserialize(is, is_idx, "number")
		is_idx, cmd.self_info = DeserializeStruct(is, is_idx, "RolePveArenaInfo")
		is_idx, cmd.role_info = DeserializeStruct(is, is_idx, "PveArenaFighterInfo")

		OnCommand_PveArenaJoinBattle_Re(player, role, cmd, others)
	elseif cmd.__type__ == 250 then
		--PveArenaEndBattle_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.score_change = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.item = {}
		for i = 1, count do
			is_idx, cmd.item[i] = DeserializeStruct(is, is_idx, "Item")
		end

		OnCommand_PveArenaEndBattle_Re(player, role, cmd, others)
	elseif cmd.__type__ == 252 then
		--PveArenaResetTime_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.last_time = Deserialize(is, is_idx, "number")

		OnCommand_PveArenaResetTime_Re(player, role, cmd, others)
	elseif cmd.__type__ == 254 then
		--PveArenaResetCount_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_PveArenaResetCount_Re(player, role, cmd, others)
	elseif cmd.__type__ == 256 then
		--ChallengeRoleByItem_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.self_info = DeserializeStruct(is, is_idx, "RolePveArenaInfo")
		is_idx, cmd.role_info = DeserializeStruct(is, is_idx, "PveArenaFighterInfo")

		OnCommand_ChallengeRoleByItem_Re(player, role, cmd, others)
	elseif cmd.__type__ == 258 then
		--GetPveArenaHistory_Re
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.hisroty_info = {}
		for i = 1, count do
			is_idx, cmd.hisroty_info[i] = DeserializeStruct(is, is_idx, "RolePveArenaHistoryInfo")
		end
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_GetPveArenaHistory_Re(player, role, cmd, others)
	elseif cmd.__type__ == 260 then
		--GetPveArenaOperation_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.self_hero_info = DeserializeStruct(is, is_idx, "RolePveArenaInfo")
		is_idx, cmd.oppo_hero_info = DeserializeStruct(is, is_idx, "RolePveArenaInfo")
		is_idx, cmd.operation = DeserializeStruct(is, is_idx, "PveArenaOperation")
		is_idx, cmd.exe_ver = Deserialize(is, is_idx, "string")
		is_idx, cmd.data_ver = Deserialize(is, is_idx, "string")

		OnCommand_GetPveArenaOperation_Re(player, role, cmd, others)
	elseif cmd.__type__ == 262 then
		--SetPveArenaHero_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_SetPveArenaHero_Re(player, role, cmd, others)
	elseif cmd.__type__ == 264 then
		--ResetSkilllevel_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_ResetSkilllevel_Re(player, role, cmd, others)
	elseif cmd.__type__ == 266 then
		--WeaponEquip_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_WeaponEquip_Re(player, role, cmd, others)
	elseif cmd.__type__ == 268 then
		--WeaponLevelUp_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.hero = Deserialize(is, is_idx, "number")
		is_idx, cmd.weapon_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.crit_flag = Deserialize(is, is_idx, "number")
		is_idx, cmd.skill_id = Deserialize(is, is_idx, "number")

		OnCommand_WeaponLevelUp_Re(player, role, cmd, others)
	elseif cmd.__type__ == 270 then
		--WeaponStrength_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.hero = Deserialize(is, is_idx, "number")
		is_idx, cmd.weapon_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.crit_flag = Deserialize(is, is_idx, "number")

		OnCommand_WeaponStrength_Re(player, role, cmd, others)
	elseif cmd.__type__ == 272 then
		--WeaponDecompose_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.money = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.item_info = {}
		for i = 1, count do
			is_idx, cmd.item_info[i] = DeserializeStruct(is, is_idx, "Item")
		end

		OnCommand_WeaponDecompose_Re(player, role, cmd, others)
	elseif cmd.__type__ == 274 then
		--WeaponUnequip_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_WeaponUnequip_Re(player, role, cmd, others)
	elseif cmd.__type__ == 275 then
		--WeaponAdd
		is_idx, cmd.weapon_info = DeserializeStruct(is, is_idx, "WeaponItem")

		OnCommand_WeaponAdd(player, role, cmd, others)
	elseif cmd.__type__ == 276 then
		--WeaponDel
		is_idx, cmd.id = Deserialize(is, is_idx, "number")

		OnCommand_WeaponDel(player, role, cmd, others)
	elseif cmd.__type__ == 277 then
		--WeaponUpdate
		is_idx, cmd.weapon_info = DeserializeStruct(is, is_idx, "WeaponItem")

		OnCommand_WeaponUpdate(player, role, cmd, others)
	elseif cmd.__type__ == 278 then
		--LotteryUpdate
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.flag = Deserialize(is, is_idx, "number")

		OnCommand_LotteryUpdate(player, role, cmd, others)
	elseif cmd.__type__ == 280 then
		--WuZheShiLianGetDifficultyInfo_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.cur_difficulty = Deserialize(is, is_idx, "number")
		is_idx, cmd.high_difficulty = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.difficulty_info = {}
		for i = 1, count do
			is_idx, cmd.difficulty_info[i] = DeserializeStruct(is, is_idx, "DifficultyInfo")
		end

		OnCommand_WuZheShiLianGetDifficultyInfo_Re(player, role, cmd, others)
	elseif cmd.__type__ == 282 then
		--WuZheShiLianSelectDifficulty_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.cur_diffculty = Deserialize(is, is_idx, "number")

		OnCommand_WuZheShiLianSelectDifficulty_Re(player, role, cmd, others)
	elseif cmd.__type__ == 284 then
		--WuZheShiLianGetOpponentInfo_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.opponent_info = {}
		for i = 1, count do
			is_idx, cmd.opponent_info[i] = DeserializeStruct(is, is_idx, "OpponentInfo")
		end

		OnCommand_WuZheShiLianGetOpponentInfo_Re(player, role, cmd, others)
	elseif cmd.__type__ == 286 then
		--WuZheShiLianGetHeroInfo_Re
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.dead_hero = {}
		for i = 1, count do
			is_idx, cmd.dead_hero[i] = Deserialize(is, is_idx, "number")
		end
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.injured_hero = {}
		for i = 1, count do
			is_idx, cmd.injured_hero[i] = DeserializeStruct(is, is_idx, "InjuredHeroInfo")
		end

		OnCommand_WuZheShiLianGetHeroInfo_Re(player, role, cmd, others)
	elseif cmd.__type__ == 288 then
		--WuZheShiLianJoinBattle_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_WuZheShiLianJoinBattle_Re(player, role, cmd, others)
	elseif cmd.__type__ == 290 then
		--WuZheShiLianFinishBattle_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.money = Deserialize(is, is_idx, "number")

		OnCommand_WuZheShiLianFinishBattle_Re(player, role, cmd, others)
	elseif cmd.__type__ == 292 then
		--WuZheShiLianReset_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_WuZheShiLianReset_Re(player, role, cmd, others)
	elseif cmd.__type__ == 293 then
		--PveArenaUpdateVideoFlag
		is_idx, cmd.video_flag = Deserialize(is, is_idx, "number")

		OnCommand_PveArenaUpdateVideoFlag(player, role, cmd, others)
	elseif cmd.__type__ == 295 then
		--WuZheShiLianGetReward_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")
		is_idx, cmd.stage = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.rewards = {}
		for i = 1, count do
			is_idx, cmd.rewards[i] = DeserializeStruct(is, is_idx, "Item")
		end

		OnCommand_WuZheShiLianGetReward_Re(player, role, cmd, others)
	elseif cmd.__type__ == 297 then
		--WuZheShiLianSweep_Re
		is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_WuZheShiLianSweep_Re(player, role, cmd, others)
	elseif cmd.__type__ == 10115 then
		--MafiaDestory_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_MafiaDestory_Re(player, role, cmd, others)
	elseif cmd.__type__ == 302 then
		--EquipmentEquip_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.hero = Deserialize(is, is_idx, "number")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.equipment_id = Deserialize(is, is_idx, "number")

		OnCommand_EquipmentEquip_Re(player, role, cmd, others)
	elseif cmd.__type__ == 304 then
		--EquipmentLevelUp_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.hero = Deserialize(is, is_idx, "number")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.equipment_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.crit_flag = Deserialize(is, is_idx, "number")

		OnCommand_EquipmentLevelUp_Re(player, role, cmd, others)
	elseif cmd.__type__ == 306 then
		--EquipmentGradeUp_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.hero = Deserialize(is, is_idx, "number")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.equipment_id = Deserialize(is, is_idx, "number")

		OnCommand_EquipmentGradeUp_Re(player, role, cmd, others)
	elseif cmd.__type__ == 308 then
		--EquipmentRefinable_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.hero = Deserialize(is, is_idx, "number")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.equipment_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.refinable_typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.refinable_count = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.tmp_refinable_pro = {}
		for i = 1, count do
			is_idx, cmd.tmp_refinable_pro[i] = DeserializeStruct(is, is_idx, "RefinableData")
		end

		OnCommand_EquipmentRefinable_Re(player, role, cmd, others)
	elseif cmd.__type__ == 310 then
		--EquipmentDecompose_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.money = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.item_info = {}
		for i = 1, count do
			is_idx, cmd.item_info[i] = DeserializeStruct(is, is_idx, "Item")
		end

		OnCommand_EquipmentDecompose_Re(player, role, cmd, others)
	elseif cmd.__type__ == 312 then
		--EquipmentUnequip_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.hero = Deserialize(is, is_idx, "number")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")

		OnCommand_EquipmentUnequip_Re(player, role, cmd, others)
	elseif cmd.__type__ == 313 then
		--EquipmentAdd
		is_idx, cmd.equipment_info = DeserializeStruct(is, is_idx, "EquipmentItem")

		OnCommand_EquipmentAdd(player, role, cmd, others)
	elseif cmd.__type__ == 314 then
		--EquipmentDel
		is_idx, cmd.id = Deserialize(is, is_idx, "number")

		OnCommand_EquipmentDel(player, role, cmd, others)
	elseif cmd.__type__ == 315 then
		--EquipmentUpdate
		is_idx, cmd.equipment_info = DeserializeStruct(is, is_idx, "EquipmentItem")

		OnCommand_EquipmentUpdate(player, role, cmd, others)
	elseif cmd.__type__ == 317 then
		--EquipmentRefinableSave_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.hero = Deserialize(is, is_idx, "number")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")
		is_idx, cmd.equipment_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.save_flag = Deserialize(is, is_idx, "number")

		OnCommand_EquipmentRefinableSave_Re(player, role, cmd, others)
	elseif cmd.__type__ == 10013 then
		--NewFriend
		is_idx, cmd.friend = DeserializeStruct(is, is_idx, "Friend")

		OnCommand_NewFriend(player, role, cmd, others)
	elseif cmd.__type__ == 10102 then
		--MafiaGet_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.mafia = DeserializeStruct(is, is_idx, "Mafia")

		OnCommand_MafiaGet_Re(player, role, cmd, others)
	elseif cmd.__type__ == 10012 then
		--FriendReply_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.src_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.accept = Deserialize(is, is_idx, "boolean")

		OnCommand_FriendReply_Re(player, role, cmd, others)
	elseif cmd.__type__ == 10104 then
		--MafiaCreate_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.mafia = DeserializeStruct(is, is_idx, "Mafia")

		OnCommand_MafiaCreate_Re(player, role, cmd, others)
	elseif cmd.__type__ == 352 then
		--TongQueTaiSetHeroInfo_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.hero = {}
		for i = 1, count do
			is_idx, cmd.hero[i] = Deserialize(is, is_idx, "number")
		end

		OnCommand_TongQueTaiSetHeroInfo_Re(player, role, cmd, others)
	elseif cmd.__type__ == 354 then
		--TongQueTaiBeginMatch_Re
		is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")
		is_idx, cmd.double_flag = Deserialize(is, is_idx, "number")
		is_idx, cmd.auto_flag = Deserialize(is, is_idx, "number")
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_TongQueTaiBeginMatch_Re(player, role, cmd, others)
	elseif cmd.__type__ == 356 then
		--TongQueTaiCancleMatch_Re
		is_idx, cmd.difficulty = Deserialize(is, is_idx, "number")
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_TongQueTaiCancleMatch_Re(player, role, cmd, others)
	elseif cmd.__type__ == 357 then
		--TongQueTaiMatchSuccess
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.join_index = Deserialize(is, is_idx, "number")
		is_idx, cmd.monster_index = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.player_info = {}
		for i = 1, count do
			is_idx, cmd.player_info[i] = DeserializeStruct(is, is_idx, "TongQueTaiPlayerInfo")
		end
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.monster_info = {}
		for i = 1, count do
			is_idx, cmd.monster_info[i] = DeserializeStruct(is, is_idx, "TongQueTaiMonsterInfo")
		end

		OnCommand_TongQueTaiMatchSuccess(player, role, cmd, others)
	elseif cmd.__type__ == 358 then
		--TongQueTaiNoticeRoleJoin

		OnCommand_TongQueTaiNoticeRoleJoin(player, role, cmd, others)
	elseif cmd.__type__ == 360 then
		--TongQueTaiJoin_Re
		is_idx, cmd.role_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_TongQueTaiJoin_Re(player, role, cmd, others)
	elseif cmd.__type__ == 362 then
		--TongQueTaiOperation_Re
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.operation = {}
		for i = 1, count do
			is_idx, cmd.operation[i] = DeserializeStruct(is, is_idx, "TongQueTaiOperation")
		end

		OnCommand_TongQueTaiOperation_Re(player, role, cmd, others)
	elseif cmd.__type__ == 364 then
		--TongQueTaiFinish_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.win_flag = Deserialize(is, is_idx, "number")
		is_idx, cmd.monster_index = Deserialize(is, is_idx, "number")
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

		OnCommand_TongQueTaiFinish_Re(player, role, cmd, others)
	elseif cmd.__type__ == 365 then
		--TongQueTaiReward

		OnCommand_TongQueTaiReward(player, role, cmd, others)
	elseif cmd.__type__ == 367 then
		--TongQueTaiSpeed_Re
		is_idx, cmd.role_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.speed = Deserialize(is, is_idx, "number")

		OnCommand_TongQueTaiSpeed_Re(player, role, cmd, others)
	elseif cmd.__type__ == 369 then
		--TongQueTaiLoad_Re
		is_idx, cmd.role_id = Deserialize(is, is_idx, "string")

		OnCommand_TongQueTaiLoad_Re(player, role, cmd, others)
	elseif cmd.__type__ == 370 then
		--TongQueTaiReLoad
		is_idx, cmd.role_index = Deserialize(is, is_idx, "number")
		is_idx, cmd.monster_index = Deserialize(is, is_idx, "number")
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_TongQueTaiReLoad(player, role, cmd, others)
	elseif cmd.__type__ == 371 then
		--TongQueTaiEnd
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_TongQueTaiEnd(player, role, cmd, others)
	elseif cmd.__type__ == 373 then
		--TongQueTaiGetReward_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.double_flag = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.reward = {}
		for i = 1, count do
			is_idx, cmd.reward[i] = DeserializeStruct(is, is_idx, "Item")
		end

		OnCommand_TongQueTaiGetReward_Re(player, role, cmd, others)
	elseif cmd.__type__ == 375 then
		--TongQueTaiGetInfo_Re
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.hero = {}
		for i = 1, count do
			is_idx, cmd.hero[i] = Deserialize(is, is_idx, "number")
		end
		is_idx, cmd.reward_flag = Deserialize(is, is_idx, "number")

		OnCommand_TongQueTaiGetInfo_Re(player, role, cmd, others)
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
	elseif cmd.__type__ == 10105 then
		--MafiaInvite
		is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")
		is_idx, cmd.src = DeserializeStruct(is, is_idx, "RoleBrief")

		OnCommand_MafiaInvite(player, role, cmd, others)
	elseif cmd.__type__ == 10107 then
		--MafiaAddMember
		is_idx, cmd.member = DeserializeStruct(is, is_idx, "RoleBrief")

		OnCommand_MafiaAddMember(player, role, cmd, others)
	elseif cmd.__type__ == 10108 then
		--MafiaUpdate
		is_idx, cmd.mafia = DeserializeStruct(is, is_idx, "Mafia")

		OnCommand_MafiaUpdate(player, role, cmd, others)
	elseif cmd.__type__ == 10110 then
		--MafiaKickout_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.dest_id = Deserialize(is, is_idx, "string")

		OnCommand_MafiaKickout_Re(player, role, cmd, others)
	elseif cmd.__type__ == 10111 then
		--MafiaLoseMember
		is_idx, cmd.member = DeserializeStruct(is, is_idx, "RoleBrief")

		OnCommand_MafiaLoseMember(player, role, cmd, others)
	elseif cmd.__type__ == 10113 then
		--MafiaQuit_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")

		OnCommand_MafiaQuit_Re(player, role, cmd, others)
	elseif cmd.__type__ == 10016 then
		--FriendDelRequest
		is_idx, cmd.role_id = Deserialize(is, is_idx, "string")

		OnCommand_FriendDelRequest(player, role, cmd, others)
	elseif cmd.__type__ == 10117 then
		--MafiaAnnounce_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.announce = Deserialize(is, is_idx, "string")

		OnCommand_MafiaAnnounce_Re(player, role, cmd, others)
	elseif cmd.__type__ == 1000002 then
		--GetRoleInfo_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.info = DeserializeStruct(is, is_idx, "RoleInfo")

		OnCommand_GetRoleInfo_Re(player, role, cmd, others)
	elseif cmd.__type__ == 402 then
		--BattleFieldGetRoundStateInfo_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.round_state = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.event_info = {}
		for i = 1, count do
			is_idx, cmd.event_info[i] = DeserializeStruct(is, is_idx, "BattleEventInfo")
		end
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.npc_info = {}
		for i = 1, count do
			is_idx, cmd.npc_info[i] = DeserializeStruct(is, is_idx, "BattleFieldNpcMoveInfo")
		end

		OnCommand_BattleFieldGetRoundStateInfo_Re(player, role, cmd, others)
	elseif cmd.__type__ == 403 then
		--BattleFieldUpdateRoundState
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.round_num = Deserialize(is, is_idx, "number")
		is_idx, cmd.round_state = Deserialize(is, is_idx, "number")

		OnCommand_BattleFieldUpdateRoundState(player, role, cmd, others)
	elseif cmd.__type__ == 405 then
		--BattleFieldRoundCount_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.battle_id = Deserialize(is, is_idx, "number")

		OnCommand_BattleFieldRoundCount_Re(player, role, cmd, others)
	elseif cmd.__type__ == 10004 then
		--PublicChat
		is_idx, cmd.src = DeserializeStruct(is, is_idx, "RoleBrief")
		is_idx, cmd.text_content = Deserialize(is, is_idx, "string")
		is_idx, cmd.speech_content = Deserialize(is, is_idx, "string")
		is_idx, cmd.time = Deserialize(is, is_idx, "number")
		is_idx, cmd.typ = Deserialize(is, is_idx, "number")

		OnCommand_PublicChat(player, role, cmd, others)
	elseif cmd.__type__ == 1000004 then
		--CreateRole_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.info = DeserializeStruct(is, is_idx, "RoleInfo")

		OnCommand_CreateRole_Re(player, role, cmd, others)
	elseif cmd.__type__ == 10017 then
		--FriendUpdateInfo
		is_idx, cmd.friend_info = DeserializeStruct(is, is_idx, "Friend")

		OnCommand_FriendUpdateInfo(player, role, cmd, others)
	elseif cmd.__type__ == 422 then
		--BackPackUseItem_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.item_id = Deserialize(is, is_idx, "number")
		is_idx, cmd.item_num = Deserialize(is, is_idx, "number")
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.items = {}
		for i = 1, count do
			is_idx, cmd.items[i] = DeserializeStruct(is, is_idx, "Item")
		end

		OnCommand_BackPackUseItem_Re(player, role, cmd, others)
	elseif cmd.__type__ == 424 then
		--TemporaryBackPackGetInfo_Re
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.items = {}
		for i = 1, count do
			is_idx, cmd.items[i] = DeserializeStruct(is, is_idx, "TemporaryBackPackData")
		end

		OnCommand_TemporaryBackPackGetInfo_Re(player, role, cmd, others)
	elseif cmd.__type__ == 426 then
		--TemporaryBackPackReceiveItem_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.id = Deserialize(is, is_idx, "number")

		OnCommand_TemporaryBackPackReceiveItem_Re(player, role, cmd, others)
	elseif cmd.__type__ == 427 then
		--TemporaryBackPackUpdate
		is_idx, cmd.item = DeserializeStruct(is, is_idx, "TemporaryBackPackData")

		OnCommand_TemporaryBackPackUpdate(player, role, cmd, others)
	elseif cmd.__type__ == 10202 then
		--Ping_Re
		is_idx, cmd.client_send_time = Deserialize(is, is_idx, "number")

		OnCommand_Ping_Re(player, role, cmd, others)
	elseif cmd.__type__ == 10204 then
		--UDPPing_Re
		is_idx, cmd.client_send_time = Deserialize(is, is_idx, "number")

		OnCommand_UDPPing_Re(player, role, cmd, others)
	elseif cmd.__type__ == 613 then
		--MaShuEnd_Re
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
	elseif cmd.__type__ == 10007 then
		--ListFriends_Re
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.friends = {}
		for i = 1, count do
			is_idx, cmd.friends[i] = DeserializeStruct(is, is_idx, "Friend")
		end
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.requests = {}
		for i = 1, count do
			is_idx, cmd.requests[i] = DeserializeStruct(is, is_idx, "Friend")
		end
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.black_list = {}
		for i = 1, count do
			is_idx, cmd.black_list[i] = DeserializeStruct(is, is_idx, "RoleBase")
		end

		OnCommand_ListFriends_Re(player, role, cmd, others)
	elseif cmd.__type__ == 501 then
		--LegionGetInfo_Re
		is_idx, cmd.junxueguan_level = Deserialize(is, is_idx, "number")

		OnCommand_LegionGetInfo_Re(player, role, cmd, others)
	elseif cmd.__type__ == 503 then
		--LegionJunXueGuanGetInfo_Re
		is_idx, count = Deserialize(is, is_idx, "number");
		cmd.info = {}
		for i = 1, count do
			is_idx, cmd.info[i] = DeserializeStruct(is, is_idx, "LegionJunXueGuanData")
		end

		OnCommand_LegionJunXueGuanGetInfo_Re(player, role, cmd, others)
	elseif cmd.__type__ == 505 then
		--LegionJunXueZhuanJingLevelUp_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.id = Deserialize(is, is_idx, "number")
		is_idx, cmd.level = Deserialize(is, is_idx, "number")
		is_idx, cmd.xiangmu_open = Deserialize(is, is_idx, "number")
		is_idx, cmd.xiangmu_id = Deserialize(is, is_idx, "number")

		OnCommand_LegionJunXueZhuanJingLevelUp_Re(player, role, cmd, others)
	elseif cmd.__type__ == 507 then
		--LegionLearnJunXueXiangMu_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.id = Deserialize(is, is_idx, "number")
		is_idx, cmd.learn_id = Deserialize(is, is_idx, "number")

		OnCommand_LegionLearnJunXueXiangMu_Re(player, role, cmd, others)
	elseif cmd.__type__ == 508 then
		--LegionAddJunXueGuanInfo
		is_idx, cmd.info = DeserializeStruct(is, is_idx, "LegionJunXueGuanData")

		OnCommand_LegionAddJunXueGuanInfo(player, role, cmd, others)
	elseif cmd.__type__ == 509 then
		--LegionOpenJunXueGuan
		is_idx, cmd.level = Deserialize(is, is_idx, "number")

		OnCommand_LegionOpenJunXueGuan(player, role, cmd, others)
	elseif cmd.__type__ == 511 then
		--LegionActivationZhuanJing_Re
		is_idx, cmd.retcode = Deserialize(is, is_idx, "number")
		is_idx, cmd.id = Deserialize(is, is_idx, "number")
		is_idx, cmd.info = DeserializeStruct(is, is_idx, "LegionJunXueGuanData")

		OnCommand_LegionActivationZhuanJing_Re(player, role, cmd, others)

	end
end
