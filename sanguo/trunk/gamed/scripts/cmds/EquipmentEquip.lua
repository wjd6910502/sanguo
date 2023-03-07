function OnCommand_EquipmentEquip(player, role, arg, others)
	player:Log("OnCommand_EquipmentEquip, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("EquipmentEquip_Re")
	resp.hero = arg.hero
	resp.typ = arg.typ
	resp.equipment_id = arg.equipment_id

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
		player:Log("OnCommand_EquipmentEquip, error=EQUIPMENT_TYP_ERR")
		return
	end

	local find_equipment = role._roledata._backpack._equipment_items._equipment_items:Find(arg.equipment_id)
	if find_equipment == nil then
		resp.retcode = G_ERRCODE["EQUIPMENT_NOT_EXIST"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_EquipmentEquip, error=EQUIPMENT_NOT_EXIST")
		return
	end

	local hero_info = role._roledata._hero_hall._heros:Find(arg.hero)
	if hero_info == nil then
		resp.retcode = G_ERRCODE["EQUIPMENT_HERO_NOT_EXIST"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_EquipmentEquip, error=EQUIPMENT_HERO_NOT_EXIST")
		return
	end

	if find_equipment._equipment_pro._hero_id ~= 0 and find_equipment._equipment_pro._hero_id ~= arg.hero then
		resp.retcode = G_ERRCODE["EQUIPMENT_BIND_OTHER_HERO"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_EquipmentEquip, error=EQUIPMENT_BIND_OTHER_HERO")
		return
	end
	
	--查看这个装备是否可以装备在这个格子上面
	local item = ed:FindBy("item_id", find_equipment._base_item._tid)
	if item == nil then
		return
	end
	
	local equipment_info = ed:FindBy("equip_id", item.type_data1)
	if equipment_info == nil then
		return
	end

	if equipment_info.equip_type ~= arg.typ then
		resp.retcode = G_ERRCODE["EQUIPMENT_TYP_NOT_MATCH"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_EquipmentEquip, error=EQUIPMENT_TYP_NOT_MATCH")
		return
	end

	local pos_info = hero_info._equipment:Find(arg.typ)
	local old_equip_id = nil
	if pos_info == nil then
		--这个武将还没有装备这个格子的装备
		local insert_pos_info = CACHE.EquipmentPosInfo()
		insert_pos_info._pos = arg.typ
		insert_pos_info._id = arg.equipment_id
		hero_info._equipment:Insert(arg.typ, insert_pos_info)
		find_equipment._equipment_pro._wear_flag = 1
	else
		old_equip_id = pos_info._id
		--进行这个格子装备的替换,如果当前装备的装备就是这个，直接赋值就可以了，没有必要返回一个错误码了
		--这个装备替换的时候查看是直接销毁还是卸下
		if arg.cost_flag == 1 then
			if role._roledata._status._money < equipment_info.undress_cost then
				resp.retcode = G_ERRCODE["EQUIPMENT_UNEQUIP_MONEY_LESS"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_EquipmentUnequip, error=EQUIPMENT_UNEQUIP_MONEY_LESS")
				return
			end
		end
		
		local tmp_find_equipment = role._roledata._backpack._equipment_items._equipment_items:Find(pos_info._id)
		tmp_find_equipment._equipment_pro._wear_flag = 0
		tmp_find_equipment._equipment_pro._hero_id = 0

		if arg.cost_flag == 1 then
			--扣钱
			ROLE_SubMoney(role, equipment_info.undress_cost)
		else
			--删除装备
			BACKPACK_DelEquipment(role, pos_info._id)
		end
		
		pos_info._id = arg.equipment_id
		find_equipment._equipment_pro._wear_flag = 1
	end

	if find_equipment._equipment_pro._hero_id == 0 then
		find_equipment._equipment_pro._hero_id = arg.hero
	end
	--更新武将的信息
	HERO_UpdateHeroInfo(role, arg.hero)
	--更新这个装备的信息
	if old_equip_id~=nil then BACKPACK_UpdateEquipment(role, old_equip_id) end
	BACKPACK_UpdateEquipment(role, arg.equipment_id)

	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
	return
end
