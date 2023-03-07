function OnCommand_BattleFieldFinishBattle(player, role, arg, others)
	player:Log("OnCommand_BattleFieldFinishBattle, "..DumpTable(arg).." "..DumpTable(others))

	if role._roledata._status._time_line ~= G_ROLE_STATE["BATTLEFIELD"] then
		return
	end

	local resp = NewCommand("BattleFieldFinishBattle_Re")

	resp.battle_id = arg.battle_id
	resp.win_flag = arg.win_flag
	resp.npc_id = arg.npc_id
	resp.heros = arg.heros
	resp.fail_flag = 0
	
	local battle = role._roledata._battle_info:Find(arg.battle_id)
	if battle == nil then
		return
	end
	local position = battle._position_info:Find(battle._cur_position)
	
	local id = 0
	local army_id = 0
	local npc_it = position._npc_info:SeekToBegin()
	local npc = npc_it:GetValue()
	while npc ~= nil do
		if npc._camp == 2 then
			id = npc._id
			army_id = npc._armyid
			break
		end
		npc_it:Next()
		npc = npc_it:GetValue()
	end

	local ed = DataPool_Find("elementdata")
	local battlearmy_info = ed:FindBy("battlearmy_id", army_id)
	--关卡类型（0普通，1马战）
	--1代表的成功，2代表的是失败，3代表的是放弃
	--查看操作和种子，准备做后面的验证
	--arg.operations
	--role._roledata._status._fight_seed
	role._roledata._status._time_line = G_ROLE_STATE["FREE"]
	
	if arg.win_flag == 1 then

		if role._roledata._status._vp >= battlearmy_info.end_tili then
			ROLE_Subvp(role, battlearmy_info.enter_tili)
		end
		
		local npc_it = position._npc_info:SeekToBegin()
		local npc = npc_it:GetValue()
		while npc ~= nil do
			if npc._camp == 2 then
				if npc._id == arg.npc_id then
					npc._alive = 0
					break
				end
			end
			npc_it:Next()
			npc = npc_it:GetValue()
		end
		
		for i = 1, table.getn(arg.heros) do
			local find_hero = battle._hero_info:Find(arg.heros[i].hero_id)
			if find_hero ~= nil then
				find_hero._hp = arg.heros[i].hp
			end
		end

		local Item = DROPITEM_DropItem(role, battlearmy_info.dropid)
		local Reward = DROPITEM_Reward(role, battlearmy_info.rewardmouldid)

		ROLE_AddReward(role, Reward)
	
		local instance_info = {}
		instance_info.exp = Reward.exp
		instance_info.heroexp = math.floor(Reward.heroexp/table.getn(arg.heros))
		instance_info.item = {}
		local item_count = table.getn(Item)
		for i = 1, item_count do
			local instance_item = {}
			local have_flag = 1
			for j = 1, #instance_info.item do
				if instance_info.item[j].id == Item[i].id then
					instance_info.item[j].count = instance_info.item[j].count + Item[i].count
					have_flag = 0
					break
				end
			end
			
			instance_item.id = Item[i].id
			instance_item.count = Item[i].count
			if have_flag == 1 then
				instance_info.item[#instance_info.item+1] = instance_item
			end
			BACKPACK_AddItem(role, instance_item.id, instance_item.count)
		end
	
		item_count = table.getn(Reward.item)
		for i = 1, item_count do
			local instance_item = {}
			local have_flag = 1
			for j = 1, #instance_info.item do
				if instance_info.item[j].id == Reward.item[i].itemid then
					instance_info.item[j].count = instance_info.item[j].count + Reward.item[i].itemnum
					have_flag = 0
					break
				end
			end
			instance_item.id = Reward.item[i].itemid
			instance_item.count = Reward.item[i].itemnum
			if have_flag == 1 then
				instance_info.item[#instance_info.item+1] = instance_item
			end
		end
		--给所有的武将加经验
		for i = 1, table.getn(arg.heros) do
			HERO_AddExp(role, arg.heros[i].hero_id, math.floor(Reward.heroexp/table.getn(arg.heros)))
		end
		
		resp.rewards = instance_info
		
		resp.retcode = G_ERRCODE["SUCCESS"]
		player:SendToClient(SerializeCommand(resp))

		--这里需要判断这个地点是不是所有的怪都被打死了。如果不是的话，那么就让客户端那边接着打
		local success_capture_flag = true
		local npc_it = position._npc_info:SeekToBegin()
		local npc = npc_it:GetValue()
		while npc ~= nil do
			if npc._camp == 2 then
				if npc._alive == 1 then
					success_capture_flag = false
					break
				end
			end
			npc_it:Next()
			npc = npc_it:GetValue()
		end

		local battle_info = ed:FindBy("battle_id", arg.battle_id)
		local battlefielddata_info = ed:FindBy("battlefielddata_id", battle_info.battlefieldid)
		if battlefielddata_info.battle_target_type == 1 then
			local npc_it = position._npc_info:SeekToBegin()
			local npc = npc_it:GetValue()
			while npc ~= nil do
				if npc._armyid == battlefielddata_info.enemy_leader_id and npc._alive == 0 then
					battle._state = 2
		
					resp = NewCommand("ChangeBattleState")
					resp.battle_id = arg.battle_id
					resp.state = battle._state
					player:SendToClient(SerializeCommand(resp))
					local insert_data = CACHE.Int()
					insert_data._value = arg.battle_id
					role._roledata._have_finish_battle:Insert(arg.battle_id, insert_data)
					ROLE_FinishFieldBattle(role, arg.battle_id, 1)
					break
				end
				npc_it:Next()
				npc = npc_it:GetValue()
			end
		end
		
		if success_capture_flag == true then
			position._flag = 1
			--这个协议用来表示这次移动结束的
			local ed = DataPool_Find("elementdata")
			local battle_info = ed:FindBy("battle_id", arg.battle_id)
			local battlefielddata_info = ed:FindBy("battlefielddata_id", battle_info.battlefieldid)

			local cur_event_id = 0
			if position._event_flag == 0 then
				for slot in DataPool_Array(battlefielddata_info.init_slots) do
					if slot.pos == battle._cur_position then
						cur_event_id = slot.eventid
						break
					end
				end
			end
			position._event_flag = 1
			
			local resp = NewCommand("BattleFieldCapturedPosition")
			resp.battle_id = arg.battle_id
			resp.position_info = ROLE_MakeBattleCurPositionInfo(role, arg.battle_id)
			if cur_event_id ~= 0 then
				resp.event_info = ROLE_GetBattleEventInfo(role, arg.battle_id, cur_event_id)
			end
			resp.event = cur_event_id
			player:SendToClient(SerializeCommand(resp))

			if battlefielddata_info.battle_target_type == 0 then
				if battlefielddata_info.enemy_camp_pos == battle._cur_position then
					battle._state = 2
			
					resp = NewCommand("ChangeBattleState")
					resp.battle_id = arg.battle_id
					resp.state = battle._state
					player:SendToClient(SerializeCommand(resp))
					local insert_data = CACHE.Int()
					insert_data._value = arg.battle_id
					role._roledata._have_finish_battle:Insert(arg.battle_id, insert_data)
					ROLE_FinishFieldBattle(role, arg.battle_id, 1)
				end
			end
		
			battle._round_state = 3
			resp = NewCommand("BattleFieldUpdateRoundState")
			resp.battle_id = arg.battle_id
			resp.round_num = battle._round_num
			resp.round_state = battle._round_state
			player:SendToClient(SerializeCommand(resp))
			return
		end

	elseif arg.win_flag == 2 then
		--在这里不仅要回到上一个位置，而且还要告诉他这次战役已经失败了。
		if battlearmy_info.stagetype == 0 then
			local cur_hero_it = battle._cur_hero_info:SeekToBegin()
			local cur_hero = cur_hero_it:GetValue()
			while cur_hero ~= nil do
				local find_hero = battle._hero_info:Find(cur_hero._value)
				if find_hero ~= nil then
					find_hero._hp = 0
				end
				cur_hero_it:Next()
				cur_hero = cur_hero_it:GetValue()
			end
		else
			local cur_hero_it = battle._cur_hero_horse_info._heroinfo:SeekToBegin()
			local cur_hero = cur_hero_it:GetValue()
			while cur_hero ~= nil do
				local find_hero = battle._hero_info:Find(cur_hero._value)
				if find_hero ~= nil then
					find_hero._hp = 0
				end
				cur_hero_it:Next()
				cur_hero = cur_hero_it:GetValue()
			end
		end

		--判断是否是所有的人都死了，是的话就直接让这次战役失败吧
		local hero_info_it = battle._hero_info:SeekToBegin()
		local hero_info = hero_info_it:GetValue()
		local fail_flag = 1
		while hero_info ~= nil do
			if hero_info._hp ~= 0 then
				fail_flag = 0
				break
			end
			hero_info_it:Next()
			hero_info = hero_info_it:GetValue()
		end

		resp.fail_flag = fail_flag
		player:SendToClient(SerializeCommand(resp))
	
		if fail_flag == 1 then
			battle._state = 3
			local resp = NewCommand("ChangeBattleState")
			resp.battle_id = arg.battle_id
			resp.state = battle._state
			player:SendToClient(SerializeCommand(resp))
		end

		local resp = NewCommand("BattleFieldCancel_Re")
		resp.battle_id = arg.battle_id
		battle._cur_position = battle._last_position
		resp.retcode = G_ERRCODE["SUCCESS"]
		resp.position = battle._cur_position
		player:SendToClient(SerializeCommand(resp))
			
		battle._round_state = 3
		resp = NewCommand("BattleFieldUpdateRoundState")
		resp.battle_id = arg.battle_id
		resp.round_num = battle._round_num
		resp.round_state = battle._round_state
		player:SendToClient(SerializeCommand(resp))
	elseif arg.win_flag == 3 then
		
		resp.retcode = G_ERRCODE["SUCCESS"]
		player:SendToClient(SerializeCommand(resp))
		
		--放弃,什么都不改变，直接让他退回到上一次的位置
		resp = NewCommand("BattleFieldCancel_Re")
		resp.battle_id = arg.battle_id
		battle._cur_position = battle._last_position
		resp.retcode = G_ERRCODE["SUCCESS"]
		resp.position = battle._cur_position
		player:SendToClient(SerializeCommand(resp))
		
		battle._round_state = 3
		resp = NewCommand("BattleFieldUpdateRoundState")
		resp.battle_id = arg.battle_id
		resp.round_num = battle._round_num
		resp.round_state = battle._round_state
		player:SendToClient(SerializeCommand(resp))
		return
	end
end
