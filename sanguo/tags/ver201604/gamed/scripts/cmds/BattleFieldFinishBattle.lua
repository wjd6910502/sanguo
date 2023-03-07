function OnCommand_BattleFieldFinishBattle(player, role, arg, others)
	player:Log("OnCommand_BattleFieldFinishBattle, "..DumpTable(arg).." "..DumpTable(others))

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

	--if id == 0 or id ~= arg.npc_id then
	--	resp.retcode = G_ERRCODE["SYSTEM_INVALID"]
	--	player:SendToClient(SerializeCommand(resp))

	--	battle._cur_position = battle._last_position
	--	resp = NewCommand("BattleFieldCancel_Re")
	--	resp.battle_id = arg.battle_id
	--	resp.retcode = G_ERRCODE["SUCCESS"]
	--	resp.position = battle._cur_position
	--	player:SendToClient(SerializeCommand(resp))
	--	return
	--end

	local ed = DataPool_Find("elementdata")
	local battlearmy_info = ed:FindBy("battlearmy_id", army_id)
	--关卡类型（0普通，1马战）
	--1代表的成功，2代表的是失败，3代表的是放弃
	if arg.win_flag == 1 then

		if role._roledata._status._vp >= battlearmy_info.end_tili then
			ROLE_Subvp(role, battlearmy_info.enter_tili)
		end
		position._flag = 1
		position._event_flag = 1
		
		local npc_it = position._npc_info:SeekToBegin()
		local npc = npc_it:GetValue()
		while npc ~= nil do
			if npc._camp == 2 then
				npc._alive = 0
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

		--这个协议用来表示这次移动结束的
		local resp = NewCommand("BattleFieldCapturedPosition")
		resp.battle_id = arg.battle_id
		resp.position_info = ROLE_MakeBattleCurPositionInfo(role, arg.battle_id)
		resp.event = 0
		player:SendToClient(SerializeCommand(resp))

		local battle_info = ed:FindBy("battle_id", arg.battle_id)
		local battlefielddata_info = ed:FindBy("battlefielddata_id", battle_info.battlefieldid)
		if battlefielddata_info.battle_target_type == 1 then
			local npc_it = position._npc_info:SeekToBegin()
			local npc = npc_it:GetValue()
			while npc ~= nil do
				if npc._armyid == battlefielddata_info.enemy_leader_id then
					battle._state = 2
		
					resp = NewCommand("ChangeBattleState")
					resp.battle_id = arg.battle_id
					resp.state = battle._state
					player:SendToClient(SerializeCommand(resp))
					break
				end
				npc_it:Next()
				npc = npc_it:GetValue()
			end
		end
		return

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
		return
	end
end
