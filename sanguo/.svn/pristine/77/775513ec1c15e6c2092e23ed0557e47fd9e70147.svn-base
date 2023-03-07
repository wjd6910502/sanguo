function OnCommand_EquipmentEasyLevelUp(player, role, arg, others)
	player:Log("OnCommand_EquipmentEasyLevelUp, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("EquipmentEasyLevelUp_Re")
	resp.hero = arg.hero
	resp.equipment_id = {}
	resp.money = 0

	local hero_info = role._roledata._hero_hall._heros:Find(arg.hero)
	if hero_info == nil then
		resp.retcode = G_ERRCODE["EQUIPMENT_HERO_NOT_EXIST"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_EquipmentEasyLevelUp, error=EQUIPMENT_HERO_NOT_EXIST")
		return
	end

	--查看这个武将是否有可升级的装备
	local equipments = {}
	for equiptype = 1, 6 do
		local pos_info = hero_info._equipment:Find(equiptype)
		if pos_info ~= nil then
			local find_equipment = role._roledata._backpack._equipment_items._equipment_items:Find(pos_info._id)
			if find_equipment._equipment_pro._level_up < role._roledata._status._level*2 then
				equipments[#equipments+1] = find_equipment
			end
		end
	end

	if #equipments == 0 then
		resp.retcode = G_ERRCODE["EQUIPMENT_NO_LEVELUP_EQUIP"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_EquipmentEasyLevelUp, error=EQUIPMENT_NO_LEVELUP_EQUIP")
		return
	end

	--装备升级，直到钱不够，或等级达到上限
	local old_level = {}
	local new_level = {}
	local need_money = 0
	local order = 0
	local levelup_flag = 0
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	while #equipments ~= 0 do
		--找出武将身上已装备的装备中升级1级最便宜的一件
		for i = 1, #equipments do
			local item = ed:FindBy("item_id", equipments[i]._base_item._tid)
			local equipment_info = ed:FindBy("equip_id", item.type_data1)
			local equipment_lv_info = ed:FindBy("equip_lv", equipments[i]._equipment_pro._level_up)
			local equipment_order = equipment_info.equip_quality

			if equipment_lv_info == nil then
				resp.retcode = G_ERRCODE["EQUIPMENT_LEVEL_SYS_ERR"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_EquipmentEasyLevelUp, error=EQUIPMENT_LEVEL_SYS_ERR")
				return
			end

			for qualityinfo in DataPool_Array(equipment_lv_info.qualityinfo) do
				if qualityinfo.quality == equipment_order then
					if i == 1 then
						need_money = qualityinfo.costcurrency
						order = i
					elseif qualityinfo.costcurrency < need_money then
						need_money = qualityinfo.costcurrency
						order = i
					end
					break
				end
			end

			if need_money <= 0 then
				resp.retcode = G_ERRCODE["EQUIPMENT_LEVEL_SYS_ERR"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_EquipmentEasyLevelUp, error=EQUIPMENT_LEVEL_SYS_ERR")
				return
			end
		end

		--钱是否足够
		if need_money > role._roledata._status._money - resp.money then
			break
		else
			levelup_flag = 1
			resp.money = resp.money + need_money
		end

		--是否发生了暴击
		local crit_random = math.random(10000)
		if crit_random <= quanju.equiplvupcriticalprobablity then
			resp.crit_flag = 1
		end

		equipments[order]._equipment_pro._level_up_money = equipments[order]._equipment_pro._level_up_money + need_money

		local o_level = equipments[order]._equipment_pro._level_up
		if resp.crit_flag == 1 then
			equipments[order]._equipment_pro._level_up = equipments[order]._equipment_pro._level_up + 2
		else
			equipments[order]._equipment_pro._level_up = equipments[order]._equipment_pro._level_up + 1
		end

		local insert_flag = 1
		for j = 1, #resp.equipment_id do
			if resp.equipment_id[j] == equipments[order]._equipment_pro._tid then
				insert_flag = 0
				new_level[j] = equipments[order]._equipment_pro._level_up
				break
			end  
		end
		if insert_flag == 1 then
			resp.equipment_id[#resp.equipment_id+1] = equipments[order]._equipment_pro._tid
			old_level[#old_level+1] = o_level
			new_level[#new_level+1] = equipments[order]._equipment_pro._level_up
		end

		--达到等级限制，从可升级列表里删除
		if equipments[order]._equipment_pro._level_up >= role._roledata._status._level*2 then
			table.remove(equipments, order)
		end

	end

	if levelup_flag == 0 then
		resp.retcode = G_ERRCODE["EQUIPMENT_LEVEL_MONEY_LESS"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_EquipmentEasyLevelUp, error=EQUIPMENT_LEVEL_MONEY_LESS")
		return
	end

	ROLE_SubMoney(role, resp.money)

	--给客户端更新装备信息
	for i = 1, #resp.equipment_id do
		BACKPACK_UpdateEquipment(role, resp.equipment_id[i])
		--成就修改
		TASK_ChangeCondition_Special(role, G_ACH_TYPE["EQUIPMENT_LEVELUP"], new_level[i], old_level[i], 1)
	end

	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
	return
end
