function OnCommand_EquipmentDecompose(player, role, arg, others)
	player:Log("OnCommand_EquipmentDecompose, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("EquipmentDecompose_Re")
	resp.equipment_id = {}
	resp.money = 0
	resp.item_info = {}

	for _, equipment_id in ipairs(arg.equipment_id) do
		resp.equipment_id[#resp.equipment_id+1] = equipment_id
		local find_equipment = role._roledata._backpack._equipment_items._equipment_items:Find(equipment_id)
		
		if find_equipment == nil then
			resp.retcode = G_ERRCODE["EQUIPMENT_NOT_EXIST"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_EquipmentDecompose, error=EQUIPMENT_NOT_EXIST")
			return
		end

		if find_equipment._equipment_pro._wear_flag == 1 then
			resp.retcode = G_ERRCODE["EQUIPMENT_DECOMPOSE_WEARED"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_EquipmentDecompose, error=EQUIPMENT_DECOMPOSE_WEARED")
			return
		end

		local ed = DataPool_Find("elementdata")
		local item = ed:FindBy("item_id", find_equipment._base_item._tid)
		local equipment_info = ed:FindBy("equip_id", item.type_data1)

		if equipment_info.equip_decompose_id == 0 then
			resp.retcode = G_ERRCODE["EQUIPMENT_NOT_DECOMPOSE"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_EquipmentDecompose, error=EQUIPMENT_NOT_DECOMPOSE")
			return
		end

		local decompose_id = equipment_info.equip_decompose_id[find_equipment._equipment_pro._order+1]

		if decompose_id == 0 or decompose_id == nil then
			resp.retcode = G_ERRCODE["EQUIPMENT_NOT_DECOMPOSE"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_EquipmentDecompose, error=EQUIPMENT_NOT_DECOMPOSE")
			return
		end

		if equipment_info.equip_selling_base_price > 0 then
			resp.money = resp.money + equipment_info.equip_selling_base_price
		end

		local quanju = ed.gamedefine[1]
		if find_equipment._equipment_pro._level_up_money > 0 then
			resp.money = resp.money + math.ceil(find_equipment._equipment_pro._level_up_money*quanju.equiplvupreturn/10000.0)
		end

		if find_equipment._equipment_pro._strengthen_cost > 0 then
			local tmp_item = {}
			tmp_item.tid = 20830
			tmp_item.count = math.ceil(find_equipment._equipment_pro._strengthen_cost*equiprefinereturn/10000.0)
			local have_flag = 1
			for i = 1, #resp.item_info do
				if resp.item_info[i].tid == 20830 then
					resp.item_info[i].count = resp.item_info[i].count + tmp_item.count
					have_flag = 0
					break
				end
			end
			if have_flag == 1 then
				resp.item_info[#resp.item_info+1] = tmp_item
			end
		end

		local reward = DROPITEM_Reward(role, decompose_id)
		for i = 1, table.getn(reward.item) do
			local tmp_item = {}
			local have_flag = 1
			for j = 1, #resp.item_info do
				if resp.item_info[j].tid == reward.item[i].itemid then
					resp.item_info[j].count = resp.item_info[j].count + reward.item[i].itemnum
					have_flag = 0
					break
				end
			end
			if have_flag == 1 then
				tmp_item.tid = reward.item[i].itemid
				tmp_item.count = reward.item[i].itemnum
				resp.item_info[#resp.item_info+1] = tmp_item
			end
		end

		--成就修改
		TASK_ChangeCondition_Special(role, G_ACH_TYPE["EQUIPMENT_LEVELUP"], find_equipment._equipment_pro._level_up, 0, -1)
	end	

	--把物品添加到背包里面去
	if resp.money > 0 then
		ROLE_AddMoney(role, resp.money)
	end

	for i = 1, #resp.item_info do
		BACKPACK_AddItem(role, resp.item_info[i].tid, resp.item_info[i].count)
	end

	for i = 1, #arg.equipment_id do
		BACKPACK_DelEquipment(role, arg.equipment_id[i])
	end
	
	
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
	return
end
