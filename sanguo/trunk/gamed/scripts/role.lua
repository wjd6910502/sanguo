function ROLE_Init(role)
	local ed = DataPool_Find("elementdata")
	
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

	local quanju = ed.gamedefine[1]
	role._roledata._pvp_info._elo_score = quanju.pvp_initial_elo_score

	--初始化的时候给一匹马
	if quanju.init_horse_id ~= 0 then
		local tmp = CACHE.RoleHorse()
		tmp._tid = quanju.init_horse_id
		role._roledata._horse_hall._horses:Insert(quanju.init_horse_id,tmp)
		role._roledata._status._last_horse_hero._horse = 0
		role._roledata._status._last_horse_hero._horse = quanju.init_horse_id
	end

	--初始化的时候给一个武将
	if quanju.init_role_id ~= 0 then
		local hero = ed:FindBy("hero_id", quanju.init_role_id)
		local tmp_hero = CACHE.RoleHero()
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
	
		--在这里设置初始出战武将
		role._roledata._status._last_hero:Clear()
		local value = CACHE.Int()
		value._value = quanju.init_role_id
		role._roledata._status._last_hero:PushBack(value)
		
		role._roledata._pvp_info._last_hero:Clear()
		local value = CACHE.Int()
		value._value = quanju.init_role_id
		role._roledata._pvp_info._last_hero:PushBack(value)
		
		local value = CACHE.Int()
		value._value = quanju.init_role_id
		role._roledata._status._last_horse_hero._heroinfo:Clear()
		role._roledata._status._last_horse_hero._heroinfo:PushBack(value)
		
		HERO_UpdateHeroSkill(role, quanju.init_role_id)
	end

	--根据性别设置玩家的头像和头像框
	local headports = ed.headport
	for headport in DataPool_Array(headports) do
		if role._roledata._base._sex == 1 and headport.sex_type == 1 then
			--男的
			if headport.head_type == 1 then
				local insert_photo_info = CACHE.PhotoInfo()
				insert_photo_info._id = headport.key_id
				insert_photo_info._typ = headport.head_type
				role._roledata._base._photo_map:Insert(insert_photo_info._id, insert_photo_info)
			elseif headport.head_type == 2 then
				if headport.hero_id ~= 0 then
					local find_hero_info = role._roledata._hero_hall._heros:Find(headport.hero_id)
					if find_hero_info ~= nil then
						local insert_photo_info = CACHE.PhotoInfo()
						insert_photo_info._id = headport.key_id
						insert_photo_info._typ = headport.head_type
						role._roledata._base._photo_map:Insert(insert_photo_info._id, insert_photo_info)
					end
				end
			end
		elseif role._roledata._base._sex == 0 then
			--女的
			if headport.sex_type == 2 then
				if headport.head_type == 1 then
					local insert_photo_info = CACHE.PhotoInfo()
					insert_photo_info._id = headport.key_id
					insert_photo_info._typ = headport.head_type
					role._roledata._base._photo_map:Insert(insert_photo_info._id, insert_photo_info)
				elseif headport.head_type == 2 then
					if headport.hero_id ~= 0 then
						local find_hero_info = role._roledata._hero_hall._heros:Find(headport.hero_id)
						if find_hero_info ~= nil then
							local insert_photo_info = CACHE.PhotoInfo()
							insert_photo_info._id = headport.key_id
							insert_photo_info._typ = headport.head_type
							role._roledata._base._photo_map:Insert(insert_photo_info._id, insert_photo_info)
						end
					end
				end
			end
		end
	end

	--设置玩家的头像框
	local insert_photo_info = CACHE.PhotoInfo()
	insert_photo_info._id = 1
	insert_photo_info._typ = 1
	role._roledata._base._photo_frame_map:Insert(insert_photo_info._id, insert_photo_info)
	role._roledata._base._photo_frame = insert_photo_info._id

	if role._roledata._base._sex == 0 then
		local insert_photo_info = CACHE.PhotoInfo()
		insert_photo_info._id = 4
		insert_photo_info._typ = 1
		role._roledata._base._photo_frame_map:Insert(insert_photo_info._id, insert_photo_info)
		role._roledata._base._photo_frame = insert_photo_info._id
	end
		
	--玩家的初始徽章
	--local badge_info = CACHE.BadgeInfo()
	--badge_info._id = 0
	--for i = 1, 3 do
	--	badge_info._pos = i
	--	role._roledata._base._badge_map:Insert(badge_info._pos, badge_info)
	--end
	
	--初始化武将的技能点
	role._roledata._status._hero_skill_point = ROLE_GetMaxHeroSkillPoint(role)
	role._roledata._status._hero_skill_point_refreshtime = 0

	--初始化玩家的武者试炼信息
	ROLE_UpdateWuZheShiLianInfo(role)

	--初始化武器图鉴等级
	role._roledata._make_data._level = 1 

	--test code
	if role._roledata._status._last_hero:Size() ~= 0 and role._roledata._status._level >= quanju.arena_open_lv then
		role._roledata._pve_arena_info._defence_hero_info:Clear()

		local hero_it = role._roledata._status._last_hero:SeekToBegin()
		local hero = hero_it:GetValue()
		while hero ~= nil do
			local value = CACHE.Int()
			value._value = hero._value
			role._roledata._pve_arena_info._defence_hero_info:PushBack(value)
			hero_it:Next()
			hero = hero_it:GetValue()
		end

		local msg = NewMessage("TopListInsertInfo")
		msg.typ = 4
		msg.data = tostring(role._roledata._pve_arena_info._score)
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
	
	--local list = role._roledata._overload_list
	--local str = CACHE.Str()
	--for i=1,1000 do
	--	str._value = "NUMBER: "..i
	--	list:PushBack(str)
	--end

	role._roledata._status._update_server_event = API_GetTime()
	role._roledata._status._login_time = API_GetTime()
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
	roleinfo.base.sex = role._roledata._base._sex
	roleinfo.base.photo_frame = role._roledata._base._photo_frame
	roleinfo.base.badge_info = {}
	local badge_info_it = role._roledata._base._badge_map:SeekToBegin()
	local badge_info = badge_info_it:GetValue()
	while badge_info ~= nil do
		local tmp_badge_info = {}
		tmp_badge_info.id = badge_info._id
		tmp_badge_info.typ = badge_info._pos
		roleinfo.base.badge_info[#roleinfo.base.badge_info+1] = tmp_badge_info

		badge_info_it:Next()
		badge_info = badge_info_it:GetValue()
	end
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
		h2.skin_id = h._skin
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
	roleinfo.backpack.skinitems = {}
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
		i2.weapon_info.exp = i._weapon_pro._exp
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
	local backpack = role._roledata._backpack._skin_items
	local iit = backpack:SeekToBegin()
	local i = iit:GetValue()
	while i ~= nil do
		local item = {}
		item.id = i._id
		item.time = i._time
		roleinfo.backpack.skinitems[#roleinfo.backpack.skinitems+1] = item
		iit:Next()
		i = iit:GetValue()
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
		pvp_video_data.match_pvp = v._match_pvp
		pvp_video_data.player1 = {}
		pvp_video_data.player2 = {}
		local checksum = G_CHECKSUM_S["RolePVPInfo"]
		if checksum == v._first_pvpinfo._checksum and checksum == v._second_pvpinfo._checksum then
			local is_idx,player1 = DeserializeStruct(v._first_pvpinfo._str, 1, "RolePVPInfo")
			local is_idx,player2 = DeserializeStruct(v._second_pvpinfo._str, 1, "RolePVPInfo")
			
			pvp_video_data.player1.brief = player1.brief
			pvp_video_data.player1.hero_hall = player1.hero_hall
			pvp_video_data.player1.pvp_score = player1.pvp_score
			pvp_video_data.player2.brief = player2.brief
			pvp_video_data.player2.hero_hall = player2.hero_hall
			pvp_video_data.player2.pvp_score = player2.pvp_score
			
			roleinfo.pvp_video[#roleinfo.pvp_video+1] = pvp_video_data
		else
			API_Log("roleid:"..role._roledata._base._id:ToStr()..", Err in deserialize struct RolePVPInfo: strus has changed!")
		end

		vit:Next()
		v = vit:GetValue()
	end

	--black_list
	--roleinfo.black_list = {}
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

	--阵容信息
	local hero_it = role._roledata._hero_all_team:SeekToBegin()
	local hero = hero_it:GetValue()
	while hero ~= nil do
		local tmp_instancehero = {}
		tmp_instancehero.typ = hero._id
		tmp_instancehero.heroinfo = {}
		tmp_instancehero.heroinfo.info = {}
		local data_it = hero._cur_hero_ids:SeekToBegin()
		local data = data_it:GetValue()
		while data ~= nil do
			tmp_instancehero.heroinfo.info[#tmp_instancehero.heroinfo.info + 1] = data._value
			data_it:Next()
			data = data_it:GetValue()
		end
		roleinfo.instancehero_info[#roleinfo.instancehero_info+1] = tmp_instancehero

		hero_it:Next()
		hero = hero_it:GetValue()
	end
	
	--临时的，后面进行修改阵容信息
	--local hero_team_it = role._roledata._hero_team:SeekToBegin()
	--local hero_team = hero_team_it:GetValue()
	--while hero_team ~= nil do
	--	tmp_instancehero = {}
	--	tmp_instancehero.typ = 14
	--	tmp_instancehero.battle_id = 0
	--	tmp_instancehero.horse = 0
	--	tmp_instancehero.heroinfo = {}
	--	tmp_instancehero.heroinfo.info = {}
	--	local hero_team_info_it = hero_team:SeekToBegin()
	--	local hero_team_info = hero_team_info_it:GetValue()
	--	while hero_team_info ~= nil do
	--		tmp_instancehero.heroinfo.info[#tmp_instancehero.heroinfo.info+1] = hero_team_info._value

	--		hero_team_info_it:Next()
	--		hero_team_info = hero_team_info_it:GetValue()
	--	end

	--	roleinfo.instancehero_info[#roleinfo.instancehero_info+1] = tmp_instancehero

	--	hero_team_it:Next()
	--	hero_team = hero_team_it:GetValue()
	--end
	
	roleinfo.pve_arena = {}
	roleinfo.pve_arena.video_flag = role._roledata._pve_arena_info._new_video

	--玩家的头像信息
	roleinfo.photo_info = {}
	roleinfo.photoframe_info = {}

	local photo_info_it = role._roledata._base._photo_map:SeekToBegin()
	local photo_info = photo_info_it:GetValue()
	while photo_info ~= nil do
		local tmp_photo_info = {}
		tmp_photo_info.id = photo_info._id
		tmp_photo_info.typ = photo_info._typ
		roleinfo.photo_info[#roleinfo.photo_info+1] = tmp_photo_info

		photo_info_it:Next()
		photo_info = photo_info_it:GetValue()
	end

	local photoframe_info_it = role._roledata._base._photo_frame_map:SeekToBegin()
	local photoframe_info = photoframe_info_it:GetValue()
	while photoframe_info ~= nil do
		local tmp_photo_info = {}
		tmp_photo_info.id = photoframe_info._id
		tmp_photo_info.typ = photoframe_info._typ
		roleinfo.photoframe_info[#roleinfo.photoframe_info+1] = tmp_photo_info

		photoframe_info_it:Next()
		photoframe_info = photoframe_info_it:GetValue()
	end

	roleinfo.daily_info = {}
	roleinfo.daily_info.sign_date = role._roledata._status._dailly_sign._sign_date
	local now = API_GetTime()
	local today_time = now - 5*3600
	local today_date = os.date("*t", today_time)
	if today_date.yday ~= role._roledata._status._dailly_sign._today_flag then
		roleinfo.daily_info.today_flag = 0
	else
		roleinfo.daily_info.today_flag = 1
	end
	roleinfo.daily_info.little_fudai = role._roledata._status._little_fudai
	roleinfo.daily_info.big_fudai = role._roledata._status._big_fudai

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
	rolebrief.sex = role._roledata._base._sex
	rolebrief.photo_frame = role._roledata._base._photo_frame
	rolebrief.badge_info = {}
	local badge_info_it = role._roledata._base._badge_map:SeekToBegin()
	local badge_info = badge_info_it:GetValue()
	while badge_info ~= nil do
		local tmp_badge_info = {}
		tmp_badge_info.id = badge_info._id
		tmp_badge_info.typ = badge_info._pos
		rolebrief.badge_info[#rolebrief.badge_info+1] = tmp_badge_info

		badge_info_it:Next()
		badge_info = badge_info_it:GetValue()
	end
	rolebrief.zhanli = role._roledata._status._zhanli
	return rolebrief
end

function ROLE_AddExp(role, exp, path)
	path = path or 0
	API_Log("ROLE_AddExp id="..role._roledata._base._id:ToStr().."   cur_exp="..role._roledata._status._exp:ToStr().."  exp="..exp..
		"   PATH="..path)
	
	--首先判断玩家现在的等级是否已经达到了最高等级
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	if role._roledata._status._level < quanju.legion_maxlv then
		role._roledata._status._exp:Add(exp)
		--在这里判断是否达到了升级的经验
		--拿到当前等级升级所需要的经验
		local level_exp = ed:FindBy("level_id", role._roledata._status._level)
		if level_exp == nil then
			API_Log("level_exp nil, roleid:"..role._roledata._base._id:ToStr()..", exp:"..exp..
					", level"..role._roledata._status._level)
			return
		end

		local level_flag = 0
		while role._roledata._status._exp:Equal(level_exp.needexp) or role._roledata._status._exp:Great(level_exp.needexp) do
			role._roledata._status._level = role._roledata._status._level + 1
			role._roledata._status._exp:Sub(level_exp.needexp)
			--给玩家加体力
			ROLE_Addvp(role, level_exp.vp_up, 1)
			level_exp = ed:FindBy("level_id", role._roledata._status._level)
			if level_exp == nil then
				API_Log("level_exp nil, roleid:"..role._roledata._base._id:ToStr()..", exp:"..exp..
						", level"..role._roledata._status._level)
				break
			end
			level_flag = 1
			--修改成就
			TASK_ChangeCondition(role, G_ACH_TYPE["LEVEL_FINISH"], 0, role._roledata._status._level)
			if role._roledata._status._level == quanju.legion_maxlv then
				break
			end
			role._roledata._status._notice_other = 1

			--数据统计日志
			local date = os.date("%Y-%m-%d %H:%M:%S")
			local now = API_GetTime()
			local leveluptime = now-role._roledata._status._levelup_time
			API_BILog("{\"logtime\":\""..date.."\",\"logname\":\"levelup\",\"serverid\":\""
				..API_GetZoneId().."\",\"os\":\""..role._roledata._device_info._os.."\",\"platform\":\"".."laohu"..
				"\",\"userid\":\""..role._roledata._status._account.."\",\"account\":\""..role._roledata._status._account..
				"\",\"roleid\":\""..role._roledata._base._id:ToStr().."\",\"rolename\":\""..role._roledata._base._name..
				"\",\"lev\":\""..role._roledata._status._level.."\",\"totalcash\":\"".."0".."\",\"leveluptime\":\""
				..leveluptime.."\"}")
			role._roledata._status._levelup_time = now
		end

		if level_flag == 1 and role._roledata._status._level >= 20 then
			local cache = API_GetLuaRoleNameCache()
			local rolebrief = CACHE.RoleBrief()
			rolebrief._id = role._roledata._base._id
			rolebrief._name = role._roledata._base._name
			rolebrief._photo = role._roledata._base._photo
			rolebrief._level = role._roledata._status._level
			rolebrief._mafia_id = role._roledata._mafia._id
			rolebrief._mafia_name = role._roledata._mafia._name
			rolebrief._sex = role._roledata._base._sex
			rolebrief._photo_frame = role._roledata._base._photo_frame
			rolebrief._badge_map = CACHE.BadgeInfoMap()
			local badge_info_it = role._roledata._base._badge_map:SeekToBegin()
			local badge_info = badge_info_it:GetValue()
			while badge_info ~= nil do
				local tmp_badge_info = CACHE.BadgeInfo()
				tmp_badge_info._id = badge_info._id
				tmp_badge_info._pos = badge_info._pos
				rolebrief._badge_map:Insert(tmp_badge_info._id, tmp_badge_info)

				badge_info_it:Next()
				badge_info = badge_info_it:GetValue()
			end
			cache:Update(rolebrief)
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
				local msg = NewMessage("TopListInsertInfo")
				msg.typ = 1
				msg.data = tostring(role._roledata._status._level)
				API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
				
				local msg = NewMessage("TopListUpdateInfo")
				API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
			end
			
			ROLE_UpdateMiscPveArenaInfo(role)

			--在这里开启JJC的相关功能 只进入一次
			if role._roledata._pve_arena_info._score == 0 and role._roledata._status._level >= quanju.arena_open_lv then	
				role._roledata._pve_arena_info._score = quanju.arena_initial_score
				TASK_ChangeCondition(role, G_ACH_TYPE["YONGJIU"], G_ACH_TWENTY_TYPE["JJCSCORE"], role._roledata._pve_arena_info._score)
				local msg = NewMessage("TopListInsertInfo")
				msg.typ = 4
				msg.data = tostring(role._roledata._pve_arena_info._score)
				API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
				if role._roledata._pve_arena_info._defence_hero_info:Size() ~= 0 then 
					local msg = NewMessage("RoleUpdatePveArenaMisc")
					API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
				end
			end
		end

	end
end

function ROLE_AddMoney(role, money, path)

	API_Log("ROLE_AddMoney id="..role._roledata._base._id:ToStr().."   cur_money="..role._roledata._status._money.."  money="..money)
	
	role._roledata._status._money = role._roledata._status._money + money
	local resp = NewCommand("Role_Mon_Exp")
	resp.level = role._roledata._status._level
	resp.exp = role._roledata._status._exp:ToStr()
	resp.money = role._roledata._status._money
	resp.yuanbao = role._roledata._status._yuanbao
	resp.vp = role._roledata._status._vp
	role:SendToClient(SerializeCommand(resp))

	--数据统计日志
	local date = os.date("%Y-%m-%d %H:%M:%S")
	path = path or 0
    API_BILog("{\"logtime\":\""..date.."\",\"logname\":\"addcoin\",\"serverid\":\""..API_GetZoneId()..
		"\",\"os\":\""..role._roledata._device_info._os.."\",\"platform\":\"".."laohu".."\",\"userid\":\""
		..role._roledata._status._account.."\",\"account\":\""..role._roledata._status._account..
		"\",\"roleid\":\""..role._roledata._base._id:ToStr().."\",\"rolename\":\""..role._roledata._base._name..
		"\",\"lev\":\""..role._roledata._status._level.."\",\"totalcash\":\"".."0".."\",\"cointype\":\"".."99"..
		"\",\"coinpath\":\""..path.."\",\"coin\":\""..money.."\"}")
end

function ROLE_SubMoney(role, money, path)
	
	API_Log("ROLE_SubMoney id="..role._roledata._base._id:ToStr().."   cur_money="..role._roledata._status._money.."  money="..money)
	
	role._roledata._status._money = role._roledata._status._money - money
	local resp = NewCommand("Role_Mon_Exp")
	resp.level = role._roledata._status._level
	resp.exp = role._roledata._status._exp:ToStr()
	resp.money = role._roledata._status._money
	resp.yuanbao = role._roledata._status._yuanbao
	resp.vp = role._roledata._status._vp
	role:SendToClient(SerializeCommand(resp))

	--数据统计日志
	local date = os.date("%Y-%m-%d %H:%M:%S")
	path = path or 0
    API_BILog("{\"logtime\":\""..date.."\",\"logname\":\"costcoin\",\"serverid\":\""..API_GetZoneId()..
		"\",\"os\":\""..role._roledata._device_info._os.."\",\"platform\":\"".."laohu".."\",\"userid\":\""
		..role._roledata._status._account.."\",\"account\":\""..role._roledata._status._account.."\",\"roleid\":\""
		..role._roledata._base._id:ToStr().."\",\"rolename\":\""..role._roledata._base._name.."\",\"lev\":\""
		..role._roledata._status._level.."\",\"totalcash\":\"".."0".."\",\"cointype\":\"".."99".."\",\"coinpath\":\""
		..path.."\",\"coin\":\""..money.."\"}")
end

--这个flag等于1的时候代表可以超过最大体力值，等于0的时候代表不可以超过
function ROLE_Addvp(role, num, flag)
	
	API_Log("ROLE_Addvp id="..role._roledata._base._id:ToStr().."   cur_vp="..role._roledata._status._vp.."  vp="..num)
	
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
	
	API_Log("ROLE_Subvp id="..role._roledata._base._id:ToStr().."   cur_vp="..role._roledata._status._vp.."  vp="..num)
	
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

function ROLE_AddYuanBao(role, num, path)
	
	API_Log("ROLE_AddYuanBao id="..role._roledata._base._id:ToStr().."   cur_yuanbao="..role._roledata._status._yuanbao.."  yuanbao="..num)
	
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

	--数据统计日志
	local date = os.date("%Y-%m-%d %H:%M:%S")
	path = path or 0
	API_BILog("{\"logtime\":\""..date.."\",\"logname\":\"addyuanbao\",\"serverid\":\""..API_GetZoneId()..
		"\",\"os\":\""..role._roledata._device_info._os.."\",\"platform\":\"".."laohu".."\",\"userid\":\""
		..role._roledata._status._account.."\",\"account\":\""..role._roledata._status._account.."\",\"roleid\":\""
		..role._roledata._base._id:ToStr().."\",\"rolename\":\""..role._roledata._base._name.."\",\"lev\":\""
		..role._roledata._status._level.."\",\"totalcash\":\"".."0".."\",\"yuanbaotype\":\"2\",\"yuanbaopath\":\""
		..path.."\",\"yuanbao\":\""..num.."\"}")
end

function ROLE_SubYuanBao(role, num, path)
	
	API_Log("ROLE_SubYuanBao id="..role._roledata._base._id:ToStr().."   cur_yuanbao="..role._roledata._status._yuanbao.."  yuanbao="..num)
	
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
		--修改消费成就
		TASK_ChangeCondition(role, G_ACH_TYPE["CHONGZHI"], G_ACH_NINTEEN_TYPE["LEIJIXIAOFEI"], num)

		--数据统计日志
		local date = os.date("%Y-%m-%d %H:%M:%S")
		path = path or 0
		API_BILog("{\"logtime\":\""..date.."\",\"logname\":\"costyuanbao\",\"serverid\":\""..API_GetZoneId()..
			"\",\"os\":\""..role._roledata._device_info._os.."\",\"platform\":\"".."laohu".."\",\"userid\":\""
			..role._roledata._status._account.."\",\"account\":\""..role._roledata._status._account..
			"\",\"roleid\":\""..role._roledata._base._id:ToStr().."\",\"rolename\":\""..role._roledata._base._name..
			"\",\"lev\":\""..role._roledata._status._level.."\",\"totalcash\":\"".."0".."\",\"yuanbaotype\":\"2\",\"yuanbaopath\":\""
			..path.."\",\"yuanbao\":\""..num.."\"}")

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
		TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_VIP"], 1, cur_vip - last_vip)
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

function ROLE_AddReward(role, reward, path, data)
	ROLE_AddExp(role, reward.exp, path)
        local item_count = table.getn(reward.item)
        local add_item = {}
        for i = 1, item_count do
                local flag, item = BACKPACK_AddItem(role, reward.item[i].itemid, reward.item[i].itemnum, path, data)
                for i = 1, table.getn(item) do
                        add_item[#add_item+1] = item[i]
                end

        end
        return add_item
end

function ROLE_AddRep(role, repid, repnum, path)
	local resp = NewCommand("UpdateRep")
	resp.rep_id = repid
	local repmap = role._roledata._rep_info
	local rep = repmap:Find(repid)
	local last_num = 0
	if rep == nil then
		last_num = 0
		local value = CACHE.RepData()
		value._rep_id = repid
		value._rep_num = repnum
		repmap:Insert(repid, value)
		resp.rep_num = value._rep_num
	else
		last_num = rep._rep_num
		rep._rep_num = rep._rep_num + repnum
		resp.rep_num = rep._rep_num
	end

	role:SendToClient(SerializeCommand(resp))
	
	API_Log("ROLE_AddRep id="..role._roledata._base._id:ToStr().."   repid="..repid.."  repnum="..repnum.."   last_num"..last_num.."   cur_num"..resp.rep_num)

	--数据统计日志
	local date = os.date("%Y-%m-%d %H:%M:%S")
	path = path or 0
	API_BILog("{\"logtime\":\""..date.."\",\"logname\":\"addcoin\",\"serverid\":\""..API_GetZoneId()..
		"\",\"os\":\""..role._roledata._device_info._os.."\",\"platform\":\"".."laohu".."\",\"userid\":\""
		..role._roledata._status._account.."\",\"account\":\""..role._roledata._status._account..
		"\",\"roleid\":\""..role._roledata._base._id:ToStr().."\",\"rolename\":\""..role._roledata._base._name..
		"\",\"lev\":\""..role._roledata._status._level.."\",\"totalcash\":\"".."0".."\",\"cointype\":\""..repid..
		"\",\"coinpath\":\""..path.."\",\"coin\":\""..repnum.."\"}")

	--查看是否需要修改成就
	--10代表的余香
	--11代表的鲜花
	if repid == 10 then
		TASK_ChangeCondition(role, G_ACH_TYPE["FLOWER_LINGERING"], 0, repnum)
		TASK_ChangeCondition(role, G_ACH_TYPE["YONGJIU"], G_ACH_TWENTY_TYPE["YUXIANG"], repnum)
	elseif repid == 11 then
		TASK_ChangeCondition(role, G_ACH_TYPE["YONGJIU"], G_ACH_TWENTY_TYPE["FLOWER"], repnum)
	end
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

function ROLE_SubRep(role, repid, repnum, path)
	
	API_Log("ROLE_SubRep id="..role._roledata._base._id:ToStr().."   repid="..repid.."  repnum="..repnum)

	--注意这个函数只考虑这个声望存在并且足够才会进行计算
	--再加上一个返回值，确保，调用这个函数之前，首先调用上面的CheckRep函数
	local resp = NewCommand("UpdateRep")
	resp.rep_id = repid
	local repmap = role._roledata._rep_info
	local rep = repmap:Find(repid)
	if rep ~= nil then
		if rep._rep_num < repnum then
			return false
		end
		rep._rep_num = rep._rep_num - repnum
		resp.rep_num = rep._rep_num
		role:SendToClient(SerializeCommand(resp))

		--数据统计日志
		local date = os.date("%Y-%m-%d %H:%M:%S")
		path = path or 0
		API_BILog("{\"logtime\":\""..date.."\",\"logname\":\"costcoin\",\"serverid\":\""..API_GetZoneId()..
			"\",\"os\":\""..role._roledata._device_info._os.."\",\"platform\":\"".."laohu".."\",\"userid\":\""
			..role._roledata._status._account.."\",\"account\":\""..role._roledata._status._account..
			"\",\"roleid\":\""..role._roledata._base._id:ToStr().."\",\"rolename\":\""..role._roledata._base._name..
			"\",\"lev\":\""..role._roledata._status._level.."\",\"totalcash\":\"".."0".."\",\"cointype\":\""
			..repid.."\",\"coinpath\":\""..path.."\",\"coin\":\""..repnum.."\"}")

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
--		local tmp_soul = CACHE.HeroSoul()
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
	if battlefielddata_info==nil then API_Log("battle_info.battlefieldid="..battle_info.battlefieldid) end

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
if battlefielddata_info.init_npcs~=nil then
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
end

	tmp_battle._npc_id = cur_npc_id
	
	--把这个删除掉，然后再更新
	role._roledata._battle_info:Delete(battle_id)
	role._roledata._battle_info:Insert(battle_id, tmp_battle)

	return 0
end

function ROLE_MakeBattleInfo(role, battle_id)
	local battle = role._roledata._battle_info:Find(battle_id)
	local battle_info = {}
	battle_info.battle_id = battle._battle_id
	battle_info.cur_pos = battle._cur_position
	battle_info.state = battle._state
	battle_info.round_num = battle._round_num
	battle_info.round_flag = battle._round_flag
	battle_info.round_state = battle._round_state
	battle_info.cur_morale = battle._cur_morale
	battle_info.attacked_flag = battle._attacked_flag
	battle_info.hero_info = {}
	battle_info.cur_hero = {}
	battle_info.cur_horse_hero = {}
	battle_info.cur_horse_hero.hero = {}
	battle_info.position_data = {}
	battle_info.info_history = {}

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
			tmp_npc.next_pos = npc._next_pos
			
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
	--在这里放进去战役的情报履历
	battle_info.info_history = {}
	local info_history_it = battle._info_history:SeekToBegin()
	local info_history = info_history_it:GetValue()
	while info_history ~= nil do
		battle_info.info_history[#battle_info.info_history+1] = info_history._value

		info_history_it:Next()
		info_history = info_history_it:GetValue()
	end
	return battle_info
end

function ROLE_MakeBattleCurPositionInfo(role, battle_id)
	local battle = role._roledata._battle_info:Find(battle_id)
	local position_info = {}
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
	event_info.battle_dialog_id = 0
	
	local battle = role._roledata._battle_info:Find(battleid)
	if battle == nil then
		return event_info
	end
	event_info.plot_dia_id = battleevent_info.eventstoryid
	event_info.battle_dialog_id = battleevent_info.battledialogid

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

	if battleevent_info.trigger_results == 1 then
		--胜利
		battle._state = 2
		
		local resp = NewCommand("ChangeBattleState")
		resp.battle_id = battleid
		resp.state = battle._state
		role:SendToClient(SerializeCommand(resp))
		local insert_data = CACHE.Int()
		insert_data._value = battleid
		role._roledata._have_finish_battle:Insert(battleid, insert_data)
		ROLE_FinishFieldBattle(role, battleid, 1)
		ROLE_UpdateHaveFinishBattle(role)
	elseif battleevent_info.trigger_results == 2 then
		--失败
		battle._state = 3

		local resp = NewCommand("ChangeBattleState")
		resp.battle_id = battleid
		resp.state = battle._state
		role:SendToClient(SerializeCommand(resp))
	end

	event_info.trigger_results = battleevent_info.trigger_results

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
	battle_info.para_record = {}
	
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

	local event_info_it = battle._cehuaeventid:SeekToBegin()
	local event_info = event_info_it:GetValue()
	while event_info ~= nil do
		local tmp = {}
		tmp.eventid = event_info._value
		tmp.count = event_info._count
		battle_info.eventid[#battle_info.eventid+1] = tmp

		event_info_it:Next()
		event_info = event_info_it:GetValue()
	end

	local event_info_it = battle._battleevent:SeekToBegin()
	local event_info = event_info_it:GetValue()
	while event_info ~= nil do
		local tmp = {}
		tmp.eventid = event_info._value
		tmp.count = event_info._count
		battle_info.battleevent[#battle_info.battleevent+1] = tmp

		event_info_it:Next()
		event_info = event_info_it:GetValue()
	end

	local event_info_it = battle._occupyevent:SeekToBegin()
	local event_info = event_info_it:GetValue()
	while event_info ~= nil do
		local tmp = {}
		tmp.eventid = event_info._value
		tmp.count = event_info._count
		battle_info.occupyevent[#battle_info.occupyevent+1] = tmp

		event_info_it:Next()
		event_info = event_info_it:GetValue()
	end
	
	battle_info.para_record = {}
	local para_record_it = battle._parameter_record:SeekToBegin()
	local para_record = para_record_it:GetValue()
	while para_record ~= nil do
		local tmp = {}
		tmp.typ = para_record._value
		tmp.count = para_record._count
		battle_info.para_record[#battle_info.para_record+1] = tmp

		para_record_it:Next()
		para_record = para_record_it:GetValue()
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
		diff_time.last_date = last_time.day
		diff_time.cur_date = now_time.day
		
		LIMIT_RefreshUseLimit(role, diff_time)
		TASK_RefreshDailyTask(role, diff_time)
	end
	
	--初始化所有武将的战力
	--HERO_InitHeroZhanli(role)
	ROLE_UpdateZhanli(role)

	--更新一下军团信息
	ROLE_UpdateLegionInfo(role)

	--更新玩家的头像信息
	ROLE_UpdatePhotoInfo(role)
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

	if cur_zhanli < role._roledata._status._zhanli then
		TASK_ChangeCondition(role, G_ACH_TYPE["ZHANLI"], 0, role._roledata._status._zhanli)
	end

	if role._roledata._status._zhanli > 0 then
		local msg = NewMessage("TopListInsertInfo")
		msg.typ = 2 
		msg.data = tostring(role._roledata._status._zhanli)
		API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
	end
end

function ROLE_UpdatePhotoHero(role, heroid)
	local heros = role._roledata._hero_hall._heros
	local hero = heros:Find(heroid)
	if hero ~= nil then
		local ed = DataPool_Find("elementdata")
		local headports = ed.headport
		for headport in DataPool_Array(headports) do
			if heroid == headport.hero_id then
				local photo_id = 0
				if role._roledata._base._sex == 1 then
					--男的
					if headport.head_type == 2 and headport.sex_type == 1 then
						local insert_photo_info = CACHE.PhotoInfo()
						insert_photo_info._id = headport.key_id
						insert_photo_info._typ = headport.head_type
						photo_id = insert_photo_info._id
						role._roledata._base._photo_map:Insert(insert_photo_info._id, insert_photo_info)
					end
				elseif role._roledata._base._sex == 0 then
					--女性
					if headport.head_type == 2 and headport.sex_type == 2 then
						local insert_photo_info = CACHE.PhotoInfo()
						insert_photo_info._id = headport.key_id
						insert_photo_info._typ = headport.head_type
						photo_id = insert_photo_info._id
						role._roledata._base._photo_map:Insert(insert_photo_info._id, insert_photo_info)
					end
				end
				if photo_id ~= 0 then
					local resp = NewCommand("PhotoUpdatePhotoInfo")
					resp.photo_info = {}
					local tmp_photo_info = {}
					tmp_photo_info.id = photo_id
					tmp_photo_info.typ = 2
					resp.photo_info[#resp.photo_info+1] = tmp_photo_info
					role:SendToClient(SerializeCommand(resp))
				end
				break
			end
		end
	end
end

function ROLE_UpdatePhotoInfo(role)
	--根据性别设置玩家的头像和头像框
	local ed = DataPool_Find("elementdata")
	local headports = ed.headport
	for headport in DataPool_Array(headports) do
		if role._roledata._base._sex == 1 then
			--男的
			if headport.head_type == 1 and headport.sex_type == 1 then
				local insert_photo_info = CACHE.PhotoInfo()
				insert_photo_info._id = headport.key_id
				insert_photo_info._typ = headport.head_type
				role._roledata._base._photo_map:Insert(insert_photo_info._id, insert_photo_info)
			elseif headport.head_type == 2 and headport.sex_type == 1 then
				if headport.hero_id ~= 0 then
					local find_hero_info = role._roledata._hero_hall._heros:Find(headport.hero_id)
					if find_hero_info ~= nil then
						local insert_photo_info = CACHE.PhotoInfo()
						insert_photo_info._id = headport.key_id
						insert_photo_info._typ = headport.head_type
						role._roledata._base._photo_map:Insert(insert_photo_info._id, insert_photo_info)
					end
				end
			end
		elseif role._roledata._base._sex == 0 then
			--女的
			if headport.headport == 1 and headport.sex_type == 2 then
				local insert_photo_info = CACHE.PhotoInfo()
				insert_photo_info._id = headport.key_id
				insert_photo_info._typ = headport.head_type
				role._roledata._base._photo_map:Insert(insert_photo_info._id, insert_photo_info)
			elseif headport.head_type == 2 and headport.sex_type == 2 then
				if headport.hero_id ~= 0 then
					local find_hero_info = role._roledata._hero_hall._heros:Find(headport.hero_id)
					if find_hero_info ~= nil then
						local insert_photo_info = CACHE.PhotoInfo()
						insert_photo_info._id = headport.key_id
						insert_photo_info._typ = headport.head_type
						role._roledata._base._photo_map:Insert(insert_photo_info._id, insert_photo_info)
					end
				end
			end
		end
	end
end

function ROLE_AddPhoto(role, photo_id, photo_typ)
	if role._roledata._base._photo_map:Find(photo_id) == nil then
		local insert_photo_info = CACHE.PhotoInfo()
		insert_photo_info._id = photo_id
		insert_photo_info._typ = photo_typ
		role._roledata._base._photo_map:Insert(insert_photo_info._id, insert_photo_info)

		local resp = NewCommand("PhotoUpdatePhotoInfo")
		resp.photo_info = {}
		local tmp_photo = {}
		tmp_photo.id = insert_photo_info._id
		tmp_photo.typ = insert_photo_info._typ
		resp.photo_info[#resp.photo_info+1] = tmp_photo
		role:SendToClient(SerializeCommand(resp))
	end
end

function ROLE_AddPhotoFrame(role, photoframe_id)
	if role._roledata._base._photo_frame_map:Find(photoframe_id) == nil then
		local insert_photo_info = CACHE.PhotoInfo()
		insert_photo_info._id = photoframe_id
		insert_photo_info._typ = 1
		role._roledata._base._photo_frame_map:Insert(insert_photo_info._id, insert_photo_info)

		local resp = NewCommand("PhotoUpdatePhotoInfo")
		resp.photoframe_info = {}
		local tmp_photoframe = {}
		tmp_photoframe.id = insert_photo_info._id
		tmp_photoframe.typ = insert_photo_info._typ
		resp.photoframe_info[#resp.photoframe_info+1] = tmp_photoframe
		role:SendToClient(SerializeCommand(resp))
	end
end

--add_flag为1的时候代表添加，0的时候代表删除
function ROLE_UpdateBadge(role, pos, id, add_flag)
	if pos >= 1 and pos <= 3 then
		if add_flag == 1 then
			if role._roledata._base._badge_map:Find(pos) ~= nil then
				return
			end
			local badge_info = CACHE.BadgeInfo()
			badge_info._id = id
			badge_info._pos = pos
			role._roledata._base._badge_map:Insert(badge_info._pos, badge_info)

			--在这里更新到排行榜上面去
			local msg = NewMessage("TopListUpdateInfo")
			API_SendMsg(role._roledata._base._id:ToStr(), SerializeMessage(msg), 0)
		else
			role._roledata._base._badge_map:Delete(pos)
		end

		local resp = NewCommand("PhotoUpdateBadgeInfo")
		resp.add_flag = add_flag
		resp.badge_info = {}
		local tmp_badge_info = {}
		tmp_badge_info.typ = pos
		tmp_badge_info.id = id
		resp.badge_info[#resp.badge_info+1] = tmp_badge_info
		role:SendToClient(SerializeCommand(resp))
	
		--更新到好友以及帮会
		local msg = NewMessage("RoleUpdateFriendInfo")
		msg.roleid = role._roledata._base._id:ToStr()
		msg.level = role._roledata._status._level
		msg.zhanli = role._roledata._status._zhanli
		msg.online = role._roledata._status._online
		msg.mashu_score = role._roledata._mashu_info._today_max_score
		msg.photo = role._roledata._base._photo
		msg.photo_frame = role._roledata._base._photo_frame
		msg.badge_info = {}

		local badge_info_it = role._roledata._base._badge_map:SeekToBegin()
		local badge_info = badge_info_it:GetValue()
		while badge_info ~= nil do
			local tmp_badge_info = {}
			tmp_badge_info.id = badge_info._id
			tmp_badge_info.typ = badge_info._pos
			msg.badge_info[#msg.badge_info+1] = tmp_badge_info

			badge_info_it:Next()
			badge_info = badge_info_it:GetValue()
		end
		
		local friend_info_it = role._roledata._friend._friends:SeekToBegin()
		local friend_info = friend_info_it:GetValue()
		while friend_info ~= nil do
			API_SendMsg(friend_info._brief._id:ToStr(), SerializeMessage(msg), 0)

			friend_info_it:Next()
			friend_info = friend_info_it:GetValue()
		end

		ROLE_UpdateMafiaInfo(role)
	end
end

function ROLE_UpdateMafiaInfo(role)
	--把自己的状态更新到帮会
	if role._roledata._mafia._id:ToStr() ~= "0" then
		local msg = NewMessage("RoleUpdateMafiaInfo")
		msg.roleid = role._roledata._base._id:ToStr()
		msg.name = role._roledata._base._name
		msg.level = role._roledata._status._level
		msg.zhanli = role._roledata._status._zhanli
		msg.online = role._roledata._status._online
		msg.photo = role._roledata._base._photo
		msg.photo_frame = role._roledata._base._photo_frame
		msg.badge_info = {}
		
		local badge_info_it = role._roledata._base._badge_map:SeekToBegin()
		local badge_info = badge_info_it:GetValue()
		while badge_info ~= nil do
			local tmp_badge_info = {}
			tmp_badge_info.id = badge_info._id
			tmp_badge_info.typ = badge_info._pos
			msg.badge_info[#msg.badge_info+1] = tmp_badge_info

			badge_info_it:Next()
			badge_info = badge_info_it:GetValue()
		end
		API_SendMessage(role._roledata._mafia._id, SerializeMessage(msg), CACHE.Int64List(), CACHE.Int64List(), CACHE.IntList())
		--API_SendMsg(role._roledata._mafia._id, SerializeMessage(msg))
	end
end

function ROLE_DayUpdateFlower(role)	
	
	if role._roledata._flower_info._refresh_time == 0 then
		role._roledata._flower_info._sendflower:Clear()
		role._roledata._flower_info._refresh_time = API_GetTime()
		return
	end
	
	local now = API_GetTime()
	local now_time = os.date("*t", now)
	local last_time = os.date("*t", role._roledata._flower_info._refresh_time)	 
	local need_day_refresh = 0 -- 0 代表不用刷新 1 代表需要刷新
	if now_time.year == last_time.year and now_time.month == last_time.month and last_time.yday == now_time.yday then
		if last_time.hour < 5 and now_time.hour >= 5 then
			need_day_refresh = 1
		end
	else
		need_day_refresh = 1 
	end
	
	--以后添加所有每天更新的数据
	if need_day_refresh == 1 then
		role._roledata._flower_info._sendflower:Clear()
		--刷新时间
		role._roledata._flower_info._refresh_time = now
	end
	
end

--第一个参数是公告的ID，第二个参数是公告的参数
function ROLE_SendNotice(notice_id, notice_para)

	local msg = NewMessage("SendNotice")
	msg.notice_id = notice_id
	msg.notice_para = notice_para
	
	API_SendMsg("-1", SerializeMessage(msg), 0)
end

function Split(str)
	local result = {}
	if str==nil or str=="" then
	return result
	end

	local pos = 1
	local len = string.len(str)
	while true do
		local begin_pos, end_pos = string.find(str, "%.", pos)
		if end_pos ~= nil then
			local tmp_str = string.sub(str, pos, end_pos-1)
			result[#result+1] = tmp_str
			pos = end_pos + 1
		else
			local tmp_str = string.sub(str, pos, len)
			result[#result+1] = tmp_str
			break
		end
	end
	return result
 end

function ROLE_GetPVPVersion(client_id, exe_ver, data_ver)
	if G_CONF_CLIENT_VERSION_CHECK_ENABLE==true then
		if G_VERSION_INFO[client_id] == nil then
			return -1
		end
	
		for i = 1, table.getn(G_VERSION_INFO[client_id]) do
			if G_VERSION_INFO[client_id][i].exe_ver == exe_ver and G_VERSION_INFO[client_id][i].res_ver == data_ver then
				return tonumber(G_VERSION_INFO[client_id][i].pvp_ver)
			end
		end
		
		local cur_pvp_ver = 0
		local result_exe_ver = tonumber(exe_ver)
		local result_data_ver = Split(data_ver)
		
		local len = 0
		for i = 1, table.getn(result_data_ver) do
			if string.len(result_data_ver[i]) > len then
				len = string.len(result_data_ver[i])
			end
		end
	
		local client_num = table.getn(G_VERSION_INFO[client_id])
		local cur_exe_ver = tonumber(G_VERSION_INFO[client_id][client_num].exe_ver)
		local cur_res_ver = Split(G_VERSION_INFO[client_id][client_num].res_ver)
		
		local flag = false
	
		if tonumber(result_data_ver[1]) > tonumber(cur_res_ver[1]) then
			flag = true
		elseif tonumber(result_data_ver[1]) == tonumber(cur_res_ver[1]) then
			if tonumber(result_data_ver[2]) > tonumber(cur_res_ver[2]) then
				flag = true
			elseif tonumber(result_data_ver[2]) == tonumber(cur_res_ver[2]) then
				if tonumber(result_data_ver[3]) >= tonumber(cur_res_ver[3]) then
					flag = true
				end
			end
		end
	
		if flag == true and result_exe_ver >= cur_exe_ver then
			cur_pvp_ver = tonumber(G_VERSION_INFO[client_id][client_num].pvp_ver)
		end
	
		return cur_pvp_ver
	else
		return 1
	end
end

function ROLE_PVPJoin(player, role)
	player:NetTime_Sync2Client()

	local rolebrief = ROLE_MakeRoleBrief(role)
	local pvpinfo = NewStruct("RolePVPInfo")
	pvpinfo.brief = {}
	pvpinfo.brief = rolebrief
	pvpinfo.hero_hall = {}

	local heros = role._roledata._hero_hall._heros
	local last_hero = role._roledata._pvp_info._last_hero
	local lit = last_hero:SeekToBegin()
	local l = lit:GetValue()
	while l ~= nil do
		local hero = {}
		local h = heros:Find(l._value)
		hero.tid = l._value
		hero.level = h._level
		hero.order = h._order
		hero.star = h._star
		hero.skin = h._skin
		hero.skill = {}
		hero.common_skill = {}
		hero.select_skill = {}
		--武将无双技能赋值
		local skills = h._skill
		local sit = skills:SeekToBegin()
		local s = sit:GetValue()
		while s ~= nil do
			local h3 = {}
			h3.skill_id = s._skill_id
			h3.skill_level = s._skill_level
			hero.skill[#hero.skill+1] = h3
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
			hero.common_skill[#hero.common_skill+1] = h3
			com_it:Next()
			com = com_it:GetValue()
		end

		--武将已经选择的无双技能
		local select_skills = h._select_skill
		local select_skill_it = select_skills:SeekToBegin()
		local select_skill = select_skill_it:GetValue()
		while select_skill ~= nil do
			hero.select_skill[#hero.select_skill+1] = select_skill._value
			select_skill_it:Next()
			select_skill = select_skill_it:GetValue()
		end

		--武将的羁绊
		hero.relations = {}
		local relations = h._relation
		local relation_it = relations:SeekToBegin()
		local relation = relation_it:GetValue()
		while relation ~= nil do
			hero.relations[#hero.relations+1] = relation._value
			relation_it:Next()
			relation = relation_it:GetValue()
		end
		--武将的武器
		local wenpon_id = h._weapon_id
		hero.weapon = {}
		hero.weapon.base_item = {}
		hero.weapon.weapon_info = {}

		if wenpon_id ~= 0 then
			local weapon_items = role._roledata._backpack._weapon_items

			local weapon_item_it = weapon_items._weapon_items:SeekToBegin()
			local weapon_item = weapon_item_it:GetValue()
			while weapon_item ~= nil do
				if weapon_item._weapon_pro._tid == wenpon_id then
					hero.weapon.base_item.tid = weapon_item._base_item._tid
					hero.weapon.base_item.count = weapon_item._base_item._count

					hero.weapon.weapon_info.tid = weapon_item._weapon_pro._tid
					hero.weapon.weapon_info.level = weapon_item._weapon_pro._level
					hero.weapon.weapon_info.star = weapon_item._weapon_pro._star
					hero.weapon.weapon_info.quality = weapon_item._weapon_pro._quality
					hero.weapon.weapon_info.prop = weapon_item._weapon_pro._prop
					hero.weapon.weapon_info.attack = weapon_item._weapon_pro._attack
					hero.weapon.weapon_info.weapon_skill = weapon_item._weapon_pro._weapon_skill
					hero.weapon.weapon_info.strength = weapon_item._weapon_pro._strengthen
					hero.weapon.weapon_info.level_up = weapon_item._weapon_pro._level_up
					hero.weapon.weapon_info.strength_prob = weapon_item._weapon_pro._strengthen_prob
					hero.weapon.weapon_info.skill_pro = {}
					local skill_pro_it = weapon_item._weapon_pro._skill_pro:SeekToBegin()
					local skill_pro = skill_pro_it:GetValue()
					while skill_pro ~= nil do
						local tmp_skill_pro = {}
						tmp_skill_pro.skill_id = skill_pro._skill_id
						tmp_skill_pro.skill_level = skill_pro._skill_level
						hero.weapon.weapon_info.skill_pro[#hero.weapon.weapon_info.skill_pro+1] = tmp_skill_pro
						skill_pro_it:Next()
						skill_pro = skill_pro_it:GetValue()
					end
				end
				weapon_item_it:Next()
				weapon_item = weapon_item_it:GetValue()
			end
		else
			hero.weapon.base_item.tid = 0
		end

		--武将的装备
		hero.equipment = {}
		local equipment_it = h._equipment:SeekToBegin()
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

				hero.equipment[#hero.equipment+1] = tmp_equipment
			else
				--输出错误日志
			end

			equipment_it:Next()
			equipment = equipment_it:GetValue()
		end

		pvpinfo.hero_hall[#pvpinfo.hero_hall+1] = hero
		lit:Next()
		l = lit:GetValue()
	end

	pvpinfo.p2p_magic = math.random(1000000)
	pvpinfo.p2p_net_typ = role._roledata._device_info._net_type
	pvpinfo.p2p_public_ip = role._roledata._device_info._public_ip
	pvpinfo.p2p_public_port = role._roledata._device_info._public_port
	pvpinfo.p2p_local_ip = role._roledata._device_info._local_ip
	pvpinfo.p2p_local_port = role._roledata._device_info._local_port
		
	--在这里把玩家的当前星级传送进去
	local data = 0
	local data1 = 0
	if role._roledata._pvp_info._pvp_grade == 0 then
		local ed = DataPool_Find("elementdata")
		for i = 25, role._roledata._pvp_info._pvp_grade + 1, -1 do
			local ranking = ed:FindBy("ranking_id", i)
			data = data + ranking.ascending_order_star
		end
		data = data + 1
		data1 = role._roledata._pvp_info._cur_star + 10000
	else
		local ed = DataPool_Find("elementdata")
		for i = 25, role._roledata._pvp_info._pvp_grade + 1, -1 do
			local ranking = ed:FindBy("ranking_id", i)
			data = data + ranking.ascending_order_star
		end
		data = data + role._roledata._pvp_info._cur_star
		data1 = data
	end
	--是否匹配机器人
	local arg = {}
	arg.rank = role._roledata._pvp_info._pvp_grade
	arg.failed_count_in_succession = role._roledata._pvp_info._failed_count_in_succession
	local ed = DataPool_Find("elementdata")
	local rank_data = ed:FindBy("ranking_id", arg.rank)
	local pvp_vs_robot = 0
	local pvp_wait_max_before_vs_robot = 99999
	pvp_vs_robot, pvp_wait_max_before_vs_robot = DESIGNER_PVPVsRobot(arg, rank_data)
	--typ等于1的时候代表的是跨服战斗
	pvpinfo.pvp_score = data1
	local os = {}
	SerializeStruct(os, pvpinfo)
	role._roledata._pvp._pvpcenterinfo = table.concat(os)
	role._roledata._pvp._typ = G_PVP_STATE_TYP["3V3"]
	role:SendPVPJoin(data, pvp_vs_robot, pvp_wait_max_before_vs_robot)
end

function ROLE_UpdateTeXing(role, texing_id)
	local insert_info = CACHE.Int()
	insert_info._value = texing_id
	role._roledata._status._texing:PushBack(insert_info)

	local resp = NewCommand("TeXingUpdateInfo")
	resp.texing_add = {}
	resp.texing_del = {}

	resp.texing_add[#resp.texing_add+1] = texing_id
	role:SendToClient(SerializeCommand(resp))
end

function ROLE_GetAllHeroStar(role)
	local all_star = 0
	local hero_info_it = role._roledata._hero_hall._heros:SeekToBegin()
	local hero_info = hero_info_it:GetValue()
	while hero_info ~= nil do
		all_star = hero_info._star + all_star
		
		hero_info_it:Next()
		hero_info = hero_info_it:GetValue()
	end
	return all_star
end

function ROLE_InitBattleRoleData(role)
	role._roledata._battle_role_data.battleType = 0
	role._roledata._battle_role_data.controlTypeL = 0
	role._roledata._battle_role_data.controlTypeR = 0
	role._roledata._battle_role_data.sceneID = 0
	role._roledata._battle_role_data.BGMID = 0
	role._roledata._battle_role_data.startDialogID = 0
	role._roledata._battle_role_data.endDialogID = 0
	role._roledata._battle_role_data.instanceID = 0
	role._roledata._battle_role_data.legionStar = 0
	role._roledata._battle_role_data.remainTime = 0
	role._roledata._battle_role_data.rideScriptID = 0
	role._roledata._battle_role_data.stagehpadjust = 0
	role._roledata._battle_role_data.stageatkadjust = 0
	role._roledata._battle_role_data.stagearmoradjust = 0
	role._roledata._battle_role_data.randSeed = 0
	role._roledata._battle_role_data.friendId:Set("0")
	role._roledata._battle_role_data.eventingHighScore = 0
	role._roledata._battle_role_data.eventingRank = 0
	role._roledata._battle_role_data.monsterLevel = 0
	role._roledata._battle_role_data.starConditions.condition1.id = 0
	role._roledata._battle_role_data.starConditions.condition1.conType = 0
	role._roledata._battle_role_data.starConditions.condition1.param1 = 0
	role._roledata._battle_role_data.starConditions.condition1.param2 = 0
	role._roledata._battle_role_data.starConditions.condition2.id = 0
	role._roledata._battle_role_data.starConditions.condition2.conType = 0
	role._roledata._battle_role_data.starConditions.condition2.param1 = 0
	role._roledata._battle_role_data.starConditions.condition2.param2 = 0
	role._roledata._battle_role_data.starConditions.condition3.id = 0
	role._roledata._battle_role_data.starConditions.condition3.conType = 0
	role._roledata._battle_role_data.starConditions.condition3.param1 = 0
	role._roledata._battle_role_data.starConditions.condition3.param2 = 0
	role._roledata._battle_role_data.legionInfoL.totalStar = 0
	role._roledata._battle_role_data.legionInfoL.friend_zhanli = 0
	role._roledata._battle_role_data.legionInfoL.buffs:Clear()
	role._roledata._battle_role_data.legionInfoR.totalStar = 0
	role._roledata._battle_role_data.legionInfoR.friend_zhanli = 0
	role._roledata._battle_role_data.legionInfoR.buffs:Clear()

	role._roledata._battle_role_data.leftRoleTab.role1.level = 0
	role._roledata._battle_role_data.leftRoleTab.role1.star = 0
	role._roledata._battle_role_data.leftRoleTab.role1.chosenMusou = 0
	role._roledata._battle_role_data.leftRoleTab.role1.grade = 0
	role._roledata._battle_role_data.leftRoleTab.role1.chainSkill:Clear()
	role._roledata._battle_role_data.leftRoleTab.role1.templateID = 0
	role._roledata._battle_role_data.leftRoleTab.role1.equip:Clear()
	role._roledata._battle_role_data.leftRoleTab.role1.skillPcks:Clear()
	role._roledata._battle_role_data.leftRoleTab.role1.index = 0
	role._roledata._battle_role_data.leftRoleTab.role1.roleType = -1
	role._roledata._battle_role_data.leftRoleTab.role1.relationID:Clear()
	role._roledata._battle_role_data.leftRoleTab.role1.features:Clear()
	role._roledata._battle_role_data.leftRoleTab.role1.isShinMusouAvail = 0
	role._roledata._battle_role_data.leftRoleTab.role2.level = 0
	role._roledata._battle_role_data.leftRoleTab.role2.star = 0
	role._roledata._battle_role_data.leftRoleTab.role2.chosenMusou = 0
	role._roledata._battle_role_data.leftRoleTab.role2.grade = 0
	role._roledata._battle_role_data.leftRoleTab.role2.chainSkill:Clear()
	role._roledata._battle_role_data.leftRoleTab.role2.templateID = 0
	role._roledata._battle_role_data.leftRoleTab.role2.equip:Clear()
	role._roledata._battle_role_data.leftRoleTab.role2.skillPcks:Clear()
	role._roledata._battle_role_data.leftRoleTab.role2.index = 0
	role._roledata._battle_role_data.leftRoleTab.role2.roleType = -1
	role._roledata._battle_role_data.leftRoleTab.role2.relationID:Clear()
	role._roledata._battle_role_data.leftRoleTab.role2.features:Clear()
	role._roledata._battle_role_data.leftRoleTab.role2.isShinMusouAvail = 0
	role._roledata._battle_role_data.leftRoleTab.role3.level = 0
	role._roledata._battle_role_data.leftRoleTab.role3.star = 0
	role._roledata._battle_role_data.leftRoleTab.role3.chosenMusou = 0
	role._roledata._battle_role_data.leftRoleTab.role3.grade = 0
	role._roledata._battle_role_data.leftRoleTab.role3.chainSkill:Clear()
	role._roledata._battle_role_data.leftRoleTab.role3.templateID = 0
	role._roledata._battle_role_data.leftRoleTab.role3.equip:Clear()
	role._roledata._battle_role_data.leftRoleTab.role3.skillPcks:Clear()
	role._roledata._battle_role_data.leftRoleTab.role3.index = 0
	role._roledata._battle_role_data.leftRoleTab.role3.roleType = -1
	role._roledata._battle_role_data.leftRoleTab.role3.relationID:Clear()
	role._roledata._battle_role_data.leftRoleTab.role3.features:Clear()
	role._roledata._battle_role_data.leftRoleTab.role3.isShinMusouAvail = 0
	role._roledata._battle_role_data.rightRoleTab.role1.level = 0
	role._roledata._battle_role_data.rightRoleTab.role1.star = 0
	role._roledata._battle_role_data.rightRoleTab.role1.chosenMusou = 0
	role._roledata._battle_role_data.rightRoleTab.role1.grade = 0
	role._roledata._battle_role_data.rightRoleTab.role1.chainSkill:Clear()
	role._roledata._battle_role_data.rightRoleTab.role1.templateID = 0
	role._roledata._battle_role_data.rightRoleTab.role1.equip:Clear()
	role._roledata._battle_role_data.rightRoleTab.role1.skillPcks:Clear()
	role._roledata._battle_role_data.rightRoleTab.role1.index = 0
	role._roledata._battle_role_data.rightRoleTab.role1.roleType = -1
	role._roledata._battle_role_data.rightRoleTab.role1.relationID:Clear()
	role._roledata._battle_role_data.rightRoleTab.role1.features:Clear()
	role._roledata._battle_role_data.rightRoleTab.role1.isShinMusouAvail = 0
	role._roledata._battle_role_data.rightRoleTab.role2.level = 0
	role._roledata._battle_role_data.rightRoleTab.role2.star = 0
	role._roledata._battle_role_data.rightRoleTab.role2.chosenMusou = 0
	role._roledata._battle_role_data.rightRoleTab.role2.grade = 0
	role._roledata._battle_role_data.rightRoleTab.role2.chainSkill:Clear()
	role._roledata._battle_role_data.rightRoleTab.role2.templateID = 0
	role._roledata._battle_role_data.rightRoleTab.role2.equip:Clear()
	role._roledata._battle_role_data.rightRoleTab.role2.skillPcks:Clear()
	role._roledata._battle_role_data.rightRoleTab.role2.index = 0
	role._roledata._battle_role_data.rightRoleTab.role2.roleType = -1
	role._roledata._battle_role_data.rightRoleTab.role2.relationID:Clear()
	role._roledata._battle_role_data.rightRoleTab.role2.features:Clear()
	role._roledata._battle_role_data.rightRoleTab.role2.isShinMusouAvail = 0
	role._roledata._battle_role_data.rightRoleTab.role3.level = 0
	role._roledata._battle_role_data.rightRoleTab.role3.star = 0
	role._roledata._battle_role_data.rightRoleTab.role3.chosenMusou = 0
	role._roledata._battle_role_data.rightRoleTab.role3.grade = 0
	role._roledata._battle_role_data.rightRoleTab.role3.chainSkill:Clear()
	role._roledata._battle_role_data.rightRoleTab.role3.templateID = 0
	role._roledata._battle_role_data.rightRoleTab.role3.equip:Clear()
	role._roledata._battle_role_data.rightRoleTab.role3.skillPcks:Clear()
	role._roledata._battle_role_data.rightRoleTab.role3.index = 0
	role._roledata._battle_role_data.rightRoleTab.role3.roleType = -1
	role._roledata._battle_role_data.rightRoleTab.role3.relationID:Clear()
	role._roledata._battle_role_data.rightRoleTab.role3.features:Clear()
	role._roledata._battle_role_data.rightRoleTab.role3.isShinMusouAvail = 0
end

function ROLE_SetBattleRoleData(role, stage, battle_typ, controlTypeL, controlTypeR, randseed, hero_id1, hero_id2, hero_id3)
	if hero_id1 == nil then
		hero_id1 = 0
	end
	if hero_id2 == nil then
		hero_id2 = 0
	end
	if hero_id3 == nil then
		hero_id3 = 0
	end
	local ed = DataPool_Find("elementdata")
	
	role._roledata._battle_role_data.battleType = battle_typ
	role._roledata._battle_role_data.controlTypeL = controlTypeL
	role._roledata._battle_role_data.controlTypeR = controlTypeR
	role._roledata._battle_role_data.sceneID = stage.mapid
	role._roledata._battle_role_data.BGMID = stage.musicid

	if role._roledata._status._instances:Find(stage.stageid) == nil then
		role._roledata._battle_role_data.startDialogID = stage.startstoryid
		role._roledata._battle_role_data.endDialogID = stage.endstoryid
	else
		role._roledata._battle_role_data.startDialogID = 0
		role._roledata._battle_role_data.endDialogID = 0
	end
	role._roledata._battle_role_data.instanceID = stage.stageid
	role._roledata._battle_role_data.legionStar = ROLE_GetAllHeroStar(role)
	role._roledata._battle_role_data.remainTime = stage.max_time
	role._roledata._battle_role_data.rideScriptID = stage.ridescriptid
	role._roledata._battle_role_data.stagehpadjust = stage.stagehpadjust
	role._roledata._battle_role_data.stageatkadjust = stage.stageatkadjust
	role._roledata._battle_role_data.stagearmoradjust = 0
	role._roledata._battle_role_data.randSeed = randseed
	role._roledata._battle_role_data.friendId:Set("0")
	role._roledata._battle_role_data.eventingHighScore = 0
	role._roledata._battle_role_data.eventingRank = 0
	role._roledata._battle_role_data.monsterLevel = stage.monster_level

	role._roledata._battle_role_data.starConditions.condition1.id = 0
	role._roledata._battle_role_data.starConditions.condition1.conType = 0
	role._roledata._battle_role_data.starConditions.condition1.param1 = 0
	role._roledata._battle_role_data.starConditions.condition1.param2 = 0
	role._roledata._battle_role_data.starConditions.condition2.id = 0
	role._roledata._battle_role_data.starConditions.condition2.conType = 0
	role._roledata._battle_role_data.starConditions.condition2.param1 = 0
	role._roledata._battle_role_data.starConditions.condition2.param2 = 0
	role._roledata._battle_role_data.starConditions.condition3.id = 0
	role._roledata._battle_role_data.starConditions.condition3.conType = 0
	role._roledata._battle_role_data.starConditions.condition3.param1 = 0
	role._roledata._battle_role_data.starConditions.condition3.param2 = 0

	role._roledata._battle_role_data.legionInfoL.totalStar = ROLE_GetAllHeroStar(role)
	role._roledata._battle_role_data.legionInfoL.friend_zhanli = 0
	role._roledata._battle_role_data.legionInfoL.buffs:Clear()
	local buff_info_it = role._roledata._mashu_info._buff:SeekToBegin()
	local buff_info = buff_info_it:GetValue()
	while buff_info ~= nil do
		role._roledata._battle_role_data.legionInfoL.buffs:PushBack(buff_info._buff_id)
		
		buff_info_it:Next()
		buff_info = buff_info_it:GetValue()
	end
	role._roledata._battle_role_data.legionInfoR.totalStar = 0
--	role._roledata._battle_role_data.legionInfoR.friend_zhanli = 0
	role._roledata._battle_role_data.legionInfoR.buffs:Clear()

	local chainskills_role1 = {}
	local hero_info = role._roledata._hero_hall._heros:Find(hero_id1)
	if hero_info ~= nil then
		role._roledata._battle_role_data.leftRoleTab.role1.level = hero_info._level
		role._roledata._battle_role_data.leftRoleTab.role1.star = hero_info._star
		role._roledata._battle_role_data.leftRoleTab.role1.index = 1
		role._roledata._battle_role_data.leftRoleTab.role1.roleType = 0
		role._roledata._battle_role_data.leftRoleTab.role1.grade = hero_info._order
		role._roledata._battle_role_data.leftRoleTab.role1.templateID = hero_info._tid
		role._roledata._battle_role_data.leftRoleTab.role1.isShinMusouAvail = 1
		role._roledata._battle_role_data.leftRoleTab.role1.skillPcks:Clear()
		role._roledata._battle_role_data.leftRoleTab.role1.features:Clear()
		role._roledata._battle_role_data.leftRoleTab.role1.equip:Clear()
		role._roledata._battle_role_data.leftRoleTab.role1.relationID:Clear()
		--合体技能最后再进行处理
		role._roledata._battle_role_data.leftRoleTab.role1.chainSkill:Clear()

		local heroinfo = ed:FindBy("hero_id", hero_id1)
		local skill = ed:FindBy("skill_id", heroinfo.fightscriptid)
		local flag = 0
		local select_skill_it = hero_info._select_skill:SeekToBegin()
		local select_skill = select_skill_it:GetValue()
		if select_skill ~= nil then
			for tmp_skill in DataPool_Array(skill.musou) do
				flag = flag + 1
				if tmp_skill.skillpackageID == select_skill._value then
					role._roledata._battle_role_data.leftRoleTab.role1.chosenMusou = flag
					break
				end
			end
		end

		for chainskill in DataPool_Array(heroinfo.chainskillid) do
			if chainskill ~= 0 then
				chainskills_role1[#chainskills_role1+1] = chainskill
			else
				break
			end
		end
		
		local relation_it = hero_info._relation:SeekToBegin()
		local relation = relation_it:GetValue()
		while relation ~= nil do
			role._roledata._battle_role_data.leftRoleTab.role1.relationID:PushBack(relation)

			relation_it:Next()
			relation = relation_it:GetValue()
		end

		--无双技能	
		local select_skill_it = hero_info._select_skill:SeekToBegin()
		local select_skill = select_skill_it:GetValue()
		while select_skill ~= nil do
			local tmp = CACHE.BattleNumInfo()
			tmp.id = select_skill._value
			tmp.level = 1

			API_Log("1111111111111111111111111111111111111111111111 "..select_skill._value)
			role._roledata._battle_role_data.leftRoleTab.role1.skillPcks:PushBack(tmp)
			select_skill_it:Next()
			select_skill = select_skill_it:GetValue()
			
		end
		--普通技能
		local common_skill_it = hero_info._common_skill:SeekToBegin()
		local common_skill = common_skill_it:GetValue()
		while common_skill ~= nil do
			local tmp = CACHE.BattleNumInfo()
			tmp.id = common_skill._skill_id
			tmp.level = common_skill._skill_level
			role._roledata._battle_role_data.leftRoleTab.role1.skillPcks:PushBack(tmp)
			common_skill_it:Next()
			common_skill = common_skill_it:GetValue()
		end

		--升阶带来的特性
		local beidong_skill_it = hero_info._beidong_skill:SeekToBegin()
		local beidong_skill = beidong_skill_it:GetValue()
		while beidong_skill ~= nil do
			local tmp = CACHE.BattleNumInfo()
			tmp.level = beidong_skill._value%1000
			tmp.id = (beidong_skill._value-tmp.level)/1000
			role._roledata._battle_role_data.leftRoleTab.role1.features:PushBack(tmp)
			beidong_skill_it:Next()
			beidong_skill = beidong_skill_it:GetValue()
		end
		
		--武将装备的信息，包括武器和装备。
		local wenpon_id = hero_info._weapon_id
		if wenpon_id ~= 0 then
			local weapon_items = role._roledata._backpack._weapon_items

			local weapon_item_it = weapon_items._weapon_items:SeekToBegin()
			local weapon_item = weapon_item_it:GetValue()
			while weapon_item ~= nil do
				if weapon_item._weapon_pro._tid == wenpon_id then
					local equip_info = CACHE.BattleEquip()
					equip_info.typ = 1
					equip_info.id = weapon_item._base_item._tid
					equip_info.info.level_up = weapon_item._weapon_pro._level_up
					equip_info.info.star = weapon_item._weapon_pro._star
					equip_info.info.quality = weapon_item._weapon_pro._quality
					equip_info.info.prop = weapon_item._weapon_pro._prop
					equip_info.info.attack = weapon_item._weapon_pro._attack
					equip_info.info.strength = weapon_item._weapon_pro._strengthen
					equip_info.info.strength_prob = weapon_item._weapon_pro._strengthen_prob

					local tmp = CACHE.BattleNumInfo()
					tmp.level = 1
					tmp.id = weapon_item._weapon_pro._weapon_skill
					role._roledata._battle_role_data.leftRoleTab.role1.features:PushBack(tmp)
					
					local skill_pro_it = weapon_item._weapon_pro._skill_pro:SeekToBegin()
					local skill_pro = skill_pro_it:GetValue()
					while skill_pro ~= nil do
						local tmp = CACHE.BattleNumInfo()
						tmp.level = skill_pro._skill_level
						tmp.id = skill_pro._skill_id
						role._roledata._battle_role_data.leftRoleTab.role1.features:PushBack(tmp)
						skill_pro_it:Next()
						skill_pro = skill_pro_it:GetValue()
					end
					role._roledata._battle_role_data.leftRoleTab.role1.equip:PushBack(equip_info)
					break
				end
				weapon_item_it:Next()
				weapon_item = weapon_item_it:GetValue()
			end
		end

		--武将的装备
		local equipment_it = hero_info._equipment:SeekToBegin()
		local equipment = equipment_it:GetValue()
		while equipment ~= nil do
			local find_equipment = role._roledata._backpack._equipment_items._equipment_items:Find(equipment._id)
			if find_equipment ~= nil then
				local equip_info = CACHE.BattleEquip()
				equip_info.typ = 2
				equip_info.id = find_equipment._base_item._tid
				
				equip_info.info.tid = equipment._id
				equip_info.info.hero_id = 0
				equip_info.info.level = find_equipment._equipment_pro._level_up
				equip_info.info.order = find_equipment._equipment_pro._order
				local refine_it = find_equipment._equipment_pro._refinable_pro:SeekToBegin()
				local refine = refine_it:GetValue()
				while refine ~= nil do
					local tmp = CACHE.BattleRefinable_Pro()
					tmp.typ = refine._typ
					tmp.data = refine._num
					equip_info.info.refinable_pro:PushBack(tmp)
					refine_it:Next()
					refine = refine_it:GetValue()
				end
				role._roledata._battle_role_data.leftRoleTab.role1.equip:PushBack(equip_info)
			end

			equipment_it:Next()
			equipment = equipment_it:GetValue()
		end
	end

	local chainskills_role2 = {}
	local hero_info = role._roledata._hero_hall._heros:Find(hero_id2)
	if hero_info ~= nil then
		role._roledata._battle_role_data.leftRoleTab.role2.level = hero_info._level
		role._roledata._battle_role_data.leftRoleTab.role2.star = hero_info._star
		role._roledata._battle_role_data.leftRoleTab.role2.index = 1
		role._roledata._battle_role_data.leftRoleTab.role2.roleType = 0
		role._roledata._battle_role_data.leftRoleTab.role2.grade = hero_info._order
		role._roledata._battle_role_data.leftRoleTab.role2.templateID = hero_info._tid
		role._roledata._battle_role_data.leftRoleTab.role2.isShinMusouAvail = 1
		role._roledata._battle_role_data.leftRoleTab.role2.skillPcks:Clear()
		role._roledata._battle_role_data.leftRoleTab.role2.features:Clear()
		role._roledata._battle_role_data.leftRoleTab.role2.equip:Clear()
		role._roledata._battle_role_data.leftRoleTab.role2.relationID:Clear()
		--合体技能最后再进行处理
		role._roledata._battle_role_data.leftRoleTab.role2.chainSkill:Clear()

		local heroinfo = ed:FindBy("hero_id", hero_id2)
		local skill = ed:FindBy("skill_id", heroinfo.fightscriptid)
		local flag = 0
		local select_skill_it = hero_info._select_skill:SeekToBegin()
		local select_skill = select_skill_it:GetValue()
		if select_skill ~= nil then
			for tmp_skill in DataPool_Array(skill.musou) do
				flag = flag + 1
				if tmp_skill.skillpackageID == select_skill._value then
					role._roledata._battle_role_data.leftRoleTab.role2.chosenMusou = flag
					break
				end
			end
		end

		for chainskill in DataPool_Array(heroinfo.chainskillid) do
			if chainskill ~= 0 then
				chainskills_role2[#chainskills_role2+1] = chainskill
			else
				break
			end
		end
		
		local relation_it = hero_info._relation:SeekToBegin()
		local relation = relation_it:GetValue()
		while relation ~= nil do
			role._roledata._battle_role_data.leftRoleTab.role2.relationID:PushBack(relation)

			relation_it:Next()
			relation = relation_it:GetValue()
		end

		--无双技能	
		local select_skill_it = hero_info._select_skill:SeekToBegin()
		local select_skill = select_skill_it:GetValue()
		while select_skill ~= nil do
			local tmp = CACHE.BattleNumInfo()
			tmp.id = select_skill._value
			tmp.level = 1
			role._roledata._battle_role_data.leftRoleTab.role2.skillPcks:PushBack(tmp)
			skill_it:Next()
			skill = skill_it:GetValue()
		end
		--普通技能
		local common_skill_it = hero_info._common_skill:SeekToBegin()
		local common_skill = common_skill_it:GetValue()
		while common_skill ~= nil do
			local tmp = CACHE.BattleNumInfo()
			tmp.id = common_skill._skill_id
			tmp.level = common_skill._skill_level
			role._roledata._battle_role_data.leftRoleTab.role2.skillPcks:PushBack(tmp)
			common_skill_it:Next()
			common_skill = common_skill_it:GetValue()
		end

		--升阶带来的特性
		local beidong_skill_it = hero_info._beidong_skill:SeekToBegin()
		local beidong_skill = beidong_skill_it:GetValue()
		while beidong_skill ~= nil do
			local tmp = CACHE.BattleNumInfo()
			tmp.level = beidong_skill._value%1000
			tmp.id = (beidong_skill._value-tmp.level)/1000
			role._roledata._battle_role_data.leftRoleTab.role2.features:PushBack(tmp)
			beidong_skill_it:Next()
			beidong_skill = beidong_skill_it:GetValue()
		end
		
		--武将装备的信息，包括武器和装备。
		local wenpon_id = hero_info._weapon_id
		if wenpon_id ~= 0 then
			local weapon_items = role._roledata._backpack._weapon_items

			local weapon_item_it = weapon_items._weapon_items:SeekToBegin()
			local weapon_item = weapon_item_it:GetValue()
			while weapon_item ~= nil do
				if weapon_item._weapon_pro._tid == wenpon_id then
					local equip_info = CACHE.BattleEquip()
					equip_info.typ = 1
					equip_info.id = weapon_item._base_item._tid
					equip_info.info.level_up = weapon_item._weapon_pro._level_up
					equip_info.info.star = weapon_item._weapon_pro._star
					equip_info.info.quality = weapon_item._weapon_pro._quality
					equip_info.info.prop = weapon_item._weapon_pro._prop
					equip_info.info.attack = weapon_item._weapon_pro._attack
					equip_info.info.strength = weapon_item._weapon_pro._strengthen
					equip_info.info.strength_prob = weapon_item._weapon_pro._strengthen_prob

					local tmp = CACHE.BattleNumInfo()
					tmp.level = 1
					tmp.id = weapon_item._weapon_pro._weapon_skill
					role._roledata._battle_role_data.leftRoleTab.role2.features:PushBack(tmp)
					
					local skill_pro_it = weapon_item._weapon_pro._skill_pro:SeekToBegin()
					local skill_pro = skill_pro_it:GetValue()
					while skill_pro ~= nil do
						local tmp = CACHE.BattleNumInfo()
						tmp.level = skill_pro._skill_level
						tmp.id = skill_pro._skill_id
						role._roledata._battle_role_data.leftRoleTab.role2.features:PushBack(tmp)
						skill_pro_it:Next()
						skill_pro = skill_pro_it:GetValue()
					end
					role._roledata._battle_role_data.leftRoleTab.role2.equip:PushBack(equip_info)
					break
				end
				weapon_item_it:Next()
				weapon_item = weapon_item_it:GetValue()
			end
		end

		--武将的装备
		local equipment_it = hero_info._equipment:SeekToBegin()
		local equipment = equipment_it:GetValue()
		while equipment ~= nil do
			local find_equipment = role._roledata._backpack._equipment_items._equipment_items:Find(equipment._id)
			if find_equipment ~= nil then
				local equip_info = CACHE.BattleEquip()
				equip_info.typ = 2
				equip_info.id = find_equipment._base_item._tid
				
				equip_info.info.tid = equipment._id
				equip_info.info.hero_id = 0
				equip_info.info.level = find_equipment._equipment_pro._level_up
				equip_info.info.order = find_equipment._equipment_pro._order
				local refine_it = find_equipment._equipment_pro._refinable_pro:SeekToBegin()
				local refine = refine_it:GetValue()
				while refine ~= nil do
					local tmp = CACHE.BattleRefinable_Pro()
					tmp.typ = refine._typ
					tmp.data = refine._num
					equip_info.info.refinable_pro:PushBack(tmp)
					refine_it:Next()
					refine = refine_it:GetValue()
				end
				role._roledata._battle_role_data.leftRoleTab.role2.equip:PushBack(equip_info)
			end

			equipment_it:Next()
			equipment = equipment_it:GetValue()
		end
	end

	local chainskills_role3 = {}
	local hero_info = role._roledata._hero_hall._heros:Find(hero_id3)
	if hero_info ~= nil then
		role._roledata._battle_role_data.leftRoleTab.role3.level = hero_info._level
		role._roledata._battle_role_data.leftRoleTab.role3.star = hero_info._star
		role._roledata._battle_role_data.leftRoleTab.role3.index = 1
		role._roledata._battle_role_data.leftRoleTab.role3.roleType = 0
		role._roledata._battle_role_data.leftRoleTab.role3.grade = hero_info._order
		role._roledata._battle_role_data.leftRoleTab.role3.templateID = hero_info._tid
		role._roledata._battle_role_data.leftRoleTab.role3.isShinMusouAvail = 1
		role._roledata._battle_role_data.leftRoleTab.role3.skillPcks:Clear()
		role._roledata._battle_role_data.leftRoleTab.role3.features:Clear()
		role._roledata._battle_role_data.leftRoleTab.role3.equip:Clear()
		role._roledata._battle_role_data.leftRoleTab.role3.relationID:Clear()
		--合体技能最后再进行处理
		role._roledata._battle_role_data.leftRoleTab.role3.chainSkill:Clear()

		local heroinfo = ed:FindBy("hero_id", hero_id3)
		local skill = ed:FindBy("skill_id", heroinfo.fightscriptid)
		local flag = 0
		local select_skill_it = hero_info._select_skill:SeekToBegin()
		local select_skill = select_skill_it:GetValue()
		if select_skill ~= nil then
			for tmp_skill in DataPool_Array(skill.musou) do
				flag = flag + 1
				if tmp_skill.skillpackageID == select_skill._value then
					role._roledata._battle_role_data.leftRoleTab.role3.chosenMusou = flag
					break
				end
			end
		end

		for chainskill in DataPool_Array(heroinfo.chainskillid) do
			if chainskill ~= 0 then
				chainskills_role3[#chainskills_role3+1] = chainskill
			else
				break
			end
		end
		
		local relation_it = hero_info._relation:SeekToBegin()
		local relation = relation_it:GetValue()
		while relation ~= nil do
			role._roledata._battle_role_data.leftRoleTab.role3.relationID:PushBack(relation)

			relation_it:Next()
			relation = relation_it:GetValue()
		end

		--无双技能	
		local select_skill_it = hero_info._select_skill:SeekToBegin()
		local select_skill = select_skill_it:GetValue()
		while select_skill ~= nil do
			local tmp = CACHE.BattleNumInfo()
			tmp.id = select_skill._value
			tmp.level = 1
			role._roledata._battle_role_data.leftRoleTab.role3.skillPcks:PushBack(tmp)
			skill_it:Next()
			skill = skill_it:GetValue()
		end
		--普通技能
		local common_skill_it = hero_info._common_skill:SeekToBegin()
		local common_skill = common_skill_it:GetValue()
		while common_skill ~= nil do
			local tmp = CACHE.BattleNumInfo()
			tmp.id = common_skill._skill_id
			tmp.level = common_skill._skill_level
			role._roledata._battle_role_data.leftRoleTab.role3.skillPcks:PushBack(tmp)
			common_skill_it:Next()
			common_skill = common_skill_it:GetValue()
		end

		--升阶带来的特性
		local beidong_skill_it = hero_info._beidong_skill:SeekToBegin()
		local beidong_skill = beidong_skill_it:GetValue()
		while beidong_skill ~= nil do
			local tmp = CACHE.BattleNumInfo()
			tmp.level = beidong_skill._value%1000
			tmp.id = (beidong_skill._value-tmp.level)/1000
			role._roledata._battle_role_data.leftRoleTab.role3.features:PushBack(tmp)
			beidong_skill_it:Next()
			beidong_skill = beidong_skill_it:GetValue()
		end
		
		--武将装备的信息，包括武器和装备。
		local wenpon_id = hero_info._weapon_id
		if wenpon_id ~= 0 then
			local weapon_items = role._roledata._backpack._weapon_items

			local weapon_item_it = weapon_items._weapon_items:SeekToBegin()
			local weapon_item = weapon_item_it:GetValue()
			while weapon_item ~= nil do
				if weapon_item._weapon_pro._tid == wenpon_id then
					local equip_info = CACHE.BattleEquip()
					equip_info.typ = 1
					equip_info.id = weapon_item._base_item._tid
					equip_info.info.level_up = weapon_item._weapon_pro._level_up
					equip_info.info.star = weapon_item._weapon_pro._star
					equip_info.info.quality = weapon_item._weapon_pro._quality
					equip_info.info.prop = weapon_item._weapon_pro._prop
					equip_info.info.attack = weapon_item._weapon_pro._attack
					equip_info.info.strength = weapon_item._weapon_pro._strengthen
					equip_info.info.strength_prob = weapon_item._weapon_pro._strengthen_prob

					local tmp = CACHE.BattleNumInfo()
					tmp.level = 1
					tmp.id = weapon_item._weapon_pro._weapon_skill
					role._roledata._battle_role_data.leftRoleTab.role3.features:PushBack(tmp)
					
					local skill_pro_it = weapon_item._weapon_pro._skill_pro:SeekToBegin()
					local skill_pro = skill_pro_it:GetValue()
					while skill_pro ~= nil do
						local tmp = CACHE.BattleNumInfo()
						tmp.level = skill_pro._skill_level
						tmp.id = skill_pro._skill_id
						role._roledata._battle_role_data.leftRoleTab.role3.features:PushBack(tmp)
						skill_pro_it:Next()
						skill_pro = skill_pro_it:GetValue()
					end
					role._roledata._battle_role_data.leftRoleTab.role3.equip:PushBack(equip_info)
					break
				end
				weapon_item_it:Next()
				weapon_item = weapon_item_it:GetValue()
			end
		end

		--武将的装备
		local equipment_it = hero_info._equipment:SeekToBegin()
		local equipment = equipment_it:GetValue()
		while equipment ~= nil do
			local find_equipment = role._roledata._backpack._equipment_items._equipment_items:Find(equipment._id)
			if find_equipment ~= nil then
				local equip_info = CACHE.BattleEquip()
				equip_info.typ = 2
				equip_info.id = find_equipment._base_item._tid
				
				equip_info.info.tid = equipment._id
				equip_info.info.hero_id = 0
				equip_info.info.level = find_equipment._equipment_pro._level_up
				equip_info.info.order = find_equipment._equipment_pro._order
				local refine_it = find_equipment._equipment_pro._refinable_pro:SeekToBegin()
				local refine = refine_it:GetValue()
				while refine ~= nil do
					local tmp = CACHE.BattleRefinable_Pro()
					tmp.typ = refine._typ
					tmp.data = refine._num
					equip_info.info.refinable_pro:PushBack(tmp)
					refine_it:Next()
					refine = refine_it:GetValue()
				end
				role._roledata._battle_role_data.leftRoleTab.role3.equip:PushBack(equip_info)
			end

			equipment_it:Next()
			equipment = equipment_it:GetValue()
		end
	end
	
	--左边武将的合体技能
	for index1 = 1,table.getn(chainskills_role1) do
		for index2 = 1,table.getn(chainskills_role2) do
			if chainskills_role2[index2] == chainskills_role1[index1] then
				local tmp = CACHE.Int()
				tmp._value = chainskills_role1[index1]
				role._roledata._battle_role_data.leftRoleTab.role1.chainSkill:PushBack(tmp)
				role._roledata._battle_role_data.leftRoleTab.role2.chainSkill:PushBack(tmp)
			end
		end
		for index3 = 1,table.getn(chainskills_role3) do
			if chainskills_role3[index3] == chainskills_role1[index1] then
				local tmp = CACHE.Int()
				tmp._value = chainskills_role1[index1]
				role._roledata._battle_role_data.leftRoleTab.role1.chainSkill:PushBack(tmp)
				role._roledata._battle_role_data.leftRoleTab.role3.chainSkill:PushBack(tmp)
			end
		end
	end
	
	for index2 = 1,table.getn(chainskills_role2) do
		for index3 = 1,table.getn(chainskills_role3) do
			if chainskills_role3[index3] == chainskills_role2[index2] then
				local tmp = CACHE.Int()
				tmp._value = chainskills_role2[index2]
				role._roledata._battle_role_data.leftRoleTab.role2.chainSkill:PushBack(tmp)
				role._roledata._battle_role_data.leftRoleTab.role3.chainSkill:PushBack(tmp)
			end
		end
	end

	role._roledata._battle_role_data.rightRoleTab.role1.level = 0
	role._roledata._battle_role_data.rightRoleTab.role1.star = 0
	role._roledata._battle_role_data.rightRoleTab.role1.chosenMusou = 0
	role._roledata._battle_role_data.rightRoleTab.role1.grade = 0
	role._roledata._battle_role_data.rightRoleTab.role1.chainSkill:Clear()
	role._roledata._battle_role_data.rightRoleTab.role1.templateID = 0
	role._roledata._battle_role_data.rightRoleTab.role1.equip:Clear()
	role._roledata._battle_role_data.rightRoleTab.role1.skillPcks:Clear()
	role._roledata._battle_role_data.rightRoleTab.role1.index = 0
	role._roledata._battle_role_data.rightRoleTab.role1.roleType = -1
	role._roledata._battle_role_data.rightRoleTab.role1.relationID:Clear()
	role._roledata._battle_role_data.rightRoleTab.role1.features:Clear()
	role._roledata._battle_role_data.rightRoleTab.role1.isShinMusouAvail = 0
	
	if stage.monster1id ~= 0 then
		role._roledata._battle_role_data.rightRoleTab.role1.level = stage.monster_level
		role._roledata._battle_role_data.rightRoleTab.role1.index = 1
		role._roledata._battle_role_data.rightRoleTab.role1.roleType = 1
		role._roledata._battle_role_data.rightRoleTab.role1.templateID = stage.monster1id
		local momster_info = ed:FindBy("monster_id", stage.monster1id)
		role._roledata._battle_role_data.rightRoleTab.role1.chosenMusou = momster_info.chosen_musou
		for teji in DataPool_Array(momster_info.monster_teji) do
			if teji.monster_teji_id ~= 0 then
				local tmp = CACHE.BattleNumInfo()
				tmp.level = teji.monster_teji_level
				tmp.id = teji.monster_teji_id
				role._roledata._battle_role_data.rightRoleTab.role1.features:PushBack(tmp)
			else
				break
			end
		end
		
		local proftab_info = ed:FindBy("proftab_id", momster_info.proftabid*1000+stage.monster_level)
		role._roledata._battle_role_data.rightRoleTab.role1.star = proftab_info.star
		role._roledata._battle_role_data.rightRoleTab.role1.grade = proftab_info.grade
	end

	role._roledata._battle_role_data.rightRoleTab.role2.level = 0
	role._roledata._battle_role_data.rightRoleTab.role2.star = 0
	role._roledata._battle_role_data.rightRoleTab.role2.chosenMusou = 0
	role._roledata._battle_role_data.rightRoleTab.role2.grade = 0
	role._roledata._battle_role_data.rightRoleTab.role2.chainSkill:Clear()
	role._roledata._battle_role_data.rightRoleTab.role2.templateID = 0
	role._roledata._battle_role_data.rightRoleTab.role2.equip:Clear()
	role._roledata._battle_role_data.rightRoleTab.role2.skillPcks:Clear()
	role._roledata._battle_role_data.rightRoleTab.role2.index = 0
	role._roledata._battle_role_data.rightRoleTab.role2.roleType = -1
	role._roledata._battle_role_data.rightRoleTab.role2.relationID:Clear()
	role._roledata._battle_role_data.rightRoleTab.role2.features:Clear()
	role._roledata._battle_role_data.rightRoleTab.role2.isShinMusouAvail = 0
	
	if stage.monster2id ~= 0 then
		role._roledata._battle_role_data.rightRoleTab.role2.level = stage.monster_level
		role._roledata._battle_role_data.rightRoleTab.role2.index = 2
		role._roledata._battle_role_data.rightRoleTab.role2.roleType = 1
		role._roledata._battle_role_data.rightRoleTab.role2.templateID = stage.monster2id
		local momster_info = ed:FindBy("monster_id", stage.monster2id)
		role._roledata._battle_role_data.rightRoleTab.role2.chosenMusou = momster_info.chosen_musou
		for teji in DataPool_Array(momster_info.monster_teji) do
			if teji.monster_teji_id ~= 0 then
				local tmp = CACHE.BattleNumInfo()
				tmp.level = teji.monster_teji_level
				tmp.id = teji.monster_teji_id
				role._roledata._battle_role_data.rightRoleTab.role2.features:PushBack(tmp)
			else
				break
			end
		end
		
		local proftab_info = ed:FindBy("proftab_id", momster_info.proftabid*1000+stage.monster_level)
		role._roledata._battle_role_data.rightRoleTab.role2.star = proftab_info.star
		role._roledata._battle_role_data.rightRoleTab.role2.grade = proftab_info.grade
	end

	role._roledata._battle_role_data.rightRoleTab.role3.level = 0
	role._roledata._battle_role_data.rightRoleTab.role3.star = 0
	role._roledata._battle_role_data.rightRoleTab.role3.chosenMusou = 0
	role._roledata._battle_role_data.rightRoleTab.role3.grade = 0
	role._roledata._battle_role_data.rightRoleTab.role3.chainSkill:Clear()
	role._roledata._battle_role_data.rightRoleTab.role3.templateID = 0
	role._roledata._battle_role_data.rightRoleTab.role3.equip:Clear()
	role._roledata._battle_role_data.rightRoleTab.role3.skillPcks:Clear()
	role._roledata._battle_role_data.rightRoleTab.role3.index = 0
	role._roledata._battle_role_data.rightRoleTab.role3.roleType = -1
	role._roledata._battle_role_data.rightRoleTab.role3.relationID:Clear()
	role._roledata._battle_role_data.rightRoleTab.role3.features:Clear()
	role._roledata._battle_role_data.rightRoleTab.role3.isShinMusouAvail = 0
	
	if stage.monster3id ~= 0 then
		role._roledata._battle_role_data.rightRoleTab.role3.level = stage.monster_level
		role._roledata._battle_role_data.rightRoleTab.role3.index = 3
		role._roledata._battle_role_data.rightRoleTab.role3.roleType = 1
		role._roledata._battle_role_data.rightRoleTab.role3.templateID = stage.monster3id
		local momster_info = ed:FindBy("monster_id", stage.monster3id)
		role._roledata._battle_role_data.rightRoleTab.role3.chosenMusou = momster_info.chosen_musou
		for teji in DataPool_Array(momster_info.monster_teji) do
			if teji.monster_teji_id ~= 0 then
				local tmp = CACHE.BattleNumInfo()
				tmp.level = teji.monster_teji_level
				tmp.id = teji.monster_teji_id
				role._roledata._battle_role_data.rightRoleTab.role3.features:PushBack(tmp)
			else
				break
			end
		end
		
		local proftab_info = ed:FindBy("proftab_id", momster_info.proftabid*1000+stage.monster_level)
		role._roledata._battle_role_data.rightRoleTab.role3.star = proftab_info.star
		role._roledata._battle_role_data.rightRoleTab.role3.grade = proftab_info.grade
	end
	--ROLE_CopyBattleRoleData(role)
end

function ROLE_CopyBattleRoleData(role, operation)
	local result = {}
	result.battleType = role._roledata._battle_role_data.battleType
	result.controlTypeL = role._roledata._battle_role_data.controlTypeL
	result.controlTypeR = role._roledata._battle_role_data.controlTypeR
	result.sceneID = role._roledata._battle_role_data.sceneID
	result.BGMID = role._roledata._battle_role_data.BGMID
	result.startDialogID = role._roledata._battle_role_data.startDialogID
	result.endDialogID = role._roledata._battle_role_data.endDialogID
	result.instanceID = role._roledata._battle_role_data.instanceID
	result.legionStar = role._roledata._battle_role_data.legionStar
	result.remainTime = role._roledata._battle_role_data.remainTime
	result.rideScriptID = role._roledata._battle_role_data.rideScriptID
	result.stagehpadjust = role._roledata._battle_role_data.stagehpadjust
	result.stageatkadjust = role._roledata._battle_role_data.stageatkadjust
	result.stagearmoradjust = role._roledata._battle_role_data.stagearmoradjust
	result.randSeed = role._roledata._battle_role_data.randSeed
	result.eventingHighScore = role._roledata._battle_role_data.eventingHighScore
	result.eventingRank = role._roledata._battle_role_data.eventingRank
	result.monsterLevel = role._roledata._battle_role_data.monsterLevel
	result.friendId = role._roledata._battle_role_data.friendId:ToStr()

	result.starConditions = {}
	result.starConditions.condition1 = {}
	result.starConditions.condition1.id = role._roledata._battle_role_data.starConditions.condition1.id
	result.starConditions.condition1.conType = role._roledata._battle_role_data.starConditions.condition1.conType
	result.starConditions.condition1.param1 = role._roledata._battle_role_data.starConditions.condition1.param1
	result.starConditions.condition1.param2 = role._roledata._battle_role_data.starConditions.condition1.param2
	result.starConditions.condition2 = {}
	result.starConditions.condition2.id = role._roledata._battle_role_data.starConditions.condition2.id
	result.starConditions.condition2.conType = role._roledata._battle_role_data.starConditions.condition2.conType
	result.starConditions.condition2.param1 = role._roledata._battle_role_data.starConditions.condition2.param1
	result.starConditions.condition2.param2 = role._roledata._battle_role_data.starConditions.condition2.param2
	result.starConditions.condition3 = {}
	result.starConditions.condition3.id = role._roledata._battle_role_data.starConditions.condition3.id
	result.starConditions.condition3.conType = role._roledata._battle_role_data.starConditions.condition3.conType
	result.starConditions.condition3.param1 = role._roledata._battle_role_data.starConditions.condition3.param1
	result.starConditions.condition3.param2 = role._roledata._battle_role_data.starConditions.condition3.param2

	result.legionInfoL = {}
	result.legionInfoL.totalStar = role._roledata._battle_role_data.legionInfoL.totalStar
	result.legionInfoL.friend_zhanli = role._roledata._battle_role_data.legionInfoL.friend_zhanli
	result.legionInfoL.buffs = {}
	local buff_it = role._roledata._battle_role_data.legionInfoL.buffs:SeekToBegin()
	local buff = buff_it:GetValue()
	while buff ~= nil do
		result.legionInfoL.buffs[#result.legionInfoL.buffs+1] = buff._value
		buff_it:Next()
		buff = buff_it:GetValue()
	end

	result.legionInfoR = {}
	result.legionInfoR.totalStar = role._roledata._battle_role_data.legionInfoR.totalStar
	result.legionInfoR.buffs = {}
	local buff_it = role._roledata._battle_role_data.legionInfoR.buffs:SeekToBegin()
	local buff = buff_it:GetValue()
	while buff ~= nil do
		result.legionInfoR.buffs[#result.legionInfoR.buffs+1] = buff._value
		buff_it:Next()
		buff = buff_it:GetValue()
	end

	result.leftRoleTab = {}
	result.leftRoleTab.role1 = {}
	result.leftRoleTab.role1.level = role._roledata._battle_role_data.leftRoleTab.role1.level
	result.leftRoleTab.role1.star = role._roledata._battle_role_data.leftRoleTab.role1.star
	result.leftRoleTab.role1.chosenMusou = role._roledata._battle_role_data.leftRoleTab.role1.chosenMusou
	result.leftRoleTab.role1.grade = role._roledata._battle_role_data.leftRoleTab.role1.grade
	result.leftRoleTab.role1.templateID = role._roledata._battle_role_data.leftRoleTab.role1.templateID
	result.leftRoleTab.role1.index = role._roledata._battle_role_data.leftRoleTab.role1.index
	result.leftRoleTab.role1.roleType = role._roledata._battle_role_data.leftRoleTab.role1.roleType
	result.leftRoleTab.role1.isShinMusouAvail = role._roledata._battle_role_data.leftRoleTab.role1.isShinMusouAvail
	result.leftRoleTab.role1.chainSkill = {}
	local chain_skill_it = role._roledata._battle_role_data.leftRoleTab.role1.chainSkill:SeekToBegin()
	local chain_skill = chain_skill_it:GetValue()
	while chain_skill ~= nil do
		result.leftRoleTab.role1.chainSkill[#result.leftRoleTab.role1.chainSkill+1] = chain_skill._value
		chain_skill_it:Next()
		chain_skill = chain_skill_it:GetValue()
	end
	result.leftRoleTab.role1.relationID = {}
	local relation_it = role._roledata._battle_role_data.leftRoleTab.role1.relationID:SeekToBegin()
	local relation = relation_it:GetValue()
	while relation ~= nil do
		result.leftRoleTab.role1.relationID[#result.leftRoleTab.role1.relationID+1] = relation._value
		relation_it:Next()
		relation = relation_it:GetValue()
	end
	result.leftRoleTab.role1.equip = {}
	local equip_it = role._roledata._battle_role_data.leftRoleTab.role1.equip:SeekToBegin()
	local equip = equip_it:GetValue()
	while equip ~= nil do
		local tmp = {}
		tmp.typ = equip.typ
		tmp.id = equip.id
		tmp.info = {}
		tmp.info.level_up = equip.info.level_up
		tmp.info.star = equip.info.star
		tmp.info.quality = equip.info.quality
		tmp.info.prop = equip.info.prop
		tmp.info.attack = equip.info.attack
		tmp.info.strength = equip.info.strength
		tmp.info.strength_prob = equip.info.strength_prob
		tmp.info.tid = equip.info.tid
		tmp.info.hero_id = equip.info.hero_id
		tmp.info.level = equip.info.level
		tmp.info.order = equip.info.order
		tmp.info.refinable_pro = {}
		local refinable_pro_it = equip.info.refinable_pro:SeekToBegin()
		local refinable_pro = refinable_pro_it:GetValue()
		while refinable_pro ~= nil do
			local tmp1 = {}
			tmp1.typ = refinable_pro.typ
			tmp1.data = refinable_pro.data
			tmp.info.refinable_pro[#tmp.info.refinable_pro+1] = tmp1
			refinable_pro_it:Next()
			refinable_pro = refinable_pro_it:GetValue()
		end
		result.leftRoleTab.role1.equip[#result.leftRoleTab.role1.equip+1] = tmp
		equip_it:Next()
		equip = equip_it:GetValue()
	end
	
	result.leftRoleTab.role1.skillPcks = {}
	local skillPcks_it = role._roledata._battle_role_data.leftRoleTab.role1.skillPcks:SeekToBegin()
	local skillPcks = skillPcks_it:GetValue()
	while skillPcks ~= nil do
		local tmp = {}
		tmp[#tmp+1] = skillPcks.id
		tmp[#tmp+1] = skillPcks.level
		result.leftRoleTab.role1.skillPcks[#result.leftRoleTab.role1.skillPcks+1] = tmp
	
		skillPcks_it:Next()
		skillPcks = skillPcks_it:GetValue()
	end
	result.leftRoleTab.role1.features = {}
	local features_it = role._roledata._battle_role_data.leftRoleTab.role1.features:SeekToBegin()
	local features = features_it:GetValue()
	while features ~= nil do
		local tmp = {}
		tmp[#tmp+1] = features.id
		tmp[#tmp+1] = features.level
		result.leftRoleTab.role1.features[#result.leftRoleTab.role1.features+1] = tmp

		features_it:Next()
		features = features_it:GetValue()
	end
	
	result.leftRoleTab.role2 = {}
	result.leftRoleTab.role2.level = role._roledata._battle_role_data.leftRoleTab.role2.level
	result.leftRoleTab.role2.star = role._roledata._battle_role_data.leftRoleTab.role2.star
	result.leftRoleTab.role2.chosenMusou = role._roledata._battle_role_data.leftRoleTab.role2.chosenMusou
	result.leftRoleTab.role2.grade = role._roledata._battle_role_data.leftRoleTab.role2.grade
	result.leftRoleTab.role2.templateID = role._roledata._battle_role_data.leftRoleTab.role2.templateID
	result.leftRoleTab.role2.index = role._roledata._battle_role_data.leftRoleTab.role2.index
	result.leftRoleTab.role2.roleType = role._roledata._battle_role_data.leftRoleTab.role2.roleType
	result.leftRoleTab.role2.isShinMusouAvail = role._roledata._battle_role_data.leftRoleTab.role2.isShinMusouAvail
	result.leftRoleTab.role2.chainSkill = {}
	local chain_skill_it = role._roledata._battle_role_data.leftRoleTab.role2.chainSkill:SeekToBegin()
	local chain_skill = chain_skill_it:GetValue()
	while chain_skill ~= nil do
		result.leftRoleTab.role2.chainSkill[#result.leftRoleTab.role2.chainSkill+1] = chain_skill._value
		chain_skill_it:Next()
		chain_skill = chain_skill_it:GetValue()
	end
	result.leftRoleTab.role2.relationID = {}
	local relation_it = role._roledata._battle_role_data.leftRoleTab.role2.relationID:SeekToBegin()
	local relation = relation_it:GetValue()
	while relation ~= nil do
		result.leftRoleTab.role2.relationID[#result.leftRoleTab.role2.relationID+1] = relation._value
		relation_it:Next()
		relation = relation_it:GetValue()
	end
	result.leftRoleTab.role2.equip = {}
	local equip_it = role._roledata._battle_role_data.leftRoleTab.role2.equip:SeekToBegin()
	local equip = equip_it:GetValue()
	while equip ~= nil do
		local tmp = {}
		tmp.typ = equip.typ
		tmp.id = equip.id
		tmp.info = {}
		tmp.info.level_up = equip.info.level_up
		tmp.info.star = equip.info.star
		tmp.info.quality = equip.info.quality
		tmp.info.prop = equip.info.prop
		tmp.info.attack = equip.info.attack
		tmp.info.strength = equip.info.strength
		tmp.info.strength_prob = equip.info.strength_prob
		tmp.info.tid = equip.info.tid
		tmp.info.hero_id = equip.info.hero_id
		tmp.info.level = equip.info.level
		tmp.info.order = equip.info.order
		tmp.info.refinable_pro = {}
		local refinable_pro_it = equip.info.refinable_pro:SeekToBegin()
		local refinable_pro = refinable_pro_it:GetValue()
		while refinable_pro ~= nil do
			local tmp1 = {}
			tmp1.typ = refinable_pro.typ
			tmp1.data = refinable_pro.data
			tmp.info.refinable_pro[#tmp.info.refinable_pro+1] = tmp1
			refinable_pro_it:Next()
			refinable_pro = refinable_pro_it:GetValue()
		end
		result.leftRoleTab.role2.equip[#result.leftRoleTab.role2.equip+1] = tmp
		equip_it:Next()
		equip = equip_it:GetValue()
	end
	
	result.leftRoleTab.role2.skillPcks = {}
	local skillPcks_it = role._roledata._battle_role_data.leftRoleTab.role2.skillPcks:SeekToBegin()
	local skillPcks = skillPcks_it:GetValue()
	while skillPcks ~= nil do
		local tmp = {}
		tmp[#tmp+1] = skillPcks.id
		tmp[#tmp+1] = skillPcks.level
		result.leftRoleTab.role2.skillPcks[#result.leftRoleTab.role2.skillPcks+1] = tmp
	
		skillPcks_it:Next()
		skillPcks = skillPcks_it:GetValue()
	end
	result.leftRoleTab.role2.features = {}
	local features_it = role._roledata._battle_role_data.leftRoleTab.role2.features:SeekToBegin()
	local features = features_it:GetValue()
	while features ~= nil do
		local tmp = {}
		tmp[#tmp+1] = features.id
		tmp[#tmp+1] = features.level
		result.leftRoleTab.role2.features[#result.leftRoleTab.role2.features+1] = tmp

		features_it:Next()
		features = features_it:GetValue()
	end
	
	result.leftRoleTab.role3 = {}
	result.leftRoleTab.role3.level = role._roledata._battle_role_data.leftRoleTab.role3.level
	result.leftRoleTab.role3.star = role._roledata._battle_role_data.leftRoleTab.role3.star
	result.leftRoleTab.role3.chosenMusou = role._roledata._battle_role_data.leftRoleTab.role3.chosenMusou
	result.leftRoleTab.role3.grade = role._roledata._battle_role_data.leftRoleTab.role3.grade
	result.leftRoleTab.role3.templateID = role._roledata._battle_role_data.leftRoleTab.role3.templateID
	result.leftRoleTab.role3.index = role._roledata._battle_role_data.leftRoleTab.role3.index
	result.leftRoleTab.role3.roleType = role._roledata._battle_role_data.leftRoleTab.role3.roleType
	result.leftRoleTab.role3.isShinMusouAvail = role._roledata._battle_role_data.leftRoleTab.role3.isShinMusouAvail
	result.leftRoleTab.role3.chainSkill = {}
	local chain_skill_it = role._roledata._battle_role_data.leftRoleTab.role3.chainSkill:SeekToBegin()
	local chain_skill = chain_skill_it:GetValue()
	while chain_skill ~= nil do
		result.leftRoleTab.role3.chainSkill[#result.leftRoleTab.role3.chainSkill+1] = chain_skill._value
		chain_skill_it:Next()
		chain_skill = chain_skill_it:GetValue()
	end
	result.leftRoleTab.role3.relationID = {}
	local relation_it = role._roledata._battle_role_data.leftRoleTab.role3.relationID:SeekToBegin()
	local relation = relation_it:GetValue()
	while relation ~= nil do
		result.leftRoleTab.role3.relationID[#result.leftRoleTab.role3.relationID+1] = relation._value
		relation_it:Next()
		relation = relation_it:GetValue()
	end
	result.leftRoleTab.role3.equip = {}
	local equip_it = role._roledata._battle_role_data.leftRoleTab.role3.equip:SeekToBegin()
	local equip = equip_it:GetValue()
	while equip ~= nil do
		local tmp = {}
		tmp.typ = equip.typ
		tmp.id = equip.id
		tmp.info = {}
		tmp.info.level_up = equip.info.level_up
		tmp.info.star = equip.info.star
		tmp.info.quality = equip.info.quality
		tmp.info.prop = equip.info.prop
		tmp.info.attack = equip.info.attack
		tmp.info.strength = equip.info.strength
		tmp.info.strength_prob = equip.info.strength_prob
		tmp.info.tid = equip.info.tid
		tmp.info.hero_id = equip.info.hero_id
		tmp.info.level = equip.info.level
		tmp.info.order = equip.info.order
		tmp.info.refinable_pro = {}
		local refinable_pro_it = equip.info.refinable_pro:SeekToBegin()
		local refinable_pro = refinable_pro_it:GetValue()
		while refinable_pro ~= nil do
			local tmp1 = {}
			tmp1.typ = refinable_pro.typ
			tmp1.data = refinable_pro.data
			tmp.info.refinable_pro[#tmp.info.refinable_pro+1] = tmp1
			refinable_pro_it:Next()
			refinable_pro = refinable_pro_it:GetValue()
		end
		result.leftRoleTab.role3.equip[#result.leftRoleTab.role3.equip+1] = tmp
		equip_it:Next()
		equip = equip_it:GetValue()
	end
	
	result.leftRoleTab.role3.skillPcks = {}
	local skillPcks_it = role._roledata._battle_role_data.leftRoleTab.role3.skillPcks:SeekToBegin()
	local skillPcks = skillPcks_it:GetValue()
	while skillPcks ~= nil do
		local tmp = {}
		tmp[#tmp+1] = skillPcks.id
		tmp[#tmp+1] = skillPcks.level
		result.leftRoleTab.role3.skillPcks[#result.leftRoleTab.role3.skillPcks+1] = tmp
	
		skillPcks_it:Next()
		skillPcks = skillPcks_it:GetValue()
	end
	result.leftRoleTab.role3.features = {}
	local features_it = role._roledata._battle_role_data.leftRoleTab.role3.features:SeekToBegin()
	local features = features_it:GetValue()
	while features ~= nil do
		local tmp = {}
		tmp[#tmp+1] = features.id
		tmp[#tmp+1] = features.level
		result.leftRoleTab.role3.features[#result.leftRoleTab.role3.features+1] = tmp

		features_it:Next()
		features = features_it:GetValue()
	end

	result.rightRoleTab = {}
	result.rightRoleTab.role1 = {}
	result.rightRoleTab.role1.level = role._roledata._battle_role_data.rightRoleTab.role1.level
	result.rightRoleTab.role1.index = role._roledata._battle_role_data.rightRoleTab.role1.index
	result.rightRoleTab.role1.roleType = role._roledata._battle_role_data.rightRoleTab.role1.roleType
	result.rightRoleTab.role1.templateID = role._roledata._battle_role_data.rightRoleTab.role1.templateID	
	result.rightRoleTab.role1.chosenMusou = role._roledata._battle_role_data.rightRoleTab.role1.chosenMusou	
	result.rightRoleTab.role1.star = role._roledata._battle_role_data.rightRoleTab.role1.star
	result.rightRoleTab.role1.grade = role._roledata._battle_role_data.rightRoleTab.role1.grade
	result.rightRoleTab.role1.features = {}
	local features_it = role._roledata._battle_role_data.rightRoleTab.role1.features:SeekToBegin()
	local features = features_it:GetValue()
	while features ~= nil do
		local tmp = {}
		tmp[#tmp+1] = features.id
		tmp[#tmp+1] = features.level
		result.rightRoleTab.role1.features[#result.rightRoleTab.role1.features+1] = tmp

		features_it:Next()
		features = features_it:GetValue()
	end

	result.rightRoleTab.role2 = {}
	result.rightRoleTab.role2.level = role._roledata._battle_role_data.rightRoleTab.role2.level
	result.rightRoleTab.role2.index = role._roledata._battle_role_data.rightRoleTab.role2.index
	result.rightRoleTab.role2.roleType = role._roledata._battle_role_data.rightRoleTab.role2.roleType
	result.rightRoleTab.role2.templateID = role._roledata._battle_role_data.rightRoleTab.role2.templateID	
	result.rightRoleTab.role2.chosenMusou = role._roledata._battle_role_data.rightRoleTab.role2.chosenMusou	
	result.rightRoleTab.role2.star = role._roledata._battle_role_data.rightRoleTab.role2.star
	result.rightRoleTab.role2.grade = role._roledata._battle_role_data.rightRoleTab.role2.grade
	result.rightRoleTab.role2.features = {}
	local features_it = role._roledata._battle_role_data.rightRoleTab.role2.features:SeekToBegin()
	local features = features_it:GetValue()
	while features ~= nil do
		local tmp = {}
		tmp[#tmp+1] = features.id
		tmp[#tmp+1] = features.level
		result.rightRoleTab.role2.features[#result.rightRoleTab.role2.features+1] = tmp

		features_it:Next()
		features = features_it:GetValue()
	end
	
	result.rightRoleTab.role3 = {}
	result.rightRoleTab.role3.level = role._roledata._battle_role_data.rightRoleTab.role3.level
	result.rightRoleTab.role3.index = role._roledata._battle_role_data.rightRoleTab.role3.index
	result.rightRoleTab.role3.roleType = role._roledata._battle_role_data.rightRoleTab.role3.roleType
	result.rightRoleTab.role3.templateID = role._roledata._battle_role_data.rightRoleTab.role3.templateID	
	result.rightRoleTab.role3.chosenMusou = role._roledata._battle_role_data.rightRoleTab.role3.chosenMusou	
	result.rightRoleTab.role3.star = role._roledata._battle_role_data.rightRoleTab.role3.star
	result.rightRoleTab.role3.grade = role._roledata._battle_role_data.rightRoleTab.role3.grade
	result.rightRoleTab.role3.features = {}
	local features_it = role._roledata._battle_role_data.rightRoleTab.role3.features:SeekToBegin()
	local features = features_it:GetValue()
	while features ~= nil do
		local tmp = {}
		tmp[#tmp+1] = features.id
		tmp[#tmp+1] = features.level
		result.rightRoleTab.role3.features[#result.rightRoleTab.role3.features+1] = tmp

		features_it:Next()
		features = features_it:GetValue()
	end

	API_Log("        "..DumpTable(result))
	local file2 = io.output("2.txt")
	--io.write(DumpTable(result))
	local result_log = "BattleRoleData =".."\n"..prettytostring(result).."\n"
	local operation_log = "operations={"..DumpTable(operation).."}"
	io.write(result_log)
	io.flush()
	io.write(operation_log)
	io.flush()
	io.close()
	local cur_pvp_ver = ROLE_GetPVPVersion(role._roledata._client_ver._client_id, role._roledata._client_ver._exe_ver, role._roledata._client_ver._data_ver)
	role:SendOperation(role._roledata._battle_role_data.sceneID, operation_log, result_log, cur_pvp_ver)
end
	
	
--更新今日答题信息
--right_flag = {[1, 答对一题], [2, 答错一题], [3, 开启宝箱], [4, 开启宝箱失败]}
function ROLE_UpdateDaTiData(role, right_flag, reward, usetime)
        if right_flag == 1 then
                role._roledata._dati_data._cur_num = role._roledata._dati_data._cur_num + 1
                role._roledata._dati_data._cur_right_num = role._roledata._dati_data._cur_right_num + 1
                role._roledata._dati_data._exp = role._roledata._dati_data._exp + reward.exp
                role._roledata._dati_data._yuanbao = role._roledata._dati_data._yuanbao + reward.item[1].itemnum
				role._roledata._dati_data._history_right_num = role._roledata._dati_data._history_right_num + 1
				role._roledata._dati_data._use_time = 0
				role._roledata._dati_data._history_use_time = role._roledata._dati_data._history_use_time + usetime
        elseif right_flag == 2 then
                role._roledata._dati_data._cur_num = role._roledata._dati_data._cur_num + 1
				role._roledata._dati_data._use_time = 0
				role._roledata._dati_data._history_use_time = role._roledata._dati_data._history_use_time + usetime
        elseif right_flag == 3 then
                role._roledata._dati_data._today_reward = 1
        elseif right_flag == 4 then
                role._roledata._dati_data._today_reward = 2
        end

        return
end

function ROLE_UpdateLotteryInfo(role)
	local resp = NewCommand("UpdateLotteryInfo")
	resp.lottery_info = {}
	local lottery_map = role._roledata._status._lottery_info
	local lottery_info_it = lottery_map:SeekToBegin()
	local lottery_info = lottery_info_it:GetValue()
	while lottery_info ~= nil do
		local tmp = {}
		tmp.lottery_id = lottery_info._lottery_id
		tmp.last_time = lottery_info._time
		tmp.select_id = lottery_info._select

		resp.lottery_info[#resp.lottery_info+1] = tmp
		lottery_info_it:Next()
		lottery_info = lottery_info_it:GetValue()
	end

	role:SendToClient(SerializeCommand(resp)) 
end


function ROLE_UpdateHaveFinishBattle(role)
	local resp = NewCommand("UpdateHaveFinishBattle")
	resp.battle_id = {}
	local battleid_map = role._roledata._have_finish_battle
	local battle_id_it = battleid_map:SeekToBegin()
	local battleid = battle_id_it:GetValue()
	while battleid ~= nil do
		resp.battle_id[#resp.battle_id+1] = battleid._value
		battle_id_it:Next()
		battleid = battle_id_it:GetValue()
	end

	role:SendToClient(SerializeCommand(resp)) 
end

function ROLE_SendErrorInfo(role, err)
	local cmd = NewCommand("ErrorInfo")
	cmd.error_id = err
	role:SendToClient(SerializeCommand(cmd))
	return
end

function ROLE_GainFudai(role, fudai_flag)
	local version_dpc = DataPool_Find("versiondata")
	local chongzhi_info = version_dpc:FindBy("rmb_typ", fudai_flag)

	if chongzhi_info == nil then
		API:Log("ROLE_GainFudai..ERROR "..fudai_flag)
		return
	end
	
	if chongzhi_info.recharge_type == 1 then
		if role._roledata._status._little_fudai == 0 then
			local begin_time = API_MakeTodayTime(5, 0, 0)
			local now = API_GetTime()
			if now >= begin_time then
				role._roledata._status._little_fudai = begin_time + chongzhi_info.actuation_duration*24*3600
			else
				role._roledata._status._little_fudai = begin_time + (chongzhi_info.actuation_duration-1)*24*3600
			end
		else
			role._roledata._status._little_fudai = role._roledata._status._little_fudai + chongzhi_info.actuation_duration*24*3600
		end
		local resp = NewCommand("UpdateFuDaiTime")
		resp.fudai_flag = chongzhi_info.recharge_type
		resp.fudai_time = role._roledata._status._little_fudai
	elseif chongzhi_info.recharge_type == 2 then
		if role._roledata._status._big_fudai == 0 then
			local begin_time = API_MakeTodayTime(5, 0, 0)
			local now = API_GetTime()
			if now >= begin_time then
				role._roledata._status._big_fudai = begin_time + chongzhi_info.actuation_duration*24*3600
			else
				role._roledata._status._big_fudai = begin_time + (chongzhi_info.actuation_duration-1)*24*3600
			end
		else
			role._roledata._status._big_fudai = role._roledata._status._big_fudai + chongzhi_info.actuation_duration*24*3600
		end
		local resp = NewCommand("UpdateFuDaiTime")
		resp.fudai_flag = chongzhi_info.recharge_type
		resp.fudai_time = role._roledata._status._big_fudai
	end

	local resp = NewCommand("ChongZhi")
	resp.fudai_flag = fudai_flag
	if resp.fudai_flag == 1 then
		resp.fudai_time = role._roledata._status._little_fudai
	elseif resp.fudai_flag == 2 then
		resp.fudai_time = role._roledata._status._big_fudai
	end

	role:SendToClient(SerializeCommand(resp))
end

--结束
