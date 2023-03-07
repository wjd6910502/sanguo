function OnCommand_CompleteInstance(player, role, arg, others)
	--副本失败的原因，目前1代表战斗失败。2代表主动退出
	--player:Log("OnCommand_CompleteInstance"..DumpTable(arg))
	
	local resp = NewCommand("CompleteInstance_Re")
	if role._roledata._status._instance_id ~= arg.inst_tid then
		resp.retcode = G_ERRCODE["NO_STAGE"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	role._roledata._status._instance_id = 0

	local star_count = 0
	if arg.flag ~= 1 then
		resp.retcode = G_ERRCODE["NO_FAIL"]
		player:SendToClient(SerializeCommand(resp))
		return
	else
		local table_count = table.getn(arg.star)
		for i = 1, table_count do
			if arg.star[i].flag == 1 then
				star_count = star_count + 1
			end
		end
		if star_count == 0 then
			resp.retcode = G_ERRCODE["NO_STAR"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
	end

	local ed = DataPool_Find("elementdata")
	local stage = ed:FindBy("stage_id", arg.inst_tid)
	if stage == nil then
		resp.retcode = G_ERRCODE["NO_STAGE"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--说明有强制出战的武将
	local addexp_hero = {}
	local req_hero = ed:FindBy("requisite_role", arg.inst_tid)
	if req_hero ~= nil then
		if (table.getn(arg.req_heros) + table.getn(arg.heros)) > 3 or (table.getn(arg.req_heros) + table.getn(arg.heros)) < 1 then
			resp.retcode = G_ERRCODE["HERO_COUNT_ERR"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
		--检查武将的合法性,检查玩家是否有这些武将
		local heros = role._roledata._hero_hall._heros

		for i = 1, table.getn(arg.heros) do
			local h = heros:Find(arg.heros[i])
			if h == nil then
				resp.retcode = G_ERRCODE["NO_HERO"]
				player:SendToClient(SerializeCommand(resp))
				return
			end
			addexp_hero[#addexp_hero+1] = arg.heros[i]
		end
	else
		if stage.stagetype == 0 then
			local last_hero = role._roledata._status._last_hero
			local lit = last_hero:SeekToBegin()
			local l = lit:GetValue()
			while l ~= nil do
				addexp_hero[#addexp_hero+1] = l._value
				lit:Next()
				l = lit:GetValue()
			end
		else
			local last_hero = role._roledata._status._last_horse_hero._heroinfo
			local lit = last_hero:SeekToBegin()
			local l = lit:GetValue()
			while l ~= nil do
				addexp_hero[#addexp_hero+1] = l._value
				lit:Next()
				l = lit:GetValue()
			end
		end
	end

	local vp = role._roledata._status._vp
	--查看体力是否足够
	local need_vp = stage.finish_tili
	if need_vp > vp then
		resp.retcode = G_ERRCODE["NO_ENOUGHVP"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	if stage.limittimes ~= 0 then
		if LIMIT_TestUseLimit(role, stage.limittimes, 1) == false then
			resp.retcode = G_ERRCODE["NO_COUNT"]--这个副本没有了次数
			player:SendToClient(SerializeCommand(resp))
			return
		end
	end

	ROLE_Subvp(role, stage.finish_tili)
	if stage.limittimes ~= 0 then
		LIMIT_AddUseLimit(role, stage.limittimes, 1)
	end
	
	local instance = role._roledata._status._instances
	local i = instance:Find(arg.inst_tid)
	local first_flag = 0
	if i == nil then
		local value = CACHE.RoleInstance:new()
		value._tid = arg.inst_tid
		value._score = arg.score
		value._star = star_count
		instance:Insert(arg.inst_tid, value)
		TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, star_count)
		if star_count == 3 then
			first_flag = 1
		end
	else
		if star_count > i._star then
			TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, star_count - i._star)
			i._star = star_count
			if star_count == 3 then
				first_flag = 1
			end
		end
	end

	resp.star = star_count
	resp.retcode = 0
	resp.inst_tid = arg.inst_tid
	resp.score = arg.score
	local Item = DROPITEM_DropItem(role, stage.dropid)
	local Reward = DROPITEM_Reward(role, stage.rewardmouldid)

	ROLE_AddReward(role, Reward)

	local instance_info = {}
	instance_info.exp = Reward.exp
	instance_info.heroexp = math.floor(Reward.heroexp/table.getn(arg.heros))
	instance_info.item = {}
	local item_count = table.getn(Item)
	for i = 1, item_count do
		local instance_item = {}
		local have_flag = 1
		for j = 1, #instance_info.item do
			if instance_info.item[j].id == Item[i].id then
				instance_info.item[j].count = instance_info.item[j].count + Item[i].count
				have_flag = 0
				break
			end
		end
		
		instance_item.id = Item[i].id
		instance_item.count = Item[i].count
		if have_flag == 1 then
			instance_info.item[#instance_info.item+1] = instance_item
		end
		BACKPACK_AddItem(role, instance_item.id, instance_item.count)
	end

	item_count = table.getn(Reward.item)
	for i = 1, item_count do
		local instance_item = {}
		local have_flag = 1
		for j = 1, #instance_info.item do
			if instance_info.item[j].id == Reward.item[i].itemid then
				instance_info.item[j].count = instance_info.item[j].count + Reward.item[i].itemnum
				have_flag = 0
				break
			end
		end
		instance_item.id = Reward.item[i].itemid
		instance_item.count = Reward.item[i].itemnum
		if have_flag == 1 then
			instance_info.item[#instance_info.item+1] = instance_item
		end
	end
	--给所有的武将加经验
	for i = 1, table.getn(addexp_hero) do
		HERO_AddExp(role, addexp_hero[i], math.floor(Reward.heroexp/table.getn(addexp_hero)))
	end

	--修改成就
	if stage.isifstage == 0 then
		TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_FINISH"], arg.inst_tid, 1)
		TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_COUNT"], 0 , 1)
	elseif stage.isifstage == 1 then
		TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_JINGYING_FINISH"], arg.inst_tid, 1)
		TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_JINGYING_COUNT"], 0 ,1)
	end

	--查看是否可以导致开启新的军团建筑
	ROLE_FinishInstance(role, arg.inst_tid)

	resp.rewards = instance_info
	resp.first_flag = first_flag
	player:SendToClient(SerializeCommand(resp))
end
