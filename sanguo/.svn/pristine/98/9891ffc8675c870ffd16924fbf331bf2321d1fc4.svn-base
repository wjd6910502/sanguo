--这个接口需要根据返回值进行判断，才可以进行下一步的操作，使用的时候一定要注意
function BACKPACK_AddItem(role, tid, count)
	--typ 1是物品，2是装备，3是武器，4是武将
	local add_item = {}
	local flag = BACKPACK_ActualAddItem(role, tid, count, 1, add_item)
	return flag, add_item
end

function BACKPACK_ActualAddItem(role, tid, count, layer, add_item)
	if layer >= 3 then
		API_Log("BACKPACK_ActualAddItem      layer too large")
		return false
	end

	if count<=0 or tid<=0 then
		return false
	end

	local ed = DataPool_Find("elementdata")
	local item = ed:FindBy("item_id", tid)
	if item == nil then
		return false
	end
	--判断一下，这个物品进背包的时候是否需要做相应的转化,类型是20的需要进行转化,在程序里面进行写死
	if item.item_type == 20 then
		local currency = ed:FindBy("currency_id", item.type_data1)
		if currency.currency_type == 1 then
			--金币
			ROLE_AddMoney(role, item.type_data2*count)
		elseif currency.currency_type == 2 then
			--元宝，勾玉
			ROLE_AddYuanBao(role, item.type_data2*count)
		elseif currency.currency_type == 3 then
			--体力
			ROLE_Addvp(role, item.type_data2*count, 1)
		elseif currency.currency_type == 4 then
			--声望
			ROLE_AddRep(role, currency.rep_id, item.type_data2*count)
		elseif currency.currency_type == 5 then
			--活跃
			TASK_ChangeCondition(role, G_ACH_TYPE["HUODONG_HUOYUE"], 0, item.type_data2*count)
		end
		return true
	elseif item.item_type == 21 then
		--转化成武将
		for i = 1, count do
			HERO_AddHero(role, item.type_data1, 1)
			
			local tmp_item = {}
			tmp_item.tid = tid
			tmp_item.count = 1
			tmp_item.typ = 4
			add_item[#add_item+1] = tmp_item
		end
		return true
	elseif item.item_type == 7 then
		--武器物品转化成武器
		for i = 1, count do
			BACKPACK_AddWeapon(role, tid, item.type_data1)
			
			local tmp_item = {}
			tmp_item.tid = tid
			tmp_item.count = 1
			tmp_item.typ = 3
			add_item[#add_item+1] = tmp_item
		end
		return true
	elseif item.item_type == 22 then
		--开箱子得到物品
		for z = 1, count do
			for i = 1, item.type_data2 do
				local Item = DROPITEM_DropItem(role, item.type_data1)
				for j = 1, table.getn(Item) do
					BACKPACK_ActualAddItem(role, Item[j].id, Item[j].count, layer+1, add_item)
				end
			end
		end
		return true
	elseif item.item_type == 23 then
		--装备物品转化成装备
		for i = 1, count do
			BACKPACK_AddEquipment(role, tid, item.type_data1)
			local tmp_item = {}
			tmp_item.tid = tid
			tmp_item.count = 1
			tmp_item.typ = 2
			add_item[#add_item+1] = tmp_item
		end
		return true
	elseif item.item_type == 27 then
		--头像物品转换为头像
		ROLE_AddPhoto(role,item.type_data1,item.type_data2)
		return true
	elseif item.item_type == 25 then
		--头像框物品转换为头像框
		ROLE_AddPhotoFrame(role,item.type_data1)
		return true
	elseif item.item_type == 26 then
		--徽章物品转换为徽章
		ROLE_UpdateBadge(role,item.type_data2,item.type_data1,1)
		return true
	end

	local flag = false
	local backpack = role._roledata._backpack._items
	local iit = backpack:SeekToBegin()
	local i = iit:GetValue()
	while i~= nil do
		if i._tid == tid then
			if item.packlimit == 0 then
				for index = 1, count do
					local tmp = CACHE.Item()
					tmp._tid = tid
					tmp._count = 1
					backpack:PushBack(tmp)
				end
			else
				i._count = i._count + count
			end
			flag = true
			break
		end
		iit:Next();
		i = iit:GetValue()
	end

	if flag == false then
		if item.packlimit == 0 then
			for index = 1, count do
				local tmp = CACHE.Item()
				tmp._tid = tid
				tmp._count = 1
				backpack:PushBack(tmp)
			end
		else
			local tmp = CACHE.Item()
			tmp._tid = tid
			tmp._count = count
			backpack:PushBack(tmp)
		end
	end
	BACKPACK_SendBackPackOneItem(role, tid)
	--把物品加到列表里面去
	local tmp_item = {}
	tmp_item.tid = tid
	tmp_item.count = count
	tmp_item.typ = 1
	add_item[#add_item+1] = tmp_item
	return true
end

--这个接口需要根据返回值进行判断，才可以进行下一步的操作，使用的时候一定要注意
function BACKPACK_DelItem(role, tid, count)
	if count<=0 or tid<=0 then
		return false
	end
	
	if BACKPACK_HaveItem(role, tid, count) == false then
		return false
	end

	local ed = DataPool_Find("elementdata")
	local item = ed:FindBy("item_id", tid)
	if item == nil then
		return false
	end

	local backpack = role._roledata._backpack._items
	local iit = backpack:SeekToBegin()
	local i = iit:GetValue()
	while i ~= nil do
		if i._tid == tid then
			if i._count >= count then
				i._count = i._count - count
			else
				count = count - i._count
				i._count = 0
			end
		end
		iit:Next()
		i = iit:GetValue()
	end
	BACKPACK_SendBackPackOneItem(role, tid)
	--更新一下，主要是把数量是0的数据删除掉
	local break_flag = true
	while break_flag do
		break_flag = false
		local iit = backpack:SeekToBegin()
		local i = iit:GetValue()
		while i ~= nil do
			if i._count == 0 then
				iit:Pop()
				break_flag = true
				break
			end
			iit:Next()
			i = iit:GetValue()
		end
	end
	return true
end

--查看玩家的背包里面某一个道具的数量是否达到一个值
function BACKPACK_HaveItem(role, tid, count)
	if count<=0 or tid<=0 then
		return false
	end
	local items = role._roledata._backpack._items

	local all_count = 0
	local iit = items:SeekToBegin() --从头开始遍历
	local i = iit:GetValue()
	while i~=nil do
		if i._tid == tid then
			all_count = all_count + i._count
		end
		iit:Next()
		i = iit:GetValue()
	end
	if all_count >= count then
		return true
	else
		return false
	end
end

--告诉客户端，我的背包信息
function BACKPACK_SendBackPack(role)
	local resp = NewCommand("GetBackPack_Re")
	resp.info = {}
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
	resp.retcode = G_ERRCODE["SUCCESS"]
	role:SendToClient(SerializeCommand(resp))
end

--告诉客户端，我的某一个物品的当前数量
function BACKPACK_SendBackPackOneItem(role,itemid)
	local resp = NewCommand("ItemCountChange")
	resp.itemid = itemid
	resp.count = 0
	local items = role._roledata._backpack._items
	
	local iit = items:SeekToBegin() --从头开始遍历
	local i = iit:GetValue()
	while i~=nil do
		if i._tid == itemid then
			resp.count = i._count
			break
		end
		iit:Next()
		i = iit:GetValue()
	end
	role:SendToClient(SerializeCommand(resp))
end

--分别是物品的ID，以及生成属性的模板ID
function BACKPACK_AddWeapon(role, item_id, tid)
	local ed = DataPool_Find("elementdata")
	local weapon_info = ed:FindBy("weapon_id", tid)

	local insert_weapon = CACHE.WeaponItem()

	role._roledata._backpack._weapon_items._id = role._roledata._backpack._weapon_items._id + 1

	insert_weapon._base_item._tid = item_id
	insert_weapon._base_item._count = 1

	insert_weapon._weapon_pro._tid = role._roledata._backpack._weapon_items._id
	insert_weapon._weapon_pro._level = weapon_info.wearlv
	insert_weapon._weapon_pro._star = weapon_info.star
	insert_weapon._weapon_pro._quality = weapon_info.grade
	insert_weapon._weapon_pro._prop = weapon_info.weapontype
	insert_weapon._weapon_pro._attack = weapon_info.atk
	insert_weapon._weapon_pro._weapon_skill = weapon_info.weaponskill

	local max_skill_num = weapon_info.specialpropnummax
	local min_skill_num = weapon_info.specialpropnummin

	--下面这点代码纯属为了防止策划写错表，所以这里限制一下最大个数
	local num = 0
	for tmp_skill in DataPool_Array(weapon_info.specialprop) do
		if tmp_skill == 0 then
			break
		end
		num = num + 1
	end

	if max_skill_num > num then
		max_skill_num = num
	end

	if min_skill_num > max_skill_num then
		min_skill_num = max_skill_num
	end

	local need_num = math.random(min_skill_num, max_skill_num)
	while insert_weapon._weapon_pro._skill_pro:Size() < need_num do
		local tmp_num = math.random(num)
		local insert_skill_id = weapon_info.specialprop[tmp_num]
		if insert_weapon._weapon_pro._skill_pro:Find(insert_skill_id) == nil then
			local insert_skill = CACHE.WeaponSkill()
			insert_skill._skill_id = insert_skill_id
			insert_skill._skill_level = math.random(weapon_info.specialproplvmin, weapon_info.specialproplvmax)
			insert_weapon._weapon_pro._skill_pro:Insert(insert_skill_id, insert_skill)
		end
	end

	insert_weapon._weapon_pro._tid = role._roledata._backpack._weapon_items._id
	insert_weapon._weapon_pro._level = weapon_info.wearlv
	insert_weapon._weapon_pro._star = weapon_info.star
	insert_weapon._weapon_pro._quality = weapon_info.grade
	insert_weapon._weapon_pro._prop = weapon_info.weapontype
	insert_weapon._weapon_pro._attack = weapon_info.atk
	insert_weapon._weapon_pro._weapon_skill = weapon_info.weaponskill
	insert_weapon._weapon_pro._level_up = 1
	
	role._roledata._backpack._weapon_items._weapon_items:PushBack(insert_weapon)
	
	--告诉客户端获得了一个新的武器
	local resp = NewCommand("WeaponAdd")
	resp.weapon_info = {}
	resp.weapon_info.base_item = {}
	resp.weapon_info.base_item.tid = item_id
	resp.weapon_info.base_item.count = 1
	resp.weapon_info.weapon_info = {}
	resp.weapon_info.weapon_info.tid = insert_weapon._weapon_pro._tid
	resp.weapon_info.weapon_info.level = insert_weapon._weapon_pro._level
	resp.weapon_info.weapon_info.star = insert_weapon._weapon_pro._star
	resp.weapon_info.weapon_info.quality = insert_weapon._weapon_pro._quality
	resp.weapon_info.weapon_info.prop = insert_weapon._weapon_pro._prop
	resp.weapon_info.weapon_info.attack = insert_weapon._weapon_pro._attack
	resp.weapon_info.weapon_info.strength = 0
	resp.weapon_info.weapon_info.level_up = 1
	resp.weapon_info.weapon_info.weapon_skill = insert_weapon._weapon_pro._weapon_skill
	resp.weapon_info.weapon_info.strength_prob = 0
	resp.weapon_info.weapon_info.skill_pro = {}
	local tmp_skill_it = insert_weapon._weapon_pro._skill_pro:SeekToBegin()
	local tmp_skill = tmp_skill_it:GetValue()
	while tmp_skill ~= nil do
		local xxxx = {}
		xxxx.skill_id = tmp_skill._skill_id
		xxxx.skill_level = tmp_skill._skill_level
		resp.weapon_info.weapon_info.skill_pro[#resp.weapon_info.weapon_info.skill_pro+1] = xxxx
		tmp_skill_it:Next()
		tmp_skill = tmp_skill_it:GetValue()
	end
	
	role:SendToClient(SerializeCommand(resp))
end

function BACKPACK_UpdateWeaponItem(role, weapon_id)
	local weapon_items = role._roledata._backpack._weapon_items

	local weapon_item_it = weapon_items._weapon_items:SeekToBegin()
	local weapon_item = weapon_item_it:GetValue()
	while weapon_item ~= nil do
		if weapon_item._weapon_pro._tid == weapon_id then
			--告诉客户端获得了一个新的武器
			local resp = NewCommand("WeaponUpdate")
			resp.weapon_info = {}
			resp.weapon_info.base_item = {}
			resp.weapon_info.base_item.tid = weapon_item._base_item._tid
			resp.weapon_info.base_item.count = 1
			resp.weapon_info.weapon_info = {}
			resp.weapon_info.weapon_info.tid = weapon_item._weapon_pro._tid
			resp.weapon_info.weapon_info.level = weapon_item._weapon_pro._level
			resp.weapon_info.weapon_info.star = weapon_item._weapon_pro._star
			resp.weapon_info.weapon_info.quality = weapon_item._weapon_pro._quality
			resp.weapon_info.weapon_info.prop = weapon_item._weapon_pro._prop
			resp.weapon_info.weapon_info.attack = weapon_item._weapon_pro._attack
			resp.weapon_info.weapon_info.strength = weapon_item._weapon_pro._strengthen
			resp.weapon_info.weapon_info.level_up = weapon_item._weapon_pro._level_up
			resp.weapon_info.weapon_info.weapon_skill = weapon_item._weapon_pro._weapon_skill
			resp.weapon_info.weapon_info.strength_prob = weapon_item._weapon_pro._strengthen_prob
			resp.weapon_info.weapon_info.skill_pro = {}
			local tmp_skill_it = weapon_item._weapon_pro._skill_pro:SeekToBegin()
			local tmp_skill = tmp_skill_it:GetValue()
			while tmp_skill ~= nil do
				local xxxx = {}
				xxxx.skill_id = tmp_skill._skill_id
				xxxx.skill_level = tmp_skill._skill_level
				resp.weapon_info.weapon_info.skill_pro[#resp.weapon_info.weapon_info.skill_pro+1] = xxxx
				tmp_skill_it:Next()
				tmp_skill = tmp_skill_it:GetValue()
			end
			
			role:SendToClient(SerializeCommand(resp))
			return
		end
		weapon_item_it:Next()
		weapon_item = weapon_item_it:GetValue()
	end
end

--得到一个新的装备
function BACKPACK_AddEquipment(role, item_id, equipment_id)
	local ed = DataPool_Find("elementdata")
	local equip_info = ed:FindBy("equip_id", equipment_id)

	local insert_equip = CACHE.EquipmentItem()
	
	insert_equip._base_item._tid = item_id
	insert_equip._base_item._count = 1

	role._roledata._backpack._equipment_items._id = role._roledata._backpack._equipment_items._id + 1

	insert_equip._equipment_pro._tid = role._roledata._backpack._equipment_items._id
	insert_equip._equipment_pro._level_up = 1

	role._roledata._backpack._equipment_items._equipment_items:Insert(insert_equip._equipment_pro._tid, insert_equip)

	--通知客户端得到了一个新的装备
	local resp = NewCommand("EquipmentAdd")
	resp.equipment_info = {}
	resp.equipment_info.base_item = {}
	resp.equipment_info.equipment_info = {}

	resp.equipment_info.base_item.tid = insert_equip._base_item._tid
	resp.equipment_info.base_item.count = 1

	resp.equipment_info.equipment_info.tid = insert_equip._equipment_pro._tid
	resp.equipment_info.equipment_info.hero_id = 0
	resp.equipment_info.equipment_info.level = 1
	resp.equipment_info.equipment_info.order = 0
	resp.equipment_info.equipment_info.refinable_pro = {}
	resp.equipment_info.equipment_info.tmp_refinable_pro = {}
			
	role:SendToClient(SerializeCommand(resp))

end

--更新一个装备的属性
function BACKPACK_UpdateEquipment(role, equipment_id)
	
	local find_equipment = role._roledata._backpack._equipment_items._equipment_items:Find(equipment_id)
	if find_equipment ~= nil then
		--更新客户端的一个装备信息
		local resp = NewCommand("EquipmentUpdate")
		resp.equipment_info = {}
		resp.equipment_info.base_item = {}
		resp.equipment_info.equipment_info = {}

		resp.equipment_info.base_item.tid = find_equipment._base_item._tid
		resp.equipment_info.base_item.count = 1

		resp.equipment_info.equipment_info.tid = find_equipment._equipment_pro._tid
		resp.equipment_info.equipment_info.hero_id = find_equipment._equipment_pro._hero_id
		resp.equipment_info.equipment_info.level = find_equipment._equipment_pro._level_up
		resp.equipment_info.equipment_info.order = find_equipment._equipment_pro._order
		resp.equipment_info.equipment_info.refinable_pro = {}
		resp.equipment_info.equipment_info.tmp_refinable_pro = {}

		local refinable_it = find_equipment._equipment_pro._refinable_pro:SeekToBegin()
		local refinable = refinable_it:GetValue()
		while refinable ~= nil do
			local tmp_refinable = {}
			tmp_refinable.typ = refinable._typ
			tmp_refinable.data = refinable._num
			resp.equipment_info.equipment_info.refinable_pro[#resp.equipment_info.equipment_info.refinable_pro+1] = tmp_refinable

			refinable_it:Next()
			refinable = refinable_it:GetValue()
		end
		
		local refinable_it = find_equipment._equipment_pro._tmp_refinable_pro:SeekToBegin()
		local refinable = refinable_it:GetValue()
		while refinable ~= nil do
			local tmp_refinable = {}
			tmp_refinable.typ = refinable._typ
			tmp_refinable.data = refinable._num
			resp.equipment_info.equipment_info.tmp_refinable_pro[#resp.equipment_info.equipment_info.tmp_refinable_pro+1] = tmp_refinable

			refinable_it:Next()
			refinable = refinable_it:GetValue()
		end
				
		role:SendToClient(SerializeCommand(resp))
	end
end

--删除一个装备
function BACKPACK_DelEquipment(role, equipment_id)
	role._roledata._backpack._equipment_items._equipment_items:Delete(equipment_id)

	--通知客户端得到了一个新的装备
	local resp = NewCommand("EquipmentDel")
	resp.id = equipment_id
	role:SendToClient(SerializeCommand(resp))
end

--往临时背包中添加物品
function BACKPACK_TemporaryAddItem(role, drop_id, reward_id, typ)
	role._roledata._temporary_backpack._id = role._roledata._temporary_backpack._id + 1
	local insert_data = CACHE.TemporaryBackPackData()
	insert_data._id = role._roledata._temporary_backpack._id
	insert_data._typ = typ
	
	if drop_id ~= 0 then
		local drop_item = DROPITEM_DropItem(role, drop_id)

		for index = 1,table.getn(drop_item) do
			local item = ed:FindBy("item_id", drop_item[index].id)
			if item.packlimit == 0 then
				for index = 1,drop_item[index].count do
					local tmp = CACHE.Item()
					tmp._tid = drop_item[index].id
					tmp._count = 1
					insert_data._iteminfo:PushBack(tmp)
				end
			else
				local insert_flag = true
				local iteminfo_it = insert_data._iteminfo:SeekToBegin()
				local iteminfo = iteminfo_it:GetValue()
				while iteminfo ~= nil do
					if iteminfo._tid == drop_item[index].id then
						iteminfo._count = iteminfo._count + drop_item[index].count
						insert_flag = false
						break
					end
					iteminfo_it:Next()
					iteminfo = iteminfo_it:GetValue()
				end
				if insert_flag == true then
					local tmp = CACHE.Item()
					tmp._tid = drop_item[index].id
					tmp._count = drop_item[index].count
					insert_data._iteminfo:PushBack(tmp)
				end
			end
		end
	end

	if reward_id ~= 0 then
		local reward = DROPITEM_Reward(role, reward_id)
		for index = 1,table.getn(reward.item) do
			local item = ed:FindBy("item_id", reward.item[index].itemid)
			if item.packlimit == 0 then
				for index = 1,reward.item[index].itemnum do
					local tmp = CACHE.Item()
					tmp._tid = reward.item[index].itemid
					tmp._count = 1
					insert_data._iteminfo:PushBack(tmp)
				end
			else
				local insert_flag = true
				local iteminfo_it = insert_data._iteminfo:SeekToBegin()
				local iteminfo = iteminfo_it:GetValue()
				while iteminfo ~= nil do
					if iteminfo._tid == reward.item[index].itemid then
						iteminfo._count = iteminfo._count + reward.item[index].itemnum
						insert_flag = false
						break
					end
					iteminfo_it:Next()
					iteminfo = iteminfo_it:GetValue()
				end
				if insert_flag == true then
					local tmp = CACHE.Item()
					tmp._tid = reward.item[index].itemid
					tmp._count = reward.item[index].itemnum
					insert_data._iteminfo:PushBack(tmp)
				end
			end
		end
	end
	role._roledata._temporary_backpack._data:Insert(insert_data._id, insert_data)
	return insert_data
end
