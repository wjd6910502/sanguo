function OnCommand_EquipmentLevelUp(player, role, arg, others)
	player:Log("OnCommand_EquipmentLevelUp, "..DumpTable(arg).." "..DumpTable(others))


	--�����Ҫ�ж��佫��װ���Ƿ���ڡ�װ�������Ƿ����
	--����Ҫ�жϣ�����佫�ĵ�ǰװ�������Ƿ������װ��
	local resp = NewCommand("EquipmentLevelUp_Re")
	resp.hero = arg.hero
	resp.typ = arg.typ
	resp.equipment_id = arg.equipment_id
	resp.crit_flag = 0

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

	local find_equipment = role._roledata._backpack._equipment_items._equipment_items:Find(arg.equipment_id)
	if find_equipment == nil then
		resp.retcode = G_ERRCODE["EQUIPMENT_NOT_EXIST"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if find_equipment._equipment_pro._level_up >= role._roledata._status._level*2 then
		resp.retcode = G_ERRCODE["EQUIPMENT_MAX_LEVEL"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if find_equipment._equipment_pro._hero_id ~= arg.hero then
		resp.retcode = G_ERRCODE["EQUIPMENT_BIND_OTHER_HERO"]
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
		resp.retcode = G_ERRCODE["EQUIPMENT_BIND_OTHER_HERO"]
		player:SendToClient(SerializeCommand(resp))
		return
	else
		if pos_info._id ~= arg.equipment_id then
			resp.retcode = G_ERRCODE["EQUIPMENT_BIND_OTHER_HERO"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
	end

	--�鿴��Ǯ�Ƿ��㹻
	local need_money = 0
	local item = ed:FindBy("item_id", find_equipment._base_item._tid)
	local equipment_info = ed:FindBy("equip_id", item.type_data1)
	local equipment_lv_info = ed:FindBy("equip_lv", find_equipment._equipment_pro._level_up)
	local equipment_order = equipment_info.equip_quality

	if equipment_lv_info == nil then
		resp.retcode = G_ERRCODE["EQUIPMENT_LEVEL_SYS_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	for qualityinfo in DataPool_Array(equipment_lv_info.qualityinfo) do
		if qualityinfo.quality == equipment_order then
			need_money = qualityinfo.costcurrency
			break
		end
	end

	if need_money <= 0 then
		resp.retcode = G_ERRCODE["EQUIPMENT_LEVEL_SYS_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if need_money > role._roledata._status._money then
		resp.retcode = G_ERRCODE["EQUIPMENT_LEVEL_MONEY_LESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--�Ƿ����˱���
	local crit_random = math.random(10000)
	if crit_random <= quanju.equiplvupcriticalprobablity then
		resp.crit_flag = 1
	end

	ROLE_SubMoney(role, need_money)
	find_equipment._equipment_pro._level_up_money = find_equipment._equipment_pro._level_up_money + need_money

	if resp.crit_flag == 1 then
		find_equipment._equipment_pro._level_up = find_equipment._equipment_pro._level_up + 2
	else
		find_equipment._equipment_pro._level_up = find_equipment._equipment_pro._level_up + 1
	end

	ROLE_UpdateMiscPveArenaHeroInfo(role, arg.hero)
	BACKPACK_UpdateEquipment(role, arg.equipment_id)
	
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
	return
end