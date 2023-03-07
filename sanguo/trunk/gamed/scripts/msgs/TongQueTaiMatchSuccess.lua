function OnMessage_TongQueTaiMatchSuccess(player, role, arg, others)
	player:Log("OnMessage_TongQueTaiMatchSuccess, "..DumpTable(arg).." "..DumpTable(others))

	local all_role = {}
	local dest_role1 = others.roles[arg.player_roleid1]
	local dest_role2 = others.roles[arg.player_roleid2]
	local tongquetai = others.tongquetai._data

	all_role[#all_role+1] = dest_role2
	all_role[#all_role+1] = dest_role1
	all_role[#all_role+1] = role
	--在这里再次查看所有玩家需要的钱，以及次数

	local err_role = {}
	local right_role = {}
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	for index = 1, table.getn(all_role) do
		local match_success = true
		if LIMIT_TestUseLimit(all_role[index], quanju.party_for_flag_limit_id, 1) == true then
			local buy_count = LIMIT_GetUseLimit(all_role[index], quanju.party_for_flag_limit_id)
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
				match_success = false
			end

			if all_role[index]._roledata._tongquetai_data._double_flag == 1 then
				if all_role[index]._roledata._status._yuanbao < quanju.party_for_flag_3_times_reward_cost then
					match_success = false
				end
			end
			
			if cost_typ == 1 then
				if all_role[index]._roledata._status._money < cost_num then
					match_success = false
				end
			elseif cost_typ == 2 then
				if all_role[index]._roledata._tongquetai_data._double_flag == 1 then
					cost_num = cost_num + quanju.party_for_flag_3_times_reward_cost
				end
				if all_role[index]._roledata._status._yuanbao < cost_num then
					match_success = false
				end
			else
				match_success = false
			end
		else
			match_success = false
		end

		if match_success == false then
			err_role[#err_role+1] = all_role[index]
		else
			right_role[#right_role+1] = all_role[index]
		end
	end

	--谁有数据有问题把谁从匹配队列里面扔出来
	if table.getn(err_role) > 0 then
		for index = 1, table.getn(err_role) do
			local all_fight = tongquetai._join_role:Find(err_role[index]._roledata._base._id)
			
			local difficulty_info_list = 0
			if all_fight._difficulty == 1 then
				difficulty_info_list = tongquetai._hard_difficulty:Find(all_fight._fight)
			else
				difficulty_info_list = tongquetai._easy_difficulty:Find(all_fight._fight)
			end

			if difficulty_info_list ~= nil then
				local difficulty_info_it = difficulty_info_list:SeekToBegin()
				local difficulty_info = difficulty_info_it:GetValue()
				while difficulty_info ~= nil do
					if difficulty_info._role_base._id:ToStr() == err_role[index]._roledata._base._id:ToStr() then
						difficulty_info_it:Pop()
						break
					end
					
					difficulty_info_it:Next()
					difficulty_info = difficulty_info_it:GetValue()
				end
			end
			tongquetai._join_role:Delete(err_role[index]._roledata._base._id)
			err_role[index]._roledata._tongquetai_data._cur_state = 0
		end
		
		--开始把没有问题的玩家重新让他去进行匹配
		for index = 1, table.getn(right_role) do
			local all_fight = tongquetai._join_role:Find(right_role[index]._roledata._base._id)
			
			local difficulty_info_list = 0
			if all_fight._difficulty == 1 then
				difficulty_info_list = tongquetai._hard_difficulty:Find(all_fight._fight)
			else
				difficulty_info_list = tongquetai._easy_difficulty:Find(all_fight._fight)
			end

			if difficulty_info_list ~= nil then
				local difficulty_info_it = difficulty_info_list:SeekToBegin()
				local difficulty_info = difficulty_info_it:GetValue()
				while difficulty_info ~= nil do
					if difficulty_info._role_base._id:ToStr() == right_role[index]._roledata._base._id:ToStr() then
						ifficulty_info._match_success = 0
						break
					end
					
					difficulty_info_it:Next()
					difficulty_info = difficulty_info_it:GetValue()
				end
			end
		end

		return
	end

	--走到这里说明这个时候玩家是符合参加这个活动的，开始真正的扣钱，加次数
	for index = 1, table.getn(all_role) do
		if LIMIT_TestUseLimit(all_role[index], quanju.party_for_flag_limit_id, 1) == true then
			local buy_count = LIMIT_GetUseLimit(all_role[index], quanju.party_for_flag_limit_id)
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
			
			if all_role[index]._roledata._tongquetai_data._double_flag == 1 then
				ROLE_SubYuanBao(all_role[index], quanju.party_for_flag_3_times_reward_cost)
			end
			
			if cost_typ == 1 then
				ROLE_SubMoney(all_role[index], cost_num)
			elseif cost_typ == 2 then
				ROLE_SubYuanBao(all_role[index], cost_num)
			end
			LIMIT_AddUseLimit(all_role[index], quanju.party_for_flag_limit_id, 1)
		end
	end

	--把玩家从匹配队列里面拿出来，然后放到已经匹配成功的队列里面去，然后告诉客户端，可以开始加载了。
	tongquetai._tongquetai_id = tongquetai._tongquetai_id + 1
	local tmp_match_data = CACHE.TongQueTaiMatchData()
	tmp_match_data._cur_fight_role = 1
	tmp_match_data._time = API_GetTime()
	tmp_match_data._cur_state = 0
	tmp_match_data._tongquetai_id = tongquetai._tongquetai_id
	tmp_match_data._cur_monster_index = 1

	for index = 1, table.getn(all_role) do
		local all_fight = tongquetai._join_role:Find(all_role[index]._roledata._base._id)
		
		local difficulty_info_list = 0
		if all_fight._difficulty == 1 then
			difficulty_info_list = tongquetai._hard_difficulty:Find(all_fight._fight)
		else
			difficulty_info_list = tongquetai._easy_difficulty:Find(all_fight._fight)
		end

		if difficulty_info_list ~= nil then
			local difficulty_info_it = difficulty_info_list:SeekToBegin()
			local difficulty_info = difficulty_info_it:GetValue()
			while difficulty_info ~= nil do
				if difficulty_info._role_base._id:ToStr() == all_role[index]._roledata._base._id:ToStr() then
					local tmp_match_role_data = CACHE.TongQueTaiMatchRoleData()
					tmp_match_role_data._role_base = difficulty_info._role_base
					tmp_match_role_data._hero_info = difficulty_info._hero_info
					tmp_match_role_data._double_flag = difficulty_info._double_flag
					tmp_match_role_data._auto_flag = difficulty_info._auto_flag
					tmp_match_role_data._hero_fight = difficulty_info._hero_fight
					tmp_match_role_data._level = difficulty_info._level
					
					tmp_match_data._role_info:Insert(index, tmp_match_role_data)
					tmp_match_data._defence_info:Insert(index, tmp_match_role_data)

					all_role[index]._roledata._tongquetai_data._cur_state = 2
					all_role[index]._roledata._tongquetai_data._cur_tongquetai_id = tongquetai._tongquetai_id
					
					difficulty_info_it:Pop()
					break
				end
				
				difficulty_info_it:Next()
				difficulty_info = difficulty_info_it:GetValue()
			end
		end
	end
	tongquetai._match_data:Insert(tongquetai._tongquetai_id, tmp_match_data)
	--在这里开始给客户端发送相关的信息了。
	
	local resp = NewCommand("TongQueTaiMatchSuccess")
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.join_index = 1
	resp.monster_index = 1
	resp.player_info = {}
	local tmp_player_info_it = tmp_match_data._role_info:SeekToBegin()
	local tmp_player_info = tmp_player_info_it:GetValue()
	while tmp_player_info ~= nil do
		local client_player_info = {}
		client_player_info.id = tmp_player_info._role_base._id:ToStr()
		client_player_info.name = tmp_player_info._role_base._name
		client_player_info.photo = tmp_player_info._role_base._photo
		client_player_info.photo_frame = tmp_player_info._role_base._photo_frame
		client_player_info.badge_info = {}
		local badge_info_it = tmp_player_info._role_base._badge_map:SeekToBegin()
		local badge_info = badge_info_it:GetValue()
		while badge_info ~= nil do
		        local tmp_badge_info = {}
		        tmp_badge_info.id = badge_info._id
		        tmp_badge_info.typ = badge_info._pos
		        client_player_info.badge_info[#client_player_info.badge_info+1] = tmp_badge_info
		
		        badge_info_it:Next()
			badge_info = badge_info_it:GetValue()
		end
		client_player_info.auto_flag = tmp_player_info._auto_flag
		client_player_info.level = tmp_player_info._level
		client_player_info.fight_num = tmp_player_info._hero_fight

		client_player_info.hero_info = {}

		local tmp_hero_info_it = tmp_player_info._hero_info:SeekToBegin()
		local tmp_hero_info = tmp_hero_info_it:GetValue()
		while tmp_hero_info ~= nil do
			local client_hero_info = {}

			client_hero_info.id = tmp_hero_info._heroid
			client_hero_info.level = tmp_hero_info._level
			client_hero_info.star = tmp_hero_info._star
			client_hero_info.grade = tmp_hero_info._grade
			client_hero_info.cur_hp = tmp_hero_info._cur_hp
			client_hero_info.cur_anger = tmp_hero_info._cur_anger
			client_hero_info.alive_flag = tmp_hero_info._alive_flag

			client_hero_info.skill = {}
			client_hero_info.common_skill = {}
			client_hero_info.select_skill = {}
			client_hero_info.relations = {}
			client_hero_info.weapon = {}
			client_hero_info.equipment = {}

			local skill_it = tmp_hero_info._skill:SeekToBegin()
			local skill = skill_it:GetValue()
			while skill ~= nil do
				local tmp_skill = {}
				tmp_skill.skill_id = skill._skill_id
				tmp_skill.skill_level = skill._skill_level
				client_hero_info.skill[#client_hero_info.skill+1] = tmp_skill

				skill_it:Next()
				skill = skill_it:GetValue()
			end

			local common_it = tmp_hero_info._common_skill:SeekToBegin()
			local common = common_it:GetValue()
			while common ~= nil do
				local tmp_skill = {}
				tmp_skill.skill_id = common._skill_id
				tmp_skill.skill_level = common._skill_level
				client_hero_info.common_skill[#client_hero_info.common_skill+1] = tmp_skill

				common_it:Next()
				common = common_it:GetValue()
			end

			local skill_it = tmp_hero_info._select_skill:SeekToBegin()
			local skill = skill_it:GetValue()
			while skill ~= nil do
				client_hero_info.select_skill[#client_hero_info.select_skill+1] = skill._value
				skill_it:Next()
				skill = skill_it:GetValue()
			end

			local relation_it = tmp_hero_info._relations:SeekToBegin()
			local relation = relation_it:GetValue()
			while relation ~= nil do
				client_hero_info.relations[#client_hero_info.relations+1] = relation._value
				relation_it:Next()
				relation = relation_it:GetValue()
			end

			client_hero_info.weapon.base_item = {}
			client_hero_info.weapon.weapon_info = {}

			if tmp_hero_info._weapon_info._base_item._tid ~= 0 then
				client_hero_info.weapon.base_item.tid = tmp_hero_info._weapon_info._base_item._tid
				client_hero_info.weapon.base_item.count = tmp_hero_info._weapon_info._base_item._count

				client_hero_info.weapon.weapon_info.tid = tmp_hero_info._weapon_info._weapon_pro._tid
				client_hero_info.weapon.weapon_info.level = tmp_hero_info._weapon_info._weapon_pro._level
				client_hero_info.weapon.weapon_info.star = tmp_hero_info._weapon_info._weapon_pro._star
				client_hero_info.weapon.weapon_info.quality = tmp_hero_info._weapon_info._weapon_pro._quality
				client_hero_info.weapon.weapon_info.prop = tmp_hero_info._weapon_info._weapon_pro._prop
				client_hero_info.weapon.weapon_info.attack = tmp_hero_info._weapon_info._weapon_pro._attack
				client_hero_info.weapon.weapon_info.weapon_skill = tmp_hero_info._weapon_info._weapon_pro._weapon_skill
				client_hero_info.weapon.weapon_info.strength = tmp_hero_info._weapon_info._weapon_pro._strengthen
				client_hero_info.weapon.weapon_info.level_up = tmp_hero_info._weapon_info._weapon_pro._level_up
				client_hero_info.weapon.weapon_info.strength_prob = tmp_hero_info._weapon_info._weapon_pro._strengthen_prob
				client_hero_info.weapon.weapon_info.skill_pro = {}
				local skill_pro_it = tmp_hero_info._weapon_info._weapon_pro._skill_pro:SeekToBegin()
				local skill_pro = skill_pro_it:GetValue()
				while skill_pro ~= nil do
					local tmp_skill_pro = {}
					tmp_skill_pro.skill_id = skill_pro._skill_id
					tmp_skill_pro.skill_level = skill_pro._skill_level
					client_hero_info.weapon.weapon_info.skill_pro[#client_hero_info.weapon.weapon_info.skill_pro+1] = tmp_skill_pro
					skill_pro_it:Next()
					skill_pro = skill_pro_it:GetValue()
				end
			else
				client_hero_info.weapon.base_item.tid = 0
			end

			--武将的装备信息
			local equipment_it = tmp_hero_info._equipment_info:SeekToBegin()
			local equipment = equipment_it:GetValue()
			while equipment ~= nil do
				local tmp_equipment = {}
				tmp_equipment.pos = equipment._pos
				tmp_equipment.item_id = equipment._item_id
				tmp_equipment.level = equipment._level
				tmp_equipment.order = equipment._roder
				tmp_equipment.refinable_pro = {}
				local refine_it = equipment._refinable_data:SeekToBegin()
				local refine = refine_it:GetValue()
				while refine ~= nil do
					local tmp_refine = {}
					tmp_refine.typ = refine._typ
					tmp_refine.data = refine._num
					tmp_equipment.refinable_pro[#tmp_equipment.refinable_pro+1] = tmp_refine
					refine_it:Next()
					refine = refine_it:GetValue()
				end
				client_hero_info.equipment[#client_hero_info.equipment+1] = tmp_equipment
				equipment_it:Next()
				equipment = equipment_it:GetValue()
			end
			
			client_player_info.hero_info[#client_player_info.hero_info+1] = client_hero_info
			tmp_hero_info_it:Next()
			tmp_hero_info = tmp_hero_info_it:GetValue()
		end

		resp.player_info[#resp.player_info+1] = client_player_info
		tmp_player_info_it:Next()
		tmp_player_info = tmp_player_info_it:GetValue()
	end
	resp.monster_info = {}
	
	local tmp_player_info_it = tmp_match_data._defence_info:SeekToBegin()
	local tmp_player_info = tmp_player_info_it:GetValue()
	while tmp_player_info ~= nil do
		local client_player_info = {}
		client_player_info.id = tmp_player_info._role_base._id:ToStr()
		client_player_info.name = tmp_player_info._role_base._name
		client_player_info.photo = tmp_player_info._role_base._photo
		client_player_info.photo_frame = tmp_player_info._role_base._photo_frame
		client_player_info.badge_info = {}
		local badge_info_it = tmp_player_info._role_base._badge_map:SeekToBegin()
		local badge_info = badge_info_it:GetValue()
		while badge_info ~= nil do
		        local tmp_badge_info = {}
		        tmp_badge_info.id = badge_info._id
		        tmp_badge_info.typ = badge_info._pos
		        client_player_info.badge_info[#client_player_info.badge_info+1] = tmp_badge_info
		
		        badge_info_it:Next()
			badge_info = badge_info_it:GetValue()
		end
		client_player_info.level = tmp_player_info._level
		client_player_info.fight_num = tmp_player_info._hero_fight

		client_player_info.hero_info = {}

		local tmp_hero_info_it = tmp_player_info._hero_info:SeekToBegin()
		local tmp_hero_info = tmp_hero_info_it:GetValue()
		while tmp_hero_info ~= nil do
			local client_hero_info = {}

			client_hero_info.id = tmp_hero_info._heroid
			client_hero_info.level = tmp_hero_info._level
			client_hero_info.star = tmp_hero_info._star
			client_hero_info.grade = tmp_hero_info._grade
			client_hero_info.cur_hp = tmp_hero_info._cur_hp
			client_hero_info.cur_anger = tmp_hero_info._cur_anger
			client_hero_info.alive_flag = tmp_hero_info._alive_flag

			client_hero_info.skill = {}
			client_hero_info.common_skill = {}
			client_hero_info.select_skill = {}
			client_hero_info.relations = {}
			client_hero_info.weapon = {}
			client_hero_info.equipment = {}

			local skill_it = tmp_hero_info._skill:SeekToBegin()
			local skill = skill_it:GetValue()
			while skill ~= nil do
				local tmp_skill = {}
				tmp_skill.skill_id = skill._skill_id
				tmp_skill.skill_level = skill._skill_level
				client_hero_info.skill[#client_hero_info.skill+1] = tmp_skill

				skill_it:Next()
				skill = skill_it:GetValue()
			end

			local common_it = tmp_hero_info._common_skill:SeekToBegin()
			local common = common_it:GetValue()
			while common ~= nil do
				local tmp_skill = {}
				tmp_skill.skill_id = common._skill_id
				tmp_skill.skill_level = common._skill_level
				client_hero_info.common_skill[#client_hero_info.common_skill+1] = tmp_skill

				common_it:Next()
				common = common_it:GetValue()
			end

			local skill_it = tmp_hero_info._select_skill:SeekToBegin()
			local skill = skill_it:GetValue()
			while skill ~= nil do
				client_hero_info.select_skill[#client_hero_info.select_skill+1] = skill._value
				skill_it:Next()
				skill = skill_it:GetValue()
			end

			local relation_it = tmp_hero_info._relations:SeekToBegin()
			local relation = relation_it:GetValue()
			while relation ~= nil do
				client_hero_info.relations[#client_hero_info.relations+1] = relation._value
				relation_it:Next()
				relation = relation_it:GetValue()
			end

			client_hero_info.weapon.base_item = {}
			client_hero_info.weapon.weapon_info = {}

			if tmp_hero_info._weapon_info._base_item._tid ~= 0 then
				client_hero_info.weapon.base_item.tid = tmp_hero_info._weapon_info._base_item._tid
				client_hero_info.weapon.base_item.count = tmp_hero_info._weapon_info._base_item._count

				client_hero_info.weapon.weapon_info.tid = tmp_hero_info._weapon_info._weapon_pro._tid
				client_hero_info.weapon.weapon_info.level = tmp_hero_info._weapon_info._weapon_pro._level
				client_hero_info.weapon.weapon_info.star = tmp_hero_info._weapon_info._weapon_pro._star
				client_hero_info.weapon.weapon_info.quality = tmp_hero_info._weapon_info._weapon_pro._quality
				client_hero_info.weapon.weapon_info.prop = tmp_hero_info._weapon_info._weapon_pro._prop
				client_hero_info.weapon.weapon_info.attack = tmp_hero_info._weapon_info._weapon_pro._attack
				client_hero_info.weapon.weapon_info.weapon_skill = tmp_hero_info._weapon_info._weapon_pro._weapon_skill
				client_hero_info.weapon.weapon_info.strength = tmp_hero_info._weapon_info._weapon_pro._strengthen
				client_hero_info.weapon.weapon_info.level_up = tmp_hero_info._weapon_info._weapon_pro._level_up
				client_hero_info.weapon.weapon_info.strength_prob = tmp_hero_info._weapon_info._weapon_pro._strengthen_prob
				client_hero_info.weapon.weapon_info.skill_pro = {}
				local skill_pro_it = tmp_hero_info._weapon_info._weapon_pro._skill_pro:SeekToBegin()
				local skill_pro = skill_pro_it:GetValue()
				while skill_pro ~= nil do
					local tmp_skill_pro = {}
					tmp_skill_pro.skill_id = skill_pro._skill_id
					tmp_skill_pro.skill_level = skill_pro._skill_level
					client_hero_info.weapon.weapon_info.skill_pro[#client_hero_info.weapon.weapon_info.skill_pro+1] = tmp_skill_pro
					skill_pro_it:Next()
					skill_pro = skill_pro_it:GetValue()
				end
			else
				client_hero_info.weapon.base_item.tid = 0
			end

			--武将的装备信息
			local equipment_it = tmp_hero_info._equipment_info:SeekToBegin()
			local equipment = equipment_it:GetValue()
			while equipment ~= nil do
				local tmp_equipment = {}
				tmp_equipment.pos = equipment._pos
				tmp_equipment.item_id = equipment._item_id
				tmp_equipment.level = equipment._level
				tmp_equipment.order = equipment._roder
				tmp_equipment.refinable_pro = {}
				local refine_it = equipment._refinable_data:SeekToBegin()
				local refine = refine_it:GetValue()
				while refine ~= nil do
					local tmp_refine = {}
					tmp_refine.typ = refine._typ
					tmp_refine.data = refine._num
					tmp_equipment.refinable_pro[#tmp_equipment.refinable_pro+1] = tmp_refine
					refine_it:Next()
					refine = refine_it:GetValue()
				end
				client_hero_info.equipment[#client_hero_info.equipment+1] = tmp_equipment
				equipment_it:Next()
				equipment = equipment_it:GetValue()
			end
			
			client_player_info.hero_info[#client_player_info.hero_info+1] = client_hero_info
			tmp_hero_info_it:Next()
			tmp_hero_info = tmp_hero_info_it:GetValue()
		end

		resp.monster_info[#resp.monster_info+1] = client_player_info
		tmp_player_info_it:Next()
		tmp_player_info = tmp_player_info_it:GetValue()
	end

	role:SendToClient(SerializeCommand(resp))
	dest_role1:SendToClient(SerializeCommand(resp))
	dest_role2:SendToClient(SerializeCommand(resp))

	--在这里把玩家的状态修改成2
	role._roledata._tongquetai_data._cur_state = 2
	dest_role1._roledata._tongquetai_data._cur_state = 2
	dest_role2._roledata._tongquetai_data._cur_state = 2
	return
end
