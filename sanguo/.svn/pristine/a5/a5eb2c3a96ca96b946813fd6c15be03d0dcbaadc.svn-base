function OnCommand_Lottery(player, role, arg, others)
	player:Log("OnCommand_Lottery, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("Lottery_Re")
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.lottery_id = arg.lottery_id
	resp.cost_type = arg.cost_type
	resp.reward_ids = {}	
	
	--查找抽奖id
	local ed = DataPool_Find("elementdata")
	local lottery = ed:FindBy("lottery_id",arg.lottery_id)	
	if lottery == nil then
		resp.retcode = G_ERRCODE["NO_LOTTERY"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_Lottery, error=NO_LOTTERY")
		return
	end

	--判断VIP等级是否足够
	local vip_level = ROLE_GetVIP(role)
	if lottery.need_vip_level > vip_level then
		resp.retcode = G_ERRCODE["VIP_LEVEL_LESS"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_Lottery, error=VIP_LEVEL_LESS")
		return
	end

	--数据统计日志
	local source_id = 0
	if arg.lottery_id == G_LOTTERY_TYP["NORMAL_RECRUIT"] or arg.lottery_id == G_LOTTERY_TYP["TEN_NORMAL_RECRUIT"] then
		source_id = G_SOURCE_TYP["NORMAL_RECRUIT"]
	elseif arg.lottery_id == G_LOTTERY_TYP["ONE_HIGHER_RECRUIT"] or arg.lottery_id == G_LOTTERY_TYP["TEN_HIGHER_RECRUIT"] then
		source_id = G_SOURCE_TYP["HIGHER_RECRUIT"]
	elseif arg.lottery_id == G_LOTTERY_TYP["ONE_LIMITE_RECRUIT"] or arg.lottery_id == G_LOTTERY_TYP["TEN_LIMITE_RECRUIT"]  then
		source_id = G_SOURCE_TYP["APPOINT_RECRUIT"]
	end

	local reward_id = lottery.reward_id
	local drop_id = lottery.drop_id
	local now = API_GetTime()
	local lottery_map = role._roledata._status._lottery_info
	local lottery_info = lottery_map:Find(arg.lottery_id)

	if arg.cost_type == 0 then
		--查看这个抽奖是否有免费次数
		if lottery.free_cd_loop == 0 then
			resp.retcode = G_ERRCODE["LOTTERY_NO_FREE"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_Lottery, error=LOTTERY_NO_FREE")
			return
		end
		
		local last_time = 0
		if lottery_info ~= nil then
			last_time = lottery_info._time
		else
			if lottery.first_drop_id ~= 0 then
				drop_id = lottery.first_drop_id
			end
		end

		if now - last_time < lottery.free_cd_loop then
			resp.retcode = G_ERRCODE["LOTTERY_FREE_CD"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_Lottery, error=LOTTERY_FREE_CD")
			return
		end

		if lottery_info == nil then
			local insert_info = CACHE.Lottery_Info()
			insert_info._lottery_id = arg.lottery_id
			insert_info._time = now
			insert_info._count = lottery.lottery_times
			insert_info._select = lottery.vip_drop[1]

			lottery_map:Insert(arg.lottery_id, insert_info)
		else
			lottery_info._time = now
			lottery_info._count = lottery_info._count + lottery.lottery_times
			lottery_info._lottery_id = arg.lottery_id
		end
	elseif arg.cost_type == 1 then
		--查看是否可以使用物品抽取，以及物品数量是否足够
		if lottery.itemid == 0 or lottery.itemcount == 0 then
			resp.retcode = G_ERRCODE["LOTTERY_REP_NOTENOUGH"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_Lottery, error=LOTTERY_REP_NOTENOUGH")
			return
		end
		local currency = ed:FindBy("currency_id", lottery.itemid)
		if ROLE_CheckRep(role, currency.rep_id, lottery.itemcount) == false then
			resp.retcode = G_ERRCODE["LOTTERY_REP_NOTENOUGH"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_Lottery, error=NO_LOTTERY")
			return
		end
		ROLE_SubRep(role, currency.rep_id, lottery.itemcount, source_id)
		
		if lottery_info == nil then
			if lottery.first_drop_id ~= 0 then
				drop_id = lottery.first_drop_id
			end
		end

		if lottery_info == nil then
			local insert_info = CACHE.Lottery_Info()
			insert_info._lottery_id = arg.lottery_id
			insert_info._time = 0
			insert_info._count = lottery.lottery_times
			insert_info._select = lottery.vip_drop[1]

			lottery_map:Insert(arg.lottery_id, insert_info)
		else
			lottery_info._count = lottery_info._count + lottery.lottery_times
		end
	elseif arg.cost_type == 2 then
		if lottery.yuanbao == 0 then
			resp.retcode = G_ERRCODE["LOTTERY_YUANBAO_NOTENOUGH"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_Lottery, error=LOTTERY_YUANBAO_NOTENOUGH")
			return
		end

		if role._roledata._status._yuanbao < lottery.yuanbao then
			resp.retcode = G_ERRCODE["LOTTERY_YUANBAO_NOTENOUGH"]
			player:SendToClient(SerializeCommand(resp))
			player:Log("OnCommand_Lottery, error=LOTTERY_YUANBAO_NOTENOUGH")
			return
		end
		ROLE_SubYuanBao(role, lottery.yuanbao, source_id)
		
		if lottery_info == nil then
			if lottery.first_drop_id ~= 0 then
				drop_id = lottery.first_drop_id
			end
		end

		if lottery_info == nil then
			local insert_info = CACHE.Lottery_Info()
			insert_info._lottery_id = arg.lottery_id
			insert_info._time = 0
			insert_info._count = lottery.lottery_times
			insert_info._select = lottery.vip_drop[1]

			lottery_map:Insert(arg.lottery_id, insert_info)
		else
			lottery_info._count = lottery_info._count + lottery.lottery_times
		end
	else
		resp.retcode = G_ERRCODE["NO_LOTTERY"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_Lottery, error=NO_LOTTERY")
		return
	end

	local randd = 0
	if lottery.lottery_times == 10 and arg.lottery_id ~= G_LOTTERY_TYP["TEN_NORMAL_RECRUIT"] then
		randd = math.random(1, lottery.lottery_times)
	end

	local lottery_info = {}
	for index = 1, lottery.lottery_times do	
		--根据掉落表配置每次只会随即掉落一个物品
		if index == randd then
			drop_id = lottery.ten_recruit_reward_id
		end

		local ditem = DROPITEM_DropItem(role, drop_id)
		if ditem == nil then
			local cmd = NewCommand("ErrorInfo")
			cmd.error_id = G_ERRCODE["LOTTERY_DROPITEM_ERROR"]
			role:SendToClient(SerializeCommand(cmd))		
			return
		end

		for drop_index = 1, table.getn(ditem) do
			local tmp_item = {}
			tmp_item.id = ditem[drop_index].id
			tmp_item.num = ditem[drop_index].count
			
			--找武将 是否首次获取看背包有没有 为空代表是物品
			local item = ed:FindBy("item_id",tmp_item.id)
			if item == nil then
				local cmd = NewCommand("ErrorInfo")
				cmd.error_id = G_ERRCODE["LOTTERY_ITEM_ERROR"]
				role:SendToClient(SerializeCommand(cmd))	
				return
			end

			if item.item_type == 21 then
				--找一下是否首次获得
				local heroid =  item.type_data1 --这个是武将id 不是模板id
				local hero_map = role._roledata._hero_hall._heros
				local h = hero_map:Find(heroid)	
				if h ~= nil then
					--转换成武魂物品
					tmp_item.firstget = 0
				else
					--第一次获取
					tmp_item.firstget = 1 	
				end
				tmp_item.bproorhero = 1
				for i = 1, tmp_item.num do
					HERO_AddHero(role, item.type_data1, 0, source_id)
				end
			else	
				tmp_item.firstget = 0 	
				tmp_item.bproorhero = 0					
				BACKPACK_AddItem(role,tmp_item.id,tmp_item.num, source_id)
			end

			resp.reward_ids[#resp.reward_ids+1]= tmp_item
		end
		--开始随机VIP掉落
		local have_num = table.getn(ditem)
		lottery_info = lottery_map:Find(arg.lottery_id)
		while lottery_info._select ~= 0 and have_num < 3 do
			have_num = have_num + 1
			local ditem = DROPITEM_DropItem(role, lottery_info._select)
			if ditem == nil then
				local cmd = NewCommand("ErrorInfo")
				cmd.error_id = G_ERRCODE["LOTTERY_DROPITEM_ERROR"]
				role:SendToClient(SerializeCommand(cmd))		
				return
			end

			for drop_index = 1, table.getn(ditem) do
				local tmp_item = {}
				tmp_item.id = ditem[drop_index].id
				tmp_item.num = ditem[drop_index].count
				
				--找武将 是否首次获取看背包有没有 为空代表是物品
				local item = ed:FindBy("item_id",tmp_item.id)
				if item == nil then
					local cmd = NewCommand("ErrorInfo")
					cmd.error_id = G_ERRCODE["LOTTERY_ITEM_ERROR"]
					role:SendToClient(SerializeCommand(cmd))	
					return
				end

				if item.item_type == 21 then
					--找一下是否首次获得
					local heroid =  item.type_data1 --这个是武将id 不是模板id
					local hero_map = role._roledata._hero_hall._heros
					local h = hero_map:Find(heroid)	
					if h ~= nil then
						--转换成武魂物品
						tmp_item.firstget = 0
					else
						--第一次获取
						tmp_item.firstget = 1 	
					end
					tmp_item.bproorhero = 1
					for i = 1, tmp_item.num do
						HERO_AddHero(role, item.type_data1, 0, source_id)
					end
				else	
					tmp_item.firstget = 0 	
					tmp_item.bproorhero = 0					
					BACKPACK_AddItem(role,tmp_item.id,tmp_item.num, source_id)
				end

				resp.reward_ids[#resp.reward_ids+1]= tmp_item
			end
		end
		drop_id = lottery.drop_id
	end
	
	--加固定奖励
	for index = 1, lottery.lottery_times do
		local Reward = DROPITEM_Reward(role, reward_id)
		ROLE_AddReward(role, Reward, source_id)
	end

	TASK_ChangeCondition(role, G_ACH_TYPE["STAGE_COUNT"], G_ACH_EIGHT_TYPE["LOTTERY"] , lottery.lottery_times)

	ROLE_UpdateLotteryInfo(role)
	player:SendToClient(SerializeCommand(resp))
end
