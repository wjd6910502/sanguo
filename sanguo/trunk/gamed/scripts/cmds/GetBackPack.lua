function OnCommand_GetBackPack(player, role, arg, others)
	player:Log("OnCommand_GetBackPack, "..DumpTable(arg))
	
	local resp = NewCommand("GetBackPack_Re")
	resp.info = {}
	resp.weaponitems = {}
	resp.equipmentitems = {}
	resp.skinitems = {}
	local backpack = role._roledata._backpack._items
	local iit = backpack:SeekToBegin()
	local i = iit:GetValue()
	while i ~= nil do
		local item = {}
		item.tid = i._tid
		item.count = i._count
		resp.info[#resp.info+1] = item
		iit:Next()
		i = iit:GetValue()
	end
	
	local weaponitems = role._roledata._backpack._weapon_items._weapon_items
	local iit = weaponitems:SeekToBegin() --从头开始遍历
	local i = iit:GetValue()
	while i~=nil do
		local i2 = {}
		i2.base_item = {}
		i2.weapon_info = {}
		i2.base_item.tid = i._base_item._tid
		i2.base_item.count = i._base_item._count

		i2.weapon_info.tid = i._weapon_pro._tid
		i2.weapon_info.level = i._weapon_pro._level
		i2.weapon_info.star = i._weapon_pro._star
		i2.weapon_info.quality = i._weapon_pro._quality
		i2.weapon_info.prop = i._weapon_pro._prop
		i2.weapon_info.attack = i._weapon_pro._attack
		i2.weapon_info.weapon_skill = i._weapon_pro._weapon_skill
		i2.weapon_info.strength = i._weapon_pro._strengthen
		i2.weapon_info.level_up = i._weapon_pro._level_up
		i2.weapon_info.strength_prob = i._weapon_pro._strengthen_prob
		i2.weapon_info.skill_pro = {}
		local skill_pro_it = i._weapon_pro._skill_pro:SeekToBegin()
		local skill_pro = skill_pro_it:GetValue()
		while skill_pro ~= nil do
			local tmp_skill_pro = {}
			tmp_skill_pro.skill_id = skill_pro._skill_id
			tmp_skill_pro.skill_level = skill_pro._skill_level
			i2.weapon_info.skill_pro[#i2.weapon_info.skill_pro+1] = tmp_skill_pro
			skill_pro_it:Next()
			skill_pro = skill_pro_it:GetValue()
		end
		i2.weapon_info.exp = i._weapon_pro._exp
		resp.weaponitems[#resp.weaponitems+1] = i2
		iit:Next()
		i = iit:GetValue()
	end
	
	local equipmentitems = role._roledata._backpack._equipment_items._equipment_items
	local equipment_it = equipmentitems:SeekToBegin()
	local equipment = equipment_it:GetValue()
	while equipment ~= nil do
		local tmp_equipment = {}
		tmp_equipment.base_item = {}
		tmp_equipment.equipment_info = {}
		tmp_equipment.equipment_info.refinable_pro = {}
		tmp_equipment.equipment_info.tmp_refinable_pro = {}

		tmp_equipment.base_item.tid = equipment._base_item._tid
		tmp_equipment.base_item.count = 1

		tmp_equipment.equipment_info.tid = equipment._equipment_pro._tid
		tmp_equipment.equipment_info.hero_id = equipment._equipment_pro._hero_id
		tmp_equipment.equipment_info.level = equipment._equipment_pro._level_up
		tmp_equipment.equipment_info.order = equipment._equipment_pro._order
		tmp_equipment.equipment_info.level_up_money = equipment._equipment_pro._level_up_money

		local refinable_it = equipment._equipment_pro._refinable_pro:SeekToBegin()
		local refinable = refinable_it:GetValue()
		while refinable ~= nil do
			local tmp_refinable = {}
			tmp_refinable.typ = refinable._typ
			tmp_refinable.data = refinable._num
			tmp_equipment.equipment_info.refinable_pro[#tmp_equipment.equipment_info.refinable_pro+1] = tmp_refinable

			refinable_it:Next()
			refinable = refinable_it:GetValue()
		end
		
		local refinable_it = equipment._equipment_pro._tmp_refinable_pro:SeekToBegin()
		local refinable = refinable_it:GetValue()
		while refinable ~= nil do
			local tmp_refinable = {}
			tmp_refinable.typ = refinable._typ
			tmp_refinable.data = refinable._num
			tmp_equipment.equipment_info.tmp_refinable_pro[#tmp_equipment.equipment_info.tmp_refinable_pro+1] = tmp_refinable

			refinable_it:Next()
			refinable = refinable_it:GetValue()
		end
		
		resp.equipmentitems[#resp.equipmentitems+1] = tmp_equipment
		equipment_it:Next()
		equipment = equipment_it:GetValue()
	end
	resp.skinitems = {}
	local backpack = role._roledata._backpack._skin_items
	local iit = backpack:SeekToBegin()
	local i = iit:GetValue()
	while i ~= nil do
		local item = {}
		item.id = i._id
		item.time = i._time
		resp.skinitems[#resp.skinitems+1] = item
		iit:Next()
		i = iit:GetValue()
	end
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
end
