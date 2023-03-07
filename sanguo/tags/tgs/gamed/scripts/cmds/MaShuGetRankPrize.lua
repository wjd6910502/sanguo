function OnCommand_MaShuGetRankPrize(player, role, arg, others)
	player:Log("OnCommand_MaShuGetRankPrize, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("MaShuGetRankPrize_Re")
	local now = API_GetTime()
	if now > role._roledata._mashu_info._timestamp then
		role._roledata._mashu_info._yestaday_rank = 0
	end

	resp.yestaday_rank = role._roledata._mashu_info._yestaday_rank
	if role._roledata._mashu_info._yestaday_rank == 0 then
		resp.retcode = G_ERRCODE["MASHU_GET_PRIZE_NOT_RANK"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if role._roledata._mashu_info._get_prize_flag == 1 then
		resp.get_prize_flag = role._roledata._mashu_info._get_prize_flag
		resp.retcode = G_ERRCODE["MASHU_GET_PRIZE_HAVE_GET"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--查看自己的名次是否有奖励
	local ed = DataPool_Find("elementdata")
	local reward = ed.equestrainreward[1]

	local reward_id = 0
	for equestrainrewardgroup in DataPool_Array(reward.equestrainrewardgroup) do
		if resp.yestaday_rank >= equestrainrewardgroup.equestrain_rank_min and resp.yestaday_rank <= equestrainrewardgroup.equestrain_rank_max then
			reward_id = equestrainrewardgroup.equestrain_id
		end
	end

	if reward_id == 0 then
		resp.get_prize_flag = role._roledata._mashu_info._get_prize_flag
		resp.retcode = G_ERRCODE["MASHU_GET_PRIZE_RANK_LOW"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--下面开始给奖励
	role._roledata._temporary_backpack._id = role._roledata._temporary_backpack._id + 1
		
	local insert_data = CACHE.TemporaryBackPackData()
	insert_data._id = role._roledata._temporary_backpack._id
	insert_data._typ = 3	--类型为3代表的马术排名奖励

	local reward_info = DROPITEM_Reward(role, reward_id)

	for index = 1,table.getn(reward_info.item) do
		local item = ed:FindBy("item_id", reward_info.item[index].itemid)
		if item.packlimit == 0 then
			for index = 1,reward_info.item[index].itemnum do
				local tmp = CACHE.Item()
				tmp._tid = reward_info.item[index].itemid
				tmp._count = 1
				insert_data._iteminfo:PushBack(tmp)
			end
		else
			local insert_flag = true
			local iteminfo_it = insert_data._iteminfo:SeekToBegin()
			local iteminfo = iteminfo_it:GetValue()
			while iteminfo ~= nil do
				if iteminfo._tid == reward_info.item[index].itemid then
					iteminfo._count = iteminfo._count + reward_info.item[index].itemnum
					insert_flag = false
					break
				end
				iteminfo_it:Next()
				iteminfo = iteminfo_it:GetValue()
			end
			if insert_flag == true then
				local tmp = CACHE.Item()
				tmp._tid = reward_info.item[index].itemid
				tmp._count = reward_info.item[index].itemnum
				insert_data._iteminfo:PushBack(tmp)
			end
		end
	end
	role._roledata._temporary_backpack._data:Insert(insert_data._id, insert_data)

	resp.item = {}
	resp.item.items = {}
	resp.item.id = insert_data._id
	resp.item.typ = insert_data._typ
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
	
	--设置信息
	role._roledata._mashu_info._get_prize_flag = 1
	resp.get_prize_flag = role._roledata._mashu_info._get_prize_flag
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))

	return

end
