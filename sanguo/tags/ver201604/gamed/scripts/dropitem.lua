--注意这个接口的作用是根据传进来的模板ID来进行随机物品的掉落
--function DROPITEM_DropItem(role, tid)
--	local item_list = {}
--	local prize_template = role._roledata._status._prize_template
--	local i = prize_template:Find(tid)
--	local count = DROPITEM_DropItemCount(role, tid)
--	if i == nil then
--		DROPITEM_DropItemTemplate(role, tid)
--	end
--	--调用开始给奖励
--	return DROPITEM_BeginDropItem(role, tid, count)
--
--end

--注意这个接口的作用是根据传进来的模板ID来进行随机物品的掉落
function DROPITEM_DropItem(role, tid)
	local ed = DataPool_Find("elementdata")
	local drop_item = ed:FindBy("drop_id",tid)
	local player_drop_item = {}

	if drop_item == nil then
		return player_drop_item
	end

	--掉落的次数，首先需要得到
	local drop_count = 0
	local prob = 0
	local seed = math.random(1000000)
	for tmp_prob in DataPool_Array(drop_item.dropchancefortime) do
		prob = prob + tmp_prob
		--注意只有有概率才会进行后面的判断，如果这个概率配置的是0就没有后面的判断这些事情了
		if tmp_prob > 0 then
			if seed <= prob  then
				break
			end
		end
		drop_count = drop_count + 1
	end

	if drop_count == 0 then
		return player_drop_item
	end

	for tmp_index = 1, drop_count do
		--下面开始计算每一个物品组掉落的概率
		local all_drop_template = drop_item.total_statistic_id
		local all_drop_count = LIMIT_GetUseLimit(role, all_drop_template)
		local item_prob = {}
		local index = 1
		local all_prob = 0
		for tmp_bonus_set in DataPool_Array(drop_item.bonus_set) do
			local tmp_count = 0
			
			if tmp_bonus_set.array_id == 0 then
				break
			end

			if tmp_bonus_set.array_statistic_id ~= 0 then
				tmp_count = LIMIT_GetUseLimit(role, tmp_bonus_set.array_statistic_id)
			end

			local tmp_piancha = all_drop_count*tmp_bonus_set.drop_chance/1000000 - tmp_count - tmp_bonus_set.chance_origin/100
			local tmp_kongjian = 0
		
			if tmp_bonus_set.array_statistic_id ~= 0 then
				if tmp_piancha > 0 then
					tmp_kongjian = tmp_bonus_set.drop_chance + tmp_bonus_set.chance_up*tmp_piancha*tmp_piancha*tmp_piancha
					
				else
					tmp_kongjian = tmp_bonus_set.drop_chance + tmp_bonus_set.chance_down*tmp_piancha*tmp_piancha*tmp_piancha
				end
			else
				tmp_kongjian = tmp_bonus_set.drop_chance
			end

			if tmp_kongjian < 0 then
				item_prob[index] = 0
				all_prob = all_prob + 0
			else
				item_prob[index] = math.floor(tmp_kongjian)
				all_prob = all_prob + math.floor(tmp_kongjian)
			end
			index = index + 1
		end

		if all_prob <= 0 then
			return player_drop_item
		end
		--下面开始计算要掉落哪一个物品组的ID
		local drop_group_id = {}
		local seed = math.random()
		seed = math.floor(seed*all_prob)
		local prob = 0
		for i = 1, table.getn(item_prob) do
			prob = prob + item_prob[i]
			--注意只有有概率才会进行后面的判断，如果这个概率配置的是0就没有后面的判断这些事情了
			if item_prob[i] > 0 then
				if seed <= prob then
					drop_group_id = drop_item.bonus_set[i]
					break
				end
			end
		end

		--开始掉落具体的物品
		local drop_itemset = ed:FindBy("itemset_id", drop_group_id.array_id)
		if drop_itemset == nil then
			API_Log("DROPITEM_DropItem DROPITEM_DropItem DROPITEM_DropItem  ".. drop_group_id.array_id)
			return player_drop_item
		end
		--计算一共掉落几个物品
		local count1 = 0
		for tmp_item_set in DataPool_Array(drop_itemset.itemid) do
			if tmp_item_set ~= 0 then
				count1 = count1 + 1
			end
		end
		
		local seed = math.random(1,count1)

		local result_drop_item_id = 0
		local count1 = 0
		for tmp_item_set in DataPool_Array(drop_itemset.itemid) do
			if tmp_item_set ~= 0 then
				count1 = count1 + 1
			end
			if count1 == seed then
				result_drop_item_id = tmp_item_set
				break
			end
		end
		local tmp_item = {}
		tmp_item.id = result_drop_item_id
		tmp_item.count = drop_group_id.item_nums
		player_drop_item[#player_drop_item+1] = tmp_item

		--开始修改掉落次数
		LIMIT_AddUseLimit(role, all_drop_template, 1)
		if drop_group_id.array_statistic_id ~= 0 then
			LIMIT_AddUseLimit(role, drop_group_id.array_statistic_id, 1)
		end
	end
	return player_drop_item
	
end

--这个函数就是用来给玩家身上根据tid随机出来需要用下面的那一层模板来进行顺序发奖
--function DROPITEM_DropItemTemplate(role, tid)
--	local ed = DataPool_Find("elementdata")
--	local rand_plan = ed:FindBy("randplan_id",tid)
--	local quanju = ed.gamedefine[1]
--	
--	if rand_plan ==  nil then
--		return 
--	end
--	--随机出来需要使用的模板ID
--	local drop_tid = 0
--	local seed = math.random(1000000)
--	local prob = 0
--	for i = 1, quanju.plan_arrayid_max do
--		local xxx = "dropchance"..i
--		prob = prob + rand_plan[xxx]
--		if seed <= prob then
--			local yyy = "arrayid"..i
--			drop_tid = rand_plan[yyy]
--			break
--		end
--	end
--
--	if drop_tid == 0 then
--		ThrowException("DROPITEM_DropItemTemplate drop_tid=0")
--	end
--	local prize_template = role._roledata._status._prize_template
--	local value = CACHE.PrizeTemplate:new()
--	value._tid = tid
--	value._tid2 = drop_tid
--	value._position = 1
--
--	prize_template:Insert(tid, value)
--end
--
----这个函数就是用来给玩家身上根据tid随机出来需要给几个物品
--function DROPITEM_DropItemCount(role, tid)
--	local ed = DataPool_Find("elementdata")
--	local rand_plan = ed:FindBy("randplan_id",tid)
--	local quanju = ed.gamedefine[1]
--	
--	if rand_plan == nil then
--		return 0
--	end
--	local seed = math.random(1000000)
--	--首先随机出来要给的数量
--	local drop_count = 0
--	local prob = 0
--	for i = 0, quanju.plan_droptimes_max - 1 do
--		local xxx="drop"..i.."timechance"
--		prob = prob + rand_plan[xxx]
--		if seed <= prob then
--			drop_count = i
--			break
--		end
--	end
--	return drop_count
--end
--
----这个接口是真正的在给玩家随机物品
--function DROPITEM_BeginDropItem(role, tid, count)
--	local iteminfo = {}
--	local ed = DataPool_Find("elementdata")
--	while count > 0 do
--		local itemgroup = 0
--		local prize_template = role._roledata._status._prize_template
--		local i = prize_template:Find(tid)
--		if i ~= nil then
--			droparray = ed:FindBy("droparray_id",i._tid2)
--			if droparray ~= nil then
--				if i._position <= droparray.array_length then
--					local yyy="itemgroup"..i._position
--					itemgroup = droparray[yyy]
--					local itemid = 0
--					local droparray = ed:FindBy("itemgroup_id",itemgroup)
--					if droparray ~= nil then
--						local seed = math.random(1,droparray.group_length)
--						if seed <= 100 then
--							local xxx="Item"..seed
--							itemid = droparray[xxx]
--						else
--							
--						end
--						local item = {}
--						item.id = itemid
--						item.count = 1
--						iteminfo[#iteminfo+1]=item
--					end
--					i._position = i._position + 1
--					count = count - 1
--				else
--					DROPITEM_DropItemTemplate(role, tid)
--				end
--			else
--				API_Log("DROPITEM_BeginDropItem id is error i._tid2=="..i._tid2)
--				return iteminfo
--			end
--		else
--			--其实这里是不应该进来的。进来的话就是哪里出现了问题
--			DROPITEM_DropItemTemplate(role, tid)	
--		end
--	end
--	return iteminfo
--end

function DROPITEM_Reward(role, rewardmouldid)
	local iteminfo = {}
	iteminfo.item = {}
	local ed = DataPool_Find("elementdata")
	local reward = ed:FindBy("reward_id", rewardmouldid)

	if reward == nil then
		return iteminfo
	end
	
	iteminfo.exp = reward.exp
	iteminfo.heroexp =  reward.heroexp
	for reward_item in DataPool_Array(reward.items) do
		if reward_item.itemid ~= 0 then
			local tmp_item={}
			tmp_item.itemid = reward_item.itemid
			tmp_item.itemnum = reward_item.itemnum
			iteminfo.item[#iteminfo.item+1] = tmp_item
		end
	end
	return iteminfo
end
