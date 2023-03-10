function OnCommand_PvpJoin(player, role, arg, others)
	player:Log("OnCommand_PvpJoin, "..DumpTable(arg).." "..DumpTable(others))

	--检查当前玩家的状态是否可以进行PVP
	if role._roledata._pvp._id ~= 0 or role._roledata._pvp._state ~= 0 then
		player:Log("OnCommand_PvpJoin, "..role._roledata._pvp._id.."  ".."  "..role._roledata._pvp._state)
		return
	end

	if role._roledata._device_info._net_type < 2 then
		local resp = NewCommand("ErrorInfo")
		resp.error_id = G_ERRCODE["PVP_NET_TYPE_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if player:GetLatency() >= 100 then
		player:Log("OnCommand_PvpJoin, player:GetLatency()="..player:GetLatency())
		local resp = NewCommand("ErrorInfo")
		resp.error_id = G_ERRCODE["PVP_LATENCY_LARGE"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--在这里不进行任何的验证。直接就把消息发给中心服务器去
	if role._roledata._pvp_info._last_hero:Size() == 0 then
		local resp = NewCommand("ErrorInfo")
		resp.error_id = G_ERRCODE["PVP_HERO_COUNT_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
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
	--typ等于1的时候代表的是跨服战斗
	pvpinfo.pvp_score = data1
	local os = {}
	SerializeStruct(os, pvpinfo)
	role._roledata._pvp._pvpcenterinfo = table.concat(os)
	role._roledata._pvp._typ = arg.typ
	role:SendPVPJoin(data)

	--设置当前进入了PVP状态
	role._roledata._pvp._state = 1
	role._roledata._status._instance_id = 0
end
