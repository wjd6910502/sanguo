function OnCommand_CompleteInstance(player, role, arg, others)
	--副本失败的原因，目前0代表战斗失败。2代表主动退出
	--1代表战斗胜利
	--player:Log("OnCommand_CompleteInstance, "..DumpTable(arg))
	player:Log("OnCommand_CompleteInstance, flag="..arg.flag)

	if role._roledata._status._time_line ~= G_ROLE_STATE["INSTANCE"] then
		return
	end

	local resp = NewCommand("CompleteInstance_Re")
	if role._roledata._status._instance_id ~= arg.inst_tid then
		resp.retcode = G_ERRCODE["NO_STAGE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_CompleteInstance, error=NO_STAGE")
		return
	end
	role._roledata._status._instance_id = 0

	local star_count = 0
	if arg.flag ~= 1 then
		resp.retcode = G_ERRCODE["NO_FAIL"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_CompleteInstance, error=NO_FAIL")
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
			player:Log("OnCommand_CompleteInstance, error=NO_STAR")
			return
		end
	end

	local ed = DataPool_Find("elementdata")
	local stage = ed:FindBy("stage_id", arg.inst_tid)
	if stage == nil then
		resp.retcode = G_ERRCODE["NO_STAGE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_CompleteInstance, error=NO_STAGE")
		return
	end
	
	--数据统计日志
	local source_id = 0
	if stage.isifstage == G_INSTANCE_TYP["NORMAL_STAGE"] then
		source_id = G_SOURCE_TYP["NORMAL_STAGE"]
	elseif stage.isifstage == G_INSTANCE_TYP["SPECIAL_STAGE"] then
		source_id = G_SOURCE_TYP["SPECIAL_STAGE"]
	end
	local date = os.date("%Y-%m-%d %H:%M:%S")
	player:BILog("{\"logtime\":\""..date.."\",\"logname\":\"endinstance\",\"serverid\":\""..API_GetZoneId().."\",\"os\":\""
		..role._roledata._device_info._os.."\",\"platform\":\"".."laohu".."\",\"userid\":\""..role._roledata._status._account..
		"\",\"account\":\""..role._roledata._status._account.."\",\"roleid\":\""..role._roledata._base._id:ToStr()..
		"\",\"rolename\":\""..role._roledata._base._name.."\",\"lev\":\""..role._roledata._status._level.."\",\"totalcash\":\""
		.."0".."\",\"chapterid\":\""..stage.chapterid.."\",\"ectypeid\":\""..stage.stageid.."\",\"stagetype\":\""..stage.isifstage..
		"\",\"fight\":\""..role._roledata._status._zhanli.."\",\"result\":\""..arg.flag.."\",\"star\":\""..star_count.."\"}")
	if arg.flag ~= 1 then
		return
	end

	--说明有强制出战的武将
	local addexp_hero = {}
	local req_hero = ed:FindBy("requisite_role", arg.inst_tid)
	if req_hero ~= nil then
		if (table.getn(arg.req_heros) + table.getn(arg.heros)) > 3 or (table.getn(arg.req_heros) + table.getn(arg.heros)) < 1 then
			resp.retcode = G_ERRCODE["HERO_COUNT_ERR"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_CompleteInstance, error=HERO_COUNT_ERR")
			return
		end
		--检查武将的合法性,检查玩家是否有这些武将
		local heros = role._roledata._hero_hall._heros

		for i = 1, table.getn(arg.heros) do
			local h = heros:Find(arg.heros[i])
			if h == nil then
				resp.retcode = G_ERRCODE["NO_HERO"]
				player:SendToClient(SerializeCommand(resp))
				player:Log("OnCommand_CompleteInstance, error=NO_HERO")
				return
			end
			addexp_hero[#addexp_hero+1] = arg.heros[i]
		end
	else
		if stage.stagetype == 1 then
			local last_hero = role._roledata._status._last_horse_hero._heroinfo
			local lit = last_hero:SeekToBegin()
			local l = lit:GetValue()
			while l ~= nil do
				addexp_hero[#addexp_hero+1] = l._value
				lit:Next()
				l = lit:GetValue()
			end
		else
			local last_hero = role._roledata._status._last_hero
			local lit = last_hero:SeekToBegin()
			local l = lit:GetValue()
			while l ~= nil do
				addexp_hero[#addexp_hero+1] = l._value
				lit:Next()
				l = lit:GetValue()
			end
		end
end

	local first_finish = 0
	if role._roledata._status._instances:Find(arg.inst_tid) == nil then
		first_finish = 1
	end
	local vp = role._roledata._status._vp
	--查看体力是否足够
	local need_vp = 0
	if first_finish == 0 then
		need_vp = stage.finish_tili
	else
		need_vp = stage.first_finish_tili
	end
	if need_vp > vp then
		resp.retcode = G_ERRCODE["NO_ENOUGHVP"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_CompleteInstance, error=NO_ENOUGHVP")
		return
	end
	
	if stage.limittimes ~= 0 then
		if LIMIT_TestUseLimit(role, stage.limittimes, 1) == false then
			resp.retcode = G_ERRCODE["NO_COUNT"]--这个副本没有了次数
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_CompleteInstance, error=NO_COUNT")
			return
		end
	end

	--查看钱堆、宝箱掉落次数
	if arg.moneypiles < 0 or arg.moneypiles > stage.maxmoneypiles then
		resp.retcode = G_ERRCODE["MONEYPILES_ERR"]
                player:SendToClient(SerializeCommand(resp))
                player:Log("OnCommand_CompleteInstance, error=MONEYPILES_ERR arg.moneypiles:"..arg.moneypiles.." stage.maxmoneypiles:"..stage.maxmoneypiles)
                return
	end
	if arg.moneypiles ~= 0 and stage.moneypiledropid == 0 then
		resp.retcode = G_ERRCODE["NO_MONEYPILES"]
                player:SendToClient(SerializeCommand(resp))
                player:Log("OnCommand_CompleteInstance, error=NO_MONEYPILES")
                return
	end
	if arg.chests < 0 or arg.chests > stage.maxchests then
		resp.retcode = G_ERRCODE["CHESTS_ERR"]
                player:SendToClient(SerializeCommand(resp))
                player:Log("OnCommand_CompleteInstance, error=CHESTS_ERR")
                return
	end
	if arg.chests ~= 0 and stage.chestdropid == 0 then
		resp.retcode = G_ERRCODE["NO_CHESTS"]
                player:SendToClient(SerializeCommand(resp))
                player:Log("OnCommand_CompleteInstance, error=NO_CHESTS")
                return
	end

	local dropid = 0
	local rewardmouldid = 0
	ROLE_Subvp(role, need_vp)
	if first_finish == 0 then
		dropid = stage.dropid
		rewardmouldid = stage.rewardmouldid
	else
		if stage.first_drop_id ~= 0 then
			dropid = stage.first_drop_id
		else
			dropid = stage.dropid
		end
		if stage.first_reward_id ~= 0 then
			rewardmouldid = stage.first_reward_id
		else
			rewardmouldid = stage.rewardmouldid
		end
	end

	if stage.limittimes ~= 0 then
		LIMIT_AddUseLimit(role, stage.limittimes, 1)
	end
	
	local instance = role._roledata._status._instances
	local i = instance:Find(arg.inst_tid)
	local first_flag = 0
	if i == nil then
		local value = CACHE.RoleInstance()
		value._tid = arg.inst_tid
		value._score = arg.score
		value._star = star_count
		instance:Insert(arg.inst_tid, value)
		if stage.isifstage == 0 then
			TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, star_count)
		end
		if star_count == 3 then
			first_flag = 1
		end
	else
		if star_count > i._star then
			if stage.isifstage == 0 then	
				TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_STAR"], stage.chapterid, star_count - i._star)
			end
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
	local Item = DROPITEM_DropItem(role, dropid)
	local Reward = DROPITEM_Reward(role, rewardmouldid)

	ROLE_AddReward(role, Reward, source_id)

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
		BACKPACK_AddItem(role, instance_item.id, instance_item.count, source_id)
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

	--钱堆、宝箱掉落
	local MoneyReward = {}
	if arg.moneypiles ~= 0 then
		MoneyReward = DROPITEM_Reward(role, stage.moneypiledropid)
		--策划配置有误
		if #MoneyReward.item ~= 1 then
			resp.retcode = G_ERRCODE["MONEY_DROPDATA_ERR"]
			player:SendToClient(SerializeCommand(resp))
                	player:Log("OnCommand_CompleteInstance, error=MONEY_DROPDATA_ERR")
                	return
		end
		BACKPACK_AddItem(role, MoneyReward.item[1].itemid, MoneyReward.item[1].itemnum * arg.moneypiles, source_id)
		local money = {}
		money.id = MoneyReward.item[1].itemid
		money.count = MoneyReward.item[1].itemnum * arg.moneypiles
		local have_flag = 1
		for i = 1, #instance_info.item do
			if instance_info.item[i].id == money.tid then
				instance_info.item[i].count = instance_info.item[i].count + money.count
				have_flag = 0
				break
			end
		end
		if have_flag == 1 then
			instance_info.item[#instance_info.item+1] = money
		end
	end
	if arg.chests ~= 0 then
		for i = 1, arg.chests do
			local chestdrop = {}
			chestdrop = DROPITEM_DropItem(role, stage.chestdropid)
			local chestdropnum = table.getn(chestdrop)
			for j = 1, chestdropnum do
				local instance_item = {}
				local have_flag = 1
				for k = 1 , #instance_info.item do
					if instance_info.item[k].id == chestdrop[j].id then
						instance_info.item[k].count = instance_info.item[k].count + chestdrop[j].count
						have_flag = 0
						break
					end
				end
				instance_item.id = chestdrop[j].id
				instance_item.count = chestdrop[j].count
				if have_flag == 1 then
					instance_info.item[#instance_info.item+1] = instance_item
				end
				BACKPACK_AddItem(role, chestdrop[j].id, chestdrop[j].count, source_id)
			end
		end
	end

	--给所有的武将加经验
	for i = 1, table.getn(addexp_hero) do
		HERO_AddExp(role, addexp_hero[i], math.floor(Reward.heroexp/table.getn(addexp_hero)))
		HERO_UpdateHeroInfo(role, addexp_hero[i])
	end

	--修改成就
	if stage.isifstage == 0 then
		TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_FINISH"], arg.inst_tid, 1)
		TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_COUNT"], G_ACH_EIGHT_TYPE["STAGE"] , 1)
	elseif stage.isifstage == 1 then
		TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_JINGYING_FINISH"], arg.inst_tid, 1)
		TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_JINGYING_COUNT"], 0 ,1)
	elseif stage.isifstage == 2 then
		TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_FINISH"], arg.inst_tid, 1)
		TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_COUNT"], G_ACH_EIGHT_TYPE["YANWUCHANG"] , 1)
	end
	TASK_RefreshTask(role)

	--查看是否可以导致开启新的军团建筑
	ROLE_FinishInstance(role, arg.inst_tid)

	resp.rewards = instance_info
	resp.first_flag = first_flag
	resp.first_finish = first_finish
	player:SendToClient(SerializeCommand(resp))

	--查看操作和种子，准备做后面的验证
	--arg.operations
	--role._roledata._status._fight_seed
	role._roledata._status._time_line = G_ROLE_STATE["FREE"]

	if first_finish == 1 then
		if stage.notice_id ~= 0 then
			local notice_para = {}
			
			local tmp_notice_para = {}
			tmp_notice_para.typ = 1
			tmp_notice_para.id = role._roledata._base._id:ToStr()
			tmp_notice_para.name = role._roledata._base._name
			tmp_notice_para.num = 0
			notice_para[#notice_para+1] = tmp_notice_para
			
			local tmp_notice_para = {}
			tmp_notice_para.typ = 3
			tmp_notice_para.id = ""
			tmp_notice_para.name = ""
			tmp_notice_para.num = math.floor(arg.inst_tid/1000)
			notice_para[#notice_para+1] = tmp_notice_para

			ROLE_SendNotice(stage.notice_id, notice_para)
		end
	end

	--ROLE_CopyBattleRoleData(role, arg.operations)
end
