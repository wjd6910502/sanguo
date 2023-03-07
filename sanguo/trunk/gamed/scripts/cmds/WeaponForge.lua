function OnCommand_WeaponForge(player, role, arg, others)
--[[
	player:Log("OnCommand_WeaponForge, "..DumpTable(arg).." "..DumpTable(others))
	
	--数据统计日志
	local source_id = G_SOURCE_TYP["WEAPON_FORGE"]

	local resp = NewCommand("WeaponForge_Re")

	if role._roledata._forge_info._typ ~= 0 then
		resp.retcode = G_ERRCODE["WEAPON_FORGE_ERROR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WeaponForge, error=WEAPON_FORGE_ERROR")
		return
	end
	
	if arg.typ ~= 1 and arg.typ ~= 2 and arg.typ ~= 3 then
		resp.retcode = G_ERRCODE["WEAPON_FORGE_ARG_ERROR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WeaponForge, error=WEAPON_FORGE_ARG_ERROR")
		return
	end
	
	local ed = DataPool_Find("elementdata")
	local forge_data = ed:FindBy("weaponforge_id", arg.typ)
	if forge_data == nil then
		resp.retcode = G_ERRCODE["WEAPON_EQUIP_SYS_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WeaponForge, error=WEAPON_EQUIP_SYS_ERR")
		return
	end

	if BACKPACK_HaveItem(role, forge_data.cost_item_id, forge_data.cost_item_num) == false then
		resp.retcode = G_ERRCODE["WEAPON_FORGE_ITEM_ERROR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WeaponForge, error=WEAPON_FORGE_ITEM_ERROR")
		return
	end

	--计算掉落id索引	
	local mist = API_GetLuaMisc()
	local time = math.floor(mist._miscdata._open_server_time/86400)*86400 -- 3600*24
	local today = math.floor((API_GetTime() - time)/86400) + 1 --今天是开服第多少天 从1开始
	local index = math.fmod(today, forge_data.cycle)
	if index == 0 then
		index = forge_data.cycle
	end
	local drop_id = forge_data.daily_forge_info[index].lottery_id

	local ed = DataPool_Find("elementdata")
	local drop = ed:FindBy("drop_id", drop_id)
	if drop == nil then
		resp.retcode = G_ERRCODE["WEAPON_EQUIP_SYS_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WeaponForge, error=WEAPON_EQUIP_SYS_ERR1")
		return
	end

	
	local Reward = DROPITEM_DropItem(role, drop_id)
	if #Reward ~= 1 then --每次只掉落一把武器
		resp.retcode = G_ERRCODE["WEAPON_EQUIP_SYS_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WeaponForge, error=WEAPON_EQUIP_SYS_ERR2")
		return
	end

	local item = ed:FindBy("item_id", Reward[1].id)
	if item == nil then
		resp.retcode = G_ERRCODE["WEAPON_EQUIP_SYS_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WeaponForge, error=WEAPON_EQUIP_SYS_ERR3")
		return
	end
	
	local weapon_info = ed:FindBy("weapon_id", item.type_data1)
	if weapon_info == nil then
		resp.retcode = G_ERRCODE["WEAPON_EQUIP_SYS_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WeaponForge, error=WEAPON_EQUIP_SYS_ERR4")
		return
	end

	BACKPACK_DelItem(role, forge_data.cost_item_id, forge_data.cost_item_num, source_id)
	
	role._roledata._forge_info._typ = arg.typ
	
	role._roledata._forge_info._weapon_info._base_item._tid = Reward[1].id
	role._roledata._forge_info._weapon_info._base_item._count = 1	
	role._roledata._forge_info._weapon_info._weapon_pro._level = weapon_info.wearlv
	role._roledata._forge_info._weapon_info._weapon_pro._star = weapon_info.star
	role._roledata._forge_info._weapon_info._weapon_pro._quality = weapon_info.grade
 	role._roledata._forge_info._weapon_info._weapon_pro._prop = weapon_info.weapontype
	role._roledata._forge_info._weapon_info._weapon_pro._attack = weapon_info.atk
	role._roledata._forge_info._weapon_info._weapon_pro._weapon_skill = 0
	role._roledata._forge_info._weapon_info._weapon_pro._level_up = 1
	
	local max_skill_num = weapon_info.specialpropnummax
	local min_skill_num = weapon_info.specialpropnummin
	
	local num = 0
	for tmp_skill in DataPool_Array(weapon_info.specialprop) do
		if tmp_skill == 0 then
			break
		end
		num = num + 1
	end

	if max_skill_num > num then
		max_skill_num = num
	end

	if min_skill_num > max_skill_num then
		min_skill_num = max_skill_num
	end

	local need_num = math.random(min_skill_num, max_skill_num)
	while role._roledata._forge_info._weapon_info._weapon_pro._skill_pro:Size() < need_num do
		local tmp_num = math.random(num)
		local insert_skill_id = weapon_info.specialprop[tmp_num]
		if role._roledata._forge_info._weapon_info._weapon_pro._skill_pro:Find(insert_skill_id) == nil then
			local insert_skill = CACHE.WeaponSkill()
			insert_skill._skill_id = insert_skill_id
			insert_skill._skill_level = math.random(weapon_info.specialproplvmin, weapon_info.specialproplvmax)
			role._roledata._forge_info._weapon_info._weapon_pro._skill_pro:Insert(insert_skill_id, insert_skill)
		end
	end

	--通知客户端
	resp.weapon_info = {}
	resp.weapon_info.base_item = {}
	resp.weapon_info.base_item.tid = Reward[1].id
	resp.weapon_info.base_item.count = 1
	resp.weapon_info.weapon_info = {}
	resp.weapon_info.weapon_info.tid = item.type_data1
	resp.weapon_info.weapon_info.level = weapon_info.wearlv
	resp.weapon_info.weapon_info.star = weapon_info.star
	resp.weapon_info.weapon_info.quality = weapon_info.grade
	resp.weapon_info.weapon_info.prop = weapon_info.weapontype
	resp.weapon_info.weapon_info.attack = weapon_info.atk
	resp.weapon_info.weapon_info.strength = 0
	resp.weapon_info.weapon_info.level_up = 1
	resp.weapon_info.weapon_info.weapon_skill = 0
	resp.weapon_info.weapon_info.strength_prob = 0
	resp.weapon_info.weapon_info.exp = 0
	resp.weapon_info.weapon_info.skill_pro = {}
	
	local tmp_skill_it = role._roledata._forge_info._weapon_info._weapon_pro._skill_pro:SeekToBegin()
	local tmp_skill = tmp_skill_it:GetValue()
	while tmp_skill ~= nil do
		local skill = {}
		skill.skill_id = tmp_skill._skill_id
		skill.skill_level = tmp_skill._skill_level
		resp.weapon_info.weapon_info.skill_pro[#resp.weapon_info.weapon_info.skill_pro+1] = skill

		tmp_skill_it:Next()
		tmp_skill = tmp_skill_it:GetValue()
	end

	resp.retcode = G_ERRCODE["SUCCESS"]	
	resp.typ = arg.typ
	role:SendToClient(SerializeCommand(resp))
]]--
end
