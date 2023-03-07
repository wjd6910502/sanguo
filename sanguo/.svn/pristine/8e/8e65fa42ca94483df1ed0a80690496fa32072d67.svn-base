function OnCommand_GetPveArenaOperation(player, role, arg, others)
	player:Log("OnCommand_GetPveArenaOperation, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("GetPveArenaOperation_Re")

	local history_info = role._roledata._pve_arena_info._pve_arena_history:Find(arg.id)

	if history_info == nil then
		resp.retcode = G_ERRCODE["JJC_VIDEO_NOT_EXIST"]
		role:SendToClient(SerializeCommand(resp))
		return
	end

	resp.self_hero_info = {}
	resp.self_hero_info.heroinfo = {}
	
	resp.oppo_hero_info = {}
	resp.oppo_hero_info.heroinfo = {}

	local hero_info_it = history_info._self_hero_info:SeekToBegin()
	local hero_info = hero_info_it:GetValue()
	while hero_info ~= nil do
		local tmp_hero_info = {}
		tmp_hero_info.id = hero_info._heroid
		tmp_hero_info.level = hero_info._level
		tmp_hero_info.star = hero_info._star
		tmp_hero_info.grade = hero_info._grade
	
		tmp_hero_info.skill = {}
		tmp_hero_info.common_skill = {}
		tmp_hero_info.select_skill = {}
			
		local skills = hero_info._skill
		local sit = skills:SeekToBegin()
		local s = sit:GetValue()
		while s ~= nil do
			local h3 = {}
			h3.skill_id = s._skill_id
			h3.skill_level = s._skill_level
			tmp_hero_info.skill[#tmp_hero_info.skill+1] = h3
			sit:Next()
			s = sit:GetValue()
		end
		
		local common_skills = hero_info._common_skill
		local com_it = common_skills:SeekToBegin()
		local com = com_it:GetValue()
		while com ~= nil do
			local h3 = {}
			h3.skill_id = com._skill_id
			h3.skill_level = com._skill_level
			tmp_hero_info.common_skill[#tmp_hero_info.common_skill+1] = h3
			com_it:Next()
			com = com_it:GetValue()
		end
		
		local select_skills = hero_info._select_skill
		local select_skill_it = select_skills:SeekToBegin()
		local select_skill = select_skill_it:GetValue()
		while select_skill ~= nil do
			tmp_hero_info.select_skill[#tmp_hero_info.select_skill+1] = select_skill._value
			select_skill_it:Next()
			select_skill = select_skill_it:GetValue()
		end
		--武将羁绊
		tmp_hero_info.relations = {}
		local relations = hero_info._relations
		local relation_it = relations:SeekToBegin()
		local relation = relation_it:GetValue()
		while relation ~= nil do
			tmp_hero_info.relations[#tmp_hero_info.relations+1] = relation._value
			relation_it:Next()
			relation = relation_it:GetValue()
		end
		--武将武器
		tmp_hero_info.weapon = {}
		tmp_hero_info.weapon.base_item = {}
		tmp_hero_info.weapon.weapon_info = {}

		tmp_hero_info.weapon.base_item.tid = hero_info._weapon_info._base_item._tid
		tmp_hero_info.weapon.base_item.count = hero_info._weapon_info._base_item._count

		tmp_hero_info.weapon.weapon_info.tid = hero_info._weapon_info._weapon_pro._tid
		tmp_hero_info.weapon.weapon_info.level = hero_info._weapon_info._weapon_pro._level
		tmp_hero_info.weapon.weapon_info.star = hero_info._weapon_info._weapon_pro._star
		tmp_hero_info.weapon.weapon_info.quality = hero_info._weapon_info._weapon_pro._quality
		tmp_hero_info.weapon.weapon_info.prop = hero_info._weapon_info._weapon_pro._prop
		tmp_hero_info.weapon.weapon_info.attack = hero_info._weapon_info._weapon_pro._attack
		tmp_hero_info.weapon.weapon_info.strength = hero_info._weapon_info._weapon_pro._strengthen
		tmp_hero_info.weapon.weapon_info.level_up = hero_info._weapon_info._weapon_pro._level_up
		tmp_hero_info.weapon.weapon_info.weapon_skill = hero_info._weapon_info._weapon_pro._weapon_skill
		tmp_hero_info.weapon.weapon_info.strength_prob = hero_info._weapon_info._weapon_pro._strengthen_prob
		tmp_hero_info.weapon.weapon_info.skill_pro = {}
		
		--武将装备
		tmp_hero_info.equipment = {}
		local equip_info_it = hero_info._equipment_info:SeekToBegin()
		local equip_info = equip_info_it:GetValue()
		while equip_info ~= nil do
			local tmp_equip_info = {}

			tmp_equip_info.pos = equip_info._pos
			tmp_equip_info.item_id = equip_info._item_id
			tmp_equip_info.level = equip_info._level
			tmp_equip_info.order = equip_info._order
			tmp_equip_info.refinable_pro = {}

			local refinable_info_it = equip_info._refinable_data:SeekToBegin()
			local refinable_info = refinable_info_it:GetValue()
			while refinable_info ~= nil do
				local tmp_refinable_info = {}
				tmp_refinable_info.typ = refinable_info._typ
				tmp_refinable_info.data = refinable_info._num
				tmp_equip_info.refinable_pro[#tmp_equip_info.refinable_pro+1] = tmp_refinable_info

				refinable_info_it:Next()
				refinable_info = refinable_info_it:GetValue()
			end
			
			tmp_hero_info.equipment[#tmp_hero_info.equipment+1] = tmp_equip_info
			equip_info_it:Next()
			equip_info = equip_info_it:GetValue()
		end
		

		local skill_info_it = hero_info._weapon_info._weapon_pro._skill_pro:SeekToBegin()
		local skill_info = skill_info_it:GetValue()
		while skill_info ~= nil do
			local tmp_skill = {}
			tmp_skill.skill_id = skill_info._skill_id
			tmp_skill.skill_level = skill_info._skill_level
			tmp_hero_info.weapon.weapon_info.skill_pro[#tmp_hero_info.weapon.weapon_info.skill_pro+1] = tmp_skill
			skill_info_it:Next()
			skill_info = skill_info_it:GetValue()
		end
		resp.self_hero_info.heroinfo[#resp.self_hero_info.heroinfo+1] = tmp_hero_info
		
		hero_info_it:Next()
		hero_info = hero_info_it:GetValue()
	end
	
	local hero_info_it = history_info._oppo_hero_info:SeekToBegin()
	local hero_info = hero_info_it:GetValue()
	while hero_info ~= nil do
		local tmp_hero_info = {}
		tmp_hero_info.id = hero_info._heroid
		tmp_hero_info.level = hero_info._level
		tmp_hero_info.star = hero_info._star
		tmp_hero_info.grade = hero_info._grade
	
		tmp_hero_info.skill = {}
		tmp_hero_info.common_skill = {}
		tmp_hero_info.select_skill = {}
			
		local skills = hero_info._skill
		local sit = skills:SeekToBegin()
		local s = sit:GetValue()
		while s ~= nil do
			local h3 = {}
			h3.skill_id = s._skill_id
			h3.skill_level = s._skill_level
			tmp_hero_info.skill[#tmp_hero_info.skill+1] = h3
			sit:Next()
			s = sit:GetValue()
		end
		
		local common_skills = hero_info._common_skill
		local com_it = common_skills:SeekToBegin()
		local com = com_it:GetValue()
		while com ~= nil do
			local h3 = {}
			h3.skill_id = com._skill_id
			h3.skill_level = com._skill_level
			tmp_hero_info.common_skill[#tmp_hero_info.common_skill+1] = h3
			com_it:Next()
			com = com_it:GetValue()
		end
		
		local select_skills = hero_info._select_skill
		local select_skill_it = select_skills:SeekToBegin()
		local select_skill = select_skill_it:GetValue()
		while select_skill ~= nil do
			tmp_hero_info.select_skill[#tmp_hero_info.select_skill+1] = select_skill._value
			select_skill_it:Next()
			select_skill = select_skill_it:GetValue()
		end
		
		--武将羁绊
		tmp_hero_info.relations = {}
		local relations = hero_info._relations
		local relation_it = relations:SeekToBegin()
		local relation = relation_it:GetValue()
		while relation ~= nil do
			tmp_hero_info.relations[#tmp_hero_info.relations+1] = relation._value
			relation_it:Next()
			relation = relation_it:GetValue()
		end
		--武将武器
		tmp_hero_info.weapon = {}
		tmp_hero_info.weapon.base_item = {}
		tmp_hero_info.weapon.weapon_info = {}

		tmp_hero_info.weapon.base_item.tid = hero_info._weapon_info._base_item._tid
		tmp_hero_info.weapon.base_item.count = hero_info._weapon_info._base_item._count

		tmp_hero_info.weapon.weapon_info.tid = hero_info._weapon_info._weapon_pro._tid
		tmp_hero_info.weapon.weapon_info.level = hero_info._weapon_info._weapon_pro._level
		tmp_hero_info.weapon.weapon_info.star = hero_info._weapon_info._weapon_pro._star
		tmp_hero_info.weapon.weapon_info.quality = hero_info._weapon_info._weapon_pro._quality
		tmp_hero_info.weapon.weapon_info.prop = hero_info._weapon_info._weapon_pro._prop
		tmp_hero_info.weapon.weapon_info.attack = hero_info._weapon_info._weapon_pro._attack
		tmp_hero_info.weapon.weapon_info.strength = hero_info._weapon_info._weapon_pro._strengthen
		tmp_hero_info.weapon.weapon_info.level_up = hero_info._weapon_info._weapon_pro._level_up
		tmp_hero_info.weapon.weapon_info.weapon_skill = hero_info._weapon_info._weapon_pro._weapon_skill
		tmp_hero_info.weapon.weapon_info.strength_prob = hero_info._weapon_info._weapon_pro._strengthen_prob
		tmp_hero_info.weapon.weapon_info.skill_pro = {}

		--武将装备
		tmp_hero_info.equipment = {}
		local equip_info_it = hero_info._equipment_info:SeekToBegin()
		local equip_info = equip_info_it:GetValue()
		while equip_info ~= nil do
			local tmp_equip_info = {}

			tmp_equip_info.pos = equip_info._pos
			tmp_equip_info.item_id = equip_info._item_id
			tmp_equip_info.level = equip_info._level
			tmp_equip_info.order = equip_info._order
			tmp_equip_info.refinable_pro = {}

			local refinable_info_it = equip_info._refinable_data:SeekToBegin()
			local refinable_info = refinable_info_it:GetValue()
			while refinable_info ~= nil do
				local tmp_refinable_info = {}
				tmp_refinable_info.typ = refinable_info._typ
				tmp_refinable_info.data = refinable_info._num
				tmp_equip_info.refinable_pro[#tmp_equip_info.refinable_pro+1] = tmp_refinable_info

				refinable_info_it:Next()
				refinable_info = refinable_info_it:GetValue()
			end
			
			tmp_hero_info.equipment[#tmp_hero_info.equipment+1] = tmp_equip_info
			equip_info_it:Next()
			equip_info = equip_info_it:GetValue()
		end
		local skill_info_it = hero_info._weapon_info._weapon_pro._skill_pro:SeekToBegin()
		local skill_info = skill_info_it:GetValue()
		while skill_info ~= nil do
			local tmp_skill = {}
			tmp_skill.skill_id = skill_info._skill_id
			tmp_skill.skill_level = skill_info._skill_level
			tmp_hero_info.weapon.weapon_info.skill_pro[#tmp_hero_info.weapon.weapon_info.skill_pro+1] = tmp_skill
			skill_info_it:Next()
			skill_info = skill_info_it:GetValue()
		end
		
		resp.oppo_hero_info.heroinfo[#resp.oppo_hero_info.heroinfo+1] = tmp_hero_info
		hero_info_it:Next()
		hero_info = hero_info_it:GetValue()
	end
	
	local is_idx,ds_hero_info = DeserializeStruct(history_info._operation, 1, "PveArenaOperation")
	resp.operation = {}
	resp.operation = ds_hero_info

	if history_info._attack_flag == 0 then
		resp.self_hero_info , resp.oppo_hero_info = resp.oppo_hero_info, resp.self_hero_info
	end
	role:SendToClient(SerializeCommand(resp))
	return
end
