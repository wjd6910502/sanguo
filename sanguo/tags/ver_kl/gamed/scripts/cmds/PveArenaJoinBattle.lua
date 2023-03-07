function OnCommand_PveArenaJoinBattle(player, role, arg, others)
	player:Log("OnCommand_PveArenaJoinBattle, "..DumpTable(arg).." "..DumpTable(others))
	local resp = NewCommand("PveArenaJoinBattle_Re")

	local pve_arena = others.pvearena._data._pve_arena_data_map_data
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]

	if quanju.arena_open_lv > role._roledata._status._level then
		return
	end
	
	if LIMIT_TestUseLimit(role, quanju.arena_free_times, 1) == false then
		resp.retcode = G_ERRCODE["JJC_ATTACK_COUNT_LESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local now = API_GetTime()
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	if now - role._roledata._pve_arena_info._last_attack_time < quanju.arena_pk_cd then
		resp.retcode = G_ERRCODE["JJC_ATTACK_CD"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local my_rank = PVEARENA_GetRank(pve_arena, role._roledata._base._id, role._roledata._pve_arena_info._score)

	if arg.rank == my_rank then
		resp.retcode = G_ERRCODE["JJC_JOIN_RANK_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	role._roledata._pve_arena_info._last_attack_time = API_GetTime()
	LIMIT_AddUseLimit(role, quanju.arena_free_times, 1)
	
	resp.last_attack_time = role._roledata._pve_arena_info._last_attack_time
	
	resp.role_info = {}
	local fight_info = PVEARENA_GetRoleInfoByRank(pve_arena, arg.rank)

	if fight_info.role_id ~= "0" then
		role._roledata._pve_arena_info._cur_attack_player._id = ""
		role._roledata._pve_arena_info._cur_attack_player._name = ""
		role._roledata._pve_arena_info._cur_attack_player._level = 0
		role._roledata._pve_arena_info._cur_attack_player._mafia_name = ""
		role._roledata._pve_arena_info._cur_attack_player._hero_info:Clear()
		role._roledata._pve_arena_info._cur_attack_player._score = 0

		resp.retcode = G_ERRCODE["SUCCESS"]
		resp.role_info.id = fight_info.role_id
		resp.role_info.name = fight_info.name
		resp.role_info.level = fight_info.level
		resp.role_info.score = fight_info.score
		resp.role_info.hero_score = 100
		resp.role_info.mafia_name = fight_info.mafia_name
		resp.role_info.rank = arg.rank
		resp.role_info.hero_info = {}
		resp.role_info.hero_info.heroinfo = {}
		for i = 1, table.getn(fight_info.hero_info) do
			resp.role_info.hero_info.heroinfo[#resp.role_info.hero_info.heroinfo+1] = fight_info.hero_info[i]
			
			local insert_hero = CACHE.PveArenaHeroInfo()
			
			insert_hero._heroid = fight_info.hero_info[i].id
			insert_hero._level = fight_info.hero_info[i].level
			insert_hero._star = fight_info.hero_info[i].star
			insert_hero._grade = fight_info.hero_info[i].grade
			
			local skills = fight_info.hero_info[i].skill
			for j = 1, table.getn(skills) do
				local h3_skill = CACHE.HeroSkill()
				h3_skill._skill_id = skills[j].skill_id
				h3_skill._skill_level = skills[j].skill_level
				insert_hero._skill:PushBack(h3_skill)
			end
			
			local common_skills = fight_info.hero_info[i].common_skill
			for j = 1, table.getn(common_skills) do
				local h3_skill = CACHE.HeroSkill()
				h3_skill._skill_id = common_skills[j].skill_id
				h3_skill._skill_level = common_skills[j].skill_level
				insert_hero._common_skill:PushBack(h3_skill)
			end
			
			local select_skills = fight_info.hero_info[i].select_skill
			for j = 1, table.getn(select_skills) do
				local h3_skill = CACHE.Int()
				h3_skill._value = select_skills[j]
				insert_hero._select_skill:PushBack(h3_skill)
			end

			--武将的羁绊
			local relations = fight_info.hero_info[i].relations
			for j = 1, table.getn(relations) do
				local relation = CACHE.Int()
				relation._value = relations[j]
				insert_hero._relations:PushBack(relation)
			end
			--武将的武器
			insert_hero._weapon_info = fight_info.hero_info[i].weapon_info
			
			--武将的装备
			for index = 1, table.getn(fight_info.hero_info[i].equipment) do
				local equipment = fight_info.hero_info[i].equipment[index]
				local insert_equipment = CACHE.PveArenaHeroEquipmentInfo()
				
				insert_equipment._pos = equipment.pos
				insert_equipment._item_id = equipment.item_id
				insert_equipment._level = equipment.level
				insert_equipment._order = equipment.order
				insert_equipment._refinable_data = find_equipment._equipment_pro._refinable_pro

				for i = 1, table.getn(equipment.refinable_pro) do
					local tmp_refine = CACHE.EquipmentRefinableData()
					tmp_refine._typ = equipment.refinable_pro[i].typ
					tmp_refine._num = equipment.refinable_pro[i].data
					insert_equipment._refinable_data:Insert(tmp_refine._typ, tmp_refine)
					API_Log("1111111111111111111111111111111111111111111111111111111111111111111111")
				end

				insert_hero._equipment_info:PushBack(insert_equipment)
			end
			
			role._roledata._pve_arena_info._cur_attack_player._hero_info:PushBack(insert_hero)
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
	else
		resp.retcode = G_ERRCODE["JJC_RANK_ERR"]
	end
	role:SendToClient(SerializeCommand(resp))
	return
end
