function OnCommand_WeaponMake(player, role, arg, others)
	player:Log("OnCommand_WeaponMake, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("WeaponMake_Re")
	resp.typ = arg.typ
	resp.lottery_id = arg.lottery_id

	if arg.typ == 1 and arg.lottery_id == G_LOTTERY_TYP["WEAPON_MAKE_ONE"] then
	elseif arg.typ == 5 and arg.lottery_id == G_LOTTERY_TYP["WEAPON_MAKE_TEN"] then
	else 
		resp.retcode = G_ERRCODE["WEAPON_FORGE_ARG_ERROR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WeaponMake, error=WEAPON_FORGE_ARG_ERROR")
		return
	end

	local ed = DataPool_Find("elementdata")
	local lottery = ed:FindBy("lottery_id",arg.lottery_id)
	if lottery == nil then
		resp.retcode = G_ERRCODE["NO_LOTTERY"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WeaponMake, error=NO_LOTTERY")
		return
	end

	--判断VIP等级是否足够
	local vip_level = ROLE_GetVIP(role)
	if lottery.need_vip_level > vip_level then
		resp.retcode = G_ERRCODE["VIP_LEVEL_LESS"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WeaponMake, error=VIP_LEVEL_LESS")
		return
	end

	if LIMIT_TestUseLimit(role, lottery.vip_limittimes_id, arg.typ) ~= true then
		resp.retcode = G_ERRCODE["WEAPON_FORGE_LIMIT"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WeaponMake, error=WEAPON_FORGE_LIMIT")
		return
	end

	local source_id = G_SOURCE_TYP["WEAPONMAKE"]
	if arg.cost_type == 0 then
		if lottery.itemid == 0 or lottery.itemcount == 0 then
			resp.retcode = G_ERRCODE["LOTTERY_REP_NOTENOUGH"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_WeaponMake, error=LOTTERY_REP_NOTENOUGH")
			return
		end
	
		local currency = ed:FindBy("currency_id", lottery.itemid)
		if ROLE_CheckRep(role, currency.rep_id, lottery.itemcount) == false then
			resp.retcode = G_ERRCODE["LOTTERY_REP_NOTENOUGH"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_WeaponMake, error=LOTTERY_REP_NOTENOUGH1")
			return
		end

		ROLE_SubRep(role, currency.rep_id, lottery.itemcount, source_id)
	elseif arg.cost_type == 1 then
		if lottery.yuanbao == 0 then
			resp.retcode = G_ERRCODE["LOTTERY_YUANBAO_NOTENOUGH"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_WeaponMake, error=LOTTERY_YUANBAO_NOTENOUGH")
			return
		end
		
		if role._roledata._status._yuanbao < lottery.yuanbao then
			resp.retcode = G_ERRCODE["LOTTERY_YUANBAO_NOTENOUGH"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_WeaponMake, error=LOTTERY_YUANBAO_NOTENOUGH")
			return
		end	

		ROLE_SubYuanBao(role, lottery.yuanbao, source_id)
	else
		resp.retcode = G_ERRCODE["WEAPON_FORGE_ARG_ERROR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WeaponMake, error=WEAPON_FORGE_ARG_ERROR")
		return	
	end

	resp.item = {}
	for i = 1, lottery.lottery_times do
		local drop_id = lottery.drop_id
		role._roledata._make_data._num = role._roledata._make_data._num + 1	
		local flag = math.fmod(role._roledata._make_data._num, lottery.special_drop_count)
		if flag == 0 then
			drop_id = lottery.special_drop_id
		end

		local ditem = DROPITEM_DropItem(role, drop_id)
		if ditem == nil then
			resp.retcode = G_ERRCODE["LOTTERY_DROPITEM_ERROR"]
			role:SendToClient(SerializeCommand(cmd))
			player:Log("OnCommand_WeaponMake, error=LOTTERY_DROPITEM_ERROR")
			return
		end
	
		local item_count = table.getn(ditem)
		for index = 1, item_count do
			local reward = {}
			BACKPACK_AddItem(role, ditem[index].id, ditem[index].count, source_id)
			--加入列表
			local item = ed:FindBy("item_id", ditem[index].id)
			if item ~= nil then
				local weapon = ed:FindBy("weapon_id", item.type_data1)
				if weapon ~= nil then
					local tmp = CACHE.Int()
					tmp._value = weapon.library_id
					role._roledata._make_data._weapon_not_active:Insert(weapon.library_id, tmp)
				end
			end			
			reward.tid = ditem[index].id
			reward.count = ditem[index].count
			resp.item[#resp.item+1] = reward
		end
	end	
	LIMIT_AddUseLimit(role, lottery.vip_limittimes_id, arg.typ)
	
	resp.retcode = G_ERRCODE["SUCCESS"]	
	resp.num = role._roledata._make_data._num
	player:SendToClient(SerializeCommand(resp))
end
