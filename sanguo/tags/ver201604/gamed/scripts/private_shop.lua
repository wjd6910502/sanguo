function PRIVATE_RefreshAllShop(role)
	local ed = DataPool_Find("elementdata")
	local shops = ed.mysterymall

	local role_shop = role._roledata._private_shop
	local now = API_GetTime()
	for shop in DataPool_Array(shops) do
		local find_shop = role_shop:Find(shop.id)
		if find_shop == nil then
			--直接刷新商店，添加物品
			PRIVATE_RefreshShop(role, shop.id)
			find_shop = role_shop:Find(shop.id)
			find_shop._last_refresh_time = now
		else
			--得到商店的正常刷新时间
			local shop_system_refresh_time = {}
			local today_begin_time = API_MakeTodayTime(0, 0, 0)
			if find_shop._last_refresh_time < today_begin_time then
				--上次刷新的时间是昨天的话，那么就先把昨天的刷新时间点也添加进去
				for time in DataPool_Array(shop.auto_refresh_times) do
					if time ~= 0 then
						local tmp_time = time/100*3600 + (time - time/100*100)*60
						shop_system_refresh_time[#shop_system_refresh_time+1] = today_begin_time - 24*3600 + tmp_time
					end
				end
			end
			--把今天的刷新时间也添加进去
			for time in DataPool_Array(shop.auto_refresh_times) do
				if time ~= 0 then
					local tmp_time = time/100*3600 + (time - time/100*100)*60
					shop_system_refresh_time[#shop_system_refresh_time+1] = today_begin_time + tmp_time
				end
			end

			--开始判断这个刷新时间
			for i = 1, table.getn(shop_system_refresh_time) do
				if find_shop._last_refresh_time < shop_system_refresh_time[i] and now >= shop_system_refresh_time[i] then
					PRIVATE_RefreshShop(role, shop.id)
					break
				end
			end
			find_shop._last_refresh_time = now
		end
	end
end


--这个接口进来就直接刷新商店了，不再进行判断，所以调用这个
function PRIVATE_RefreshShop(role, shopid)
	local ed = DataPool_Find("elementdata")
	local shop = ed:FindBy("shop_id", shopid)
	if shop == nil then
		role._roledata._private_shop:Delete(shopid)
		return
	end

	local new_shop = CACHE.PrivateShop()
	new_shop._shop_id = shopid

	--开始刷新物品
	for storage_id in DataPool_Array(shop.mystery_mall_storage_id) do
		if storage_id ~= 0 then
			local storage = ed:FindBy("storage_id", storage_id)

			--开始随机具体的物品
			local item_list = {}
			local all_chance = 0
			for info_set in DataPool_Array(storage.info_set) do
				if role._roledata._status._level >= info_set.level_min and role._roledata._status._level <= info_set.level_max and 
				info_set.item_id ~= 0 then
					local temp_item_list = {}
					temp_item_list.itemid = info_set.item_id
					temp_item_list.count = info_set.limit_buy_times
					temp_item_list.drop_chance = info_set.drop_chance
					item_list[#item_list+1] = temp_item_list
					all_chance = all_chance + info_set.drop_chance

				end
			end
			--开始往里面加物品了
			local seed = math.random()
			seed = math.floor(seed*all_chance)
			local cur_seed = 0
			for i = 1, table.getn(item_list) do
				cur_seed = cur_seed + item_list[i].drop_chance
				if seed <= cur_seed then
					local tmp_item = CACHE.PrivateShopData()
					tmp_item._item_id = item_list[i].itemid
					tmp_item._buy_count = 0
					tmp_item._max_count = item_list[i].count
					new_shop._shop_data:PushBack(tmp_item)
					break
				end
			end
		end
	end

	--把新的商店更新进去
	local find_shop = role._roledata._private_shop:Find(shopid)
	if find_shop == nil then
		new_shop._last_refresh_time = API_GetTime()
		role._roledata._private_shop:Insert(shopid, new_shop)
	else
		new_shop._last_refresh_time = find_shop._last_refresh_time
		role._roledata._private_shop:Insert(shopid, new_shop)
	end

	local resp = NewCommand("UpdateMysteryShopInfo")
	resp.shop_id = shopid
	resp.refresh_time = new_shop._last_refresh_time
	resp.shop_item = {}

	local shop_item_it = new_shop._shop_data:SeekToBegin()
	local shop_item = shop_item_it:GetValue()
	while shop_item ~= nil do
		local tmp_item = {}
		tmp_item.item_id = shop_item._item_id
		tmp_item.buy_count = shop_item._buy_count
		tmp_item.max_count = shop_item._max_count
		resp.shop_item[#resp.shop_item+1] = tmp_item
		shop_item_it:Next()
		shop_item = shop_item_it:GetValue()
	end
	role:SendToClient(SerializeCommand(resp))
end
