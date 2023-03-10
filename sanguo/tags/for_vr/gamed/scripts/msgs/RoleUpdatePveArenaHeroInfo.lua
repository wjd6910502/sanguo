function OnMessage_RoleUpdatePveArenaHeroInfo(player, role, arg, others)
	player:Log("OnMessage_RoleUpdatePveArenaHeroInfo, "..DumpTable(arg).." "..DumpTable(others))

	local pve_arena = others.pvearena._data._pve_arena_data_map_data
	local role_score = role._roledata._pve_arena_info._score

	local pve_arena_it = pve_arena:SeekToBegin()
	local pve_arena_info = pve_arena_it:GetValue()
	while pve_arena_info ~= nil do
		if role_score >= pve_arena_info._begin_score and role_score <= pve_arena_info._end_score then
			local find_info = pve_arena_info._pve_arena_data_map:Find(role_score)
			local pve_arena_data_it = pve_arena_info._pve_arena_data_map:SeekToBegin()
			local pve_arena_data = pve_arena_data_it:GetValue()
			while pve_arena_data ~= nil do
				if pve_arena_data._score == role_score then
					local list_data_it = pve_arena_data._list_data:SeekToBegin()
					local list_data = list_data_it:GetValue()
					while list_data ~= nil do
						if list_data._role_id:ToStr() == role._roledata._base._id:ToStr() then
							list_data._hero_info:Clear()

							local heroid_it = role._roledata._pve_arena_info._defence_hero_info:SeekToBegin()
							local heroid = heroid_it:GetValue()
							while heroid ~= nil do
								local hero_info = role._roledata._hero_hall._heros:Find(heroid._value)
								if hero_info ~= nil then
									local insert_hero = CACHE.PveArenaHeroInfo()
									
									insert_hero._heroid = heroid._value
									insert_hero._level = hero_info._level
									insert_hero._star = hero_info._star
									insert_hero._grade = hero_info._order
									
									local skills = hero_info._skill
									local sit = skills:SeekToBegin()
									local s = sit:GetValue()
									while s ~= nil do
										local h3_skill = CACHE.HeroSkill()
										h3_skill._skill_id = s._skill_id
										h3_skill._skill_level = s._skill_level
										insert_hero._skill:PushBack(h3_skill)
										
										sit:Next()
										s = sit:GetValue()
									end
							
									local common_skills = hero_info._common_skill
									local com_it = common_skills:SeekToBegin()
									local com = com_it:GetValue()
									while com ~= nil do
										local h3_skill = CACHE.HeroSkill()
										h3_skill._skill_id = com._skill_id
										h3_skill._skill_level = com._skill_level
										insert_hero._common_skill:PushBack(h3_skill)
										com_it:Next()
										com = com_it:GetValue()
									end
							
									local select_skills = hero_info._select_skill
									local select_skill_it = select_skills:SeekToBegin()
									local select_skill = select_skill_it:GetValue()
									while select_skill ~= nil do
										local h3_skill = CACHE.Int()
										h3_skill._value = select_skill._value
										insert_hero._select_skill:PushBack(h3_skill)

										select_skill_it:Next()
										select_skill = select_skill_it:GetValue()
									end
											
									--??????????
									local relations = hero_info._relation
									local relation_it = relations:SeekToBegin()
									local relation = relation_it:GetValue()
									while relation ~= nil do
										local tmp_relation = CACHE.Int()
										tmp_relation._value = relation._value
										insert_hero._relations:PushBack(tmp_relation)

										relation_it:Next()
										relation = relation_it:GetValue()
									end
									--??????????
									local wenpon_id = hero_info._weapon_id
									if wenpon_id ~= 0 then
										local weapon_items = role._roledata._backpack._weapon_items

										local weapon_item_it = weapon_items._weapon_items:SeekToBegin()
										local weapon_item = weapon_item_it:GetValue()
										while weapon_item ~= nil do
											if weapon_item._weapon_pro._tid == wenpon_id then
												insert_hero._weapon_info = weapon_item
												break
											end
											weapon_item_it:Next()
											weapon_item = weapon_item_it:GetValue()
										end
									end
									
									--??????????
									local equipments = role._roledata._backpack._equipment_items._equipment_items
									local equipment_it = hero_info._equipment:SeekToBegin()
									local equipment = equipment_it:GetValue()
									while equipment ~= nil do
										local find_equipment = equipments:Find(equipment._id)
										if find_equipment ~= nil then
											local insert_equip = CACHE.PveArenaHeroEquipmentInfo()
											insert_equip._pos = equipment._pos
											insert_equip._item_id = find_equipment._base_item._tid
											insert_equip._level = find_equipment._equipment_pro._level_up
											insert_equip._order = find_equipment._equipment_pro._order
											local refine_it = find_equipment._equipment_pro._refinable_pro:SeekToBegin()
											local refine = refine_it:GetValue()
											while refine ~= nil do
												local insert_refine = CACHE.EquipmentRefinableData()
												insert_refine._typ = refine._typ
												insert_refine._num = refine._num
												insert_equip._refinable_data:Insert(refine._typ, insert_refine)
												refine_it:Next()
												refine = refine_it:GetValue()
											end
											insert_hero._equipment_info:PushBack(insert_equip)
										end
										equipment_it:Next()
										equipment = equipment_it:GetValue()
									end
									
									list_data._hero_info:PushBack(insert_hero)
								end
								heroid_it:Next()
								heroid = heroid_it:GetValue()
							end
							return
						end
						list_data_it:Next()
						list_data = list_data_it:GetValue()
					end
				end
				pve_arena_data_it:Next()
				pve_arena_data = pve_arena_data_it:GetValue()
			end
		end
		pve_arena_it:Next()
		pve_arena_info = pve_arena_it:GetValue()
	end
	return
end
