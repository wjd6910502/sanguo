function ROLE_Init(role)
	role._roledata._status._level = 1
	role._roledata._status._vp = 60
	role._roledata._status._vp_refreshtime = 0
	role._roledata._status._money = 0
	role._roledata._status._yuanbao = 0
	role._roledata._status._exp:Set(0)
	--初始化的时候把PVP匹配的预计时间设置成60秒
	role._roledata._pvp_info._pvp_time = 60
	role._roledata._pvp_info._pvp_grade = 25
	role._roledata._pvp_info._cur_star = 0

	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	role._roledata._pvp_info._elo_score = quanju.pvp_initial_elo_score

	--初始化的时候给一匹马
	local tmp = CACHE.RoleHorse:new()
	tmp._tid = quanju.init_horse_id
	role._roledata._horse_hall._horses:Insert(quanju.init_horse_id,tmp)

	--初始化的时候给一个武将
	local hero = ed:FindBy("hero_id", quanju.init_role_id)
	local tmp_hero = CACHE.RoleHero:new()
	tmp_hero._tid = quanju.init_role_id
	tmp_hero._level = 1
	tmp_hero._order = hero.originalgrade
	tmp_hero._exp = 0
	tmp_hero._star = hero.originalstar
	--判断初始化的时候，武将有什么特技
	local herograde = ed:FindBy("herograde_id", quanju.init_role_id)
	for grade in DataPool_Array(herograde.grade) do
		if grade.grade <= tmp_hero._order then
			if grade.unlockspeciality ~= 0 then
				local speciality_info = ed:FindBy("speciality_id", grade.unlockspeciality)
				local insert_value = CACHE.Int()
				insert_value._value = speciality_info.tejiid*1000+speciality_info.tejilv
				tmp_hero._beidong_skill:PushBack(insert_value)
			end
		end
	end

	role._roledata._hero_hall._heros:Insert(quanju.init_role_id, tmp_hero)

	HERO_UpdateHeroSkill(role, quanju.init_role_id)

	--在这里设置初始出战武将
	role._roledata._status._last_hero:Clear()
	local value = CACHE.Int:new()
	value._value = quanju.init_role_id
	role._roledata._status._last_hero:PushBack(value)
	
	role._roledata._pvp_info._last_hero:Clear()
	local value = CACHE.Int:new()
	value._value = quanju.init_role_id
	role._roledata._pvp_info._last_hero:PushBack(value)
	
	role._roledata._status._last_horse_hero._heroinfo:Clear()
	role._roledata._status._last_horse_hero._horse = 0
	local value = CACHE.Int:new()
	value._value = quanju.init_role_id
	role._roledata._status._last_horse_hero._heroinfo:PushBack(value)
	role._roledata._status._last_horse_hero._horse = quanju.init_horse_id
	
	--初始化武将的技能点
	role._roledata._status._hero_skill_point = ROLE_GetMaxHeroSkillPoint(role)
	role._roledata._status._hero_skill_point_refreshtime = 0

	--初始化玩家的武者试炼信息
	ROLE_UpdateWuZheShiLianInfo(role)

	--test code
	if role._roledata._pve_arena_info._score == 0 then
		role._roledata._pve_arena_info._score = quanju.arena_initial_score
		role._roledata._pve_arena_info._defence_hero_info:Clear()

		local hero_it = role._roledata._status._last_hero:SeekToBegin()
		local hero = hero_it:GetValue()
		while hero ~= nil do
			local value = CACHE.Int:new()
			value._value = hero._value
			role._roledata._pve_arena_info._defence_hero_info:PushBack(value)
			hero_it:Next()
			hero = hero_it:GetValue()
		end

		local msg = NewMessage("RoleUpdatePveArenaTop")
		API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
		
		local msg = NewMessage("RoleUpdatePveArenaMisc")
		API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)

	end
	--HERO_InitHeroZhanli(role)
	ROLE_UpdateZhanli(role)
	--overload for test
	--local list = CACHE.OverLoadList()
	--local str = CACHE.Str()

	--for i=1,1000 do
	--	str._value = "NUMBER: "..i
	--	list:PushBack(str)
	--	role._roledata._overload:Insert(i, list)
	--end

	local list = role._roledata._overload_list
	local str = CACHE.Str()
	for i=1,1000 do
		str._value = "NUMBER: "..i
		list:PushBack(str)
	end
end

function ROLE_Copy(role, src_role)
	role._roledata._status._level = src_role._roledata._status._level
	role._roledata._status._exp = src_role._roledata._status._exp
	role._roledata._status._money = src_role._roledata._status._money
	role._roledata._status._yuanbao = src_role._roledata._status._yuanbao
	role._roledata._hero_hall = src_role._roledata._hero_hall
	role._roledata._backpack = src_role._roledata._backpack
	role._roledata._rep_info = src_role._roledata._rep_info
	role._roledata._horse_hall = src_role._roledata._horse_hall
	--TODO: 临时的, 以后不用拷贝
	role._roledata._status._instances = src_role._roledata._status._instances
end

function ROLE_PostInit(role)
	--TODO:
end

function ROLE_MakeRoleInfo(role)
	local roleinfo = {}
	--base
	roleinfo.base = {}
	roleinfo.base.id = role._roledata._base._id:ToStr()
	roleinfo.base.name = role._roledata._base._name
	roleinfo.base.photo = role._roledata._base._photo
	--status
	roleinfo.status = {}
	roleinfo.status.level = role._roledata._status._level
	roleinfo.status.exp = role._roledata._status._exp:ToStr()
	roleinfo.status.vp = role._roledata._status._vp
	roleinfo.status.lottery_one_flag = role._roledata._status._lottery_one_flag
	roleinfo.status.lottery_ten_flag = role._roledata._status._lottery_ten_flag
	--status.instances
	roleinfo.status.instances = {}
	local instances = role._roledata._status._instances
	local iit = instances:SeekToBegin() --从头开始遍历
	local i = iit:GetValue()
	while i~=nil do
		local i2 = {}
		i2.tid = i._tid
		i2.score = i._score
		roleinfo.status.instances[#roleinfo.status.instances+1] = i2
		iit:Next()
		i = iit:GetValue()
	end
	roleinfo.status.money = role._roledata._status._money
	roleinfo.status.yuanbao = role._roledata._status._yuanbao
	roleinfo.status.chongzhi = role._roledata._status._chongzhi
	roleinfo.status.hero_skill_point = role._roledata._status._hero_skill_point
	--status.common_use_limit
	roleinfo.status.common_use_limit = {}
	local common_use_limit = role._roledata._status._common_use_limit
	local cit = common_use_limit:SeekToBegin()
	local c = cit:GetValue()
	while c ~= nil do
		local c2 = {}
		c2.tid = c._tid
		c2.count = c._count
		roleinfo.status.common_use_limit[#roleinfo.status.common_use_limit+1] = c2
		cit:Next()
		c = cit:GetValue()
	end
	roleinfo.status.chongzhi = role._roledata._status._chongzhi
	--hero_hall
	roleinfo.hero_hall = {}
	roleinfo.hero_hall.heros = {}
	local heros = role._roledata._hero_hall._heros
	local hit = heros:SeekToBegin() --从头开始遍历
	local h = hit:GetValue()
	while h~=nil do
		local h2 = {}
		h2.skill = {}
		h2.common_skill = {}
		h2.tid = h._tid
		h2.level = h._level
		h2.order = h._order
		h2.exp = h._exp
		h2.star = h._star
		h2.skillpoint = h._cur_skill_point
		--武将无双技能赋值
		local skills = h._skill
		local sit = skills:SeekToBegin()
		local s = sit:GetValue()
		while s ~= nil do
			local h3 = {}
			h3.skill_id = s._skill_id
			h3.skill_level = s._skill_level
			h2.skill[#h2.skill+1] = h3
			sit:Next()
			s = sit:GetValue()
		end
		--武将普通技能赋值
		local common_skills = h._common_skill
		local com_it = common_skills:SeekToBegin()
		local com = com_it:GetValue()
		while com ~= nil do
			local h3 = {}
			h3.skill_id = com._skill_id
			h3.skill_level = com._skill_level
			h2.common_skill[#h2.common_skill+1] = h3
			com_it:Next()
			com = com_it:GetValue()
		end

		--PVP信息
		h2.hero_pvp_info = {}
		local hero_pvp = role._roledata._pvp_info._hero_pvp_info:Find(h._tid)
		if hero_pvp ~= nil then
			h2.hero_pvp_info.id = h._tid
			h2.hero_pvp_info.join_count = hero_pvp._join_count
			h2.hero_pvp_info.win_count = hero_pvp._win_count

		else
			h2.hero_pvp_info.id = h._tid
			h2.hero_pvp_info.join_count = 0
			h2.hero_pvp_info.win_count = 0
		end

		--已经选中的必杀技能
		h2.select_skill = {}
		local select_skills = h._select_skill
		local select_skill_it = select_skills:SeekToBegin()
		local select_skill = select_skill_it:GetValue()
		while select_skill ~= nil do
			h2.select_skill[#h2.select_skill+1] = select_skill._value
			select_skill_it:Next()
			select_skill = select_skill_it:GetValue()
		end

		--武将装备的武器ID
		h2.weapon_id = h._weapon_id

		--武将的装备信息
		h2.equipment = {}
		local equipments = h._equipment
		local equipment_it = equipments:SeekToBegin()
		local equipment = equipment_it:GetValue()
		while equipment ~= nil do
			local tmp_equipment = {}
			tmp_equipment.pos = equipment._pos
			tmp_equipment.equipment_id = equipment._id
			h2.equipment[#h2.equipment+1] = tmp_equipment

			equipment_it:Next()
			equipment = equipment_it:GetValue()
		end

		roleinfo.hero_hall.heros[#roleinfo.hero_hall.heros+1] = h2
		hit:Next()
		h = hit:GetValue()
	end
	--backpack
	roleinfo.backpack = {}
	roleinfo.backpack.capacity = role._roledata._backpack._capacity
	roleinfo.backpack.items = {}
	roleinfo.backpack.weaponitems = {}
	roleinfo.backpack.equipmentitems = {}
	local items = role._roledata._backpack._items
	local iit = items:SeekToBegin() --从头开始遍历
	local i = iit:GetValue()
	while i~=nil do
		local i2 = {}
		i2.tid = i._tid
		i2.count = i._count
		roleinfo.backpack.items[#roleinfo.backpack.items+1] = i2
		iit:Next()
		i = iit:GetValue()
	end
	local weaponitems = role._roledata._backpack._weapon_items._weapon_items
	local iit = weaponitems:SeekToBegin() --从头开始遍历
	local i = iit:GetValue()
	while i~=nil do
		local i2 = {}
		i2.base_item = {}
		i2.weapon_info = {}
		i2.base_item.tid = i._base_item._tid
		i2.base_item.count = i._base_item._count

		i2.weapon_info.tid = i._weapon_pro._tid
		i2.weapon_info.level = i._weapon_pro._level
		i2.weapon_info.star = i._weapon_pro._star
		i2.weapon_info.quality = i._weapon_pro._quality
		i2.weapon_info.prop = i._weapon_pro._prop
		i2.weapon_info.attack = i._weapon_pro._attack
		i2.weapon_info.weapon_skill = i._weapon_pro._weapon_skill
		i2.weapon_info.strength = i._weapon_pro._strengthen
		i2.weapon_info.level_up = i._weapon_pro._level_up
		i2.weapon_info.strength_prob = i._weapon_pro._strengthen_prob
		i2.weapon_info.skill_pro = {}
		local skill_pro_it = i._weapon_pro._skill_pro:SeekToBegin()
		local skill_pro = skill_pro_it:GetValue()
		while skill_pro ~= nil do
			local tmp_skill_pro = {}
			tmp_skill_pro.skill_id = skill_pro._skill_id
			tmp_skill_pro.skill_level = skill_pro._skill_level
			i2.weapon_info.skill_pro[#i2.weapon_info.skill_pro+1] = tmp_skill_pro
			skill_pro_it:Next()
			skill_pro = skill_pro_it:GetValue()
		end
		roleinfo.backpack.weaponitems[#roleinfo.backpack.weaponitems+1] = i2
		iit:Next()
		i = iit:GetValue()
	end
	local equipmentitems = role._roledata._backpack._equipment_items._equipment_items
	local equipment_it = equipmentitems:SeekToBegin()
	local equipment = equipment_it:GetValue()
	while equipment ~= nil do
		local tmp_equipment = {}
		tmp_equipment.base_item = {}
		tmp_equipment.equipment_info = {}
		tmp_equipment.equipment_info.refinable_pro = {}
		tmp_equipment.equipment_info.tmp_refinable_pro = {}

		tmp_equipment.base_item.tid = equipment._base_item._tid
		tmp_equipment.base_item.count = 1

		tmp_equipment.equipment_info.tid = equipment._equipment_pro._tid
		tmp_equipment.equipment_info.hero_id = equipment._equipment_pro._hero_id
		tmp_equipment.equipment_info.level = equipment._equipment_pro._level_up
		tmp_equipment.equipment_info.order = equipment._equipment_pro._order

		local refinable_it = equipment._equipment_pro._refinable_pro:SeekToBegin()
		local refinable = refinable_it:GetValue()
		while refinable ~= nil do
			local tmp_refinable = {}
			tmp_refinable.typ = refinable._typ
			tmp_refinable.data = refinable._num
			tmp_equipment.equipment_info.refinable_pro[#tmp_equipment.equipment_info.refinable_pro+1] = tmp_refinable

			refinable_it:Next()
			refinable = refinable_it:GetValue()
		end
		
		local refinable_it = equipment._equipment_pro._tmp_refinable_pro:SeekToBegin()
		local refinable = refinable_it:GetValue()
		while refinable ~= nil do
			local tmp_refinable = {}
			tmp_refinable.typ = refinable._typ
			tmp_refinable.data = refinable._num
			tmp_equipment.equipment_info.tmp_refinable_pro[#tmp_equipment.equipment_info.tmp_refinable_pro+1] = tmp_refinable

			refinable_it:Next()
			refinable = refinable_it:GetValue()
		end
		
		roleinfo.backpack.equipmentitems[#roleinfo.backpack.equipmentitems+1] = tmp_equipment
		equipment_it:Next()
		equipment = equipment_it:GetValue()
	end
	--mafia
	roleinfo.mafia = {}
	roleinfo.mafia.id = role._roledata._mafia._id:ToStr()
	roleinfo.mafia.name = role._roledata._mafia._name
	--TODO: _invites

	--task		成就
	roleinfo.task = {}
	roleinfo.task.finish = {}
	roleinfo.task.current = {}
	local finish_task = role._roledata._task._finish_task
	local tit = finish_task:SeekToBegin()
	local t = tit:GetValue()
	while t ~= nil do
		roleinfo.task.finish[#roleinfo.task.finish+1]=t._task_id
		tit:Next()
		t = tit:GetValue()
	end
	local current_task = role._roledata._task._current_task
	tit = current_task:SeekToBegin()
	t = tit:GetValue()
	while t ~= nil do
		local t2 = {}
		t2.id = t._task_id
		t2.condition = {}
		local tit3 = t._task_condition:SeekToBegin()
		local t3 = tit3:GetValue()
		while t3 ~= nil do 
			local t4 = {}
			t4.current_num = t3._num
			t4.max_num = t3._maxnum
			t2.condition[#t2.condition+1]=t4
			tit3:Next()
			t3 = tit3:GetValue()
		end
		roleinfo.task.current[#roleinfo.task.current+1]=t2
		tit:Next()
		t = tit:GetValue()
	end

	--user_define      客户端自定义类型
	roleinfo.user_define = {}
	roleinfo.user_define.role_define = {}

	local user_define = role._roledata._user_define._define
	local dit = user_define:SeekToBegin()
	local d = dit:GetValue()
	while d ~= nil do
		local d2 = {}
		d2.id = d._id
		d2.value_define = d._value
		roleinfo.user_define.role_define[#roleinfo.user_define.role_define+1]=d2
		dit:Next()
		d = dit:GetValue()
	end
	--horse_hall
	roleinfo.horse_hall = {}
	roleinfo.horse_hall.horses = {}
	local role_horse = role._roledata._horse_hall._horses
	local dit = role_horse:SeekToBegin()
	local d = dit:GetValue()
	while d ~= nil do
		local d2 = {}
		d2.tid = d._tid
		roleinfo.horse_hall.horses[#roleinfo.horse_hall.horses+1]=d2
		dit:Next()
		d = dit:GetValue()
	end
	--pvp_info
	--在这里把玩家的界别都弄完以后，开始把玩家的数据进行排行榜
	--首先先计算出来玩家目前的数值
	local data = 0
	if role._roledata._pvp_info._pvp_grade == 0 then
		--这里是为了在排行榜中做排列的时候，容易一些.
		--这里是做了一些假设的，假设玩家的传说分数不会低于10000
		data = role._roledata._pvp_info._cur_star + 10000
	else
		for i = 25, role._roledata._pvp_info._pvp_grade + 1, -1 do
			local ed = DataPool_Find("elementdata")
			local ranking = ed:FindBy("ranking_id", i)
			data = data + ranking.ascending_order_star
		end
		data = data + role._roledata._pvp_info._cur_star
	end
	roleinfo.pvp_info = {}
	roleinfo.pvp_info.star = data
	roleinfo.pvp_info.join_count = role._roledata._pvp_info._win_count + role._roledata._pvp_info._fail_count
	roleinfo.pvp_info.win_count = role._roledata._pvp_info._win_count
	roleinfo.pvp_info.end_time = role._roledata._pvp_info._pvp_season_end_time

	--pvp_video
	roleinfo.pvp_video = {}
	local vit = role._roledata._status._pvp_video:SeekToBegin()
	local v = vit:GetValue()
	while v ~= nil do
		local pvp_video_data = {}
		pvp_video_data.video = v._id._value
		pvp_video_data.win_flag = v._win_flag
		pvp_video_data.time = v._time
		pvp_video_data.player1 = {}
		pvp_video_data.player2 = {}
		local is_idx,player1 = DeserializeStruct(v._first_pvpinfo._value, 1, "RolePVPInfo")
		local is_idx,player2 = DeserializeStruct(v._second_pvpinfo._value, 1, "RolePVPInfo")
		
		pvp_video_data.player1.brief = player1.brief
		pvp_video_data.player1.hero_hall = player1.hero_hall
		pvp_video_data.player1.pvp_score = player1.pvp_score
		pvp_video_data.player2.brief = player2.brief
		pvp_video_data.player2.hero_hall = player2.hero_hall
		pvp_video_data.player2.pvp_score = player2.pvp_score
		
		roleinfo.pvp_video[#roleinfo.pvp_video+1] = pvp_video_data

		vit:Next()
		v = vit:GetValue()
	end

	--black_list
	roleinfo.black_list = {}
	--local black_it = role._roledata._friend._blacklist:SeekToBegin()
	--local black = black_it:GetValue()
	--while black ~= nil do
	--	local tmp_black = {}
	--	tmp_black.id = black._brief._id:ToStr()
	--	tmp_black.name = black._brief._name
	--	tmp_black.photo = black._brief._photo
	--	roleinfo.black_list[#roleinfo.black_list+1] = tmp_black
	--
	--	black_it:Next()
	--	black = black_it:GetValue()
	--end

	--mail_list
	roleinfo.mail_list = {}
	local mail_it = role._roledata._mail_info._mail_info:SeekToBegin()
	local mail = mail_it:GetValue()
	while mail ~= nil do
		local tmp_mail = {}
		tmp_mail.mail_id = mail._mail_id
		tmp_mail.msg_id = mail._msg_id
		tmp_mail.subject = mail._subject
		tmp_mail.context = mail._context
		tmp_mail.time = mail._time
		tmp_mail.from_id = mail._from_id:ToStr()
		tmp_mail.from_name = mail._from_name

		tmp_mail.mail_arg = {}
		local mail_arg_it = mail._mail_arg:SeekToBegin()
		local mail_arg = mail_arg_it:GetValue()
		while mail_arg ~= nil do
			tmp_mail.mail_arg[#tmp_mail.mail_arg+1] = mail_arg._value
			mail_arg_it:Next()
			mail_arg = mail_arg_it:GetValue()
		end

		tmp_mail.item = {}
		local item_it = mail._item:SeekToBegin()
		local tmp_item = item_it:GetValue()
		while tmp_item ~= nil do
			local client_item = {}
			client_item.tid = tmp_item._item_id
			client_item.count = tmp_item._item_count
			tmp_mail.item[#tmp_mail.item+1] = client_item
			item_it:Next()
			tmp_item = item_it:GetValue()
		end
		tmp_mail.read_flag = mail._read_flag
		roleinfo.mail_list[#roleinfo.mail_list + 1] = tmp_mail
		mail_it:Next()
		mail = mail_it:GetValue()
	end

	--repinfo
	roleinfo.rep_list = {}
	local rep_info = role._roledata._rep_info
	local rep_it = rep_info:SeekToBegin()
	local rep = rep_it:GetValue()
	while rep ~= nil do
		local tmp_rep = {}
		tmp_rep.rep_id = rep._rep_id
		tmp_rep.rep_num = rep._rep_num
		roleinfo.rep_list[#roleinfo.rep_list+1] = tmp_rep
		rep_it:Next()
		rep = rep_it:GetValue()
	end

	--herosoul
--	roleinfo.soul_list = {}
--	local soul_info = role._roledata._hero_soul
--	local soul_it = soul_info:SeekToBegin()
--	local soul = soul_it:GetValue()
--	while soul ~= nil do
--		local tmp_soul = {}
--		tmp_soul.soul_id = soul._id
--		tmp_soul.soul_num = soul._num
--		roleinfo.soul_list[#roleinfo.soul_list+1] = tmp_soul
--		soul_it:Next()
--		soul = soul_it:GetValue()
--	end
	
	--mysteryshop
	roleinfo.mysteryshop_list = {}
	local mysteryshop_info = role._roledata._private_shop
	local mysteryshop_info_it = mysteryshop_info:SeekToBegin()
	local mysteryshop = mysteryshop_info_it:GetValue()
	while mysteryshop ~= nil do
		local tmp_mystery = {}
		tmp_mystery.shop_id = mysteryshop._shop_id
		tmp_mystery.shop_item = {}
		local shop_item = mysteryshop._shop_data
		local shop_item_it = shop_item:SeekToBegin()
		local shop_item_info = shop_item_it:GetValue()
		while shop_item_info ~= nil do
			local tmp_shop_item = {}
			tmp_shop_item.item_id = shop_item_info._item_id
			tmp_shop_item.buy_count = shop_item_info._buy_count
			tmp_shop_item.max_count = shop_item_info._max_count
			tmp_mystery.shop_item[#tmp_mystery.shop_item+1] = tmp_shop_item
			shop_item_it:Next()
			shop_item_info = shop_item_it:GetValue()
		end
		roleinfo.mysteryshop_list[#roleinfo.mysteryshop_list+1] = tmp_mystery
		mysteryshop_info_it:Next()
		mysteryshop = mysteryshop_info_it:GetValue()
	end

	--instancehero_info
	--typ为1代表PVE副本的阵容保存
	--typ为2代表3V3的PVP阵容保存
	--typ为3代表的是马战的阵容保存
	--typ为4代表的是战役的阵容保存
	--typ为5代表的是战役的马战阵容保存
	--typ为10代表的是铜雀台的阵容
	--typ为12代表的是马术大赛的阵容
	roleinfo.instancehero_info = {}
	local tmp_instancehero = {}
	tmp_instancehero.typ = 1
	tmp_instancehero.battle_id = 0
	tmp_instancehero.horse = 0
	tmp_instancehero.heroinfo = {}
	tmp_instancehero.heroinfo.info = {}
	local last_hero = role._roledata._status._last_hero
	local lit = last_hero:SeekToBegin()
	local l = lit:GetValue()
	while l ~= nil do
		tmp_instancehero.heroinfo.info[#tmp_instancehero.heroinfo.info+1] = l._value
		lit:Next()
		l = lit:GetValue()
	end
	roleinfo.instancehero_info[#roleinfo.instancehero_info+1] = tmp_instancehero

	local tmp_instancehero = {}
	tmp_instancehero.typ = 2
	tmp_instancehero.battle_id = 0
	tmp_instancehero.horse = 0
	tmp_instancehero.heroinfo = {}
	tmp_instancehero.heroinfo.info = {}
	local last_hero = role._roledata._pvp_info._last_hero
	local lit = last_hero:SeekToBegin()
	local l = lit:GetValue()
	while l ~= nil do
		tmp_instancehero.heroinfo.info[#tmp_instancehero.heroinfo.info+1] = l._value
		lit:Next()
		l = lit:GetValue()
	end
	roleinfo.instancehero_info[#roleinfo.instancehero_info+1] = tmp_instancehero

	local tmp_instancehero = {}
	tmp_instancehero.typ = 3
	tmp_instancehero.battle_id = 0
	tmp_instancehero.horse = role._roledata._status._last_horse_hero._horse
	tmp_instancehero.heroinfo = {}
	tmp_instancehero.heroinfo.info = {}
	local last_hero = role._roledata._status._last_horse_hero._heroinfo
	local lit = last_hero:SeekToBegin()
	local l = lit:GetValue()
	while l ~= nil do
		tmp_instancehero.heroinfo.info[#tmp_instancehero.heroinfo.info+1] = l._value
		lit:Next()
		l = lit:GetValue()
	end
	roleinfo.instancehero_info[#roleinfo.instancehero_info+1] = tmp_instancehero

	local battle_it = role._roledata._battle_info:SeekToBegin()
	local battle = battle_it:GetValue()
	while battle ~= nil do
	
		local tmp_instancehero = {}
		tmp_instancehero.typ = 4
		tmp_instancehero.battle_id = battle._battle_id
		tmp_instancehero.horse = 0
		tmp_instancehero.heroinfo = {}
		tmp_instancehero.heroinfo.info = {}
		local last_hero = battle._cur_hero_info
		local lit = last_hero:SeekToBegin()
		local l = lit:GetValue()
		while l ~= nil do
			tmp_instancehero.heroinfo.info[#tmp_instancehero.heroinfo.info+1] = l._value
			lit:Next()
			l = lit:GetValue()
		end
		roleinfo.instancehero_info[#roleinfo.instancehero_info+1] = tmp_instancehero
	
		local tmp_instancehero = {}
		tmp_instancehero.typ = 5
		tmp_instancehero.battle_id = battle._battle_id
		tmp_instancehero.horse = battle._cur_hero_horse_info._horse
		tmp_instancehero.heroinfo = {}
		tmp_instancehero.heroinfo.info = {}
		local last_hero = battle._cur_hero_horse_info._heroinfo
		local lit = last_hero:SeekToBegin()
		local l = lit:GetValue()
		while l ~= nil do
			tmp_instancehero.heroinfo.info[#tmp_instancehero.heroinfo.info+1] = l._value
			lit:Next()
			l = lit:GetValue()
		end
		roleinfo.instancehero_info[#roleinfo.instancehero_info+1] = tmp_instancehero
	
		battle_it:Next()
		battle = battle_it:GetValue()
	end

	--铜雀台阵容
	tmp_instancehero = {}
	tmp_instancehero.typ = 10
	tmp_instancehero.battle_id = 0
	tmp_instancehero.horse = 0
	tmp_instancehero.heroinfo = {}
	tmp_instancehero.heroinfo.info = {}
	local hero_it = role._roledata._tongquetai_data._hero_info_list:SeekToBegin()
	local hero = hero_it:GetValue()
	while hero ~= nil do
		tmp_instancehero.heroinfo.info[#tmp_instancehero.heroinfo.info+1] = hero._value

		hero_it:Next()
		hero = hero_it:GetValue()
	end
	roleinfo.instancehero_info[#roleinfo.instancehero_info+1] = tmp_instancehero
	
	--马术大赛阵容
	tmp_instancehero = {}
	tmp_instancehero.typ = 12
	tmp_instancehero.battle_id = 0
	tmp_instancehero.horse = role._roledata._mashu_info._hero_info._horse_id
	tmp_instancehero.heroinfo = {}
	tmp_instancehero.heroinfo.info = {}
	tmp_instancehero.heroinfo.info[#tmp_instancehero.heroinfo.info+1] = role._roledata._mashu_info._hero_info._heroid

	roleinfo.instancehero_info[#roleinfo.instancehero_info+1] = tmp_instancehero
	
	roleinfo.pve_arena = {}
	roleinfo.pve_arena.video_flag = role._roledata._pve_arena_info._new_video

	--临时数据
	role._roledata._pvp._state = 0

	--在这里告诉center去把自己的房间号删掉去
	API_Log("_roledata._pvp._id          "..role._roledata._pvp._id)
	--if role._roledata._pvp._id ~= 0 then
	role:SendPVPReset()
	--end

	return roleinfo
end

function ROLE_MakeRoleBrief(role)
	local rolebrief = {}
	rolebrief.id = role._roledata._base._id:ToStr()
	rolebrief.name = role._roledata._base._name
	rolebrief.photo = role._roledata._base._photo
	rolebrief.level = role._roledata._status._level
	rolebrief.mafia_id = role._roledata._mafia._id:ToStr()
	rolebrief.mafia_name = role._roledata._mafia._name
	return rolebrief
end

function ROLE_AddExp(role, exp)
	--首先判断玩家现在的等级是否已经达到了最高等级
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	if role._roledata._status._level < quanju.legion_maxlv then
		role._roledata._status._exp:Add(exp)
		--在这里判断是否达到了升级的经验
		--拿到当前等级升级所需要的经验
		local level_exp = ed:FindBy("level_id", role._roledata._status._level)
		local level_flag = 0
		while role._roledata._status._exp:Equal(level_exp.needexp) or role._roledata._status._exp:Great(level_exp.needexp) do
			role._roledata._status._level = role._roledata._status._level + 1
			role._roledata._status._exp:Sub(level_exp.needexp)
			--给玩家加体力
			ROLE_Addvp(role, level_exp.vp_up, 1)
			level_exp = ed:FindBy("level_id", role._roledata._status._level)
			level_flag = 1
			--修改成就
			TASK_ChangeCondition(role, G_ACH_TYPE["LEVEL_FINISH"], 0, role._roledata._status._level)
			if role._roledata._status._level == quanju.legion_maxlv then
				break
			end
			role._roledata._status._notice_other = 1
		end
		--发送经验和等级改变的消息
		local resp = NewCommand("Role_Mon_Exp")
		resp.level = role._roledata._status._level
		resp.exp = role._roledata._status._exp:ToStr()
		resp.money = role._roledata._status._money
		resp.yuanbao = role._roledata._status._yuanbao
		resp.vp = role._roledata._status._vp
		role:SendToClient(SerializeCommand(resp))
	
		--等级修改，查看是否可以添加新的成就
		if level_flag == 1 then
			TASK_RefreshTask(role)
			if role._roledata._status._level >= 2 then
				local msg = NewMessage("RoleUpdateLevelTop")
				API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
			end
			
			ROLE_UpdateMiscPveArenaInfo(role)

			--在这里开启JJC的相关功能
			local quanju = ed.gamedefine[1]
			--if role._roledata._status._level == quanju.arena_open_lv then
			
			if role._roledata._pve_arena_info._score == 0 then
				role._roledata._pve_arena_info._score = quanju.arena_initial_score

				local hero_it = role._roledata._status._last_hero:SeekToBegin()
				local hero = hero_it:GetValue()
				while hero ~= nil do
					local value = CACHE.Int:new()
					value._value = hero._value
					role._roledata._pve_arena_info._defence_hero_info:PushBack(value)
					hero_it:Next()
					hero = hero_it:GetValue()
				end

				local msg = NewMessage("RoleUpdatePveArenaTop")
				API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
				
				local msg = NewMessage("RoleUpdatePveArenaMisc")
				API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
			end
			--end
		end

	end
end

function ROLE_AddMoney(role, money)
	API_Log("ROLE_AddMoney id="..role._roledata._base._id:ToStr().."  money="..money)
	role._roledata._status._money = role._roledata._status._money + money
	local resp = NewCommand("Role_Mon_Exp")
	resp.level = role._roledata._status._level
	resp.exp = role._roledata._status._exp:ToStr()
	resp.money = role._roledata._status._money
	resp.yuanbao = role._roledata._status._yuanbao
	resp.vp = role._roledata._status._vp
	role:SendToClient(SerializeCommand(resp))
end

function ROLE_SubMoney(role, money)
	API_Log("ROLE_SubMoney id="..role._roledata._base._id:ToStr().."  money="..money)
	role._roledata._status._money = role._roledata._status._money - money
	local resp = NewCommand("Role_Mon_Exp")
	resp.level = role._roledata._status._level
	resp.exp = role._roledata._status._exp:ToStr()
	resp.money = role._roledata._status._money
	resp.yuanbao = role._roledata._status._yuanbao
	resp.vp = role._roledata._status._vp
	role:SendToClient(SerializeCommand(resp))
end

--这个flag等于1的时候代表可以超过最大体力值，等于0的时候代表不可以超过
function ROLE_Addvp(role, num, flag)
	local vp = role._roledata._status._vp
	role._roledata._status._vp = vp + num
	if role._roledata._status._vp > (role._roledata._status._level + 60 - 1) then
		--现在满体力了，已经可以不让体力走了
		if flag == 0 then
			role._roledata._status._vp = role._roledata._status._level + 60 - 1
		end
		role._roledata._status._vp_refreshtime = 0
	end

	local resp = NewCommand("Role_Mon_Exp")
	resp.level = role._roledata._status._level
	resp.exp = role._roledata._status._exp:ToStr()
	resp.money = role._roledata._status._money
	resp.yuanbao = role._roledata._status._yuanbao
	resp.vp = role._roledata._status._vp
	role:SendToClient(SerializeCommand(resp))
	
	local resp = NewCommand("GetVPRefreshTime_Re")
	resp.refresh_time = role._roledata._status._vp_refreshtime
	role:SendToClient(SerializeCommand(resp))
end

function ROLE_Subvp(role, num)
	local vp = role._roledata._status._vp
	if vp >= num then
		role._roledata._status._vp = vp - num
		if role._roledata._status._vp_refreshtime == 0 and role._roledata._status._vp < (role._roledata._status._level + 60) then
			role._roledata._status._vp_refreshtime = API_GetTime()
		end
		local resp = NewCommand("Role_Mon_Exp")
		resp.level = role._roledata._status._level
		resp.exp = role._roledata._status._exp:ToStr()
		resp.money = role._roledata._status._money
		resp.yuanbao = role._roledata._status._yuanbao
		resp.vp = role._roledata._status._vp
		role:SendToClient(SerializeCommand(resp))
		
		local resp = NewCommand("GetVPRefreshTime_Re")
		resp.refresh_time = role._roledata._status._vp_refreshtime
		role:SendToClient(SerializeCommand(resp))
		return true
	else
		return false
	end
end

function ROLE_AddYuanBao(role, num)
	local yuanbao = role._roledata._status._yuanbao
	role._roledata._status._yuanbao = yuanbao + num

	--元宝变化
	local resp = NewCommand("Role_Mon_Exp")
	resp.level = role._roledata._status._level
	resp.exp = role._roledata._status._exp:ToStr()
	resp.money = role._roledata._status._money
	resp.yuanbao = role._roledata._status._yuanbao
	resp.vp = role._roledata._status._vp
	role:SendToClient(SerializeCommand(resp))
end

function ROLE_SubYuanBao(role, num)
	local yuanbao = role._roledata._status._yuanbao
	if yuanbao >= num then
		role._roledata._status._yuanbao = yuanbao - num

		--元宝变化
		local resp = NewCommand("Role_Mon_Exp")
		resp.level = role._roledata._status._level
		resp.exp = role._roledata._status._exp:ToStr()
		resp.money = role._roledata._status._money
		resp.yuanbao = role._roledata._status._yuanbao
		resp.vp = role._roledata._status._vp
		role:SendToClient(SerializeCommand(resp))
		return true
	else
		return false
	end
end

function ROLE_AddChongZhi(role, num)
	local chongzhi = role._roledata._status._chongzhi
	local last_vip = ROLE_GetVIP(role)
	role._roledata._status._chongzhi = chongzhi + num

	local resp = NewCommand("ChongZhi_Re")
	resp.chongzhi = role._roledata._status._chongzhi
	role:SendToClient(SerializeCommand(resp))
	local cur_vip = ROLE_GetVIP(role)

	if (cur_vip - last_vip) > 0 then
		TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_VIP"], 0, cur_vip - last_vip)
	end
end

function ROLE_GetVIP(role)
	local chongzhi = role._roledata._status._chongzhi
	local ed = DataPool_Find("elementdata")
	local vips = ed.vip
	local vip_level = 0
	for vip in DataPool_Array(vips) do
		if chongzhi >= vip.vip_point_req then
			if vip_level < vip.vip_level then
				vip_level = vip.vip_level
			end
		end
	end
	return vip_level
end

function ROLE_GetMaxHeroSkillPoint(role)
	local vip_level = ROLE_GetVIP(role)
	local ed = DataPool_Find("elementdata")
	local vip = ed:FindBy("vip_level", vip_level)
	return vip.skillpointlimit
end

function ROLE_AddHeroSkillPoint(role, point)
	local max_point = ROLE_GetMaxHeroSkillPoint(role)
	if role._roledata._status._hero_skill_point >= max_point then
		role._roledata._status._hero_skill_point_refreshtime = 0
		local resp = NewCommand("GetSkillPointRefreshTime_Re")
		resp.refresh_time = role._roledata._status._hero_skill_point_refreshtime

		role:SendToClient(SerializeCommand(resp))
		return
	end
	role._roledata._status._hero_skill_point = role._roledata._status._hero_skill_point + point
	if role._roledata._status._hero_skill_point >= max_point then
		role._roledata._status._hero_skill_point = max_point
		role._roledata._status._hero_skill_point_refreshtime = 0
		
		local resp = NewCommand("GetSkillPointRefreshTime_Re")
		resp.refresh_time = role._roledata._status._hero_skill_point_refreshtime
		role:SendToClient(SerializeCommand(resp))
	end
	
	local resp = NewCommand("UpdateHeroSkillPoint")
	resp.point = role._roledata._status._hero_skill_point
	role:SendToClient(SerializeCommand(resp))
end

function ROLE_AddReward(role, reward)
	ROLE_AddExp(role, reward.exp)
	local item_count = table.getn(reward.item)
	for i = 1, item_count do
		BACKPACK_AddItem(role, reward.item[i].itemid, reward.item[i].itemnum)
	end
end

function ROLE_AddRep(role, repid, repnum)
	local resp = NewCommand("UpdateRep")
	resp.rep_id = repid
	local repmap = role._roledata._rep_info
	local rep = repmap:Find(repid)
	if rep == nil then
		local value = CACHE.RepData()
		value._rep_id = repid
		value._rep_num = repnum
		repmap:Insert(repid, value)
		resp.rep_num = value._rep_num
	else
		rep._rep_num = rep._rep_num + repnum
		resp.rep_num = rep._rep_num
	end

	role:SendToClient(SerializeCommand(resp))
	return
end

function ROLE_CheckRep(role, repid, repnum)
	local repmap = role._roledata._rep_info
	local rep = repmap:Find(repid)
	if rep == nil then
		return false
	else
		if rep._rep_num >= repnum then
			return true
		end
	end

	return false
end

function ROLE_SubRep(role, repid, repnum)

	--注意这个函数只考虑这个声望存在并且足够才会进行计算
	--再加上一个返回值，确保，调用这个函数之前，首先调用上面的CheckRep函数
	local resp = NewCommand("UpdateRep")
	resp.rep_id = repid
	local repmap = role._roledata._rep_info
	local rep = repmap:Find(repid)
	if rep ~= nil then
		rep._rep_num = rep._rep_num - repnum
		resp.rep_num = rep._rep_num
		role:SendToClient(SerializeCommand(resp))
		return true
	end

	return false
end

function ROLE_GetRep(role, repid)
	local repmap = role._roledata._rep_info
	local rep = repmap:Find(repid)
	if rep == nil then
		return 0
	else
		return rep._rep_num
	end
end

--function ROLE_AddSoul(role, id, num)
--	local soul = role._roledata._hero_soul:Find(id)
--	if soul == nil then
--		local tmp_soul = CACHE.HeroSoul:new()
--		tmp_soul._id = id
--		tmp_soul._num = num
--		role._roledata._hero_soul:Insert(id, tmp_soul)
--	else
--		soul._num = soul._num + num
--	end
--	local resp = NewCommand("UpdateHeroSoul")
--	resp.soul_id = id
--	resp.soul_num = num
--	role:SendToClient(SerializeCommand(resp))
--end
--
--function ROLE_SubSoul(role, id, num)
--	local soul = role._roledata._hero_soul:Find(id)
--	if soul == nil or soul._num < num then
--		return
--	end
--	soul._num = soul._num - num
--	local resp = NewCommand("UpdateHeroSoul")
--	resp.soul_id = id
--	resp.soul_num = num
--	role:SendToClient(SerializeCommand(resp))
--end

function ROLE_RefreshAllBattleInfo(role)
	local ed = DataPool_Find("elementdata")
	local battles = ed.battle
	for battle in DataPool_Array(battles) do
		local tmp_battle = role._roledata._battle_info:Find(battle.id)
		if tmp_battle == nil then
			ROLE_ResetBattleInfo(role, battle.id)
		end
	end
end

function ROLE_ResetBattleInfo(role, battle_id)
	local ed = DataPool_Find("elementdata")
	local battle_info = ed:FindBy("battle_id", battle_id)
	local battlefielddata_info = ed:FindBy("battlefielddata_id", battle_info.battlefieldid)

	--把这个删除掉，然后再更新
	role._roledata._battle_info:Delete(battle_id)
	local tmp_battle = CACHE.BattleFieldData()
	tmp_battle._battle_id = battle_id
	tmp_battle._cur_position = battlefielddata_info.init_player_pos
	tmp_battle._last_position = battlefielddata_info.init_player_pos
	tmp_battle._state = 0
	tmp_battle._round_num = 0
	tmp_battle._round_flag = battle_info.roundlimit
	--if battle_info.roundlimit ~= 0 then
	--	tmp_battle._round_flag = 1
	--else
	--	tmp_battle._round_flag = 0
	--end
	tmp_battle._cur_morale = 100

	local cur_npc_id = 0
	--先放slot
	local tmp_slot = CACHE.BattleFieldPositionData()
	for slot in DataPool_Array(battlefielddata_info.init_slots) do
		tmp_slot._id = slot.id
		tmp_slot._position = slot.pos
		tmp_slot._flag = slot.flag
		tmp_slot._event_flag = 0
		tmp_slot._pos_buff = slot.begin_slotbuff

		tmp_battle._position_info:Insert(slot.pos, tmp_slot)
	end
	--放置NPC的信息
	local tmp_npc = CACHE.BattleFieldNPCData()
	for npc in DataPool_Array(battlefielddata_info.init_npcs) do
		cur_npc_id = cur_npc_id + 1
		tmp_npc._id = npc.id
		tmp_npc._camp = npc.camp
		tmp_npc._armyid = npc.armyid
		local army_info = ed:FindBy("battlearmy_id", npc.armyid)

		tmp_npc._alive = 1
		tmp_npc._army_buff = army_info.begin_morale
		--找到信息放进去
		local tmp_slot = tmp_battle._position_info:Find(npc.pos)
		if tmp_slot == nil then
			API_Log("ROLE_ResetBattleInfo  npc pos id error  "..npc.pos.. "   " ..battle_id .."    " ..battle_info.battlefieldid)
		end
		tmp_slot._npc_info:Insert(npc.id, tmp_npc)
	end

	tmp_battle._npc_id = cur_npc_id
	role._roledata._battle_info:Insert(battle_id, tmp_battle)

	return 0
end

function ROLE_MakeBattleInfo(role, battle_id)
	local battle = role._roledata._battle_info:Find(battle_id)
	battle_info = {}
	battle_info.battle_id = battle._battle_id
	battle_info.cur_pos = battle._cur_position
	battle_info.state = battle._state
	battle_info.round_num = battle._round_num
	battle_info.round_flag = battle._round_flag
	battle_info.round_state = battle._round_state
	battle_info.cur_morale = battle._cur_morale
	battle_info.hero_info = {}
	battle_info.cur_hero = {}
	battle_info.cur_horse_hero = {}
	battle_info.cur_horse_hero.hero = {}
	battle_info.position_data = {}

	--首先放进去所有英雄
	local hero_it = battle._hero_info:SeekToBegin()
	local hero = hero_it:GetValue()
	while hero ~= nil do
		local tmp_hero = {}
		tmp_hero.hero_id = hero._id
		tmp_hero.hp = hero._hp
		battle_info.hero_info[#battle_info.hero_info+1] = tmp_hero
		hero_it:Next()
		hero = hero_it:GetValue()
	end
	--其次放入当前英雄
	local hero_it = battle._cur_hero_info:SeekToBegin()
	local hero = hero_it:GetValue()
	while hero ~= nil do
		battle_info.cur_hero[#battle_info.cur_hero+1] = hero._value
		hero_it:Next()
		hero = hero_it:GetValue()
	end
	--然后放入马战的英雄信息
	local horse_hero_it = battle._cur_hero_horse_info._heroinfo:SeekToBegin()
	local horse_hero = horse_hero_it:GetValue()
	while horse_hero ~= nil do
		battle_info.cur_horse_hero.hero[#battle_info.cur_horse_hero.hero+1] = horse_hero._value
		horse_hero_it:Next()
		horse_hero = horse_hero_it:GetValue()
	end
	battle_info.cur_horse_hero.horse = battle._cur_hero_horse_info._horse
	--最后放入每一个节点的信息
	local position_it = battle._position_info:SeekToBegin()
	local position = position_it:GetValue()
	while position ~= nil do
		local tmp_position = {}
		tmp_position.id = position._id
		tmp_position.position = position._position
		tmp_position.flag = position._flag
		tmp_position.event_flag = position._event_flag
		tmp_position.pos_buff = position._pos_buff
		
		tmp_position.npc_info = {}
		local npc_it = position._npc_info:SeekToBegin()
		local npc = npc_it:GetValue()
		while npc ~= nil do
			local tmp_npc = {}
			tmp_npc.id = npc._id
			tmp_npc.camp = npc._camp
			tmp_npc.armyid = npc._armyid
			tmp_npc.alive = npc._alive
			tmp_npc.event_flag = npc._event_flag
			tmp_npc.army_buff = npc._army_buff
			
			tmp_position.npc_info[#tmp_position.npc_info+1] = tmp_npc
			npc_it:Next()
			npc = npc_it:GetValue()
		end
		battle_info.position_data[#battle_info.position_data+1] = tmp_position
		position_it:Next()
		position = position_it:GetValue()
	end
	--在这里做一点额外的信息，查看我方当前所在的位置是否是友方，如果是的话，那么需要让他返回到上一次的位置
	local position = battle._position_info:Find(battle._cur_position)
	if position._flag ~= 1 then
		battle._cur_position = battle._last_position
		battle_info.cur_pos = battle._cur_position
		battle._round_state = 3
		battle_info.round_state = battle._round_state
	end
	return battle_info
end

function ROLE_MakeBattleCurPositionInfo(role, battle_id)
	local battle = role._roledata._battle_info:Find(battle_id)
	position_info = {}
	--最后放入每一个节点的信息
	local position = battle._position_info:Find(battle._cur_position)
	position_info.id = position._id
	position_info.position = position._position
	position_info.flag = position._flag
	position_info.event_flag = position._event_flag
	position_info.pos_buff = position._pos_buff
	
	position_info.npc_info = {}
	local npc_it = position._npc_info:SeekToBegin()
	local npc = npc_it:GetValue()
	while npc ~= nil do
		local tmp_npc = {}
		tmp_npc.id = npc._id
		tmp_npc.camp = npc._camp
		tmp_npc.armyid = npc._armyid
		tmp_npc.alive = npc._alive
		tmp_npc.event_flag = npc._event_flag
		tmp_npc.army_buff = npc._army_buff
		
		position_info.npc_info[#position_info.npc_info+1] = tmp_npc
		npc_it:Next()
		npc = npc_it:GetValue()
	end
	return position_info
end

function ROLE_GetBattleEventInfo(role, battleid, eventid)
	local ed = DataPool_Find("elementdata")
	local battleevent_info = ed:FindBy("battle_event_id", eventid)
	
	local event_info = {}
	event_info.plot_dia_id = 0
	event_info.del_army_id = {}
	event_info.add_army_info = {}
	event_info.item = {}
	event_info.position_buff = {}
	event_info.army_buff = {}
	event_info.del_pos_buff = {}
	event_info.pos_army_buff = {}
	
	local battle = role._roledata._battle_info:Find(battleid)
	if battle == nil then
		return event_info
	end
	event_info.plot_dia_id = battleevent_info.eventstoryid

	for defeatarmyid in DataPool_Array(battleevent_info.defeatarmyid) do
		if defeatarmyid ~= 0 then
			local position_it = battle._position_info:SeekToBegin()
			local position_info = position_it:GetValue()
			while position_info ~= nil do
				local npc_it = position_info._npc_info:SeekToBegin()
				local npc = npc_it:GetValue()
				while npc ~= nil do
					if npc._armyid == defeatarmyid and npc._alive == 1 then
						local tmp_del = {}
						tmp_del.id = position_info._id
						tmp_del.pos = position_info._position
						tmp_del.npc_id = npc._id
						tmp_del.army_id = defeatarmyid
						event_info.del_army_id[#event_info.del_army_id+1] = tmp_del

						npc._alive = 0
						break
					end
					npc_it:Next()
					npc = npc_it:GetValue()
				end
				position_it:Next()
				position_info = position_it:GetValue()
			end
		end
	end

	for joinarmy in DataPool_Array(battleevent_info.select_join_army) do
		if joinarmy.joinarmyid ~= 0 then
			local position = battle._position_info:Find(joinarmy.joinarmypos)
			if position ~= nil then
				local alive_army = 0

				local npc_it = position._npc_info:SeekToBegin()
				local npc = npc_it:GetValue()
				while npc ~= nil do
					if npc._alive == 1 then
						alive_army = alive_army + 1
						if npc._camp ~= joinarmy.joinarmycamp then
							--如果加入NPC的阵营和当前据点里面的NPC阵营不一致的话，那么就直接把敌人
							--设置成10个，这样子在后面的逻辑中就不会走进去了
							alive_army = 10
							break
						end
					end
					npc_it:Next()
					npc = npc_it:GetValue()
				end
				
				if alive_army < 4 then
					battle._npc_id = battle._npc_id + 1
					local tmp_npc = CACHE.BattleFieldNPCData()
					tmp_npc._id = battle._npc_id
					tmp_npc._camp = joinarmy.joinarmycamp
					tmp_npc._armyid = joinarmy.joinarmyid
					tmp_npc._alive = 1
					
					local army_info = ed:FindBy("battlearmy_id", joinarmy.joinarmyid)

					tmp_npc._army_buff = army_info.begin_morale
					position._npc_info:Insert(tmp_npc._id, tmp_npc)
					
					if joinarmy.joinarmycamp == 1 or joinarmy.joinarmycamp == 3 then
						position._flag = 1
					elseif joinarmy.joinarmycamp == 2 then
						position._flag = 2
					end

					local tmp_add_army = {}
					tmp_add_army.id = position._id
					tmp_add_army.pos = position._position
					tmp_add_army.npc_id = tmp_npc._id
					--tmp_add_army.npc_camp = position._flag
					tmp_add_army.npc_camp = tmp_npc._camp
					tmp_add_army.army_id = tmp_npc._armyid
					tmp_add_army.army_buff = tmp_npc._army_buff
					event_info.add_army_info[#event_info.add_army_info+1] = tmp_add_army
				end
			end
		end
	end

	if battleevent_info.rewardid ~= 0 then
		local Reward = DROPITEM_Reward(role, battleevent_info.rewardid)

		ROLE_AddReward(role, Reward)
		local item_count = table.getn(Reward.item)
		for i = 1, item_count do
			local tmp_item = {}
			tmp_item.tid = Reward.item[i].itemid
			tmp_item.count = Reward.item[i].itemnum
			event_info.item[#event_info.item+1] = tmp_item
		end
	end

	for pos_buff in DataPool_Array(battleevent_info.change_slot_buff) do
		if pos_buff.slotpos ~= 0 then
			local position = battle._position_info:Find(pos_buff.slotpos)
			if position ~= nil then
				if pos_buff.slotbuff ~= 0 then
					--这里需要注意一下，因为策划配置buff的时候，是MASK值，所以可以这么来进行书写
					local tmp_change = math.floor(position._pos_buff/pos_buff.slotbuff)
					if tmp_change%2 == 0 then
						position._pos_buff = position._pos_buff + pos_buff.slotbuff
						local tmp_pos_buf = {}
						tmp_pos_buf.id = position._id
						tmp_pos_buf.pos = position._position
						--tmp_pos_buf.buff_id = pos_buff.slotbuff
						tmp_pos_buf.buff_id = position._pos_buff
						event_info.position_buff[#event_info.position_buff+1] = tmp_pos_buf
					end
				end
			end
		else
			break
		end
	end
	
	for del_pos_buff in DataPool_Array(battleevent_info.remove_buff_slotpos) do
		if del_pos_buff ~= 0 then
			local position = battle._position_info:Find(del_pos_buff)
			if position ~= nil then
				if position._pos_buff ~= 0 then
					position._pos_buff = 0
					event_info.del_pos_buff[#event_info.del_pos_buff+1] = del_pos_buff
				end
			end
		else
			break
		end
	end
	
	for army_buff in DataPool_Array(battleevent_info.change_army_buff) do
		if army_buff.slotpos ~= 0 then
			local position_info = battle._position_info:Find(army_buff.slotpos)
			if position_info ~= nil then
				local npc_it = position_info._npc_info:SeekToBegin()
				local npc = npc_it:GetValue()
				while npc ~= nil do
					if npc._alive == 1 then
						if army_buff.armybuff == 1 then
							npc._army_buff = npc._army_buff + army_buff.change_morale
							if npc._army_buff > 100 then
								npc._army_buff = 100
							end
						elseif army_buff.armybuff == 2 then
							npc._army_buff = npc._army_buff - army_buff.change_morale
							if npc._army_buff < 0 then
								npc._army_buff = 0
							end
						end
					end
					npc_it:Next()
					npc = npc_it:GetValue()
				end
			end
			local tmp_pos_army_buff = {}
			tmp_pos_army_buff.pos = army_buff.slotpos
			tmp_pos_army_buff.typ = army_buff.armybuff
			tmp_pos_army_buff.num = army_buff.change_morale
			event_info.pos_army_buff[#event_info.pos_army_buff+1] = tmp_pos_army_buff
		end

		if army_buff.armyid ~= 0 then
			local position_it = battle._position_info:SeekToBegin()
			local position_info = position_it:GetValue()
			while position_info ~= nil do
				local npc_it = position_info._npc_info:SeekToBegin()
				local npc = npc_it:GetValue()
				while npc ~= nil do
					if npc._armyid == army_buff.armyid and npc._alive == 1 then
						if army_buff.armybuff == 1 then
							npc._army_buff = npc._army_buff + army_buff.change_morale
							if npc._army_buff > 100 then
								npc._army_buff = 100
							end
						elseif army_buff.armybuff == 2 then
							npc._army_buff = npc._army_buff - army_buff.change_morale
							if npc._army_buff < 0 then
								npc._army_buff = 0
							end
						end

						local tmp_army_buff = {}
						tmp_army_buff.id = npc._id
						tmp_army_buff.pos = position_info._position
						tmp_army_buff.army = npc._armyid
						tmp_army_buff.typ = army_buff.armybuff
						tmp_army_buff.buff_id = army_buff.change_morale

						event_info.army_buff[#event_info.army_buff+1] = tmp_army_buff
					end
					npc_it:Next()
					npc = npc_it:GetValue()
				end
				position_it:Next()
				position_info = position_it:GetValue()
			end
		end
	end

	--回合数是否解除
	if battle._round_flag ~= 0 then
		if battleevent_info.remove_roundlimit == 1 then
			battle._round_flag = 0
			event_info.remove_round_limit = 1
		end
	end
	--自己的士气值变化
	if battleevent_info.change_player_buff.armybuff == 1 then
		battle._cur_morale = battle._cur_morale + battleevent_info.change_player_buff.change_morale
		if battle._cur_morale > 100 then
			battle._cur_morale = 100
		end
	elseif battleevent_info.change_player_buff.armybuff == 2 then
		battle._cur_morale = battle._cur_morale - battleevent_info.change_player_buff.change_morale
		if battle._cur_morale < 0 then
			battle._cur_morale = 0
		end
	end

	event_info.self_morale_change_typ = battleevent_info.change_player_buff.armybuff
	event_info.self_morale_change_num = battleevent_info.change_player_buff.change_morale
	
	return event_info
end

function ROLE_BattleRoundEvent(role, battle)
	local battle_info = {}
	battle_info.battle_id = battle._battle_id
	battle_info.cur_position = battle._cur_position
	battle_info.round_num = battle._round_num
	battle_info.round_state = battle._round_state
	battle_info.round_flag = battle._round_flag
	battle_info.cur_morale = battle._cur_morale
	battle_info.position_info = {}
	battle_info.eventid = {}
	battle_info.battleevent = {}
	battle_info.occupyevent = {}
	
	local position_info_it = battle._position_info:SeekToBegin()
	local position_info = position_info_it:GetValue()

	while position_info ~= nil do
		local tmp_position_info = {}
		tmp_position_info.id = position_info._id
		tmp_position_info.position = position_info._position
		tmp_position_info.flag = position_info._flag
		tmp_position_info.pos_buff = position_info._pos_buff
		tmp_position_info.npc_info = {}

		local npc_info_it = position_info._npc_info:SeekToBegin()
		local npc_info = npc_info_it:GetValue()
		while npc_info ~= nil do
			local tmp_npc_info = {}
			tmp_npc_info.id = npc_info._id
			tmp_npc_info.camp = npc_info._camp
			tmp_npc_info.armyid = npc_info._armyid
			tmp_npc_info.alive = npc_info._alive
			tmp_npc_info.army_buff = npc_info._army_buff

			tmp_position_info.npc_info[#tmp_position_info.npc_info+1] = tmp_npc_info
			npc_info_it:Next()
			npc_info = npc_info_it:GetValue()
		end
		
		battle_info.position_info[#battle_info.position_info+1] = tmp_position_info
		position_info_it:Next()
		position_info = position_info_it:GetValue()
	end

	local event_info_it = battle._eventid:SeekToBegin()
	local event_info = event_info_it:GetValue()
	while event_info ~= nil do
		battle_info.eventid[#battle_info.eventid+1] = event_info._value

		event_info_it:Next()
		event_info = event_info_it:GetValue()
	end

	local event_info_it = battle._battleevent:SeekToBegin()
	local event_info = event_info_it:GetValue()
	while event_info ~= nil do
		battle_info.battleevent[#battle_info.battleevent+1] = event_info._value

		event_info_it:Next()
		event_info = event_info_it:GetValue()
	end

	local event_info_it = battle._occupyevent:SeekToBegin()
	local event_info = event_info_it:GetValue()
	while event_info ~= nil do
		battle_info.occupyevent[#battle_info.occupyevent+1] = event_info._value

		event_info_it:Next()
		event_info = event_info_it:GetValue()
	end

	return BattleCeHuaEvent(battle_info)
end

--修改自己在JJC上面的武将信息
function ROLE_UpdateMiscPveArenaHeroInfo(role, heroid)
	local heroinfo_it = role._roledata._pve_arena_info._defence_hero_info:SeekToBegin()
	local heroinfo = heroinfo_it:GetValue()
	while heroinfo ~= nil do
		if heroinfo._value == heroid then
			local msg = NewMessage("RoleUpdatePveArenaHeroInfo")
			API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
			break
		end
		heroinfo_it:Next()
		heroinfo = heroinfo_it:GetValue()
	end
end

--修改自己在JJC上面的等级和帮会信息
function ROLE_UpdateMiscPveArenaInfo(role)
	local msg = NewMessage("RoleUpdatePveArenaInfo")
	API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
end

--刷新自己的武者试炼的信息
function ROLE_UpdateWuZheShiLianInfo(role)
	--目前一共有5个难度
	role._roledata._wuzhe_shilian._dead_hero_info:Clear()
	role._roledata._wuzhe_shilian._injured_hero_info:Clear()
	role._roledata._wuzhe_shilian._attack_info:Clear()
	role._roledata._wuzhe_shilian._cur_difficulty = 0
	role._roledata._wuzhe_shilian._cur_stage = 0
	role._roledata._wuzhe_shilian._high_difficulty = 0 

	--所有的对手武将数量
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	local boss_infos = ed.shilianboss
	local all_num = 0
	local num_id = {}
	for boss in DataPool_Array(boss_infos) do
		all_num = all_num + 1
		num_id[#num_id+1] = boss.id
	end
	
	local cur_stage = 1
	--目前选择对手的效率比较低，后面进行一下修改
	--首先随机阵营1代表魏国，2是蜀国，3是吴国，4是群雄
	for i = 1, 4 do
		local difficulty_info = CACHE.ShiLianDifficultyAttackInfo()
		difficulty_info._difficulty = i
		difficulty_info._camp = i
		while difficulty_info._difficulty_attackinfo:Size() < quanju.shilian_stage_num_max do
			local num = math.random(all_num)
			local boss_info = ed:FindBy("boss_id", num_id[num])
			if boss_info.kingdom == difficulty_info._camp and boss_info.diff == difficulty_info._difficulty then
				if difficulty_info._difficulty_attackinfo:Find(boss_info.id) == nil then
					local insert_attack_info = CACHE.ShiLianAttackInfo()
					insert_attack_info._id = boss_info.id
					insert_attack_info._level = role._roledata._status._level
					insert_attack_info._stage = cur_stage
					cur_stage = cur_stage + 1
					insert_attack_info._alive_flag = 1
					insert_attack_info._hp = 0
					insert_attack_info._anger = 0
					insert_attack_info._reward_flag = 0
					insert_attack_info._suzhu_flag = 0 
					difficulty_info._difficulty_attackinfo:Insert(insert_attack_info._stage, insert_attack_info)
				end
			end
		end
		
		role._roledata._wuzhe_shilian._attack_info:Insert(difficulty_info._difficulty, difficulty_info)
	end
		
	--这里是集结状态5
	local difficulty_info = CACHE.ShiLianDifficultyAttackInfo()
	difficulty_info._difficulty = 5
	difficulty_info._camp = 5
	while difficulty_info._difficulty_attackinfo:Size() < quanju.shilian_stage_num_max do
		local num = math.random(all_num)
		local boss_info = ed:FindBy("boss_id", num_id[num])
		if boss_info.diff == difficulty_info._difficulty then
			if difficulty_info._difficulty_attackinfo:Find(boss_info.id) == nil then
				local insert_attack_info = CACHE.ShiLianAttackInfo()
				insert_attack_info._id = boss_info.id
				insert_attack_info._level = role._roledata._status._level
				insert_attack_info._stage = cur_stage
				cur_stage = cur_stage + 1
				insert_attack_info._alive_flag = 1
				insert_attack_info._hp = 0
				insert_attack_info._anger = 0
				insert_attack_info._reward_flag = 0
				insert_attack_info._suzhu_flag = 0
				difficulty_info._difficulty_attackinfo:Insert(insert_attack_info._stage, insert_attack_info)
			end
		end
	end
	
	role._roledata._wuzhe_shilian._attack_info:Insert(difficulty_info._difficulty, difficulty_info)
end

--玩家数据进行的初始化
function ROLE_OnlineInit(role)
	HERO_UpdateHeroRelationOnline(role)
	--查看成就信息，防止添加了新的成就和删除了新的成就
	TASK_UpdateTaskOnline(role)
	--进行跟时间相关的数据的更新
	local now = API_GetTime()
	local now_time = os.date("*t", now)
	local last_time = os.date("*t", role._roledata._status._last_heartbeat)
	if now_time.year ~= last_time.year or now_time.month ~= last_time.month or last_time.yday ~= now_time.yday or now_time.hour ~= last_time.hour then
		if now_time.wday == 1 then
			now_time.wday = now_time.wday + 7
		end
		if last_time.wday == 1 then
			last_time.wday = last_time.wday + 7
		end
		
		local diff_time = {}
		diff_time.last_year = last_time.year
		diff_time.cur_year = now_time.year
		diff_time.last_month = last_time.month
		diff_time.cur_month = now_time.month
		diff_time.last_week = last_time.wday - 1
		diff_time.cur_week = now_time.wday - 1
		diff_time.last_day = last_time.yday
		diff_time.cur_day = now_time.yday
		diff_time.last_hour = last_time.hour
		diff_time.cur_hour = now_time.hour
		
		LIMIT_RefreshUseLimit(role, diff_time)
		TASK_RefreshDailyTask(role, diff_time)
	end
	
	--初始化所有武将的战力
	--HERO_InitHeroZhanli(role)
	ROLE_UpdateZhanli(role)

	--更新一下军团信息
	ROLE_UpdateLegionInfo(role)
end

function ROLE_FinishFieldBattle(role, battle_id, send_flag)
	--现在当作成就完成来做
	TASK_ChangeCondition(role, G_ACH_TYPE["BATTLEFIELD_FINISH"], battle_id, 1)
		
	
	--不在使用了，因为现在所有的专精是客户端来进行激活的
	--if battle_id < 0 then
	--	return
	--end
	--local ed = DataPool_Find("elementdata")
	--local leginonspe_info = ed.legionspec

	--if role._roledata._legion_info._junxueguan._level >= 1 then
	--	for leginonspe in DataPool_Array(leginonspe_info) do
	--		if leginonspe.spec_need_campaign == battle_id then
	--			local find_info = role._roledata._legion_info._junxueguan._junxueinfo:Find(leginonspe.id)
	--			if find_info == nil then
	--				--更新给客户端开启了新的军学专精
	--				local resp = NewCommand("LegionAddJunXueGuanInfo")
	--				resp.info = {}
	--				resp.info.id = leginonspe.id
	--				resp.info.level = 1
	--				resp.info.learned = {}
	--				local insert_info = CACHE.JunXueZhuanJingData()
	--				insert_info._id = leginonspe.id
	--				insert_info._level = 1
	--				if leginonspe.spec_platform_lv <= 1 then
	--					local insert_learned = CACHE.Int()
	--					insert_learned._value = leginonspe.spec_original_tech
	--					insert_info._learned:Insert(leginonspe.spec_original_tech, insert_learned)
	--					resp.info.learned[#resp.info.learned+1] = leginonspe.spec_original_tech
	--				end
	--				role._roledata._legion_info._junxueguan._junxueinfo:Insert(leginonspe.id, insert_info)
	--				if send_flag == 1 then
	--					role:SendToClient(SerializeCommand(resp))
	--				end
	--			end
	--		end
	--	end
	--end
end

--打完一个副本的时候进行判断
function ROLE_FinishInstance(role, instance_id)
	if instance_id < 0 then
		return
	end
	local ed = DataPool_Find("elementdata")
	local construction_info = ed.construction
	for construction in DataPool_Array(construction_info) do
		if construction.unlock_stage == instance_id then
			--1代表的是军学馆
			if construction.construction_type == 1 then
				local find_instance = role._roledata._status._instances:Find(construction.unlock_stage)
				if find_instance ~= nil then
					if role._roledata._legion_info._junxueguan._level == 0 then
						role._roledata._legion_info._junxueguan._level = 1
						--刷新专精信息,这里暂时没有必要刷新，因为是客户端自己进行激活的
						--local battle_info_it = role._roledata._have_finish_battle:SeekToBegin()
						--local battle_info = battle_info_it:GetValue()
						--while battle_info ~= nil do
						--	ROLE_FinishFieldBattle(role, battle_info._value, 1)
						--	battle_info_it:Next()
						--	battle_info = battle_info_it:GetValue()
						--end
					end
				end
			end
		end
	end
end

function ROLE_UpdateLegionInfo(role)
	local ed = DataPool_Find("elementdata")
	local leginonspe_info = ed.legionspec
	local construction_info = ed.construction
	for construction in DataPool_Array(construction_info) do
		if construction.unlock_stage ~= 0 then
			--1代表的是军学馆
			if construction.construction_type == 1 then
				local find_instance = role._roledata._status._instances:Find(construction.unlock_stage)
				if find_instance ~= nil then
					if role._roledata._legion_info._junxueguan._level == 0 then
						role._roledata._legion_info._junxueguan._level = 1
						
						----刷新专精信息
						--local battle_info_it = role._roledata._have_finish_battle:SeekToBegin()
						--local battle_info = battle_info_it:GetValue()
						--while battle_info ~= nil do
						--	ROLE_FinishFieldBattle(role, battle_info._value, 0)
						--	battle_info_it:Next()
						--	battle_info = battle_info_it:GetValue()
						--end
					end
				end
			end
		else
			if construction.construction_type == 1 then
				if role._roledata._legion_info._junxueguan._level == 0 then
					role._roledata._legion_info._junxueguan._level = 1
					
					--现在不自动对其中的专精进行激活了
					----刷新专精信息
					--local battle_info_it = role._roledata._have_finish_battle:SeekToBegin()
					--local battle_info = battle_info_it:GetValue()
					--while battle_info ~= nil do
					--	ROLE_FinishFieldBattle(role, battle_info._value, 0)
					--	battle_info_it:Next()
					--	battle_info = battle_info_it:GetValue()
					--end
				end
			end
		end
	end
	
	--if role._roledata._legion_info._junxueguan._level ~= 0 then
	--	for leginonspe in DataPool_Array(leginonspe_info) do
	--		if leginonspe.spec_need_campaign ~= 0 then
	--			--查看这个战役玩家是否通关了，如果通关了，那么就查看一下是否已经开启
	--			local finish_battle = role._roledata._have_finish_battle:Find(leginonspe.spec_need_campaign)
	--			if finish_battle ~= nil then
	--				local find_info = role._roledata._legion_info._junxueguan._junxueinfo:Find(leginonspe.id)
	--				if find_info == nil then
	--					local insert_info = CACHE.JunXueZhuanJingData()
	--					insert_info._id = leginonspe.id
	--					insert_info._level = 1
	--					role._roledata._legion_info._junxueguan._junxueinfo:Insert(leginonspe.id, insert_info)
	--				end
	--			end
	--		else
	--			local find_info = role._roledata._legion_info._junxueguan._junxueinfo:Find(leginonspe.id)
	--			if find_info == nil then
	--				local insert_info = CACHE.JunXueZhuanJingData()
	--				insert_info._id = leginonspe.id
	--				insert_info._level = 1
	--				if leginonspe.spec_platform_lv <= 1 then
	--					local insert_learned = CACHE.Int()
	--					insert_learned._value = leginonspe.spec_original_tech
	--					insert_info._learned:Insert(leginonspe.spec_original_tech, insert_learned)
	--				end
	--				role._roledata._legion_info._junxueguan._junxueinfo:Insert(leginonspe.id, insert_info)
	--			end
	--		end
	--	end
	--end
end

--需要注意，一个玩家只会有一个武将或者一个物品上排行榜
--更新玩家的武将上排行榜
function ROLE_UpdateRoleHeroTopList(role, heroid)

	--查看这个英雄ID是不是当前最高的。如果不是就把最高的刷新上去
end

--更新玩家的武器上排行榜
function ROLE_UpdateRoleWeaponTopList(role, tid)
end

--计算自己的战力
function ROLE_UpdateZhanli(role)
	--玩家的战力是自己排名最高的三个武将
	local cur_zhanli = role._roledata._status._zhanli
	role._roledata._status._zhanli = 0
	local all_zhanli = {}
	local hero_info_it = role._roledata._hero_hall._heros:SeekToBegin()
	local hero_info = hero_info_it:GetValue()
	while hero_info ~= nil do
		local zhanli = HERO_CalZhanli(role, hero_info._tid)
		hero_info._zhanli = zhanli
		all_zhanli[#all_zhanli+1] = zhanli
		
		hero_info_it:Next()
		hero_info = hero_info_it:GetValue()
	end

	if table.getn(all_zhanli) <= 3 then
		for index = 1, table.getn(all_zhanli) do
			role._roledata._status._zhanli = role._roledata._status._zhanli + all_zhanli[index]
		end
	else
		for index = 1, 3 do
			local num = 1
			for num = 1, table.getn(all_zhanli)-num do
				if all_zhanli[num] > all_zhanli[num+1] then
					all_zhanli[num], all_zhanli[num+1] = all_zhanli[num+1], all_zhanli[num]
				end
			end
			role._roledata._status._zhanli = role._roledata._status._zhanli + all_zhanli[#all_zhanli-index+1]
		end
	end

	if cur_zhanli ~= role._roledata._status._zhanli then
		role._roledata._status._notice_other = 1
	end
end

--结束
