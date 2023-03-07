function OnCommand_EquipmentUnequip(player, role, arg, others)
	player:Log("OnCommand_EquipmentUnequip, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("EquipmentUnequip_Re")
	resp.hero = arg.hero
	resp.typ = arg.typ

	local typ_flag = 0
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	for typ in DataPool_Array(quanju.equipable_type) do
		if typ == arg.typ then
			typ_flag = 1
			break
		end
	end
	if typ_flag == 0 then
		resp.retcode = G_ERRCODE["EQUIPMENT_TYP_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_EquipmentUnequip, error=EQUIPMENT_TYP_ERR")
		return
	end

	local hero_info = role._roledata._hero_hall._heros:Find(arg.hero)
	if hero_info == nil then
		resp.retcode = G_ERRCODE["EQUIPMENT_HERO_NOT_EXIST"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_EquipmentUnequip, error=EQUIPMENT_HERO_NOT_EXIST")
		return
	end


	local pos_info = hero_info._equipment:Find(arg.typ)
	if pos_info == nil then
		resp.retcode = G_ERRCODE["EQUIPMENT_NO_UNEQUIP"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_EquipmentUnequip, error=EQUIPMENT_NO_UNEQUIP")
		return
	else
		local find_equipment = role._roledata._backpack._equipment_items._equipment_items:Find(pos_info._id)
		if find_equipment == nil then
			resp.retcode = G_ERRCODE["EQUIPMENT_NOT_EXIST"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_EquipmentUnequip, error=EQUIPMENT_NOT_EXIST")
			return
		end

		local item = ed:FindBy("item_id", find_equipment._base_item._tid)
		local equipment_info = ed:FindBy("equip_id", item.type_data1)
		if equipment_info == nil then
			resp.retcode = G_ERRCODE["EQUIPMENT_NOT_EXIST"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_EquipmentUnequip, error=EQUIPMENT_NOT_EXIST")
			return
		end
		--查看是否是花钱脱下来，还是直接删除脱下来
		local find_equipment = role._roledata._backpack._equipment_items._equipment_items:Find(pos_info._id)
		if arg.cost_flag == 1 then
			if role._roledata._status._money < equipment_info.undress_cost then
				resp.retcode = G_ERRCODE["EQUIPMENT_UNEQUIP_MONEY_LESS"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_EquipmentUnequip, error=EQUIPMENT_UNEQUIP_MONEY_LESS")
				return
			end
		end

		find_equipment._equipment_pro._wear_flag = 0
		find_equipment._equipment_pro._hero_id = 0
		hero_info._equipment:Delete(arg.typ)

		if arg.cost_flag == 1 then
			--扣钱
			ROLE_SubMoney(role, equipment_info.undress_cost)
		else
			--删除装备
			BACKPACK_DelEquipment(role, pos_info._id)
		end
	end
	
	--更新武将的信息
	HERO_UpdateHeroInfo(role, arg.hero)

	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
	return
end
