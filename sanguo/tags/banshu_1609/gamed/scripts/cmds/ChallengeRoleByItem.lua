function OnCommand_ChallengeRoleByItem(player, role, arg, others)
	player:Log("OnCommand_ChallengeRoleByItem, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("ChallengeRoleByItem_Re")
	
	local dest_role = others.roles[arg.roleid]

	if dest_role == nil then
		resp.retcode = G_ERRCODE["JJC_CHALLENGE_ROLE_NOT_EXIST"]
		role:SendToClient(SerializeCommand(resp))
		return
	end

	--查看激战物品是否存在
	if BACKPACK_HaveItem(role, 17250, 1) == false then
		resp.retcode = G_ERRCODE["JJC_ITEM_NOT_EXIST"]
		role:SendToClient(SerializeCommand(resp))
		return
	end

	--查看你自己的信息没有任何的意义呀
	if role._roledata._base._id:ToStr() == dest_role._roledata._base._id:ToStr() then
		return 
	end

	BACKPACK_DelItem(role, 17250, 1)

	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.role_info = {}
	
	resp.role_info.id = dest_role._roledata._base._id:ToStr()
	resp.role_info.name = dest_role._roledata._base._name
	resp.role_info.level = dest_role._roledata._status._level
	resp.role_info.score = dest_role._roledata._pve_arena_info._score
	resp.role_info.hero_score = 100
	resp.role_info.mafia_name = dest_role._roledata._mafia._name
	resp.role_info.rank = 0
	resp.role_info.hero_info = {}
	resp.role_info.hero_info.heroinfo = {}
	
	role._roledata._pve_arena_info._cur_attack_player._id = ""
	role._roledata._pve_arena_info._cur_attack_player._name = ""
	role._roledata._pve_arena_info._cur_attack_player._level = 0
	role._roledata._pve_arena_info._cur_attack_player._mafia_name = ""
	role._roledata._pve_arena_info._cur_attack_player._hero_info:Clear()
	role._roledata._pve_arena_info._cur_attack_player._score = 0
	
	local heroid_it = dest_role._roledata._pve_arena_info._defence_hero_info:SeekToBegin()
	local heroid = heroid_it:GetValue()
	while heroid ~= nil do
		local hero_info = dest_role._roledata._hero_hall._heros:Find(heroid._value)
		if hero_info ~= nil then
			local tmp_hero = {}
			local insert_hero = CACHE.PveArenaHeroInfo()
			
			tmp_hero.id = heroid._value
			tmp_hero.level = hero_info._level
			tmp_hero.star = hero_info._star
			tmp_hero.grade = hero_info._order
			
			insert_hero._heroid = heroid._value
			insert_hero._level = hero_info._level
			insert_hero._star = hero_info._star
			insert_hero._grade = hero_info._order
			
			tmp_hero.skill = {}
			tmp_hero.common_skill = {}
			tmp_hero.select_skill = {}
			tmp_hero.relations = {}
			tmp_hero.equipment = {}
			
			local skills = hero_info._skill
			local sit = skills:SeekToBegin()
			local s = sit:GetValue()
			while s ~= nil do
				local h3_skill = CACHE.HeroSkill()
				h3_skill._skill_id = s._skill_id
				h3_skill._skill_level = s._skill_level
				insert_hero._skill:PushBack(h3_skill)
				
				local h3 = {}
				h3.skill_id = s._skill_id
				h3.skill_level = s._skill_level
				tmp_hero.skill[#tmp_hero.skill+1] = h3
			
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
				
				local h3 = {}
				h3.skill_id = com._skill_id
				h3.skill_level = com._skill_level
				tmp_hero.common_skill[#tmp_hero.common_skill+1] = h3
				
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
				
				tmp_hero.select_skill[#tmp_hero.select_skill+1] = select_skill._value
				
				select_skill_it:Next()
				select_skill = select_skill_it:GetValue()
			end

			--武将的羁绊
			local relations = hero_info._relation
			local relation_it = relations:SeekToBegin()
			local relation = relation_it:GetValue()
			while relation ~= nil do
				local tmp_relation = CACHE.Int()
				tmp_relation._value = relation._value
				insert_hero._relations:PushBack(tmp_relation)

				tmp_hero.relations[#tmp_hero.relations+1] = relation._value

				relation_it:Next()
				relation = relation_it:GetValue()
			end
			--武将的武器
			tmp_hero.weapon = {}
			tmp_hero.weapon.base_item = {}
			tmp_hero.weapon.weapon_info = {}
			local wenpon_id = hero_info._weapon_id
			if wenpon_id ~= 0 then
				local weapon_items = role._roledata._backpack._weapon_items

				local weapon_item_it = weapon_items._weapon_items:SeekToBegin()
				local weapon_item = weapon_item_it:GetValue()
				while weapon_item ~= nil do
					if weapon_item._weapon_pro._tid == wenpon_id then
						insert_hero._weapon_info = weapon_item
						
						tmp_hero.weapon.base_item.tid = weapon_item._base_item._tid
						tmp_hero.weapon.base_item.count = weapon_item._base_item._count

						tmp_hero.weapon.weapon_info.tid = weapon_item._weapon_pro._tid
						tmp_hero.weapon.weapon_info.level = weapon_item._weapon_pro._level
						tmp_hero.weapon.weapon_info.star = weapon_item._weapon_pro._star
						tmp_hero.weapon.weapon_info.quality = weapon_item._weapon_pro._quality
						tmp_hero.weapon.weapon_info.prop = weapon_item._weapon_pro._prop
						tmp_hero.weapon.weapon_info.attack = weapon_item._weapon_pro._attack
						tmp_hero.weapon.weapon_info.weapon_skill = weapon_item._weapon_pro._weapon_skill
						tmp_hero.weapon.weapon_info.strength = weapon_item._weapon_pro._strengthen
						tmp_hero.weapon.weapon_info.level_up = weapon_item._weapon_pro._level_up
						tmp_hero.weapon.weapon_info.strength_prob = weapon_item._weapon_pro._strengthen_prob
						tmp_hero.weapon.weapon_info.skill_pro = {}
						local skill_pro_it = weapon_item._weapon_pro._skill_pro:SeekToBegin()
						local skill_pro = skill_pro_it:GetValue()
						while skill_pro ~= nil do
							local tmp_skill_pro = {}
							tmp_skill_pro.skill_id = skill_pro._skill_id
							tmp_skill_pro.skill_level = skill_pro._skill_level
							tmp_hero.weapon.weapon_info.skill_pro[#tmp_hero.weapon.weapon_info.skill_pro+1] = tmp_skill_pro
							skill_pro_it:Next()
							skill_pro = skill_pro_it:GetValue()
						end
						break
					end
					weapon_item_it:Next()
					weapon_item = weapon_item_it:GetValue()
				end
			else
				tmp_hero.weapon.base_item.tid = 0
			end
			--武将的装备
			local equipment_it = hero_info._equipment:SeekToBegin()
			local equipment = equipment_it:GetValue()
			while equipment ~= nil do
				local find_equipment = role._roledata._backpack._equipment_items._equipment_items:Find(equipment._id)
				if find_equipment ~= nil then
					local insert_equipment = CACHE.PveArenaHeroEquipmentInfo()
					local tmp_equipment = {}
					
					insert_equipment._pos = equipment._pos
					insert_equipment._item_id = find_equipment._base_item._tid
					insert_equipment._level = find_equipment._equipment_pro._level_up
					insert_equipment._order = find_equipment._equipment_pro._order
					insert_equipment._refinable_data = find_equipment._equipment_pro._refinable_pro

					tmp_equipment.pos = equipment._pos
					tmp_equipment.item_id = find_equipment._base_item._tid
					tmp_equipment.level = find_equipment._equipment_pro._level_up
					tmp_equipment.order = find_equipment._equipment_pro._order
					tmp_equipment.refinable_pro = {}
				
					local refine_it = find_equipment._equipment_pro._refinable_pro:SeekToBegin()
					local refine = refine_it:GetValue()
					while refine ~= nil do
						local tmp_refine = {}
						tmp_refine.typ = refine._typ
						tmp_refine.data = refine._num
						tmp_equipment.refinable_pro[#tmp_equipment.refinable_pro+1] = tmp_refine
						refine_it:Next()
						refine = refine_it:GetValue()
					end

					insert_hero._equipment_info:PushBack(insert_equipment)
					tmp_hero.equipment[#tmp_hero.equipment+1] = tmp_equipment
				else
					--输出错误日志
				end

				equipment_it:Next()
				equipment = equipment_it:GetValue()
			end
			
			resp.role_info.hero_info.heroinfo[#resp.role_info.hero_info.heroinfo+1] = tmp_hero
			
			role._roledata._pve_arena_info._cur_attack_player._hero_info:PushBack(insert_hero)
		end
		
		heroid_it:Next()
		heroid = heroid_it:GetValue()
	end
		
	--自己的武将信息，这里这么写，是为了跟结束的时候保存的信息一致来做的
	resp.self_info = {}
	resp.self_info.heroinfo = {}
	local heroid_it = role._roledata._pve_arena_info._defence_hero_info:SeekToBegin()
	local heroid = heroid_it:GetValue()
	while heroid ~= nil do
		local hero_info = role._roledata._hero_hall._heros:Find(heroid._value)
		if hero_info ~= nil then
			local tmp_hero_info = {}
			
			tmp_hero_info.id = heroid._value
			tmp_hero_info.level = hero_info._level
			tmp_hero_info.star = hero_info._star
			tmp_hero_info.grade = hero_info._order
		
			tmp_hero_info.skill = {}
			local skills = hero_info._skill
			local sit = skills:SeekToBegin()
			local s = sit:GetValue()
			while s ~= nil do
				local tmp_skill = {}
				tmp_skill.skill_id = s._skill_id
				tmp_skill.skill_level = s._skill_level
				tmp_hero_info.skill[#tmp_hero_info.skill+1] = tmp_skill

				sit:Next()
				s = sit:GetValue()
			end
	
			tmp_hero_info.common_skill = {}
			local common_skills = hero_info._common_skill
			local com_it = common_skills:SeekToBegin()
			local com = com_it:GetValue()
			while com ~= nil do
				local tmp_skill = {}
				tmp_skill.skill_id = com._skill_id
				tmp_skill.skill_level = com._skill_level
				tmp_hero_info.common_skill[#tmp_hero_info.common_skill+1] = tmp_skill

				com_it:Next()
				com = com_it:GetValue()
			end
	
			tmp_hero_info.select_skill = {}
			local select_skills = hero_info._select_skill
			local select_skill_it = select_skills:SeekToBegin()
			local select_skill = select_skill_it:GetValue()
			while select_skill ~= nil do
				tmp_hero_info.select_skill[#tmp_hero_info.select_skill+1] = select_skill._value

				select_skill_it:Next()
				select_skill = select_skill_it:GetValue()
			end
				
			--武将的羁绊
			tmp_hero_info.relations = {}
			local relations = hero_info._relation
			local relation_it = relations:SeekToBegin()
			local relation = relation_it:GetValue()
			while relation ~= nil do
				tmp_hero_info.relations[#tmp_hero_info.relations+1] = relation._value

				relation_it:Next()
				relation = relation_it:GetValue()
			end
			--武将的武器
			tmp_hero_info.weapon = {}
			tmp_hero_info.weapon.base_item = {}
			tmp_hero_info.weapon.weapon_info = {}
			local wenpon_id = hero_info._weapon_id
			if wenpon_id ~= 0 then
				local weapon_items = role._roledata._backpack._weapon_items

				local weapon_item_it = weapon_items._weapon_items:SeekToBegin()
				local weapon_item = weapon_item_it:GetValue()
				while weapon_item ~= nil do
					if weapon_item._weapon_pro._tid == wenpon_id then
						tmp_hero_info.weapon.base_item.tid = weapon_item._base_item._tid
						tmp_hero_info.weapon.base_item.count = weapon_item._base_item._count

						tmp_hero_info.weapon.weapon_info.tid = weapon_item._weapon_pro._tid
						tmp_hero_info.weapon.weapon_info.level = weapon_item._weapon_pro._level
						tmp_hero_info.weapon.weapon_info.star = weapon_item._weapon_pro._star
						tmp_hero_info.weapon.weapon_info.quality = weapon_item._weapon_pro._quality
						tmp_hero_info.weapon.weapon_info.prop = weapon_item._weapon_pro._prop
						tmp_hero_info.weapon.weapon_info.attack = weapon_item._weapon_pro._attack
						tmp_hero_info.weapon.weapon_info.weapon_skill = weapon_item._weapon_pro._weapon_skill
						tmp_hero_info.weapon.weapon_info.strength = weapon_item._weapon_pro._strengthen
						tmp_hero_info.weapon.weapon_info.level_up = weapon_item._weapon_pro._level_up
						tmp_hero_info.weapon.weapon_info.strength_prob = weapon_item._weapon_pro._strengthen_prob
						tmp_hero_info.weapon.weapon_info.skill_pro = {}
						local skill_pro_it = weapon_item._weapon_pro._skill_pro:SeekToBegin()
						local skill_pro = skill_pro_it:GetValue()
						while skill_pro ~= nil do
							local tmp_skill_pro = {}
							tmp_skill_pro.skill_id = skill_pro._skill_id
							tmp_skill_pro.skill_level = skill_pro._skill_level
							tmp_hero_info.weapon.weapon_info.skill_pro[#tmp_hero_info.weapon.weapon_info.skill_pro+1] = tmp_skill_pro
							skill_pro_it:Next()
							skill_pro = skill_pro_it:GetValue()
						end
						break
					end
					weapon_item_it:Next()
					weapon_item = weapon_item_it:GetValue()
				end
			else
				tmp_hero_info.weapon.base_item.tid = 0
			end
			--武将的装备
			tmp_hero_info.equipment = {}
			local equipment_it = hero_info._equipment:SeekToBegin()
			local equipment = equipment_it:GetValue()
			while equipment ~= nil do
				local find_equipment = role._roledata._backpack._equipment_items._equipment_items:Find(equipment._id)
				if find_equipment ~= nil then
					local tmp_equipment = {}
					tmp_equipment.pos = equipment._pos
					tmp_equipment.item_id = find_equipment._base_item._tid
					tmp_equipment.level = find_equipment._equipment_pro._level_up
					tmp_equipment.order = find_equipment._equipment_pro._order
					tmp_equipment.refinable_pro = {}
					local refine_it = find_equipment._equipment_pro._refinable_pro:SeekToBegin()
					local refine = refine_it:GetValue()
					while refine ~= nil do
						local tmp_refine = {}
						tmp_refine.typ = refine._typ
						tmp_refine.data = refine._num
						tmp_equipment.refinable_pro[#tmp_equipment.refinable_pro+1] = tmp_refine
						refine_it:Next()
						refine = refine_it:GetValue()
					end

					tmp_hero_info.equipment[#tmp_hero_info.equipment+1] = tmp_equipment
				else
					--输出错误日志
				end

				equipment_it:Next()
				equipment = equipment_it:GetValue()
			end

			resp.self_info.heroinfo[#resp.self_info.heroinfo+1] = tmp_hero_info
		end
		heroid_it:Next()
		heroid = heroid_it:GetValue()
	end
	
	role._roledata._pve_arena_info._cur_attack_player._id = resp.role_info.id
	role._roledata._pve_arena_info._cur_attack_player._name = resp.role_info.name
	role._roledata._pve_arena_info._cur_attack_player._level = resp.role_info.level
	role._roledata._pve_arena_info._cur_attack_player._mafia_name = resp.role_info.mafia_name
	role._roledata._pve_arena_info._cur_attack_player._score = resp.role_info.score

	role:SendToClient(SerializeCommand(resp))
end
