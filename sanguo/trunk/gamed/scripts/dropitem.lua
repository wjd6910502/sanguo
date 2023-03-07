--ע������ӿڵ������Ǹ��ݴ�������ģ��ID�����������Ʒ�ĵ���
--function DROPITEM_DropItem(role, tid)
--	local item_list = {}
--	local prize_template = role._roledata._status._prize_template
--	local i = prize_template:Find(tid)
--	local count = DROPITEM_DropItemCount(role, tid)
--	if i == nil then
--		DROPITEM_DropItemTemplate(role, tid)
--	end
--	--���ÿ�ʼ������
--	return DROPITEM_BeginDropItem(role, tid, count)
--
--end

--ע������ӿڵ������Ǹ��ݴ�������ģ��ID�����������Ʒ�ĵ���
function DROPITEM_DropItem(role, tid)
	API_Log("DROPITEM_DropItem  id="..role._roledata._base._id:ToStr().."   tid="..tid )

	local ed = DataPool_Find("elementdata")
	local drop_item = ed:FindBy("drop_id",tid)
	local player_drop_item = {}

	if drop_item == nil then
		return player_drop_item
	end

	--����Ĵ�����������Ҫ�õ�
	local drop_count = 0
	local prob = 0
	local seed = math.random(1000000)
	for tmp_prob in DataPool_Array(drop_item.dropchancefortime) do
		prob = prob + tmp_prob
		--ע��ֻ���и��ʲŻ���к�����жϣ��������������õ���0��û�к�����ж���Щ������
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
		--���濪ʼ����ÿһ����Ʒ�����ĸ���
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
		--���濪ʼ����Ҫ������һ����Ʒ���ID
		local drop_group_id = {}
		local seed = math.random()
		seed = math.floor(seed*all_prob)
		local prob = 0
		for i = 1, table.getn(item_prob) do
			prob = prob + item_prob[i]
			--ע��ֻ���и��ʲŻ���к�����жϣ��������������õ���0��û�к�����ж���Щ������
			if item_prob[i] > 0 then
				if seed <= prob then
					drop_group_id = drop_item.bonus_set[i]
					break
				end
			end
		end

		--��ʼ����������Ʒ
		local drop_itemset = ed:FindBy("itemset_id", drop_group_id.array_id)
		if drop_itemset == nil then
			return player_drop_item
		end
			
		API_Log("DROPITEM_DropItem  id="..role._roledata._base._id:ToStr().."   item_id=" )

		--����һ�����伸����Ʒ
		local count1 = 0
		for tmp_item_set in DataPool_Array(drop_itemset.itemid) do
			if tmp_item_set ~= 0 then
				count1 = count1 + 1
			end
		end
		
		API_Log("DROPITEM_DropItem  id="..role._roledata._base._id:ToStr().."   item_id count1 ="..count1 )
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

		--��ʼ�޸ĵ������
		LIMIT_AddUseLimit(role, all_drop_template, 1)
		if drop_group_id.array_statistic_id ~= 0 then
			LIMIT_AddUseLimit(role, drop_group_id.array_statistic_id, 1)
		end
	end
	return player_drop_item
	
end

--�����������������������ϸ���tid���������Ҫ���������һ��ģ��������˳�򷢽�
--function DROPITEM_DropItemTemplate(role, tid)
--	local ed = DataPool_Find("elementdata")
--	local rand_plan = ed:FindBy("randplan_id",tid)
--	local quanju = ed.gamedefine[1]
--	
--	if rand_plan ==  nil then
--		return 
--	end
--	--���������Ҫʹ�õ�ģ��ID
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
--	local value = CACHE.PrizeTemplate()
--	value._tid = tid
--	value._tid2 = drop_tid
--	value._position = 1
--
--	prize_template:Insert(tid, value)
--end
--
----�����������������������ϸ���tid���������Ҫ��������Ʒ
--function DROPITEM_DropItemCount(role, tid)
--	local ed = DataPool_Find("elementdata")
--	local rand_plan = ed:FindBy("randplan_id",tid)
--	local quanju = ed.gamedefine[1]
--	
--	if rand_plan == nil then
--		return 0
--	end
--	local seed = math.random(1000000)
--	--�����������Ҫ��������
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
----����ӿ����������ڸ���������Ʒ
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
--			--��ʵ�����ǲ�Ӧ�ý����ġ������Ļ������������������
--			DROPITEM_DropItemTemplate(role, tid)	
--		end
--	end
--	return iteminfo
--end

function DROPITEM_Reward(role, rewardmouldid)
	local iteminfo = {}
	iteminfo.item = {}
	iteminfo.exp = 0
	iteminfo.heroexp = 0
	local ed = DataPool_Find("elementdata")
	local reward = ed:FindBy("reward_id", rewardmouldid)

	if reward == nil then
		return iteminfo
	end
	
	iteminfo.exp = reward.exp
	iteminfo.heroexp = reward.heroexp
	
	for reward_item in DataPool_Array(reward.items) do
		if reward_item.itemid~=0 and reward_item.itemnum>0 then
			local tmp_item={}
			tmp_item.itemid = reward_item.itemid
			tmp_item.itemnum = reward_item.itemnum
			iteminfo.item[#iteminfo.item+1] = tmp_item
		end
	end
	return iteminfo
end