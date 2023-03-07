function OnCommand_EquipmentDecompose(player, role, arg, others)
	player:Log("OnCommand_EquipmentDecompose, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("EquipmentDecompose_Re")
	resp.money = 0

	local find_equipment = role._roledata._backpack._equipment_items._equipment_items:Find(arg.equipment_id)
	
	if find_equipment == nil then
		resp.retcode = G_ERRCODE["EQUIPMENT_NOT_EXIST"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if find_equipment._equipment_pro._wear_flag == 1 then
		resp.retcode = G_ERRCODE["EQUIPMENT_DECOMPOSE_WEARED"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local item = ed:FindBy("item_id", find_equipment._base_item._tid)
	local equipment_info = ed:FindBy("equip_id", item.type_data1)

	if equipment_info.equip_decompose_id == 0 then
		resp.retcode = G_ERRCODE["EQUIPMENT_NOT_DECOMPOSE"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local decompose_id = equipment_info.equip_decompose_id[find_equipment._equipment_pro._order+1]

	if decompose_id == 0 or decompose_id == nil then
		resp.retcode = G_ERRCODE["EQUIPMENT_NOT_DECOMPOSE"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if find_equipment._equipment_pro._level_up_money > 0 then
		resp.money = math.ceil(find_equipment._equipment_pro._level_up_money*equiplvupreturn/10000.0)
	end

	if find_equipment._equipment_pro._strengthen_cost > 0 then
		local tmp_item = {}
		tmp_item.tid = 20830
		tmp_item.count = math.ceil(find_equipment._equipment_pro._strengthen_cost*equiprefinereturn/10000.0)
		resp.item_info[#resp.item_info+1] = tmp_item
	end

	local reward = DROPITEM_Reward(role, decompose_id)
	for i = 1, table.getn(reward) do
		local tmp_item = {}
		tmp_item.tid = reward[i].itemid
		tmp_item.count = reward[i].itemnum
		resp.item_info[#resp.item_info+1] = tmp_item
	end
	
	--把物品添加到背包里面去
	if resp.money > 0 then
		ROLE_AddMoney(role, resp.money)
	end

	for i = 1, table.gent(resp.item_info) do
		BACKPACK_AddItem(role, resp.item_info[i].tid, resp.item_info[i].count)
	end
	
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
	return
end
