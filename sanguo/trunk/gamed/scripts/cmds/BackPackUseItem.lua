function OnCommand_BackPackUseItem(player, role, arg, others)
	player:Log("OnCommand_BackPackUseItem, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("BackPackUseItem_Re")
	resp.item_id = arg.item_id
	resp.item_num = arg.item_num
	if arg.item_num <= 0 then
		resp.retcode = G_ERRCODE["USE_ITEM_NUM_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BackPackUseItem, error=USE_ITEM_NUM_ERR")
		return
	end
	--首先判断这个物品是否是可以使用的物品，类型24代表的是可以使用的物品
	local ed = DataPool_Find("elementdata")
	local item = ed:FindBy("item_id", arg.item_id)

	if item == nil then
		resp.retcode = G_ERRCODE["USE_ITEM_NOT_EXIST"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BackPackUseItem, error=USE_ITEM_NOT_EXIST")
		return
	end

	if item.item_type == 24 then
		--查看限次模板是否达到了每天的最大次数
		if LIMIT_TestUseLimit(role, item.type_data2, arg.item_num) == false then
			resp.retcode = G_ERRCODE["USE_ITEM_KEY_NUM_MAX"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_BackPackUseItem, error=USE_ITEM_CAN_NOT_USE")
			return
		end
		

		--查看物品的数量是否对，以及需要的钥匙是否足够
		if BACKPACK_HaveItem(role, arg.item_id, arg.item_num) == false then
			resp.retcode = G_ERRCODE["USE_ITEM_NUM_LESS"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_BackPackUseItem, error=USE_ITEM_NUM_LESS")
			return
		end

		if item.use_cost_item ~= 0 then
			if BACKPACK_HaveItem(role, item.use_cost_item, arg.item_num) == false then
				resp.retcode = G_ERRCODE["USE_ITEM_KEY_NUM_LESS"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_BackPackUseItem, error=USE_ITEM_KEY_NUM_LESS")
				return
			end
		end
		
		--数据统计日志
		local source_id = 0;
		if arg.item_id == G_BOX_TYP["SILVER_BOX"] then
			source_id = G_SOURCE_TYP["SILVER_BOX"]
		elseif arg.item_id == G_BOX_TYP["GOLDEN_BOX"] then
			source_id = G_SOURCE_TYP["GOLDEN_BOX"]
		elseif arg.item_id == G_BOX_TYP["PLATINUM_BOX"] then
			source_id = G_SOURCE_TYP["PLATINUM_BOX"]
		end

		--在这里需要扣除相应的箱子和钥匙。然后给东西
		BACKPACK_DelItem(role, arg.item_id, arg.item_num, source_id)
		if item.use_cost_item ~= 0 then
			BACKPACK_DelItem(role, item.use_cost_item, arg.item_num, source_id)
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
				local item = ed:FindBy("item_id", reward.item[index].itemid)
				if reward.item[index].itemid == 1955 or reward.item[index].itemid == 1956 then
					BACKPACK_AddItem(role, reward.item[index].itemid, reward.item[index].itemnum)
				elseif item.packlimit == 0 then
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
		LIMIT_AddUseLimit(role, item.type_data2, arg.item_num)
		player:SendToClient(SerializeCommand(resp))
	elseif item.item_type == 30 then
		local skin_info = role._roledata._backpack._skin_items:Find(item.type_data1)
		if skin_info ~= nil then
			--转换成元宝
			if skin_info._time == 0 then
				BACKPACK_AddItem(role, item.type_data3, item.type_data4, source_id)
				resp.items = {}
				local tmp_item = {}
				tmp_item.tid = item.type_data3
				tmp_item.count = item.type_data4
				resp.items[#resp.items+1] = tmp_item
				resp.retcode = G_ERRCODE["SUCCESS"]
				player:SendToClient(SerializeCommand(resp))
				return
			else
				resp.retcode = G_ERRCODE["SKIN_BUY_USING"]
				player:SendToClient(SerializeCommand(resp))
				return
			end
		else
			local ed = DataPool_Find("elementdata")
			local dress_info = ed:FindBy("dress_id", item.type_data1)
			local hero_info = role._roledata._hero_hall._heros:Find(dress_info.owner_id)
			if hero_info == nil then
				resp.retcode = G_ERRCODE["SKIN_BUY_NO_HERO"]
				player:SendToClient(SerializeCommand(resp))
				return
			end
			local insert_info = CACHE.SkinInfo()
			insert_info._id = item.type_data1
			insert_info._time = API_GetTime()+item.type_data2*3600
			role._roledata._backpack._skin_items:Insert(item.type_data1, insert_info)
			hero_info._skin = item.type_data1
			resp.retcode = G_ERRCODE["SUCCESS"]
			player:SendToClient(SerializeCommand(resp))
		
			local cmd = NewCommand("SkinUpdateInfo")
			cmd.addflag = 1
			cmd.skinid = item.type_data1
			cmd.time = insert_info._time
			cmd.item = {}
			player:SendToClient(SerializeCommand(cmd))
		end

	else
		resp.retcode = G_ERRCODE["USE_ITEM_CAN_NOT_USE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_BackPackUseItem, error=USE_ITEM_CAN_NOT_USE")
		return
	end

end
