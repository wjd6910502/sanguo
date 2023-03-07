--给武将加经验.如果是使用道具的话，那么需要更具返回值在进行是否扣除物品
function HERO_AddExp(role, tid, itemexp)

	API_Log("HERO_AddExp  id="..role._roledata._base._id:ToStr().."   tid="..tid.."   itemexp="..itemexp)
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
	--HERO_UpdateHeroInfo(role, tid)
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
				local tmp = CACHE.HeroSkill()
				tmp._skill_id = skill.normalatk.skillpackageID
				tmp._skill_level = 1
				hero._common_skill:Insert(skill.normalatk.skillpackageID, tmp)
			end
		end
		--无双技能
		for tmp_skill in DataPool_Array(skill.musou) do
			if hero._order >= tmp_skill.skillunlocktupo then
				local hit = hero._skill:Find(tmp_skill.skillpackageID)
				if hit == nil then
					local tmp = CACHE.HeroSkill()
					tmp._skill_id = tmp_skill.skillpackageID
					tmp._skill_level = 1
					hero._skill:Insert(tmp_skill.skillpackageID, tmp)
				end
				if hero._select_skill:Size() == 0 then
					local skill_id = CACHE.Int()
					skill_id._value = tmp_skill.skillpackageID
					hero._select_skill:PushBack(skill_id)
				elseif hero._select_skill:Size() == 1 then
					local select_skill_it = hero._select_skill:SeekToBegin()
					local select_skill = select_skill_it:GetValue()
					while select_skill ~= nil do
						if select_skill._value == skill.shinmusou.skillpackageID then
							local skill_id = CACHE.Int()
							skill_id._value = tmp_skill.skillpackageID
							hero._select_skill:PushBack(skill_id)
						end
						break
					end
				end
			end
		end
		--common_skill
		for tmp_skill in DataPool_Array(skill.C) do
			if hero._star >= tmp_skill.skillunlockstar then
				local hit = hero._common_skill:Find(tmp_skill.skillpackageID)
				if hit == nil then
					local tmp = CACHE.HeroSkill()
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
				local tmp = CACHE.HeroSkill()
				tmp._skill_id = skill.shinmusou.skillpackageID
				tmp._skill_level = 1
				hero._skill:Insert(skill.shinmusou.skillpackageID, tmp)
			
				local skill_id = CACHE.Int()
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
					local tmp = CACHE.HeroSkill()
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
	resp.hero_hall.skin_id = hero._skin
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

	--在这里修改一下武将的战力
	--hero._zhanli = HERO_CalZhanli(role, heroid)
	ROLE_UpdateZhanli(role)
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
function HERO_AddHero(role, heroid, flag, path)
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	local hero = ed:FindBy("hero_id", heroid)

	if hero == nil then
		return
	end
	
	local hero_map = role._roledata._hero_hall._heros
	local h = hero_map:Find(heroid)
	if h ~= nil then
		--转换成武魂物品
		BACKPACK_AddItem(role, hero.soulID, hero.convertsoul, path)
		return
	else
		local tmp_hero = CACHE.RoleHero()
		tmp_hero._tid = heroid
		tmp_hero._level = 1
		tmp_hero._order = hero.originalgrade
		tmp_hero._exp = 0
		tmp_hero._star = hero.originalstar
		tmp_hero._cur_skill_point = 0
		tmp_hero._skin = hero.default_dress
		--判断初始化的时候，武将有什么特技
		local herograde = ed:FindBy("herograde_id", heroid)
		for grade in DataPool_Array(herograde.grade) do
			if grade.grade <= tmp_hero._order then
				if grade.unlockspeciality ~= 0 then
					local speciality_info = ed:FindBy("speciality_id", grade.unlockspeciality)
					local insert_value = CACHE.Int()
					insert_value._value = speciality_info.tejiid*1000+speciality_info.tejilv
					tmp_hero._beidong_skill:PushBack(insert_value)
				end
				--解锁无双技能
				--if grade.unlockswushuang ~= 0 then
				--	local skills = hero._skill		
				--	local tmp = CACHE.HeroSkill()
				--	tmp._skill_id = grade.unlockswushuang
				--	tmp._skill_level = 1
				--	skills:Insert(grade.unlockswushuang,tmp)	
				--end
			end
		end

		--给一个武器
		--BACKPACK_AddItem(role, hero.original_weapon, 1, path)
		BACKPACK_AddInitWeapon(role, hero.original_weapon, 1, path)
		--找到需要装备的武器
		local weapon_items = role._roledata._backpack._weapon_items

		local weapon_item_it = weapon_items._weapon_items:SeekToBegin()
		local weapon_item = weapon_item_it:GetValue()
		while weapon_item ~= nil do
			if weapon_item._base_item._tid == hero.original_weapon then
				tmp_hero._weapon_id = weapon_item._weapon_pro._tid
				break
			end
			weapon_item_it:Next()
			weapon_item = weapon_item_it:GetValue()
		end
		
		hero_map:Insert(heroid, tmp_hero)
		local insert_info = CACHE.SkinInfo()
		insert_info._id = hero.default_dress
		insert_info._time = 0
		role._roledata._backpack._skin_items:Insert(hero.default_dress, insert_info)
		

		HERO_UpdateHeroRelation(role, heroid)
		HERO_UpdateHeroSkill(role, heroid)
		HERO_AddHeroToClient(role, heroid, flag)

		--战力计算
		--local hero_info = hero_map:Find(heroid)
		--hero_info._zhanli = HERO_CalZhanli(role, heroid)
		--role._roledata._status._zhanli = role._roledata._status._zhanli + hero_info._zhanli
		ROLE_UpdateZhanli(role)

		--查看是否有新的头像添加
		ROLE_UpdatePhotoHero(role, heroid)
		
		local cmd = NewCommand("SkinUpdateInfo")
		cmd.addflag = 1
		cmd.skinid = hero.default_dress
		cmd.time = 0
		cmd.item = {}
		role:SendToClient(SerializeCommand(cmd))

		--查看是否播放全服公告
		--发送全服的公告
		local notice_flag = {}
		for i = 1, 3 do
			local tmp_index = "billboard"..i
			if hero[tmp_index] ~= 0 then
				notice_flag[#notice_flag + 1] = hero[tmp_index]
			end
		end
		if path~=nil and path>0 and path<1000 and table.getn(notice_flag)>0 then
			local tmp_index = math.random(table.getn(notice_flag))
			local notice_para = {}
			
			local tmp_notice_para = {}
			tmp_notice_para.typ = 1
			tmp_notice_para.id = role._roledata._base._id:ToStr()
			tmp_notice_para.name = role._roledata._base._name
			tmp_notice_para.num = 0
			notice_para[#notice_para+1] = tmp_notice_para
			
			local tmp_notice_para = {}
			tmp_notice_para.typ = G_NOTICE_TYP["SOURCE"]
			tmp_notice_para.num = path
			notice_para[#notice_para+1] = tmp_notice_para
			
			local tmp_notice_para = {}
			tmp_notice_para.typ = 2
			tmp_notice_para.id = tostring(hero.id)
			tmp_notice_para.name = hero.name
			tmp_notice_para.num = 0
			notice_para[#notice_para+1] = tmp_notice_para

			ROLE_SendNotice(notice_flag[tmp_index], notice_para)
		end
		--判断当前JJC的阵容是否存在了，如果不存在的话就把这个武将添加到JJC阵容里面去
		if role._roledata._pve_arena_info._defence_hero_info:Size() == 0 then
			local value = CACHE.Int()
			value._value = heroid
			role._roledata._pve_arena_info._defence_hero_info:PushBack(value)

			if role._roledata._status._level >= quanju.arena_open_lv then
				local msg = NewMessage("TopListInsertInfo")
				msg.typ = 4
				msg.data = tostring(role._roledata._pve_arena_info._score)
				API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
				
				local msg = NewMessage("RoleUpdatePveArenaMisc")
				API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
				
				local resp = NewCommand("PveArenaUpdateInfo")

				resp.defence_hero = {}

				local heroid_it = role._roledata._pve_arena_info._defence_hero_info:SeekToBegin()
				local heroid = heroid_it:GetValue()
				while heroid ~= nil do
					resp.defence_hero[#resp.defence_hero+1] = heroid._value
					heroid_it:Next()
					heroid = heroid_it:GetValue()
				end

				role:SendToClient(SerializeCommand(resp))
			end
		end

		--成就修改
		TASK_ChangeCondition(role, G_ACH_TYPE["HERO"], heroid, 1)
		TASK_ChangeCondition_Special(role, G_ACH_TYPE["HERO_TUPO"], hero.originalgrade, 0, 1)
		TASK_ChangeCondition_Special(role, G_ACH_TYPE["HERO_STAR"], hero.originalstar, 0, 1)
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
	resp.hero_hall.skin_id = hero._skin
	resp.hero_hall.weapon_id = hero._weapon_id
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

	--更新战力
	--HERO_InitHeroZhanli(role)
	ROLE_UpdateZhanli(role)
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

function HERO_CalZhanli(role, hero_id)
	local hero_info = role._roledata._hero_hall._heros:Find(hero_id)
	local heroinfo = {}
	heroinfo.tid = hero_info._tid
	heroinfo.level = hero_info._level
	heroinfo.star = hero_info._star
	heroinfo.order = hero_info._order --升阶

	heroinfo.skill = {}
	heroinfo.common_skill = {}
	heroinfo.beidong_skill = {}
	local skills = hero_info._skill
	local sit = skills:SeekToBegin()
	local s = sit:GetValue()
	while s ~= nil do
		local h3 = {}
		h3.skill_id = s._skill_id
		h3.skill_level = s._skill_level
		heroinfo.skill[#heroinfo.skill+1] = h3
		sit:Next()
		s = sit:GetValue()
	end
	--武将普通技能赋值
	local common_skills = hero_info._common_skill
	local com_it = common_skills:SeekToBegin()
	local com = com_it:GetValue()
	while com ~= nil do
		local h3 = {}
		h3.skill_id = com._skill_id
		h3.skill_level = com._skill_level
		heroinfo.common_skill[#heroinfo.common_skill+1] = h3
		com_it:Next()
		com = com_it:GetValue()
	end

	local beidong_skill_it = hero_info._beidong_skill:SeekToBegin()
	local beidong_skill = beidong_skill_it:GetValue()
	while beidong_skill ~= nil do
		heroinfo.beidong_skill[#heroinfo.beidong_skill+1] = beidong_skill._value
		beidong_skill_it:Next()
		beidong_skill = beidong_skill_it:GetValue()
	end

	heroinfo.relation = {}

	local relation_it = hero_info._relation:SeekToBegin()
	local relation = relation_it:GetValue()
	while relation ~= nil do
		heroinfo.relation[#heroinfo.relation+1] = relation._value
		relation_it:Next()
		relation = relation_it:GetValue()
	end
	
	heroinfo.weapon = {}
	heroinfo.weapon.base_item = {}
	heroinfo.weapon.weapon_info = {}

	local wenpon_id = hero_info._weapon_id
	if wenpon_id ~= 0 then
		local weapon_items = role._roledata._backpack._weapon_items

		local weapon_item_it = weapon_items._weapon_items:SeekToBegin()
		local weapon_item = weapon_item_it:GetValue()
		while weapon_item ~= nil do
			if weapon_item._weapon_pro._tid == wenpon_id then
				heroinfo.weapon.base_item.tid = weapon_item._base_item._tid
				heroinfo.weapon.base_item.count = weapon_item._base_item._count

				heroinfo.weapon.weapon_info.tid = weapon_item._weapon_pro._tid
				heroinfo.weapon.weapon_info.level = weapon_item._weapon_pro._level
				heroinfo.weapon.weapon_info.star = weapon_item._weapon_pro._star
				heroinfo.weapon.weapon_info.quality = weapon_item._weapon_pro._quality
				heroinfo.weapon.weapon_info.prop = weapon_item._weapon_pro._prop
				heroinfo.weapon.weapon_info.attack = weapon_item._weapon_pro._attack
				heroinfo.weapon.weapon_info.weapon_skill = weapon_item._weapon_pro._weapon_skill
				heroinfo.weapon.weapon_info.strength = weapon_item._weapon_pro._strengthen
				heroinfo.weapon.weapon_info.level_up = weapon_item._weapon_pro._level_up
				heroinfo.weapon.weapon_info.strength_prob = weapon_item._weapon_pro._strengthen_prob
				heroinfo.weapon.weapon_info.skill_pro = {}
				local skill_pro_it = weapon_item._weapon_pro._skill_pro:SeekToBegin()
				local skill_pro = skill_pro_it:GetValue()
				while skill_pro ~= nil do
					local tmp_skill_pro = {}
					tmp_skill_pro.skill_id = skill_pro._skill_id
					tmp_skill_pro.skill_level = skill_pro._skill_level
					heroinfo.weapon.weapon_info.skill_pro[#heroinfo.weapon.weapon_info.skill_pro+1] = tmp_skill_pro
					skill_pro_it:Next()
					skill_pro = skill_pro_it:GetValue()
				end
				break
			end
			weapon_item_it:Next()
			weapon_item = weapon_item_it:GetValue()
		end
	else
		heroinfo.weapon.base_item.tid = 0
	end

	--武将的装备
	heroinfo.equipment = {}
	heroinfo.equipment_set = {}
	local ed = DataPool_Find("elementdata")
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

			heroinfo.equipment[#heroinfo.equipment+1] = tmp_equipment
			--处理套装
			local item = ed:FindBy("item_id", find_equipment._base_item._tid)
			if item ~= nil then
				local equip = ed:FindBy("equip_id", item.type_data1)
				if equip ~= nil then
					if heroinfo.equipment_set[equip.equip_set_id] == nil then
						heroinfo.equipment_set[equip.equip_set_id] = 0
					end

					heroinfo.equipment_set[equip.equip_set_id] = heroinfo.equipment_set[equip.equip_set_id] + 1
				end
			end
		else
			--输出错误日志
		end

		equipment_it:Next()
		equipment = equipment_it:GetValue()
	end

	--军学带来的影响
	local legion_info = {}
	local xiangmu_info_it = role._roledata._legion_info._junxueguan._junxueinfo:SeekToBegin()
	local xiangmu_info = xiangmu_info_it:GetValue()
	while xiangmu_info ~= nil do
		local tmp_info = {}
		tmp_info.id = xiangmu_info._id
		tmp_info.level = xiangmu_info._level
		tmp_info.learned = {}

		local learne_info_it = xiangmu_info._learned:SeekToBegin()
		local learne_info = learne_info_it:GetValue()
		while learne_info ~= nil do
			tmp_info.learned[#tmp_info.learned+1] = learne_info._value
			learne_info_it:Next()
			learne_info = learne_info_it:GetValue()
		end

		xiangmu_info_it:Next()
		xiangmu_info = xiangmu_info_it:GetValue()

		legion_info[#legion_info+1] = tmp_info
	end

	return Property_UpdateHeroInfo(heroinfo, legion_info)
end

--初始化玩家的所有武将的战力
function HERO_InitHeroZhanli(role)
	ROLE_UpdateZhanli(role)
	--role._roledata._status._zhanli = 0
	--local hero_info_it = role._roledata._hero_hall._heros:SeekToBegin()
	--local hero_info = hero_info_it:GetValue()
	--while hero_info ~= nil do
	--	hero_info._beidong_skill:Clear()
	--	if hero_info._beidong_skill:Size() == 0 then
	--		local ed = DataPool_Find("elementdata")
	--		local herograde = ed:FindBy("herograde_id", hero_info._tid)
	--		for grade in DataPool_Array(herograde.grade) do
	--			if grade.grade <= hero_info._order then
	--				if grade.unlockspeciality ~= 0 then
	--					local speciality_info = ed:FindBy("speciality_id", grade.unlockspeciality)
	--					local insert_value = CACHE.Int()
	--					insert_value._value = speciality_info.tejiid*1000+speciality_info.tejilv
	--					hero_info._beidong_skill:PushBack(insert_value)
	--				end
	--			end
	--		end
	--	end
	--	--hero_info._zhanli = HERO_CalZhanli(role, hero_info._tid)
	--	--role._roledata._status._zhanli = role._roledata._status._zhanli + hero_info._zhanli
	--	hero_info_it:Next()
	--	hero_info = hero_info_it:GetValue()
	--end
end
