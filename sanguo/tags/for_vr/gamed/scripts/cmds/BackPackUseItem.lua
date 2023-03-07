function OnCommand_BackPackUseItem(player, role, arg, others)
	player:Log("OnCommand_BackPackUseItem, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("BackPackUseItem_Re")
	resp.item_id = arg.item_id
	resp.item_num = arg.item_num
	if arg.item_num <= 0 then
		resp.retcode = G_ERRCODE["USE_ITEM_NUM_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	--首先判断这个物品是否是可以使用的物品，类型24代表的是可以使用的物品
	local ed = DataPool_Find("elementdata")
	local item = ed:FindBy("item_id", arg.item_id)

	if item == nil then
		resp.retcode = G_ERRCODE["USE_ITEM_NOT_EXIST"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if item.item_type ~= 24 then
		resp.retcode = G_ERRCODE["USE_ITEM_CAN_NOT_USE"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--查看物品的数量是否对，以及需要的钥匙是否足够
	if BACKPACK_HaveItem(role, arg.item_id, arg.item_num) == false then
		resp.retcode = G_ERRCODE["USE_ITEM_NUM_LESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if item.use_cost_item ~= 0 then
		if BACKPACK_HaveItem(role, item.use_cost_item, arg.item_num) == false then
			resp.retcode = G_ERRCODE["USE_ITEM_KEY_NUM_LESS"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
	end

	--在这里需要扣除相应的箱子和钥匙。然后给东西
	BACKPACK_DelItem(role, arg.item_id, arg.item_num)
	if item.use_cost_item ~= 0 then
		BACKPACK_DelItem(role, item.use_cost_item, arg.item_num)
	end

	resp.retcode = G_ERRCODE["SUCCESS"]
	local level_reward = ed:FindBy("level_reward", role._roledata._status._level)
	local reward_id = 0
	local drop_item_id = 0
	for huodong_reward in DataPool_Array(level_reward.huodong_reward) do
		if huodong_reward.huodong_type == item.type_data1 then
			reward_id = huodong_reward.huodong_rewardid
			drop_item_id = huodong_reward.huodong_dropid
			break
		end
	end

	role._roledata._temporary_backpack._id = role._roledata._temporary_backpack._id + 1
	local insert_data =  CACHE.TemporaryBackPackData()
	insert_data._id = role._roledata._temporary_backpack._id
	insert_data._typ = 1	--类型为1代表的是背包开箱子给的东西
	resp.items = {}
	for i = 1, arg.item_num do
		local drop_item = DROPITEM_DropItem(role, drop_item_id)
		local reward = DROPITEM_Reward(role, reward_id)

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
			--local flag, all_items = BACKPACK_AddItem(role, drop_item[index].id, drop_item[index].count)
		
			--for i = 1, table.getn(all_items) do
			--	local tmp_item = {}
			--	tmp_item.tid = all_items[i].tid
			--	tmp_item.count = all_items[i].count
			--	resp.items[#resp.items+1] = tmp_item
			--end
		end

		for index = 1,table.getn(reward.item) do
			local item = ed:FindBy("item_id", reward.item[index].id)
			if item.packlimit == 0 then
				for index = 1,reward.item[index].count do
					local tmp = CACHE.Item()
					tmp._tid = reward.item[index].id
					tmp._count = 1
					insert_data._iteminfo:PushBack(tmp)
				end
			else
				local insert_flag = true
				local iteminfo_it = insert_data._iteminfo:SeekToBegin()
				local iteminfo = iteminfo_it:GetValue()
				while iteminfo ~= nil do
					if iteminfo._tid == reward.item[index].id then
						iteminfo._count = iteminfo._count + reward.item[index].count
						insert_flag = false
						break
					end
					iteminfo_it:Next()
					iteminfo = iteminfo_it:GetValue()
				end
				if insert_flag == true then
					local tmp = CACHE.Item()
					tmp._tid = reward.item[index].id
					tmp._count = reward.item[index].count
					insert_data._iteminfo:PushBack(tmp)
				end
			end
			--local flag, all_items = BACKPACK_AddItem(role, reward.item[index].id, reward.item[index].count)
			--
			--for i = 1, table.getn(all_items) do
			--	local tmp_item = {}
			--	tmp_item.tid = all_items[i].tid
			--	tmp_item.count = all_items[i].count
			--	resp.items[#resp.items+1] = tmp_item
			--end
		end
	end
	
	role._roledata._temporary_backpack._data:Insert(insert_data._id, insert_data)
	player:SendToClient(SerializeCommand(resp))
	--告诉客户端，临时背包里面添加了新的东西
	resp = NewCommand("TemporaryBackPackUpdate")
	resp.item = {}
	resp.item.id = insert_data._id
	resp.item.typ = insert_data._typ
	resp.item.items = {}

	local iteminfo_it = insert_data._iteminfo:SeekToBegin()
	local iteminfo = iteminfo_it:GetValue()
	while iteminfo ~= nil do
		local tmp_item = {}
		tmp_item.tid = iteminfo._tid
		tmp_item.count = iteminfo._count
		resp.item.items[#resp.item.items+1] = tmp_item

		iteminfo_it:Next()
		iteminfo = iteminfo_it:GetValue()
	end
	player:SendToClient(SerializeCommand(resp))
end
