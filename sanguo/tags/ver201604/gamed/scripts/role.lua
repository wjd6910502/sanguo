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

		roleinfo.hero_hall.heros[#roleinfo.hero_hall.heros+1] = h2
		hit:Next()
		h = hit:GetValue()
	end
	--backpack
	roleinfo.backpack = {}
	roleinfo.backpack.capacity = role._roledata._backpack._capacity
	roleinfo.backpack.items = {}
	local items = role._roledata._backpack._items
	local iit = items:SeekToBegin() --从头开始遍历
	local i = iit:GetValue()
	while i~=nil do
		local i2 = {}
		i2.tid = i._tid
		i2.count = i._count;
		roleinfo.backpack.items[#roleinfo.backpack.items+1] = i2
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
	local black_it = role._roledata._friend._blacklist:SeekToBegin()
	local black = black_it:GetValue()
	while black ~= nil do
		local tmp_black = {}
		tmp_black.id = black._brief._id:ToStr()
		tmp_black.name = black._brief._name
		tmp_black.photo = black._brief._photo
		roleinfo.black_list[#roleinfo.black_list+1] = tmp_black
	
		black_it:Next()
		black = black_it:GetValue()
	end

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
	if role._roledata._status._level <= 100 then
		role._roledata._status._exp:Add(exp)
		--在这里判断是否达到了升级的经验
		--拿到当前等级升级所需要的经验
		local ed = DataPool_Find("elementdata")
		local level_exp = ed:FindBy("level_id", role._roledata._status._level)
		local level_flag = 0
		while role._roledata._status._exp:Equal(level_exp.needexp) or role._roledata._status._exp:Great(level_exp.needexp) do
			role._roledata._status._level = role._roledata._status._level + 1
			role._roledata._status._exp:Sub(level_exp.needexp)
			--给玩家加体力
			ROLE_Addvp(role, level_exp.vp_up, 1)
			level_exp = ed:FindBy("level_id", role._roledata._status._level)
			level_flag = 1
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
		end
	end
end

function ROLE_AddMoney(role, money)
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

	--先放slot
	local tmp_slot = CACHE.BattleFieldPositionData()
	for slot in DataPool_Array(battlefielddata_info.init_slots) do
		tmp_slot._id = slot.id
		tmp_slot._position = slot.pos
		tmp_slot._flag = slot.flag
		tmp_slot._event_flag = 0

		tmp_battle._position_info:Insert(slot.pos, tmp_slot)
	end
	--放置NPC的信息
	local tmp_npc = CACHE.BattleFieldNPCData()
	for npc in DataPool_Array(battlefielddata_info.init_npcs) do
		tmp_npc._id = npc.id
		tmp_npc._camp = npc.camp
		tmp_npc._armyid = npc.armyid
		tmp_npc._alive = 1
		--找到信息放进去
		local tmp_slot = tmp_battle._position_info:Find(npc.pos)
		if tmp_slot == nil then
			API_Log("ROLE_ResetBattleInfo  npc pos id error  "..npc.pos.. "   " ..battle_id .."    " ..battle_info.battlefieldid)
		end
		tmp_slot._npc_info:Insert(npc.id, tmp_npc)
	end
	
	role._roledata._battle_info:Insert(battle_id, tmp_battle)

	return 0
end

function ROLE_MakeBattleInfo(role, battle_id)
	local battle = role._roledata._battle_info:Find(battle_id)
	battle_info = {}
	battle_info.battle_id = battle._battle_id
	battle_info.cur_pos = battle._cur_position
	battle_info.state = battle._state
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
		tmp_position.event_id = 0
		
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
			tmp_npc.event_id = 0
			
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
	position_info.event_id = 0
	
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
		tmp_npc.event_id = 0
		
		position_info.npc_info[#position_info.npc_info+1] = tmp_npc
		npc_it:Next()
		npc = npc_it:GetValue()
	end
	return position_info
end
