function OnCommand_Hero_Up_Grade(player, role, arg, others)
	player:Log("OnCommand_Hero_Up_Grade, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("Hero_Up_Grade_Re")
	resp.retcode = Hero_up_Grade(role, arg.hero_id)
	player:SendToClient(SerializeCommand(resp))

	if resp.retcode == 0 then
		HERO_UpdateHeroInfo(role, arg.hero_id)
	end
end

function Hero_up_Grade(role,hero_id)

	local heros = role._roledata._hero_hall._heros
	local hero = heros:Find(hero_id)
	if hero == nil then
		return G_ERRCODE["NO_HERO"]
	end

	--判断界别是否达到了最高  这个最大值 可否写在表里读出来
	local hero_order = hero._order
	if hero_order >= 14 then
		return G_ERRCODE["MAX_HERO_ORDER"]
	end
	
	local item_id1 = 0
	local item_count1 = 0
	local item_id2 = 0
	local item_count2 = 0
	local grade_level = 0
	local cost_money = 0
	local ed = DataPool_Find("elementdata")
	local herograde = ed:FindBy("herograde_id", hero_id)
	for grade in DataPool_Array(herograde.grade) do
		if grade.grade == hero_order then
			grade_level = grade.grade_lv
			item_id1 = grade.material1
			item_count1 = grade.material1_quantity
			item_id2 = grade.material2
			item_count2 = grade.material2_quantity
			cost_money = grade.costcurrency
			learn_skill = grade.unlockspeciality
			break
		end
	end

	--判断是否满足等级条件
	if hero._level < grade_level then
		return G_ERRCODE["NOT_MAX_LEVEL_ORDER"]
	end
	
	if cost_money > role._roledata._status._money then
		return G_ERRCODE["HERO_SKILLLV_UPGRADE_MONEY_LACK"]
	end
	
	--策划配表问题
	if item_id2 == 0 and item_id1 == 0 then
		throw()
	end

	--判断物品是否存在
	local bexist1 = false
	local bexist2 = false
	if item_id1 > 0 then
		if BACKPACK_HaveItem(role, item_id1, item_count1) == false then
			return G_ERRCODE["ITEM_COUNT_LESS"]
		else
			bexist1 = true
		end	
	end
	
	if item_id2 > 0 then
		if BACKPACK_HaveItem(role, item_id2, item_count2) == false then
			return G_ERRCODE["ITEM_COUNT_LESS"]
		else
			bexist2 = true
		end
	end

	--在这里开始扣除材料，修改武将的界别
	if bexist1 then
		BACKPACK_DelItem(role, item_id1, item_count1)
	end
	if bexist2 then
		BACKPACK_DelItem(role, item_id2, item_count2)
	end
	
	--扣钱
	if cost_money > 0  then
		ROLE_SubMoney(role, cost_money)			
	end

	hero._order = hero._order + 1
	
	local learn_skill = 0
	for grade in DataPool_Array(herograde.grade) do
		if grade.grade == hero._order then
			if grade.unlockspeciality ~= 0 then
				local speciality_info = ed:FindBy("speciality_id", grade.unlockspeciality)
				learn_skill = speciality_info.tejiid*1000+speciality_info.tejilv
			end
			break
		end
	end
	if learn_skill ~= 0 then
		local insert_value = CACHE.Int()
		insert_value._value = learn_skill
		hero._beidong_skill:PushBack(insert_value)
	end
	
	--给客户端发送武将信息的修改
	return G_ERRCODE["SUCCESS"]

end
