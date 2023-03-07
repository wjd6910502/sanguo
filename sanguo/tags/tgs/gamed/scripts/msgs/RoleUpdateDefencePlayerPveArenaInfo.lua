function OnMessage_RoleUpdateDefencePlayerPveArenaInfo(player, role, arg, others)
--	API_Log("OnMessage_RoleUpdateDefencePlayerPveArenaInfo, "..DumpTable(arg).." "..DumpTable(others))

	local pve_arena = others.pvearena._data
	local score_change = 0
	if arg.win_flag == 1 then
		score_change = -10
	else
		local tmp_score = arg.score - role._roledata._pve_arena_info._score
		if tmp_score <= 0 then
			score_change = 16
		else
			tmp_score = math.floor(tmp_score/20)
			if tmp_score < 16 then
				score_change = 16
			else
				score_change = tmp_score
			end
		end
	end

	local cur_score = role._roledata._pve_arena_info._score
	role._roledata._pve_arena_info._score = role._roledata._pve_arena_info._score + score_change
	
	if role._roledata._pve_arena_info._score <= 100 then
		role._roledata._pve_arena_info._score = 100
	end

	PVEARENA_ChangeRoleScore(pve_arena, role, cur_score, role._roledata._pve_arena_info._score)

	role._roledata._pve_arena_info._cur_num = role._roledata._pve_arena_info._cur_num + 1
	local tmp_info = CACHE.PveArenaRoleInfo()
	tmp_info._match_id = role._roledata._pve_arena_info._cur_num
	tmp_info._id = arg.id
	tmp_info._name = arg.name
	tmp_info._win_flag = arg.win_flag
	tmp_info._attack_flag = 0
	tmp_info._operation = arg.operation
	tmp_info._time = API_GetTime()
	tmp_info._oppo_level = arg.level
	tmp_info._oppo_mafia = arg.mafia_name
	tmp_info._self_level = role._roledata._status._level
	tmp_info._self_mafia = role._roledata._mafia._name
	tmp_info._reply_flag = arg.reply_flag

	local is_idx,ds_hero_info = DeserializeStruct(arg.oppo_hero_info, 1, "RolePveArenaInfo")
	for i = 1, table.getn(ds_hero_info.heroinfo) do
		local insert_hero = CACHE.PveArenaHeroInfo()
		insert_hero._heroid = ds_hero_info.heroinfo[i].id
		insert_hero._level = ds_hero_info.heroinfo[i].level
		insert_hero._star = ds_hero_info.heroinfo[i].star
		insert_hero._grade = ds_hero_info.heroinfo[i].grade

		for j = 1, table.getn(ds_hero_info.heroinfo[i].skill) do
			local h3_skill = CACHE.HeroSkill()
			h3_skill._skill_id = ds_hero_info.heroinfo[i].skill[j].skill_id
			h3_skill._skill_level = ds_hero_info.heroinfo[i].skill[j].skill_level

			insert_hero._skill:PushBack(h3_skill)
		end

		for j = 1, table.getn(ds_hero_info.heroinfo[i].common_skill) do
			local h3_skill = CACHE.HeroSkill()
			h3_skill._skill_id = ds_hero_info.heroinfo[i].common_skill[j].skill_id
			h3_skill._skill_level = ds_hero_info.heroinfo[i].common_skill[j].skill_level

			insert_hero._common_skill:PushBack(h3_skill)
		end

		for j = 1, table.getn(ds_hero_info.heroinfo[i].select_skill) do
			local h3_skill = CACHE.Int()
			h3_skill._value = ds_hero_info.heroinfo[i].select_skill[j]

			insert_hero._select_skill:PushBack(h3_skill)
		end
		
		--�佫�
		for j = 1 , table.getn(ds_hero_info.heroinfo[i].relations) do
			local relation = CACHE.Int()
			relation._value = ds_hero_info.heroinfo[i].relations[j]
			insert_hero._relations:PushBack(relation)
		end

		--�佫������
		insert_hero._weapon_info._base_item._tid = ds_hero_info.heroinfo[i].weapon.base_item.tid
		insert_hero._weapon_info._base_item._count = ds_hero_info.heroinfo[i].weapon.base_item.count
		
		insert_hero._weapon_info._weapon_pro._tid = ds_hero_info.heroinfo[i].weapon.weapon_info.tid
		insert_hero._weapon_info._weapon_pro._level = ds_hero_info.heroinfo[i].weapon.weapon_info.level
		insert_hero._weapon_info._weapon_pro._star = ds_hero_info.heroinfo[i].weapon.weapon_info.star
		insert_hero._weapon_info._weapon_pro._quality = ds_hero_info.heroinfo[i].weapon.weapon_info.quality
		insert_hero._weapon_info._weapon_pro._prop = ds_hero_info.heroinfo[i].weapon.weapon_info.prop
		insert_hero._weapon_info._weapon_pro._attack = ds_hero_info.heroinfo[i].weapon.weapon_info.attack
		insert_hero._weapon_info._weapon_pro._strengthen = ds_hero_info.heroinfo[i].weapon.weapon_info.strength
		insert_hero._weapon_info._weapon_pro._level_up = ds_hero_info.heroinfo[i].weapon.weapon_info.level_up
		insert_hero._weapon_info._weapon_pro._weapon_skill = ds_hero_info.heroinfo[i].weapon.weapon_info.weapon_skill
		insert_hero._weapon_info._weapon_pro._strengthen_prob = ds_hero_info.heroinfo[i].weapon.weapon_info.strength_prob

		for j = 1, table.getn(ds_hero_info.heroinfo[i].weapon.weapon_info.skill_pro) do
			local tmp_skill = CACHE.WeaponSkill()
			tmp_skill._skill_id = ds_hero_info.heroinfo[i].weapon.weapon_info.skill_pro[j].skill_id
			tmp_skill._skill_level = ds_hero_info.heroinfo[i].weapon.weapon_info.skill_pro[j].skill_level
			insert_hero._weapon_info._weapon_pro._skill_pro:Insert(tmp_skill._skill_id, tmp_skill)
		end
		
		tmp_info._self_hero_info:PushBack(insert_hero)
	end
	
	local is_idx,ds_hero_info = DeserializeStruct(arg.self_hero_info, 1, "RolePveArenaInfo")
	for i = 1, table.getn(ds_hero_info.heroinfo) do
		local insert_hero = CACHE.PveArenaHeroInfo()
		insert_hero._heroid = ds_hero_info.heroinfo[i].id
		insert_hero._level = ds_hero_info.heroinfo[i].level
		insert_hero._star = ds_hero_info.heroinfo[i].star
		insert_hero._grade = ds_hero_info.heroinfo[i].grade

		for j = 1, table.getn(ds_hero_info.heroinfo[i].skill) do
			local h3_skill = CACHE.HeroSkill()
			h3_skill._skill_id = ds_hero_info.heroinfo[i].skill[j].skill_id
			h3_skill._skill_level = ds_hero_info.heroinfo[i].skill[j].skill_level

			insert_hero._skill:PushBack(h3_skill)
		end

		for j = 1, table.getn(ds_hero_info.heroinfo[i].common_skill) do
			local h3_skill = CACHE.HeroSkill()
			h3_skill._skill_id = ds_hero_info.heroinfo[i].common_skill[j].skill_id
			h3_skill._skill_level = ds_hero_info.heroinfo[i].common_skill[j].skill_level

			insert_hero._common_skill:PushBack(h3_skill)
		end

		for j = 1, table.getn(ds_hero_info.heroinfo[i].select_skill) do
			local h3_skill = CACHE.Int()
			h3_skill._value = ds_hero_info.heroinfo[i].select_skill[j]

			insert_hero._select_skill:PushBack(h3_skill)
		end
		
		--�佫�
		for j = 1 , table.getn(ds_hero_info.heroinfo[i].relations) do
			local relation = CACHE.Int()
			relation._value = ds_hero_info.heroinfo[i].relations[j]
			insert_hero._relations:PushBack(relation)
		end

		--�佫������
		insert_hero._weapon_info._base_item._tid = ds_hero_info.heroinfo[i].weapon.base_item.tid
		insert_hero._weapon_info._base_item._count = ds_hero_info.heroinfo[i].weapon.base_item.count
		
		insert_hero._weapon_info._weapon_pro._tid = ds_hero_info.heroinfo[i].weapon.weapon_info.tid
		insert_hero._weapon_info._weapon_pro._level = ds_hero_info.heroinfo[i].weapon.weapon_info.level
		insert_hero._weapon_info._weapon_pro._star = ds_hero_info.heroinfo[i].weapon.weapon_info.star
		insert_hero._weapon_info._weapon_pro._quality = ds_hero_info.heroinfo[i].weapon.weapon_info.quality
		insert_hero._weapon_info._weapon_pro._prop = ds_hero_info.heroinfo[i].weapon.weapon_info.prop
		insert_hero._weapon_info._weapon_pro._attack = ds_hero_info.heroinfo[i].weapon.weapon_info.attack
		insert_hero._weapon_info._weapon_pro._strengthen = ds_hero_info.heroinfo[i].weapon.weapon_info.strength
		insert_hero._weapon_info._weapon_pro._level_up = ds_hero_info.heroinfo[i].weapon.weapon_info.level_up
		insert_hero._weapon_info._weapon_pro._weapon_skill = ds_hero_info.heroinfo[i].weapon.weapon_info.weapon_skill
		insert_hero._weapon_info._weapon_pro._strengthen_prob = ds_hero_info.heroinfo[i].weapon.weapon_info.strength_prob

		for j = 1, table.getn(ds_hero_info.heroinfo[i].weapon.weapon_info.skill_pro) do
			local tmp_skill = CACHE.WeaponSkill()
			tmp_skill._skill_id = ds_hero_info.heroinfo[i].weapon.weapon_info.skill_pro[j].skill_id
			tmp_skill._skill_level = ds_hero_info.heroinfo[i].weapon.weapon_info.skill_pro[j].skill_level
			insert_hero._weapon_info._weapon_pro._skill_pro:Insert(tmp_skill._skill_id, tmp_skill)
		end
		
		tmp_info._oppo_hero_info:PushBack(insert_hero)
	end

	tmp_info._exe_ver = arg.exe_ver
	tmp_info._data_ver = arg.data_ver

	role._roledata._pve_arena_info._pve_arena_history:Insert(role._roledata._pve_arena_info._cur_num, tmp_info)
	role._roledata._pve_arena_info._new_video = 1

	local resp = NewCommand("PveArenaUpdateVideoFlag")
	resp.video_flag = 1
	role:SendToClient(SerializeCommand(resp))
end