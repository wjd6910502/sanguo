function OnCommand_TongQueTaiBeginMatch(player, role, arg, others)
	player:Log("OnCommand_TongQueTaiBeginMatch, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("TongQueTaiBeginMatch_Re")

	--判断当前是否还有未领取的铜雀台奖励
	if role._roledata._tongquetai_data._reward_flag == 1 then
		resp.retcode = G_ERRCODE["TONGQUETAI_REWARD_NOT_GET"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--判断玩家的当前出阵武将
	if role._roledata._tongquetai_data._hero_info_list:Size() < 3 then
		resp.retcode = G_ERRCODE["TONGQUETAI_JOIN_HERO_LESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local tongquetai = others.tongquetai._data
	if role._roledata._tongquetai_data._cur_state ~= 0 then
		resp.retcode = G_ERRCODE["TONGQUETAI_JOIN_IN_ACTIVITY"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	--次数限制，费用限制
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	if LIMIT_TestUseLimit(role, quanju.party_for_flag_limit_id, 1) == true then
		local buy_count = LIMIT_GetUseLimit(role, quanju.party_for_flag_limit_id)
		local flag = 0
		local cost_typ = 0
		local cost_num = 0
		for cost in DataPool_Array(quanju.cost) do
			if flag == buy_count then
				cost_typ = cost.party_for_flag_coin_type
				cost_num = cost.party_for_flag_cost
				break
			end
			flag = flag + 1
		end

		if cost_num == 0 or cost_typ == 0 then
			resp.retcode = G_ERRCODE["TONGQUETAI_JOIN_SYS_COST_ERR"]
			player:SendToClient(SerializeCommand(resp))
			return
		end

		if arg.double_flag == 1 then
			if role._roledata._status._yuanbao < quanju.party_for_flag_3_times_reward_cost then
				resp.retcode = G_ERRCODE["TONGQUETAI_JOIN_COST_MONEY_LESS"]
				player:SendToClient(SerializeCommand(resp))
				return
			end
		end
		
		if cost_typ == 1 then
			if role._roledata._status._money < cost_num then
				resp.retcode = G_ERRCODE["TONGQUETAI_JOIN_COST_MONEY_LESS"]
				player:SendToClient(SerializeCommand(resp))
				return
			end
		elseif cost_typ == 2 then
			if arg.double_flag == 1 then
				cost_num = cost_num + quanju.party_for_flag_3_times_reward_cost
			end
			if role._roledata._status._yuanbao < cost_num then
				resp.retcode = G_ERRCODE["TONGQUETAI_JOIN_COST_MONEY_LESS"]
				player:SendToClient(SerializeCommand(resp))
				return
			end
		else
			resp.retcode = G_ERRCODE["TONGQUETAI_JOIN_SYS_COST_TYP_ERR"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
	else
		resp.retcode = G_ERRCODE["TONGQUETAI_JOIN_NO_COUNT"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--参战武将的战力值
	--local hero_info_it = role._roledata._tongquetai_data._hero_info_list:SeekToBegin()
	--local hero_info = hero_info_it:GetValue()
	--while hero_info ~= nil do
	--	all_fight = all_fight + hero_info._value*100

	--	hero_info_it:Next()
	--	hero_info = hero_info_it:GetValue()
	--end

	--下面就没有其余的判断了，只需要把玩家放进去就可以了
	local tongquetai_role_data = CACHE.TongQueTaiRoleData()
	
	tongquetai_role_data._role_base = role._roledata._base
	tongquetai_role_data._double_flag = arg.double_flag
	tongquetai_role_data._auto_flag = arg.auto_flag
	tongquetai_role_data._level = role._roledata._status._level

	--下面开始弄武将的信息
	local all_fight = 0
	local heros = role._roledata._hero_hall._heros
	local hero_info_it = role._roledata._tongquetai_data._hero_info_list:SeekToBegin()
	local hero_info = hero_info_it:GetValue()
	while hero_info ~= nil do
		local insert_hero_info = CACHE.TongQueTaiHeroInfo()

		local find_hero_info = heros:Find(hero_info._value)
		--参战武将的战力值
		all_fight = all_fight + find_hero_info._zhanli
		insert_hero_info._heroid = hero_info._value
		insert_hero_info._level = find_hero_info._level
		insert_hero_info._star = find_hero_info._star
		insert_hero_info._grade = find_hero_info._order
		insert_hero_info._cur_hp = 0
		insert_hero_info._cur_anger = 0
		insert_hero_info._alive_flag = 1

		--武将无双技能赋值
		local skills = find_hero_info._skill
		local sit = skills:SeekToBegin()
		local s = sit:GetValue()
		while s ~= nil do
			insert_hero_info._skill:PushBack(s)
			
			sit:Next()
			s = sit:GetValue()
		end
		--武将普通技能赋值
		local common_skills = find_hero_info._common_skill
		local com_it = common_skills:SeekToBegin()
		local com = com_it:GetValue()
		while com ~= nil do
			insert_hero_info._common_skill:PushBack(com)

			com_it:Next()
			com = com_it:GetValue()
		end

		--武将已经选择的无双技能
		insert_hero_info._select_skill = find_hero_info._select_skill

		--武将的羁绊
		local relation_it = find_hero_info._relation:SeekToBegin()
		local relation = relation_it:GetValue()
		while relation ~= nil do
			insert_hero_info._relations:PushBack(relation)
			relation_it:Next()
			relation = relation_it:GetValue()
		end
		
		--武将的武器
		local wenpon_id = find_hero_info._weapon_id

		if wenpon_id ~= 0 then
			local weapon_items = role._roledata._backpack._weapon_items

			local weapon_item_it = weapon_items._weapon_items:SeekToBegin()
			local weapon_item = weapon_item_it:GetValue()
			while weapon_item ~= nil do
				if weapon_item._weapon_pro._tid == wenpon_id then
					insert_hero_info._weapon_info = weapon_item
					break
				end
				weapon_item_it:Next()
				weapon_item = weapon_item_it:GetValue()
			end
		end

		--武将的装备
		local equipment_it = find_hero_info._equipment:SeekToBegin()
		local equipment = equipment_it:GetValue()
		while equipment ~= nil do
			local find_equipment = role._roledata._backpack._equipment_items._equipment_items:Find(equipment._id)
			if find_equipment ~= nil then
				local tmp_equipment = CACHE.PveArenaHeroEquipmentInfo()
				tmp_equipment._pos = equipment._pos
				tmp_equipment._item_id = find_equipment._base_item._tid
				tmp_equipment._level = find_equipment._equipment_pro._level_up
				tmp_equipment._order = find_equipment._equipment_pro._order
				tmp_equipment._refinable_data = find_equipment._equipment_pro._refinable_pro
				
				insert_hero_info._equipment_info:PushBack(tmp_equipment)
			end
			equipment_it:Next()
			equipment = equipment_it:GetValue()
		end
		
		tongquetai_role_data._hero_info:PushBack(insert_hero_info)
		
		hero_info_it:Next()
		hero_info = hero_info_it:GetValue()
	end

	--武将的战力
	tongquetai_role_data._hero_fight = all_fight
	--你愿意修改就修改，反正我只认为难度1是困难的，其余的我都放到简单里面去
	if arg.difficulty == 1 then
		local difficulty_info = tongquetai._hard_difficulty:Find(all_fight)
		if difficulty_info == nil then
			local difficulty_info_list = CACHE.TongQueTaiRoleDataList()
			difficulty_info_list:PushBack(tongquetai_role_data)
			
			tongquetai._hard_difficulty:Insert(all_fight, difficulty_info_list)
		else
			difficulty_info:PushBack(tongquetai_role_data)
		end
	else
		local difficulty_info = tongquetai._easy_difficulty:Find(all_fight)
		if difficulty_info == nil then
			local difficulty_info_list = CACHE.TongQueTaiRoleDataList()
			difficulty_info_list:PushBack(tongquetai_role_data)
			
			tongquetai._easy_difficulty:Insert(all_fight, difficulty_info_list)
		else
			difficulty_info:PushBack(tongquetai_role_data)
		end
	end

	local insert_role_difficulty = CACHE.TongQueTaiJoinRoleData()
	insert_role_difficulty._fight = all_fight
	insert_role_difficulty._difficulty = arg.difficulty
	tongquetai._join_role:Insert(role._roledata._base._id, insert_role_difficulty)

	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))

	role._roledata._tongquetai_data._cur_state = 1
	role._roledata._tongquetai_data._double_flag = arg.double_flag
end
