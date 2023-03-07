function OnCommand_EquipmentRefinable(player, role, arg, others)
	player:Log("OnCommand_EquipmentRefinable, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("EquipmentRefinable_Re")
	resp.hero = arg.hero
	resp.typ = arg.typ
	resp.equipment_id = arg.equipment_id
	resp.refinable_typ = arg.refinable_typ
	resp.refinable_count = arg.refinable_count
	resp.tmp_refinable_pro = {}

	if arg.refinable_count <= 0 then
		resp.retcode = G_ERRCODE["EQUIPMENT_REFINE_COUNT_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

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

	if find_equipment._equipment_pro._hero_id ~= arg.hero then
		resp.retcode = G_ERRCODE["EQUIPMENT_BIND_OTHER_HERO"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	if find_equipment._equipment_pro._tmp_refinable_pro:Size() ~= 0 then
		find_equipment._equipment_pro._tmp_refinable_pro:Clear()
		--resp.retcode = G_ERRCODE["EQUIPMENT_LAST_REFINE"]
		--player:SendToClient(SerializeCommand(resp))
		--return
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

	--查看这件装备是否可以洗练
	local item = ed:FindBy("item_id", find_equipment._base_item._tid)
	local equipment_info = ed:FindBy("equip_id", item.type_data1)

	if equipment_info.equip_refine_id == 0 then
		resp.retcode = G_ERRCODE["EQUIPMENT_NOT_REFINABLE"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--查看是否已经洗练到了最高
	local refine_max = 1
	local refine_info = ed:FindBy("equip_refine", equipment_info.equip_refine_id)

	if find_equipment._equipment_pro._refinable_pro:Size() == 0 then
		refine_max = 0
	else
		for garde_refine in DataPool_Array(refine_info.grade_refine) do
			if garde_refine.grade == find_equipment._equipment_pro._order then
				for refineprop in DataPool_Array(garde_refine.refineprop) do
					if refineprop.prop_type ~= 0 then
						local tmp_refine = find_equipment._equipment_pro._refinable_pro:Find(refineprop.prop_type)
						if tmp_refine == nil then
							refine_max = 0
							break
						else
							API_Log("entire_max_point="..refineprop.entire_max_point.."  tmp_refine._num"..tmp_refine._num)
							--if garde_refine.entire_max_point > tmp_refine._num then
							if refineprop.entire_max_point > tmp_refine._num then
								refine_max = 0
								break
							end
						end
					else
						break
					end
				end
			end
		end
	end

	if refine_max == 1 then
		resp.retcode = G_ERRCODE["EQUIPMENT_REFINE_MAX"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--判断洗练需要的钱，物品，元宝等是否足够
	local refine_mode = ed:FindBy("equip_refine_mode", arg.refinable_typ)

	if refine_mode == nil then
		resp.retcode = G_ERRCODE["EQUIPMENT_REFINE_TYP_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if refine_mode.refine_cost_coin*arg.refinable_count > role._roledata._status._money then
		resp.retcode = G_ERRCODE["EQUIPMENT_REFINE_MONEY_LESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	if refine_mode.refine_cost_gogok*arg.refinable_count > role._roledata._status._yuanbao then
		resp.retcode = G_ERRCODE["EQUIPMENT_REFINE_GOUYU_LESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
		
	for need_item in DataPool_Array(refine_mode.refinecostitem) do
		if need_item.itemid > 0 then
			if BACKPACK_HaveItem(role, need_item.itemid, need_item.item_num*arg.refinable_count) == false then
				resp.retcode = G_ERRCODE["EQUIPMENT_REFINE_ITEM_LESS"]
				player:SendToClient(SerializeCommand(resp))
				return
			end
		else
			break
		end
	end

	--扣除金钱，物品，元宝等
	if refine_mode.refine_cost_coin*arg.refinable_count > 0 then
		ROLE_SubMoney(role, refine_mode.refine_cost_coin*arg.refinable_count)
	end

	if refine_mode.refine_cost_gogok*arg.refinable_count > 0 then
		ROLE_SubYuanBao(role, refine_mode.refine_cost_gogok*arg.refinable_count)
	end
	
	for need_item in DataPool_Array(refine_mode.refinecostitem) do
		if need_item.itemid > 0 then
			API_Log("1111111111111111111111111111111111   itemid="..need_item.itemid)
			BACKPACK_DelItem(role, need_item.itemid, need_item.item_num*arg.refinable_count)
			if need_item.itemid == 20830 then
				find_equipment._equipment_pro._strengthen_cost = find_equipment._equipment_pro._strengthen_cost + 
				need_item.item_num*arg.refinable_count
			end
		else
			break
		end
	end
	--走到这里说明所有的条件都符合了，开始做变化
	--自身数据的随机
	local tmp_change = {}
	local all_typ = {}
	for garde_refine in DataPool_Array(refine_info.grade_refine) do
		if garde_refine.grade == find_equipment._equipment_pro._order then
			for refineprop in DataPool_Array(garde_refine.refineprop) do
				if refineprop.prop_type ~= 0 then
					local change_num = math.random(refineprop.once_min_point, refineprop.once_max_point)
					local tmp_change_info = {}
					tmp_change_info.typ = refineprop.prop_type
					tmp_change_info.num = change_num*arg.refinable_count
					tmp_change[#tmp_change+1] = tmp_change_info
					all_typ[#all_typ+1] = refineprop.prop_type
				else
					break
				end
			end
		end
	end
	--这次给加的点数的随机
	for i = 1, refine_mode.addpoint do
		local index_num = math.random(1, table.getn(all_typ))
		for j = 1, table.getn(tmp_change) do
			if tmp_change[j].typ == all_typ[index_num] then
				tmp_change[j].num = tmp_change[j].num + arg.refinable_count
				break
			end
		end
	end

	find_equipment._equipment_pro._tmp_refinable_pro = find_equipment._equipment_pro._refinable_pro
	--把这些点数加到装备的临时数据上面去
	for i = 1, table.getn(tmp_change) do
		local find_refine_data = find_equipment._equipment_pro._tmp_refinable_pro:Find(tmp_change[i].typ)
		if find_refine_data == nil then
			local tmp_refine_data = CACHE.EquipmentRefinableData()
			tmp_refine_data._typ = tmp_change[i].typ
			tmp_refine_data._num = tmp_change[i].num
			find_equipment._equipment_pro._tmp_refinable_pro:Insert(tmp_refine_data._typ, tmp_refine_data)
		else
			find_refine_data._num = find_refine_data._num + tmp_change[i].num
		end
	end

	--判断临时数据是否存在着不合法的数据，这里的不合法指的是小于0或者大于他可以达到的最大值
	for garde_refine in DataPool_Array(refine_info.grade_refine) do
		if garde_refine.grade == find_equipment._equipment_pro._order then
			for refineprop in DataPool_Array(garde_refine.refineprop) do
				local tmp_refine = find_equipment._equipment_pro._tmp_refinable_pro:Find(refineprop.prop_type)
				if tmp_refine ~= nil then
					--if tmp_refine._num > garde_refine.entire_max_point then
					--	tmp_refine._num = garde_refine.entire_max_point
					if tmp_refine._num > refineprop.entire_max_point then
						tmp_refine._num = refineprop.entire_max_point
					elseif tmp_refine._num < 0 then
						tmp_refine._num = 0
					end
				end
			end
		end
	end

	--在这里把临时的数据发送给客户端
	local find_refine_data_it = find_equipment._equipment_pro._tmp_refinable_pro:SeekToBegin()
	local find_refine_data = find_refine_data_it:GetValue()
	while find_refine_data ~= nil do
		local tmp_refine_data = {}
		tmp_refine_data.typ = find_refine_data._typ
		tmp_refine_data.data = find_refine_data._num
		resp.tmp_refinable_pro[#resp.tmp_refinable_pro+1] = tmp_refine_data
		find_refine_data_it:Next()
		find_refine_data = find_refine_data_it:GetValue()
	end
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
	BACKPACK_UpdateEquipment(role, arg.equipment_id)
	return
end
