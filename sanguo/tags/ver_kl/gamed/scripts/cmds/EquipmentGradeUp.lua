function OnCommand_EquipmentGradeUp(player, role, arg, others)
	player:Log("OnCommand_EquipmentGradeUp, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("EquipmentGradeUp_Re")
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

	--查看这件装备是否可以升阶
	local item = ed:FindBy("item_id", find_equipment._base_item._tid)
	local equipment_info = ed:FindBy("equip_id", item.type_data1)

	if equipment_info.equip_grade_id == 0 then
		resp.retcode = G_ERRCODE["EQUIPMENT_NOT_GRADE"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local equipment_grade_info = ed:FindBy("equip_grade", equipment_info.equip_grade_id)
	
	--判断是否达到了最高阶别
	if find_equipment._equipment_pro._order >= equipment_grade_info.max_grade then
		API_Log("111111111111111111    _order="..find_equipment._equipment_pro._order.."  max="..equipment_grade_info.max_grade)
		resp.retcode = G_ERRCODE["EQUIPMENT_GRADE_MAX"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--查看升级所需要的物品是否足够了
	for grade_info in DataPool_Array(equipment_grade_info.grade_data) do
		API_Log("11111111111111111111111111111111111111111111111111111     grade_info.grade="..grade_info.grade)
		if grade_info.grade == find_equipment._equipment_pro._order then
			--查看需要的装备数量是否足够
			local need_count = 0
			local equipment_template_it = role._roledata._backpack._equipment_items._equipment_items:SeekToBegin()
			local equipment_template = equipment_template_it:GetValue()
			while equipment_template ~= nil do
				if equipment_template._base_item._tid == find_equipment._base_item._tid and 
					equipment_template._equipment_pro._tid ~= arg.equipment_id and
					equipment_template._equipment_pro._wear_flag == 0 and
					equipment_template._equipment_pro._level_up == 1 and 
					equipment_template._equipment_pro._order == 0 and
					equipment_template._equipment_pro._refinable_pro:Size() == 0 and
					equipment_template._equipment_pro._tmp_refinable_pro:Size() == 0 then

					need_count = need_count + 1
				end
				equipment_template_it:Next()
				equipment_template = equipment_template_it:GetValue()
			end
			if grade_info.cost_equip > need_count then
				resp.retcode = G_ERRCODE["EQUIPMENT_GRADE_EQUIP_LESS"]
				player:SendToClient(SerializeCommand(resp))
				return
			end
			
			for need_item in DataPool_Array(grade_info.upgrade_cost) do
				if need_item.itemid ~= 0 then
					if BACKPACK_HaveItem(role, need_item.itemid, need_item.item_num) == false then
						resp.retcode = G_ERRCODE["EQUIPMENT_GRADE_ITEM_LESS"]
						player:SendToClient(SerializeCommand(resp))
						return
					end
				else
					break
				end
			end
			break
		end
	end

	--开始扣除物品
	for grade_info in DataPool_Array(equipment_grade_info.grade_data) do
		if grade_info.grade == find_equipment._equipment_pro._order then
			--查看需要的装备数量是否足够
			local need_count = grade_info.cost_equip
			local equipment_template_it = role._roledata._backpack._equipment_items._equipment_items:SeekToBegin()
			local equipment_template = equipment_template_it:GetValue()
			while equipment_template ~= nil and need_count > 0 do
				if equipment_template._base_item._tid == find_equipment._base_item._tid and 
					equipment_template._equipment_pro._tid ~= arg.equipment_id and 
					equipment_template._equipment_pro._wear_flag == 0 and
					equipment_template._equipment_pro._level_up == 1 and 
					equipment_template._equipment_pro._order == 0 and
					equipment_template._equipment_pro._refinable_pro:Size() == 0 and
					equipment_template._equipment_pro._tmp_refinable_pro:Size() == 0 then

					need_count = need_count - 1
					BACKPACK_DelEquipment(role, equipment_template._equipment_pro._tid)
				end
				equipment_template_it:Next()
				equipment_template = equipment_template_it:GetValue()
			end
			
			for need_item in DataPool_Array(grade_info.upgrade_cost) do
				if need_item.itemid ~= 0 then
					BACKPACK_DelItem(role, need_item.itemid, need_item.item_num)
				else
					break
				end
			end
			break
		end
	end
	--修改数据
	find_equipment._equipment_pro._order = find_equipment._equipment_pro._order + 1
	
	--进行同步
	ROLE_UpdateMiscPveArenaHeroInfo(role, arg.hero)
	BACKPACK_UpdateEquipment(role, arg.equipment_id)
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
	return
end
