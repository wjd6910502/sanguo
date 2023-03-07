--这个函数用来刷新玩家的声望商店，以及用来添加玩家的声望商店
--添加这个情况的发生时因为目前商店是有开启等级的，所以当达到一定等级
--可以开启的时候，就可以开启了。
function REPSHOP_RefreshShop(role, shop_id)
	local repshop = role._shopmap
	local shop = current_task:Find(shop_id)
	if shop ~= nil then
		local ed = DataPool_Find("elementdata")
		local ed_shop = ed.repshop[shop_id]
		if ed_shop ~= nil then
			--在这里需要进行重新分配
			shop._shop_id = ed_shop.shop_id
			shop._type = ed_shop.shop_type
			shop._level = ed_shop.level
			shop._itemlist.clear()
			--下面开始对这次出现的物品进行随机，因为有一些物品时必出的，一些是有概率出现的
			itemlist = ed_shop.itemlist --在这里取到所有的物品
			for r in DataPool_Array(itemlist) do
				if r.prob == 100 then
					local item = {}
					item._item_id = r.item_id
					item._count = 0
					item._max_count = r.max_count
					item._price = r.price
					shop._itemlist:PushBack(item)
				end
			end

			local pro_count = ed_shop.pro_count
			if pro_count > 0 then
				local prob_sum = 0	--总的概率之和
				local prob_count = 0	--一共有多少物品
				local prob_item = {}
				for r in DataPool_Array(itemlist) do
					if r.prob > 0 and r.prob < 100 then
						local item = {}
						item._item_id = r.item_id
						item._count = 0
						item._max_count = r.max_count
						item._price = r.price
						item._prob = r.prob
						prob_sum = prob_sum + item._prob
						prob_count = prob_count + 1
						prob_item[prob_count] = item
					end
				end

				if prob_count >= pro_count then
					local all_count = 0	--已经随机到的物品个数
					while all_count < pro_count do
						local tmp_prob = math.random(1,prob_sum)
						local tmp_sum = 0
						for i = 1, prob_count do
							tmp_sum = tmp_sum + prob_item[i]._prob
							if tmp_prob <= tmp_sum then
								local item = {}
								item._item_id = prob_item[i].item_id
								item._count = 0
								item._max_count = prob_item[i].max_count
								item._price = prob_item[i].price
								shop._itemlist:PushBack(item)
								
								--修改被选中的物品的概率设置成0
								prob_sum = prob_sum - prob_item[i]._prob
								prob_item[i]._prob = 0
								all_count = all_count + 1
								break
							end
						end
					end
				else
					player:Log("shop_id prob_count is little" .. shop_id)
				end

			end
		else
			player:Log("shop_id is error" .. shop_id)
		end

	else
		
	end

	
end
