function OnCommand_WeaponLevelUp(player, role, arg, others)
	player:Log("OnCommand_WeaponLevelUp, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("WeaponLevelUp_Re")

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
	--找到需要升级的武器
	local weapon_items = role._roledata._backpack._weapon_items

	local weapon_item_it = weapon_items._weapon_items:SeekToBegin()
	local weapon_item = weapon_item_it:GetValue()
	while weapon_item ~= nil do
		if weapon_item._weapon_pro._tid == arg.weapon_id then
		
			if weapon_item._weapon_pro._level_up >= role._roledata._status._level*2 then
				resp.retcode = G_ERRCODE["WEAPON_LEVELUP_MAX_LEVEL"]
				player:SendToClient(SerializeCommand(resp))
				return
			end

			local ed = DataPool_Find("elementdata")
			local weapon_lv_info = ed:FindBy("weaponlv_id", weapon_item._weapon_pro._level_up)
		
			if weapon_lv_info == nil then
				resp.retcode = G_ERRCODE["WEAPON_EQUIP_SYS_ERR"]
				player:SendToClient(SerializeCommand(resp))
				return
			end

			if role._roledata._status._money < weapon_lv_info.weaponlvupcost then
				resp.retcode = G_ERRCODE["WEAPON_LEVELUP_MONEY_LESS"]
				player:SendToClient(SerializeCommand(resp))
				return
			end

			--开始判断是否暴击了
			local quanju = ed.gamedefine[1]
			local crit_random = math.random(10000)
			if crit_random <= quanju.weaponlvupcriticalprobablity then
				resp.crit_flag = 1
			end

			ROLE_SubMoney(role, weapon_lv_info.weaponlvupcost)
			weapon_item._weapon_pro._level_up_money = weapon_item._weapon_pro._level_up_money + weapon_lv_info.weaponlvupcost

			if resp.crit_flag == 0 then
				weapon_item._weapon_pro._level_up = weapon_item._weapon_pro._level_up + 1
			elseif resp.crit_flag == 1 then
				weapon_item._weapon_pro._level_up = weapon_item._weapon_pro._level_up + 2
			
				--在这里优先让等级最低的升级,反正基本后面需要修改
				local skill_info_it = weapon_item._weapon_pro._skill_pro:SeekToBegin()
				local skill_info = skill_info_it:GetValue()
				local select_skill_id = 0
				local select_skill_level = quanju.weaponspecialpropmaxlv
				while skill_info ~= nil do
					if select_skill_level > skill_info._skill_level then
						select_skill_id = skill_info._skill_id
						select_skill_level = skill_info._skill_level
					end
					skill_info_it:Next()
					skill_info = skill_info_it:GetValue()
				end

				if select_skill_level ~= quanju.weaponspecialpropmaxlv then
					--装备印的等级都达到了满级，没有什么可以进行修改的了
					local skill_info = weapon_item._weapon_pro._skill_pro:Find(select_skill_id)
					skill_info._skill_level = skill_info._skill_level + 1
					resp.skill_id = select_skill_id
				end
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
