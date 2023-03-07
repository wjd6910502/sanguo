function OnCommand_TowerGetLayerInfo(player, role, arg, others)
	player:Log("OnCommand_TowerGetLayerInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("TowerGetLayerInfo_Re")
	if arg.layer ~= role._roledata._tower_data._cur_layer then
		resp.retcode = G_ERRCODE["TOWER_ERROR_ARG"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_TowerGetLayerInfo, error=TOWER_ERROR_ARG")
		return
	end

	resp.layer = role._roledata._tower_data._cur_layer

	if role._roledata._tower_data._history_layer > 0 then
		local ed = DataPool_Find("elementdata")
		local layer = role._roledata._tower_data._history_layer
		if role._roledata._tower_data._difficulty == 2 then
			layer = layer + 100
		end
		local towerstage = ed:FindBy("tower_stage", layer)
		if towerstage ~= nil then
			resp.sweep_layer = towerstage.can_skipped_level
		end
	end

	local ed = DataPool_Find("elementdata")
	local layer = resp.layer
	if role._roledata._tower_data._difficulty == 2 then
		layer = layer + 100
	end
	local towerstage = ed:FindBy("tower_stage", layer)
	if towerstage == nil then
		resp.retcode = G_ERRCODE["TOWER_ERROR_DATA"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_TowerGetLayerInfo, error=TOWER_ERROR_DATA")
		return
	end
	
	if towerstage.stage_category == 1 then
		local army_info = role._roledata._tower_data._cur_army_info
		if army_info:Size() == 0 then
			local dif = 0
			for enemy in DataPool_Array(towerstage.enemy_team) do
				local size = 0
				for id in DataPool_Array(enemy.team_ids) do
					size = size + 1
				end
				local max = 0
				for i = 1, size do
					max = max + enemy.team_odds[i]
				end
				local randd = math.random(1, max)
				local add = 0
				for i = 1, size do
					add = add + enemy.team_odds[i]
					if randd <= add then
						local value = CACHE.Int()
						value._value = enemy.team_ids[i]
						role._roledata._tower_data._cur_army_ids:PushBack(value)
						local towerenemy = ed:FindBy("tower_enemy", enemy.team_ids[i])
						if towerenemy ~= nil then
							local tmp = CACHE.TowerAttackInfoList()
							for monster in DataPool_Array(towerenemy.monster_ids) do
								if monster ~= 0 then
									local tmp1 = CACHE.TowerAttackInfo()
									tmp1._id = monster
									tmp1._alive_flag = 1
									tmp:PushBack(tmp1)	
								end
							end
							dif = dif + 1
							army_info:Insert(dif, tmp)
						end
						break
					end
				end
			end
		end
		resp.cur_army = {}
		local lit = army_info:SeekToBegin()
		local l = lit:GetValue()
		while l ~= nil do
			local army_list = {}
			local lita = l:SeekToBegin()
			local la = lita:GetValue()
			while la ~= nil do
				local army = {}
				army.id =  la._id
				army.hp =  la._hp
				army.anger = la._anger
				army.alive = la._alive_flag
				army_list[#army_list + 1] = army
				lita:Next()
				la = lita:GetValue()
			end
			resp.cur_army[#resp.cur_army+1] = {}
			resp.cur_army[#resp.cur_army].armyinfo = army_list
			lit:Next()
			l = lit:GetValue()
		end
		
		resp.cur_army_ids = {}
		local lit1 = role._roledata._tower_data._cur_army_ids:SeekToBegin()
		local l1 = lit1:GetValue()
		while l1 ~= nil do
			resp.cur_army_ids[#resp.cur_army_ids+1] = l1._value	
			lit1:Next()
			l1 = lit1:GetValue()
		end
		
		resp.army_difficulty = role._roledata._tower_data._select_layer_difficulty
	elseif towerstage.stage_category == 3 then
		local buffs = role._roledata._tower_data._buff_info:Find(arg.layer)
		if buffs == nil then
			local buff_ids = {}
			local size = 0
			for buff in DataPool_Array(towerstage.buffs3) do
				size = size + 1
			end
			local max = 0
			for i = 1, size do
				max = max + towerstage.buffs3_odds[i]
			end
			local randd = math.random(1, max)
			local add = 0
			for i = 1, size do
				add = add + towerstage.buffs3_odds[i]
				if randd <= add then
					buff_ids[1] = towerstage.buffs3[i]
					break
				end
			end
			
			size = 0
			for buff in DataPool_Array(towerstage.buffs15) do
				size = size + 1
			end
			max = 0
			for i = 1, size do
				max = max + towerstage.buffs15_odds[i]
			end
			randd = math.random(1, max)
			add = 0
			for i = 1, size do
				add = add + towerstage.buffs15_odds[i]
				if randd <= add then
					buff_ids[2] = towerstage.buffs15[i]
					break
				end
			end
			
			size = 0
			for buff in DataPool_Array(towerstage.buffs30) do
				size = size + 1
			end

			max = 0
			for i = 1, size do
				max = max + towerstage.buffs30_odds[i]
			end
			randd = math.random(1, max)
			add = 0
			for i = 1, size do
				add = add + towerstage.buffs30_odds[i]
				if randd <= add then
					buff_ids[3] = towerstage.buffs30[i]
					break
				end
			end

			local tmp = CACHE.TowerBuyBuffInfo()
			tmp._layer = role._roledata._tower_data._cur_layer
			size  = table.getn(buff_ids)
			for i = 1, size do
				local tmp1 = CACHE.TowerBuffInfo()
				tmp1._id = buff_ids[i]
				tmp._buff:PushBack(tmp1)
			end
			role._roledata._tower_data._buff_info:Insert(tmp._layer, tmp)
		end
		local lit = role._roledata._tower_data._buff_info:Find(arg.layer)._buff:SeekToBegin()
		local l = lit:GetValue()
		resp.buff_list = {}
		resp.buff_buy_flag = {}
		while l~= nil do
			resp.buff_list[#resp.buff_list + 1] = l._id
			resp.buff_buy_flag[#resp.buff_buy_flag + 1] = l._buy_flag
			lit:Next()
			l = lit:GetValue()
		end
	end

	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.typ = towerstage.stage_category
	player:SendToClient(SerializeCommand(resp))
end
