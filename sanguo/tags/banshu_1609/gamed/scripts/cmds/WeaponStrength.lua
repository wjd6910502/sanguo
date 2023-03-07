function OnCommand_WeaponStrength(player, role, arg, others)
	player:Log("OnCommand_WeaponStrength, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("WeaponStrength_Re")
	resp.weapon_id = arg.weapon_id
	resp.hero = arg.hero
	resp.crit_flag = 0
	
	--需要判断的条件（武将等级，是否被装备)
	local hero_info = role._roledata._hero_hall._heros:Find(arg.hero)

	if hero_info == nil then
		resp.retcode = G_ERRCODE["WEAPON_EQUIP_HERO_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if hero_info._weapon_id ~= arg.weapon_id then
		resp.retcode = G_ERRCODE["WEAPON_LEVELUP_UNEQUIP"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	--找到需要强化的武器
	local weapon_items = role._roledata._backpack._weapon_items

	local weapon_item_it = weapon_items._weapon_items:SeekToBegin()
	local weapon_item = weapon_item_it:GetValue()
	while weapon_item ~= nil do
		if weapon_item._weapon_pro._tid == arg.weapon_id then
			local ed = DataPool_Find("elementdata")
			local quanju = ed.gamedefine[1]

			if weapon_item._weapon_pro._strengthen >= quanju.maxweaponintensify then
				resp.retcode = G_ERRCODE["WEAPON_STRENGTH_MAX"]
				player:SendToClient(SerializeCommand(resp))
				return
			end

			local cost_item_id = 0
			if weapon_item._weapon_pro._star == 5 then
				cost_item_id = quanju.weaponintensifycosthigh
			else
				cost_item_id = quanju.weaponintensifycostlow
			end
			
			if BACKPACK_HaveItem(role, cost_item_id, 1) == false then
				resp.retcode = G_ERRCODE["WEAPON_STRENGTH_ITEM_LESS"]
				player:SendToClient(SerializeCommand(resp))
				return
			end

			--开始进行装备的强化
			BACKPACK_DelItem(role, cost_item_id, 1)
		
			local crit_random = math.random(10000)
			if crit_random <= quanju.weaponintensifycriticalprobablity then
				resp.crit_flag = 1
			end

			if resp.crit_flag == 0 then
				weapon_item._weapon_pro._strengthen_prob = weapon_item._weapon_pro._strengthen_prob + 1
			else
				weapon_item._weapon_pro._strengthen_prob = weapon_item._weapon_pro._strengthen_prob + 2
			end
			local ed = DataPool_Find("elementdata")
			local strength_info = ed:FindBy("weaponstrength_id", weapon_item._weapon_pro._strengthen)
			if strength_info == nil then
				resp.retcode = G_ERRCODE["WEAPON_EQUIP_SYS_ERR"]
				player:SendToClient(SerializeCommand(resp))
				return
			end

			if weapon_item._weapon_pro._strengthen_prob >= strength_info.weaponintensifytimes then
				weapon_item._weapon_pro._strengthen_prob = weapon_item._weapon_pro._strengthen_prob - strength_info.weaponintensifytimes
				weapon_item._weapon_pro._strengthen = weapon_item._weapon_pro._strengthen + 1
			end

			if weapon_item._weapon_pro._star == 5 then
				weapon_item._weapon_pro._strengthen_high_cost = weapon_item._weapon_pro._strengthen_high_cost + 1
			else
				weapon_item._weapon_pro._strengthen_cost = weapon_item._weapon_pro._strengthen_cost + 1
			end
		
			BACKPACK_UpdateWeaponItem(role, arg.weapon_id)
			resp.retcode = G_ERRCODE["SUCCESS"]
			player:SendToClient(SerializeCommand(resp))
			
			--在这里进行一次修改,只要武将的信息修改以后，基本都会走这个协议的。
			ROLE_UpdateMiscPveArenaHeroInfo(role, arg.hero)
			return
		end
		weapon_item_it:Next()
		weapon_item = weapon_item_it:GetValue()
	end
	
	resp.retcode = G_ERRCODE["WEAPON_EQUIP_NOT_EXIST"]
	player:SendToClient(SerializeCommand(resp))
	return
end
