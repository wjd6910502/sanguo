function OnCommand_EquipmentRefinableSave(player, role, arg, others)
	player:Log("OnCommand_EquipmentRefinableSave, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("EquipmentRefinableSave_Re")
	resp.hero = arg.hero
	resp.typ = arg.typ
	resp.equipment_id = arg.equipment_id
	resp.save_flag = arg.save_flag

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
		player:Log("OnCommand_EquipmentRefinableSave, error=EQUIPMENT_TYP_ERR")
		return
	end

	local find_equipment = role._roledata._backpack._equipment_items._equipment_items:Find(arg.equipment_id)
	if find_equipment == nil then
		resp.retcode = G_ERRCODE["EQUIPMENT_NOT_EXIST"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_EquipmentRefinableSave, error=EQUIPMENT_NOT_EXIST")
		return
	end

	if find_equipment._equipment_pro._hero_id ~= arg.hero then
		resp.retcode = G_ERRCODE["EQUIPMENT_BIND_OTHER_HERO"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_EquipmentRefinableSave, error=EQUIPMENT_BIND_OTHER_HERO")
		return
	end

	local hero_info = role._roledata._hero_hall._heros:Find(arg.hero)
	if hero_info == nil then
		resp.retcode = G_ERRCODE["EQUIPMENT_HERO_NOT_EXIST"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_EquipmentRefinableSave, error=EQUIPMENT_HERO_NOT_EXIST")
		return
	end
	
	local pos_info = hero_info._equipment:Find(arg.typ)
	if pos_info == nil then
		resp.retcode = G_ERRCODE["EQUIPMENT_BIND_OTHER_HERO"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_EquipmentRefinableSave, error=EQUIPMENT_BIND_OTHER_HERO")
		return
	else
		if pos_info._id ~= arg.equipment_id then
			resp.retcode = G_ERRCODE["EQUIPMENT_BIND_OTHER_HERO"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_EquipmentRefinableSave, error=EQUIPMENT_BIND_OTHER_HERO")
			return
		end
	end

	--查看这件装备是否有临时属性可以进行替换。如果没有的话，直接返回
	if find_equipment._equipment_pro._tmp_refinable_pro:Size() == 0 then
		resp.retcode = G_ERRCODE["EQUIPMENT_NO_REFINABLE_SAVE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_EquipmentRefinableSave, error=EQUIPMENT_NO_REFINABLE_SAVE")
		return
	end
	
	if arg.save_flag == 0 then
		find_equipment._equipment_pro._tmp_refinable_pro:Clear()
	else
		find_equipment._equipment_pro._refinable_pro = find_equipment._equipment_pro._tmp_refinable_pro
		find_equipment._equipment_pro._tmp_refinable_pro:Clear()
	end

	BACKPACK_UpdateEquipment(role, arg.equipment_id)
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
	return
end
