function OnCommand_WeaponLevelUp(player, role, arg, others)
	player:Log("OnCommand_WeaponLevelUp, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("WeaponLevelUp_Re")

	resp.weapon_id = arg.weapon_id
	resp.hero = arg.hero
	resp.crit_flag = 0

	--��Ҫ�жϵ��������佫�ȼ����Ƿ�װ��)
	local hero_info = role._roledata._hero_hall._heros:Find(arg.hero)

	if hero_info == nil then
		resp.retcode = G_ERRCODE["WEAPON_EQUIP_HERO_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WeaponLevelUp, error=WEAPON_EQUIP_HERO_ERR")
		return
	end

	if hero_info._weapon_id ~= arg.weapon_id then
		resp.retcode = G_ERRCODE["WEAPON_LEVELUP_UNEQUIP"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_WeaponLevelUp, error=WEAPON_LEVELUP_UNEQUIP")
		return
	end

	--�ҵ���Ҫ����������
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

			local weapon_info = ed:FindBy("weapon_id", item.type_data1) -- ��Ҫǿ��������
			if weapon_info == nil then
				resp.retcode = G_ERRCODE["WEAPON_EQUIP_SYS_ERR"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_WeaponLevelUp, error=WEAPON_EQUIP_SYS_ERR")
				return
			end

			local max_flag = 0
			--��֤�����ǲ����Ѿ�������ߵȼ�
			if weapon_item._weapon_pro._level_up >= weapon_info.max_lv then
				local skill_info_it = weapon_item._weapon_pro._skill_pro:SeekToBegin()
				local skill_info = skill_info_it:GetValue()
				while skill_info ~= nil do
					if skill_info._skill_level < weapon_info.special_prop_lvup_max then
						max_flag = 1
						break
					end
				end			

				if max_flag == 0 then
					resp.retcode = G_ERRCODE["WEAPON_STRENGTH_MAX"]
					player:SendToClient(SerializeCommand(resp))
					player:Log("OnCommand_WeaponLevelUp, error=WEAPON_STRENGTH_MAX")	
					return
				end
			end

			--��֤���ĵ������Ƿ����	
			local exp = 0
			local size = table.getn(arg.weapon_cost_ids)
			if size == 0 then
				resp.retcode = G_ERRCODE["WEAPON_EQUIP_NOT_EXIST"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_WeaponLevelUp, error=WEAPON_EQUIP_NOT_EXIST")
				return
			end

			for i = 1, size do
				local flag = 0
				local weapon_item_it1 = weapon_items._weapon_items:SeekToBegin()
				local weapon_item1 = weapon_item_it1:GetValue()
				while weapon_item1 ~= nil do
					if weapon_item1._weapon_pro._tid == arg.weapon_cost_ids[i] then
						--���ڵĻ����ͶԲ���
						local item = ed:FindBy("item_id", weapon_item1._base_item._tid)
						if item == nil then
							resp.retcode = G_ERRCODE["WEAPON_EQUIP_SYS_ERR"]
							player:SendToClient(SerializeCommand(resp))
							player:Log("OnCommand_WeaponLevelUp, error=WEAPON_EQUIP_SYS_ERR")
							return
						end

						local weapon_info_cost = ed:FindBy("weapon_id", item.type_data1) -- ��Ҫ���ĵ�����
						if weapon_info_cost == nil then
							resp.retcode = G_ERRCODE["WEAPON_EQUIP_SYS_ERR"]
							player:SendToClient(SerializeCommand(resp))
							player:Log("OnCommand_WeaponLevelUp, error=WEAPON_EQUIP_SYS_ERR")
							return		
						end

						local weapon_lv_info = ed:FindBy("weaponlv_id", weapon_item1._weapon_pro._level_up)
						if weapon_lv_info == nil then
							resp.retcode = G_ERRCODE["WEAPON_EQUIP_SYS_ERR"]
							player:SendToClient(SerializeCommand(resp))
							player:Log("OnCommand_WeaponLevelUp, error=WEAPON_EQUIP_SYS_ERR")
							return
						end

						--�����Ļ���֤���������Ƿ���ͬ
						if max_flag == 1 then
							if weapon_info.special_prop_lvup_type ~= weapon_info_cost.special_prop_lvup_type then
								resp.retcode = G_ERRCODE["WEAPON_LEVELUP_COST_TYPE_ERROR"]
								player:SendToClient(SerializeCommand(resp))
								player:Log("OnCommand_WeaponLevelUp, error=WEAPON_LEVELUP_COST_TYPE_ERROR")
								return
							end
						end

						exp = exp + weapon_info_cost.exp --�����ľ���
						exp = exp + weapon_lv_info.starinfo[weapon_item1._weapon_pro._star].provideexp --�Ǽ�Ӱ������ľ���
						flag = 1
						break
					end
					weapon_item_it1:Next()
					weapon_item1 = weapon_item_it1:GetValue()
				end
				if flag == 0 then
					resp.retcode = G_ERRCODE["WEAPON_LEVELUP_COST_NOT_HAVE"]
					player:SendToClient(SerializeCommand(resp))
					player:Log("OnCommand_WeaponLevelUp, error=WEAPON_LEVELUP_COST_NOT_HAVE")
					return
				end
			end

			local quanju = ed.gamedefine[1]
			--��ҹ�����
			local cost_money = exp * quanju.cost_per_weapon_exp
			if role._roledata._status._money < cost_money then
				resp.retcode = G_ERRCODE["WEAPON_LEVELUP_MONEY_LESS"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_WeaponLevelUp, error=WEAPON_LEVELUP_MONEY_LESS")
				return
			end

			local new_exp = weapon_item._weapon_pro._exp + exp
			local old_level = weapon_item._weapon_pro._level_up
			local new_level = weapon_item._weapon_pro._level_up
			while 1 do
				local weapon_lv_info = ed:FindBy("weaponlv_id", new_level)
				if weapon_lv_info == nil then
					resp.retcode = G_ERRCODE["WEAPON_EQUIP_SYS_ERR"]
					player:SendToClient(SerializeCommand(resp))
					player:Log("OnCommand_WeaponLevelUp, error=WEAPON_EQUIP_SYS_ERR")
					return
				end
				
				if new_exp >= weapon_lv_info.starinfo[weapon_item._weapon_pro._star].costexp then
					new_exp = new_exp - weapon_lv_info.starinfo[weapon_item._weapon_pro._star].costexp
					new_level = new_level + 1
				else
					break	
				end	
			end

			--��Ǯ
			ROLE_SubMoney(role, cost_money)
			
			weapon_item._weapon_pro._level_up_money = weapon_item._weapon_pro._level_up_money + cost_money
			weapon_item._weapon_pro._exp = new_exp
			weapon_item._weapon_pro._level_up = new_level
			if weapon_item._weapon_pro._level_up >= weapon_info.max_lv then
				weapon_item._weapon_pro._exp = 0
				weapon_item._weapon_pro._level_up = weapon_info.max_lv
			end

			resp.level = weapon_item._weapon_pro._level_up
			resp.exp = weapon_item._weapon_pro._exp

			resp.skill_id = {}
			for i = 1, size do
				local weapon_item_it1 = weapon_items._weapon_items:SeekToBegin()
				local weapon_item1 = weapon_item_it1:GetValue()
				while weapon_item1 ~= nil do
					if weapon_item1._weapon_pro._tid == arg.weapon_cost_ids[i] then
						local item = ed:FindBy("item_id", weapon_item1._base_item._tid)
						if item == nil then
							resp.retcode = G_ERRCODE["WEAPON_EQUIP_SYS_ERR"]
							player:SendToClient(SerializeCommand(resp))
							player:Log("OnCommand_WeaponLevelUp, error=WEAPON_EQUIP_SYS_ERR")
							return
						end

						local weapon_info_cost = ed:FindBy("weapon_id", item.type_data1) -- ��Ҫ���ĵ�����
						if weapon_info_cost == nil then
							resp.retcode = G_ERRCODE["WEAPON_EQUIP_SYS_ERR"]
							player:SendToClient(SerializeCommand(resp))
							player:Log("OnCommand_WeaponLevelUp, error=WEAPON_EQUIP_SYS_ERR")
							return
						end

						if weapon_info.special_prop_lvup_type == weapon_info_cost.special_prop_lvup_type then
							--���һ������
							local size = weapon_item._weapon_pro._skill_pro:Size()
							if size > 0 then
								local skill_info_it = weapon_item._weapon_pro._skill_pro:SeekToBegin()
								if size > 1 then
									local randd = math.random(0, size-1)
									for i = 1, randd do
										skill_info_it:Next()
									end
								end
								local skill_info = skill_info_it:GetValue()
								local times = 0
								while skill_info ~= nil do
									times = times + 1
									if skill_info._skill_level < weapon_info.special_prop_lvup_max then
										skill_info._skill_level = skill_info._skill_level + 1
										resp.skill_id[#resp.skill_id+1] = skill_info._skill_id
										break
									end
									skill_info_it:Next()
									skill_info = skill_info_it:GetValue()

									if skill_info == nil then
										skill_info_it = weapon_item._weapon_pro._skill_pro:SeekToBegin()
										skill_info = skill_info_it:GetValue()
									end

									if times >= size then --����
										break
									end
								end
							end
						end
						break
					end
					weapon_item_it1:Next()
					weapon_item1 = weapon_item_it1:GetValue()
				end
			end

			--�۳����ĵ�����
			for i = 1, size do
				local weapon_item_it1 = weapon_items._weapon_items:SeekToBegin()
				local weapon_item1 = weapon_item_it1:GetValue()
				while weapon_item1 ~= nil do
					if weapon_item1._weapon_pro._tid == arg.weapon_cost_ids[i] then
						--�ɾ��޸�
						TASK_ChangeCondition_Special(role, G_ACH_TYPE["WEAPON_LEVELUP"], weapon_item1._weapon_pro._level, 0, -1)

						weapon_item_it1:Pop()
						break
					end
					weapon_item_it1:Next()
					weapon_item1 = weapon_item_it1:GetValue()
				end
			end

			ROLE_UpdateZhanli(role)
			
			--�ɾ��޸�
			TASK_ChangeCondition_Special(role, G_ACH_TYPE["WEAPON_LEVELUP"], new_level, old_level, 1)
		
			resp.retcode = G_ERRCODE["SUCCESS"]
			resp.weapon_cost_ids = arg.weapon_cost_ids
			player:SendToClient(SerializeCommand(resp))
			return
		end
		weapon_item_it:Next()
		weapon_item = weapon_item_it:GetValue()
	end
	
	resp.retcode = G_ERRCODE["WEAPON_EQUIP_NOT_EXIST"]
	player:SendToClient(SerializeCommand(resp))
	player:Log("OnCommand_WeaponLevelUp, error=WEAPON_EQUIP_NOT_EXIST")
	return
end