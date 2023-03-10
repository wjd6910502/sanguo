function OnCommand_PveArenaEndBattle(player, role, arg, others)
--	player:Log("OnCommand_PveArenaEndBattle, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("PveArenaEndBattle_Re")
	local pve_arena = others.pvearena._data
	
	if role._roledata._pve_arena_info._cur_attack_player._id == "" then
		resp.retcode = G_ERRCODE["JJC_END_NO_OPPO"]
		role:SendToClient(SerializeCommand(resp))
		return
	end
	
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.item = {}
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	local prize_id = 0
	
	if arg.win_flag == 1 then
		local tmp_score = role._roledata._pve_arena_info._cur_attack_player._score - role._roledata._pve_arena_info._score
		if tmp_score <= 0 then
			resp.score_change = 16
		else
			tmp_score = math.floor(tmp_score/20)
			if tmp_score < 16 then
				resp.score_change = 16
			else
				resp.score_change = tmp_score
			end
		end
		prize_id = quanju.arena_win_get_coins
	else
		resp.score_change = -10
		prize_id = quanju.arena_fail_get_coins
	end
	
	local reward = DROPITEM_Reward(role, prize_id)
	ROLE_AddReward(role, reward)

	for i = 1, table.getn(reward.item) do
		local tmp_item = {}
		tmp_item.tid = reward.item[i].itemid
		tmp_item.count = reward.item[i].itemnum
		resp.item[#resp.item+1] = tmp_item
	end


	local cur_score = role._roledata._pve_arena_info._score
	role._roledata._pve_arena_info._score = role._roledata._pve_arena_info._score + resp.score_change

	if role._roledata._pve_arena_info._score <= 100 then
		role._roledata._pve_arena_info._score = 100
	end

	PVEARENA_ChangeRoleScore(pve_arena, role, cur_score, role._roledata._pve_arena_info._score)

	local tmp_info = CACHE.PveArenaRoleInfo()
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
					
			tmp_info._self_hero_info:PushBack(insert_hero)
		end
		heroid_it:Next()
		heroid = heroid_it:GetValue()
	end
	
	role._roledata._pve_arena_info._cur_num = role._roledata._pve_arena_info._cur_num + 1

	tmp_info._match_id = role._roledata._pve_arena_info._cur_num
	tmp_info._id = role._roledata._pve_arena_info._cur_attack_player._id
	tmp_info._name = role._roledata._pve_arena_info._cur_attack_player._name
	tmp_info._win_flag = arg.win_flag
	tmp_info._attack_flag = 1
	tmp_info._oppo_hero_info = role._roledata._pve_arena_info._cur_attack_player._hero_info
	tmp_info._self_level = role._roledata._status._level
	tmp_info._oppo_level = role._roledata._pve_arena_info._cur_attack_player._level
	tmp_info._self_mafia = role._roledata._mafia._name
	tmp_info._oppo_mafia = role._roledata._pve_arena_info._cur_attack_player._mafia_name
	if table.getn(arg.operation.operation) == 0 then
		tmp_info._reply_flag = 0
	else
		tmp_info._reply_flag = 1
	end

	
	local os = {}
	__SerializeStruct(os, "PveArenaOperation", arg.operation)
	tmp_info._operation = table.concat(os)
	tmp_info._time = API_GetTime()

	tmp_info._exe_ver = role._roledata._client_ver._exe_ver
	tmp_info._data_ver = role._roledata._client_ver._data_ver

	role._roledata._pve_arena_info._pve_arena_history:Insert(role._roledata._pve_arena_info._cur_num, tmp_info)

	--????????????????????????????????????
	local msg = NewMessage("RoleUpdateDefencePlayerPveArenaInfo")
	msg.id = role._roledata._base._id:ToStr()
	msg.name = role._roledata._base._name
	msg.win_flag = tmp_info._win_flag
	msg.operation = tmp_info._operation
	msg.level = role._roledata._status._level
	msg.mafia_name = role._roledata._mafia._name
	msg.score = role._roledata._pve_arena_info._score - resp.score_change
	msg.reply_flag = tmp_info._reply_flag
	msg.exe_ver = tmp_info._exe_ver
	msg.data_ver = tmp_info._data_ver

	local pve_arena_hero_info = NewStruct("RolePveArenaInfo")
	pve_arena_hero_info.heroinfo = {}
	
	local cur_hero_info = tmp_info._self_hero_info
	local cur_hero_info_it = cur_hero_info:SeekToBegin()
	local hero_info = cur_hero_info_it:GetValue()
	while hero_info ~= nil do
		local tmp_hero = {}
		tmp_hero.id = hero_info._heroid
		tmp_hero.level = hero_info._level
		tmp_hero.star = hero_info._star
		tmp_hero.grade = hero_info._grade
		
		tmp_hero.skill = {}
		tmp_hero.common_skill = {}
		tmp_hero.select_skill = {}
		
		local skills = hero_info._skill
		local sit = skills:SeekToBegin()
		local s = sit:GetValue()
		while s ~= nil do
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
			tmp_hero.select_skill[#tmp_hero.select_skill+1] = select_skill._value
			select_skill_it:Next()
			select_skill = select_skill_it:GetValue()
		end

		--????????
		tmp_hero.relations = {}
		local relations = hero_info._relations
		local relation_it = relations:SeekToBegin()
		local relation = relation_it:GetValue()
		while relation ~= nil do
			tmp_hero.relations[#tmp_hero.relations+1] = relation._value
			relation_it:Next()
			relation = relation_it:GetValue()
		end
		--????????
		tmp_hero.weapon = {}
		tmp_hero.weapon.base_item = {}
		tmp_hero.weapon.weapon_info = {}

		tmp_hero.weapon.base_item.tid = hero_info._weapon_info._base_item._tid
		tmp_hero.weapon.base_item.count = hero_info._weapon_info._base_item._count

		tmp_hero.weapon.weapon_info.tid = hero_info._weapon_info._weapon_pro._tid
		tmp_hero.weapon.weapon_info.level = hero_info._weapon_info._weapon_pro._level
		tmp_hero.weapon.weapon_info.star = hero_info._weapon_info._weapon_pro._star
		tmp_hero.weapon.weapon_info.quality = hero_info._weapon_info._weapon_pro._quality
		tmp_hero.weapon.weapon_info.prop = hero_info._weapon_info._weapon_pro._prop
		tmp_hero.weapon.weapon_info.attack = hero_info._weapon_info._weapon_pro._attack
		tmp_hero.weapon.weapon_info.strength = hero_info._weapon_info._weapon_pro._strengthen
		tmp_hero.weapon.weapon_info.level_up = hero_info._weapon_info._weapon_pro._level_up
		tmp_hero.weapon.weapon_info.weapon_skill = hero_info._weapon_info._weapon_pro._weapon_skill
		tmp_hero.weapon.weapon_info.strength_prob = hero_info._weapon_info._weapon_pro._strengthen_prob
		tmp_hero.weapon.weapon_info.skill_pro = {}

		local skill_info_it = hero_info._weapon_info._weapon_pro._skill_pro:SeekToBegin()
		local skill_info = skill_info_it:GetValue()
		while skill_info ~= nil do
			local tmp_skill = {}
			tmp_skill.skill_id = skill_info._skill_id
			tmp_skill.skill_level = skill_info._skill_level
			tmp_hero.weapon.weapon_info.skill_pro[#tmp_hero.weapon.weapon_info.skill_pro+1] = tmp_skill
			skill_info_it:Next()
			skill_info = skill_info_it:GetValue()
		end

		pve_arena_hero_info.heroinfo[#pve_arena_hero_info.heroinfo+1] = tmp_hero

		cur_hero_info_it:Next()
		hero_info = cur_hero_info_it:GetValue()
	end
	local os = {}
	SerializeStruct(os, pve_arena_hero_info)

	msg.self_hero_info = table.concat(os)
	
	local pve_arena_hero_info = NewStruct("RolePveArenaInfo")
	pve_arena_hero_info.heroinfo = {}
	
	local cur_hero_info = tmp_info._oppo_hero_info
	local cur_hero_info_it = cur_hero_info:SeekToBegin()
	local hero_info = cur_hero_info_it:GetValue()
	while hero_info ~= nil do
		local tmp_hero = {}
		tmp_hero.id = hero_info._heroid
		tmp_hero.level = hero_info._level
		tmp_hero.star = hero_info._star
		tmp_hero.grade = hero_info._grade
		
		tmp_hero.skill = {}
		tmp_hero.common_skill = {}
		tmp_hero.select_skill = {}
		
		local skills = hero_info._skill
		local sit = skills:SeekToBegin()
		local s = sit:GetValue()
		while s ~= nil do
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
			tmp_hero.select_skill[#tmp_hero.select_skill+1] = select_skill._value
			select_skill_it:Next()
			select_skill = select_skill_it:GetValue()
		end
		
		--????????
		tmp_hero.relations = {}
		local relations = hero_info._relations
		local relation_it = relations:SeekToBegin()
		local relation = relation_it:GetValue()
		while relation ~= nil do
			tmp_hero.relations[#tmp_hero.relations+1] = relation._value
			relation_it:Next()
			relation = relation_it:GetValue()
		end
		--????????
		tmp_hero.weapon = {}
		tmp_hero.weapon.base_item = {}
		tmp_hero.weapon.weapon_info = {}

		tmp_hero.weapon.base_item.tid = hero_info._weapon_info._base_item._tid
		tmp_hero.weapon.base_item.count = hero_info._weapon_info._base_item._count

		tmp_hero.weapon.weapon_info.tid = hero_info._weapon_info._weapon_pro._tid
		tmp_hero.weapon.weapon_info.level = hero_info._weapon_info._weapon_pro._level
		tmp_hero.weapon.weapon_info.star = hero_info._weapon_info._weapon_pro._star
		tmp_hero.weapon.weapon_info.quality = hero_info._weapon_info._weapon_pro._quality
		tmp_hero.weapon.weapon_info.prop = hero_info._weapon_info._weapon_pro._prop
		tmp_hero.weapon.weapon_info.attack = hero_info._weapon_info._weapon_pro._attack
		tmp_hero.weapon.weapon_info.strength = hero_info._weapon_info._weapon_pro._strengthen
		tmp_hero.weapon.weapon_info.level_up = hero_info._weapon_info._weapon_pro._level_up
		tmp_hero.weapon.weapon_info.weapon_skill = hero_info._weapon_info._weapon_pro._weapon_skill
		tmp_hero.weapon.weapon_info.strength_prob = hero_info._weapon_info._weapon_pro._strengthen_prob
		tmp_hero.weapon.weapon_info.skill_pro = {}

		local skill_info_it = hero_info._weapon_info._weapon_pro._skill_pro:SeekToBegin()
		local skill_info = skill_info_it:GetValue()
		while skill_info ~= nil do
			local tmp_skill = {}
			tmp_skill.skill_id = skill_info._skill_id
			tmp_skill.skill_level = skill_info._skill_level
			tmp_hero.weapon.weapon_info.skill_pro[#tmp_hero.weapon.weapon_info.skill_pro+1] = tmp_skill
			skill_info_it:Next()
			skill_info = skill_info_it:GetValue()
		end
				
		pve_arena_hero_info.heroinfo[#pve_arena_hero_info.heroinfo+1] = tmp_hero
		
		cur_hero_info_it:Next()
		hero_info = cur_hero_info_it:GetValue()
	end
	local os = {}
	SerializeStruct(os, pve_arena_hero_info)

	msg.oppo_hero_info = table.concat(os)

	API_SendMsg(tmp_info._id, SerializeMessage(msg), 0)
	role:SendToClient(SerializeCommand(resp))

	role._roledata._pve_arena_info._cur_attack_player._id = ""
	role._roledata._pve_arena_info._cur_attack_player._name = ""
	role._roledata._pve_arena_info._cur_attack_player._level = 0
	role._roledata._pve_arena_info._cur_attack_player._mafia_name = ""
	role._roledata._pve_arena_info._cur_attack_player._hero_info:Clear()
	role._roledata._pve_arena_info._cur_attack_player._score = 0
	return
end
