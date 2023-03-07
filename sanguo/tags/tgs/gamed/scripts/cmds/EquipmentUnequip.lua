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
		return
	end

	local hero_info = role._roledata._hero_hall._heros:Find(arg.hero)
	if hero_info == nil then
		resp.retcode = G_ERRCODE["EQUIPMENT_HERO_NOT_EXIST"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	local pos_info = hero_info._equipment:Find(arg.typ)
	if pos_info == nil then
		resp.retcode = G_ERRCODE["EQUIPMENT_NO_UNEQUIP"]
		player:SendToClient(SerializeCommand(resp))
		return
	else
		hero_info._equipment:Delete(arg.typ)
	end
	
	--更新武将的信息
	HERO_UpdateHeroInfo(role, arg.hero)

	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
	return
end
