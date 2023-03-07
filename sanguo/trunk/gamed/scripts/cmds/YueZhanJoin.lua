function OnCommand_YueZhanJoin(player, role, arg, others)
	player:Log("OnCommand_YueZhanJoin, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("YueZhanJoin_Re")
	
	--检查PVP版本
	local cur_pvp_ver = ROLE_GetPVPVersion(role._roledata._client_ver._client_id, role._roledata._client_ver._exe_ver, role._roledata._client_ver._data_ver)
	if cur_pvp_ver <= 0 then
		local resp = NewCommand("ErrorInfo")
		resp.error_id = G_ERRCODE["EXE_OUT_OF_DATE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_YueZhanJoin, error=EXE_OUT_OF_DATE")
		return
	end

	local yuezhan_info = others.yuezhan_info._data

	local yuezhan_data = yuezhan_info._yuezhan_info:Find(arg.room_id)
	if yuezhan_data == nil then
		resp.retcode = G_ERRCODE["YUEZHAN_ROOM_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_YueZhanJoin, error=YUEZHAN_ROOM_ERR")
		return
	end

	if role._roledata._pvp._typ == G_PVP_STATE_TYP["YUEZHAN"] and role._roledata._pvp._id ~= 0 then
		resp.retcode = G_ERRCODE["SYSTEM_INVALID"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_YueZhanJoin, error=SYSTEM_INVALID")
		return
	end

	if role._roledata._status._time_line == G_ROLE_STATE["YUEZHAN"] then
		resp.retcode = G_ERRCODE["YUEZHAN_BATTLE_STATE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_YueZhanJoin, error=YUEZHAN_BATTLE_STATE")
		return
	end

	--查看阵容
	local hero_team = role._roledata._pvp_info._last_hero
	--local hero_team = role._roledata._hero_team:Find(G_HERO_TEAM_TYP["YUEZHAN"])
	if hero_team:Size() == 0 then
		resp.retcode = G_ERRCODE["YUEZHAN_HERO_LESS"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_YueZhanJoin, error=YUEZHAN_HERO_LESS")
		return
	end

	--查看房间是否已经有人应战了
	if not yuezhan_data._join_id:Equal(0) then
		resp.retcode = G_ERRCODE["YUEZHAN_HAVE_ROLE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_YueZhanJoin, error=YUEZHAN_HAVE_ROLE")
		return
	end

	--查看是否是自己进入
	if yuezhan_data._join_id:ToStr() == yuezhan_data._create_id:ToStr() then
		resp.retcode = G_ERRCODE["YUEZHAN_CREATER_JOIN"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_YueZhanJoin, error=YUEZHAN_CREATER_JOIN")
		return
	end

	if cur_pvp_ver ~= yuezhan_data._pvp_ver then
		resp.retcode = G_ERRCODE["EXE_OUT_OF_DATE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_YueZhanJoin, error=EXE_OUT_OF_DATE")
		return
	end

	--设置自己的信息
	local rolebrief = ROLE_MakeRoleBrief(role)
	local pvpinfo = NewStruct("RolePVPInfo")
	pvpinfo.brief = {}
	pvpinfo.brief = rolebrief
	pvpinfo.hero_hall = {}

	local heros = role._roledata._hero_hall._heros
	local lit = hero_team:SeekToBegin()
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
	pvpinfo.pvp_score = data1
	local os = {}
	SerializeStruct(os, pvpinfo)
	
	--typ等于2的时候代表的是约战战斗
	--设置当前进入了PVP状态
	role._roledata._pvp._state = 1
	role._roledata._status._instance_id = 0
	role._roledata._pvp._typ = G_PVP_STATE_TYP["YUEZHAN"]
	role._roledata._status._time_line = G_ROLE_STATE["YUEZHAN"]

	yuezhan_data._join_id = role._roledata._base._id
	yuezhan_data._join_name = role._roledata._base._name
	yuezhan_data._join_info = table.concat(os)
	yuezhan_data._join_key1 = player:GetStrKey1()
	yuezhan_data._typ = 2

	--然后把这个房间的信息给center发过去，进行数据的处理
	role:SendYueZhanBegin(arg.room_id)
	
	--广播出去把这个约战的信息
	local msg = NewMessage("YueZhanInfo")
	msg.id = yuezhan_data._id
	msg.channel = yuezhan_data._channel
	msg.typ = 2
	msg.info_id = tostring(yuezhan_info._id)
	msg.creater = {}
	msg.joiner = {}
	msg.creater.id = yuezhan_data._create_id:ToStr()
	msg.creater.name = yuezhan_data._create_name
	msg.joiner.id = role._roledata._base._id:ToStr()
	msg.joiner.name = role._roledata._base._name

	if yuezhan_data._channel == 2 then
		player:SendMessageToAllRole(SerializeMessage(msg), G_CHECKSUM_M["YueZhanInfo"])
	elseif yuezhan_data._channel == 3 then
		local mafia_msg = NewMessage("MafiaYueZhan")
		mafia_msg.id = msg.id
		mafia_msg.channel = msg.channel
		mafia_msg.typ = msg.typ
		mafia_msg.announce = msg.announce
		mafia_msg.info_id = msg.info_id
		mafia_msg.creater = msg.creater
		mafia_msg.joiner = msg.joiner
		mafia_msg.time = msg.time
		API_SendMessage(yuezhan_data._mafia_id, SerializeMessage(mafia_msg), CACHE.Int64List(), CACHE.Int64List(), CACHE.IntList())
	end

	resp.retcode = 0
	resp.room_id = arg.room_id
	player:SendToClient(SerializeCommand(resp))

	local msg2 = NewMessage("SyncNetTime")
	player:SendMessage(yuezhan_data._create_id, SerializeMessage(msg2))
	player:SendMessage(yuezhan_data._join_id, SerializeMessage(msg2))
end
