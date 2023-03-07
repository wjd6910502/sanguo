--给武将加经验.如果是使用道具的话，那么需要更具返回值在进行是否扣除物品
function HERO_AddExp(role, tid, itemexp)

	--首先判断是否有这个武将，没有的话怎么办。
	local heros = role._roledata._hero_hall._heros
	local hero = heros:Find(tid)
	if hero == nil then
		return G_ERRCODE["NO_HERO"]
	end
	--判断等级，经验
	local role_level = role._roledata._status._level
	local hero_level = hero._level
	local hero_exp = hero._exp
	local hero_order = hero._order

	if hero_level >= role_level then
		return G_ERRCODE["HERO_EXP_FULL"]
	end
	
	--得到武将的升级表
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	if hero_level >= quanju.role_maxlv then
		return G_ERRCODE["HERO_EXP_FULL"]
	end
	--当前等级不再跟界别挂钩了
	--local herograde = ed:FindBy("herograde_id", tid)
	--local max_level = 0
	--for grade in DataPool_Array(herograde.grade) do
	--	if grade.grade == hero_order then
	--		max_level = grade.max_lv
	--		break
	--	end
	--end
	--if max_level == 0 then
	--	return G_ERRCODE["NO_HERO"]
	--end

	--local flag = 1
	--local need_exp = 0
	--for tmp_exp in DataPool_Array(hero_levelup.rolelevelexp) do
	--	if flag == hero_level then
	--		need_exp = tmp_exp
	--		break
	--	end
	--	flag = flag + 1
	--end

	--local can_max_level = 0
	--if max_level > role_level then
	--	can_max_level = role_level
	--else
	--	can_max_level = max_level
	--end
	----是否达到了当前界别的最高等级
	--if can_max_level == hero_level and hero_exp == need_exp then
	--	return G_ERRCODE["HERO_EXP_FULL"]
	--end

	--开始给武将升级
	hero._exp = hero._exp + itemexp

	local level_flag = 0
	local herolevelinfo = ed:FindBy("rolelevel_id", hero._level)
	while hero._exp >= herolevelinfo.needexp do
		if role_level == hero._level then
			if hero._exp > herolevelinfo.needexp then
				hero._exp = herolevelinfo.needexp
			end
			break
		else
			level_flag = 1
			hero._level = hero._level + 1
			hero._exp = hero._exp - herolevelinfo.needexp
			hero._cur_skill_point = hero._cur_skill_point + herolevelinfo.skillpoint
		end
	
		herolevelinfo = ed:FindBy("rolelevel_id", hero._level)
	end
	HERO_UpdateHeroInfo(role, tid)
	return G_ERRCODE["SUCCESS"]
end

--武将进阶的接口
function HERO_UpGrade(role, heroid)
	--首先判断是否有这个武将，没有的话怎么办。
	local heros = role._roledata._hero_hall._heros
	local hero = heros:Find(heroid)
	if hero == nil then
		return G_ERRCODE["NO_HERO"]
	end
	--判断界别是否达到了最高
	local hero_order = hero._order

	if hero_order >= 12 then
		return G_ERRCODE["MAX_HERO_ORDER"]
	end

	local ed = DataPool_Find("elementdata")
	local herograde = ed:FindBy("herograde_id", heroid)
	local item_id1 = 0
	local item_count1 = 0
	local item_id2 = 0
	local item_count2 = 0
	local max_level = 0
	for grade in DataPool_Array(herograde.grade) do
		if grade.grade == hero_order then
			max_level = grade.max_lv
			item_id1 = grade.material1
			item_count1 = grade.material1_quantity
			item_id2 = grade.material2
			item_count2 = grade.material2_quantity
			break
		end
	end

	--判断是否达到了当前界别的最高等级
	if hero._level < max_level then
		return G_ERRCODE["NOT_MAX_LEVEL_ORDER"]
	end
	
	--判断物品是否存在
	if item_id1 > 0 then
		if BACKPACK_HaveItem(role, item_id1, item_count1) == false then
			return G_ERRCODE["ITEM_COUNT_LESS"]
		end
	end
	
	if item_id2 > 0 then
		if BACKPACK_HaveItem(role, item_id2, item_count2) == false then
			return G_ERRCODE["ITEM_COUNT_LESS"]
		end
	end

	--在这里开始扣除材料，修改武将的界别
	if item_id1 > 0 then
		BACKPACK_DelItem(role, item_id1, item_count1)
	end
	if item_id2 > 0 then
		BACKPACK_DelItem(role, item_id2, item_count2)
	end

	hero._order = hero._order + 1
	
	--给客户端发送武将信息的修改
	HERO_UpdateHeroInfo(role, heroid)
	return G_ERRCODE["SUCCESS"]
end

function HERO_UpdateHeroSkill(role, tid)
	local heros = role._roledata._hero_hall._heros
	local hero = heros:Find(tid)

	local ed = DataPool_Find("elementdata")
	local heroinfo = ed:FindBy("hero_id", tid)

	if heroinfo.fightscriptid ~= 0 then
		local skill = ed:FindBy("skill_id", heroinfo.fightscriptid)
		--普通攻击技能
		local hit = hero._common_skill:Find(skill.normalatk.skillpackageID)
		if hit == nil then
			if hero._star >= skill.normalatk.skillunlockstar then
				local tmp = CACHE.HeroSkill:new()
				tmp._skill_id = skill.normalatk.skillpackageID
				tmp._skill_level = 1
				hero._common_skill:Insert(skill.normalatk.skillpackageID, tmp)
			end
		end
		--无双技能
		for tmp_skill in DataPool_Array(skill.musou) do
			if hero._star >= tmp_skill.skillunlockstar then
				local hit = hero._skill:Find(tmp_skill.skillpackageID)
				if hit == nil then
					local tmp = CACHE.HeroSkill:new()
					tmp._skill_id = tmp_skill.skillpackageID
					tmp._skill_level = 1
					hero._skill:Insert(tmp_skill.skillpackageID, tmp)
				end
				if hero._select_skill:Size() == 0 then
					local skill_id = CACHE.Int:new()
					skill_id._value = tmp_skill.skillpackageID
					hero._select_skill:PushBack(skill_id)
				end
			end
		end
		--common_skill
		for tmp_skill in DataPool_Array(skill.C) do
			if hero._star >= tmp_skill.skillunlockstar then
				local hit = hero._common_skill:Find(tmp_skill.skillpackageID)
				if hit == nil then
					local tmp = CACHE.HeroSkill:new()
					tmp._skill_id = tmp_skill.skillpackageID
					tmp._skill_level = 1
					hero._common_skill:Insert(tmp_skill.skillpackageID, tmp)
				end
			end
		end
		--大无双
		if hero._star >= skill.shinmusou.skillunlockstar then
			local hit = hero._skill:Find(skill.shinmusou.skillpackageID)
			if hit == nil then
				local tmp = CACHE.HeroSkill:new()
				tmp._skill_id = skill.shinmusou.skillpackageID
				tmp._skill_level = 1
				hero._skill:Insert(skill.shinmusou.skillpackageID, tmp)
			
				local skill_id = CACHE.Int:new()
				skill_id._value = skill.shinmusou.skillpackageID
				hero._select_skill:PushBack(skill_id)
			end
		end
	end
	--马战技能
	if heroinfo.ridescriptid ~= 0 then
		local rideskill = ed:FindBy("skill_id", heroinfo.ridescriptid)
		if rideskill ~= nil then
			local ridehit = hero._common_skill:Find(rideskill.normalatk.skillpackageID)
			if ridehit == nil then
				if hero._star >= rideskill.normalatk.skillunlockstar then
					local tmp = CACHE.HeroSkill:new()
					tmp._skill_id = rideskill.normalatk.skillpackageID
					tmp._skill_level = 1
					hero._common_skill:Insert(rideskill.normalatk.skillpackageID, tmp)
				end
			end
		end
	end
end

function HERO_UpdateHeroInfo(role, heroid)
	--给客户端发送武将信息的修改
	local heros = role._roledata._hero_hall._heros
	local hero = heros:Find(heroid)
	local resp = NewCommand("UpdateHeroInfo")
	resp.hero_hall = {}
	resp.hero_hall.tid = heroid
	resp.hero_hall.level = hero._level
	resp.hero_hall.order = hero._order
	resp.hero_hall.exp = hero._exp
	resp.hero_hall.star = hero._star
	resp.hero_hall.skillpoint = hero._cur_skill_point
	resp.hero_hall.weapon_id = hero._weapon_id
	resp.hero_hall.skill = {}
	resp.hero_hall.common_skill = {}
	resp.hero_hall.select_skill = {}
	resp.hero_hall.equipment = {}
	--武将无双技能赋值
	local skills = hero._skill
	local sit = skills:SeekToBegin()
	local s = sit:GetValue()
	while s ~= nil do
		local h3 = {}
		h3.skill_id = s._skill_id
		h3.skill_level = s._skill_level
		resp.hero_hall.skill[#resp.hero_hall.skill+1] = h3
		sit:Next()
		s = sit:GetValue()
	end
	--武将普通技能赋值
	local common_skills = hero._common_skill
	local com_it = common_skills:SeekToBegin()
	local com = com_it:GetValue()
	while com ~= nil do
		local h3 = {}
		h3.skill_id = com._skill_id
		h3.skill_level = com._skill_level
		resp.hero_hall.common_skill[#resp.hero_hall.common_skill+1] = h3
		com_it:Next()
		com = com_it:GetValue()
	end
	--武将已经选择的必杀技能进行修改
	local select_skills = hero._select_skill
	local select_skill_it = select_skills:SeekToBegin()
	local select_skill = select_skill_it:GetValue()
	while select_skill ~= nil do
		resp.hero_hall.select_skill[#resp.hero_hall.select_skill+1] = select_skill._value
		select_skill_it:Next()
		select_skill = select_skill_it:GetValue()
	end
	--武将的装备信息
	local equipments = hero._equipment
	local equipment_it = equipments:SeekToBegin()
	local equipment = equipment_it:GetValue()
	while equipment ~= nil do
		local tmp_equipment = {}
		tmp_equipment.pos = equipment._pos
		tmp_equipment.equipment_id = equipment._id
		resp.hero_hall.equipment[#resp.hero_hall.equipment+1] = tmp_equipment

		equipment_it:Next()
		equipment = equipment_it:GetValue()
	end
	role:SendToClient(SerializeCommand(resp))

	--在这里进行一次修改,只要武将的信息修改以后，基本都会走这个协议的。
	ROLE_UpdateMiscPveArenaHeroInfo(role, heroid)
end

function HERO_UpgradeSkill(role, heroid, skillid)
	--首先判断是否有这个武将，没有的话怎么办。
	local heros = role._roledata._hero_hall._heros
	local hero = heros:Find(heroid)

	local ed = DataPool_Find("elementdata")
	local skillpackage = ed:FindBy("skillpackage_id", skillid)
	if skillpackage.functionname == "" then
		return G_ERRCODE["HERO_SKILL_NOT_LEVELUP"]
	end

	if hero == nil then
		return G_ERRCODE["NO_HERO"]
	end

	if role._roledata._status._hero_skill_point <= 0 then
		return G_ERRCODE["HERO_SKILL_POINT_LESS"]
	end

	--判断这个武将是否有这个技能
	local skill_level = 0
	local skills = hero._skill
	local common_skills = hero._common_skill
	local skill = skills:Find(skillid)
	local common_skill = common_skills:Find(skillid)
	
	if skill ~= nil then
		skill_level = skill._skill_level
	elseif common_skill ~= nil then
		skill_level = common_skill._skill_level
	end
	
	if skill_level == 0 then
		return G_ERRCODE["HERO_NO_SKILLID"]
	end

	if skill_level >= hero._level then
		return G_ERRCODE["HERO_SKILLLV_MAX"]
	end

	--判断升级所需要的金钱是否足够
	local ed = DataPool_Find("elementdata")
	local hero_skilllevelup = ed.skilllvup
	local needmoney = -1
	local flag = 1
	for tmp_money in DataPool_Array(hero_skilllevelup.skilllvupprice) do
		if flag == skill_level then
			needmoney = tmp_money
			break
		end
		flag = flag + 1
	end

	if needmoney < 0 then
		return G_ERRCODE["HERO_SKILLLV_WRONG"]
	end

	if role._roledata._status._money < needmoney then
		return G_ERRCODE["HERO_SKILLLV_MONEY_LESS"]
	end

	--扣钱，加技能等级
	ROLE_SubMoney(role, needmoney)

	if skill ~= nil then
		skill._skill_level = skill._skill_level + 1
	elseif common_skill ~= nil then
		common_skill._skill_level = common_skill._skill_level + 1
	end

	--给客户端发送技能点变化的值
	role._roledata._status._hero_skill_point = role._roledata._status._hero_skill_point - 1
	local resp = NewCommand("UpdateHeroSkillPoint")
	resp.point = role._roledata._status._hero_skill_point
	role:SendToClient(SerializeCommand(resp))
	local max_point = ROLE_GetMaxHeroSkillPoint(role)
	if role._roledata._status._hero_skill_point_refreshtime == 0 then
		if role._roledata._status._hero_skill_point < max_point then
			role._roledata._status._hero_skill_point_refreshtime = API_GetTime()
		
			local resp = NewCommand("GetSkillPointRefreshTime_Re")
			resp.refresh_time = role._roledata._status._hero_skill_point_refreshtime

			player:SendToClient(SerializeCommand(resp))
		end
	end
	return G_ERRCODE["SUCCESS"]
end

--flag表示告诉客户端是否需要播放特效,1代表播放，0代表不播放
function HERO_AddHero(role, heroid, flag)
	local ed = DataPool_Find("elementdata")
	local hero = ed:FindBy("hero_id", heroid)

	if hero == nil then
		return
	end
	
	local hero_map = role._roledata._hero_hall._heros
	local h = hero_map:Find(heroid)
	if h ~= nil then
		--转换成武魂物品
		BACKPACK_AddItem(role, hero.soulID, hero.convertsoul)
		return
	else
		local tmp_hero = CACHE.RoleHero:new()
		tmp_hero._tid = heroid
		tmp_hero._level = 1
		tmp_hero._order = hero.originalgrade
		tmp_hero._exp = 0
		tmp_hero._star = hero.originalstar
		tmp_hero._cur_skill_point = 0

		hero_map:Insert(heroid, tmp_hero)

		HERO_UpdateHeroRelation(role, heroid)
		HERO_UpdateHeroSkill(role, heroid)
		HERO_AddHeroToClient(role, heroid, flag)
		return
	end
end

function HERO_AddHeroToClient(role, heroid, flag)
	--给客户端发送武将信息的修改
	local heros = role._roledata._hero_hall._heros
	local hero = heros:Find(heroid)
	local resp = NewCommand("AddHero")
	resp.flag = flag
	resp.hero_hall = {}
	resp.hero_hall.tid = heroid
	resp.hero_hall.level = hero._level
	resp.hero_hall.order = hero._order
	resp.hero_hall.exp = hero._exp
	resp.hero_hall.star = hero._star
	resp.hero_hall.skill = {}
	resp.hero_hall.common_skill = {}
	resp.hero_hall.select_skill = {}
	--武将无双技能赋值
	local skills = hero._skill
	local sit = skills:SeekToBegin()
	local s = sit:GetValue()
	while s ~= nil do
		local h3 = {}
		h3.skill_id = s._skill_id
		h3.skill_level = s._skill_level
		resp.hero_hall.skill[#resp.hero_hall.skill+1] = h3
		sit:Next()
		s = sit:GetValue()
	end
	--武将普通技能赋值
	local common_skills = hero._common_skill
	local com_it = common_skills:SeekToBegin()
	local com = com_it:GetValue()
	while com ~= nil do
		local h3 = {}
		h3.skill_id = com._skill_id
		h3.skill_level = com._skill_level
		resp.hero_hall.common_skill[#resp.hero_hall.common_skill+1] = h3
		com_it:Next()
		com = com_it:GetValue()
	end
	--武将已经选择的必杀技能进行修改
	local select_skills = hero._select_skill
	local select_skill_it = select_skills:SeekToBegin()
	local select_skill = select_skill_it:GetValue()
	while select_skill ~= nil do
		resp.hero_hall.select_skill[#resp.hero_hall.select_skill+1] = select_skill._value
		select_skill_it:Next()
		select_skill = select_skill_it:GetValue()
	end
	role:SendToClient(SerializeCommand(resp))
end

--获得新英雄的时候触发的羁绊效果
function HERO_UpdateHeroRelation(role, heroid)
	local heros = role._roledata._hero_hall._heros
	local ed = DataPool_Find("elementdata")

	--是否会影响到JJC上面武将的信息
	local update_flag = 0

	local hero_it = heros:SeekToBegin()
	local hero = hero_it:GetValue()
	while hero ~= nil do
		local heroinfo = ed:FindBy("hero_id", hero._tid)
		for relation in DataPool_Array(heroinfo.relationID) do
			if relation ~= 0 then
				local relation_info = ed:FindBy("relation_id", relation)
				local need_flag = 0
				if relation_info.conditiontype == 1 then
					for need_hero in DataPool_Array(relation_info.conditionparameter) do
						if need_hero ~= 0 and need_hero == heroid then
							need_flag = 1
							break
						end
					end

					local active_relation = 1
					if need_flag == 1 then
						for need_hero in DataPool_Array(relation_info.conditionparameter) do
							if need_hero ~= 0 and need_hero ~= heroid then
								local find_hero = heros:Find(need_hero)
								if find_hero == nil then
									active_relation = 0
									break
								end
							end
						end
					else
						active_relation = 0
					end

					if active_relation == 1 then
						local add_relation = CACHE.Int()
						add_relation._value = relation
						hero._relation:Insert(relation ,add_relation)

						--查看是否这个武将是JJC武将
						local tmp_hero_it = role._roledata._pve_arena_info._defence_hero_info:SeekToBegin()
						local tmp_hero = tmp_hero_it:GetValue()
						while tmp_hero ~= nil do
							if tmp_hero._value == hero._tid then
								update_flag = 1
								break
							end
							tmp_hero_it:Next()
							tmp_hero = tmp_hero_it:GetValue()
						end
					end
				end
			end
		end
		hero_it:Next()
		hero = hero_it:GetValue()
	end

	--开始查看自己的羁绊是否会被激活了
	local hero = heros:Find(heroid)
	local heroinfo = ed:FindBy("hero_id", hero._tid)

	for relation in DataPool_Array(heroinfo.relationID) do
		if relation ~= 0 then
			local relation_info = ed:FindBy("relation_id", relation)
			if relation_info.conditiontype == 1 then
				local active_relation = 1
				for need_hero in DataPool_Array(relation_info.conditionparameter) do
					if need_hero ~= 0 then
						local find_hero = heros:Find(need_hero)
						if find_hero == nil then
							active_relation = 0
							break
						end
					end
				end

				if active_relation == 1 then
					local add_relation = CACHE.Int()
					add_relation._value = relation
					hero._relation:Insert(relation, add_relation)
				end
			end
		end
	end

	--查看是否这个武将是JJC武将
	local tmp_hero_it = role._roledata._pve_arena_info._defence_hero_info:SeekToBegin()
	local tmp_hero = tmp_hero_it:GetValue()
	while tmp_hero ~= nil do
		if tmp_hero._value == heroid then
			update_flag = 1
			break
		end
		tmp_hero_it:Next()
		tmp_hero = tmp_hero_it:GetValue()
	end

	if update_flag == 1 then
		tmp_hero_it = role._roledata._pve_arena_info._defence_hero_info:SeekToBegin()
		tmp_hero = tmp_hero_it:GetValue()
		ROLE_UpdateMiscPveArenaHeroInfo(role, tmp_hero._value)
	end
end

--上线的时候进行的刷新
function HERO_UpdateHeroRelationOnline(role)
	local heros = role._roledata._hero_hall._heros
	local ed = DataPool_Find("elementdata")
	
	local hero_it = heros:SeekToBegin()
	local hero = hero_it:GetValue()
	while hero ~= nil do
		local heroinfo = ed:FindBy("hero_id", hero._tid)
		for relation in DataPool_Array(heroinfo.relationID) do
			if relation ~= 0 then
				local relation_info = ed:FindBy("relation_id", relation)
				if relation_info.conditiontype == 1 then
					local active_relation = 1
					for need_hero in DataPool_Array(relation_info.conditionparameter) do
						if need_hero ~= 0 then
							local find_hero = heros:Find(need_hero)
							if find_hero == nil then
								active_relation = 0
								break
							end
						end
					end

					if active_relation == 1 then
						local add_relation = CACHE.Int()
						add_relation._value = relation
						hero._relation:Insert(relation ,add_relation)
					end
				end
			end
		end
		hero_it:Next()
		hero = hero_it:GetValue()
	end
end
