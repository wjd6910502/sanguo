function OnCommand_WeaponStrength(player, role, arg, others)
	player:Log("OnCommand_WeaponStrength, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("WeaponStrength_Re")
	resp.weapon_id = arg.weapon_id
	resp.hero = arg.hero

	--需要判断的条件（武将等级，是否被装备)
	local hero_info = role._roledata._hero_hall._heros:Find(arg.hero)
	if hero_info == nil then
		resp.retcode = G_ERRCODE["WEAPON_EQUIP_HERO_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WeaponStrength, error=WEAPON_EQUIP_HERO_ERR")
		return
	end	
	
	if hero_info._weapon_id ~= arg.weapon_id then
		resp.retcode = G_ERRCODE["WEAPON_LEVELUP_UNEQUIP"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WeaponStrength, error=WEAPON_LEVELUP_UNEQUIP")
		return
	end

	local weapon_items = role._roledata._backpack._weapon_items
	local weapon_item_it = weapon_items._weapon_items:SeekToBegin()
	local weapon_item = weapon_item_it:GetValue()
	while weapon_item ~= nil do
		if weapon_item._weapon_pro._tid == arg.weapon_id then
			local ed = DataPool_Find("elementdata")
			local item = ed:FindBy("item_id", weapon_item._base_item._tid)
			if item == nil then
				resp.retcode = G_ERRCODE["WEAPON_EQUIP_SYS_ERR"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_WeaponLevelUp, error=WEAPON_EQUIP_SYS_ERR")
				return
			end
			
			local weapon_info = ed:FindBy("weapon_id", item.type_data1) -- 需要强化的武器
			if weapon_info == nil then
				resp.retcode = G_ERRCODE["WEAPON_EQUIP_SYS_ERR"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_WeaponLevelUp, error=WEAPON_EQUIP_SYS_ERR")
				return
			end

			if weapon_item._weapon_pro._weapon_skill ~= 0 then
				resp.retcode = G_ERRCODE["WEAPON_HAVED_STRENGTH"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_WeaponLevelUp, error=WEAPON_HAVED_STRENGTH")
				return
			end
			
			if BACKPACK_HaveItem(role, weapon_info.awake_cost_item_id, weapon_info.awake_cost_item_num) == false then
				resp.retcode = G_ERRCODE["WEAPON_STRENGTH_ITEM_LESS"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_WeaponStrength, error=WEAPON_STRENGTH_ITEM_LESS")
				return
			end
			
			BACKPACK_DelItem(role, weapon_info.awake_cost_item_id, weapon_info.awake_cost_item_num)
			weapon_item._weapon_pro._weapon_skill = weapon_info.weaponskill

			BACKPACK_UpdateWeaponItem(role, arg.weapon_id)
			resp.retcode = G_ERRCODE["SUCCESS"]
			resp.weapon_skill = weapon_info.weaponskill
			player:SendToClient(SerializeCommand(resp))
			return
		end
		weapon_item_it:Next()
		weapon_item = weapon_item_it:GetValue()
	end
	
	resp.retcode = G_ERRCODE["WEAPON_EQUIP_NOT_EXIST"]
	player:SendToClient(SerializeCommand(resp))
	player:Log("OnCommand_WeaponStrength, error=WEAPON_EQUIP_NOT_EXIST")
	
	return
end
