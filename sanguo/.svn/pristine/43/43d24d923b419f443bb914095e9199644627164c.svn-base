function OnCommand_FuDaiGetReward(player, role, arg, others)
	player:Log("OnCommand_FuDaiGetReward, "..DumpTable(arg).." "..DumpTable(others))

	--数据统计日志
	local source_id = 0
	
	local resp = NewCommand("FuDaiGetReward_Re")
	resp.fudai_flag = arg.fudai_flag
	resp.item = {}

	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	local reward = 0
	local limit_id = 0
	local drop = 0
	local now = API_GetTime()
	if arg.fudai_flag == 1 then
		if role._roledata._status._little_fudai > now then
			reward = quanju.month_card_daily_reward_id
			limit_id = quanju.month_card_daily_limit_id
			drop = quanju.month_card_daily_random_reward_id
		end
		source_id = G_SOURCE_TYP["LITTLE_FUDAI"]
	elseif arg.fudai_flag == 2 then
		if role._roledata._status._big_fudai > now then
			reward = quanju.month_card2_daily_reward_id
			limit_id = quanju.month_card2_daily_limit_id
			drop = quanju.month_card2_daily_random_reward_id
		end
		source_id = G_SOURCE_TYP["BIG_FUDAI"]
	end

	if limit_id ~= 0 then
		if LIMIT_TestUseLimit(role, limit_id, 1) == true then
			if reward ~= 0 then
				local Reward = DROPITEM_Reward(role, reward)
				local add_item = ROLE_AddReward(role, Reward, source_id)
				for i = 1, table.getn(add_item) do
					local instance_item = {}
					instance_item.tid = add_item[i].tid
					instance_item.count = add_item[i].count
					resp.item[#resp.item+1] = instance_item
				end
				resp.retcode = G_ERRCODE["SUCCESS"]
				LIMIT_AddUseLimit(role, limit_id, 1)
			else
				resp.retcode = G_ERRCODE["FUDAI_BUY_FIRST"]
			end
		else
			resp.retcode = G_ERRCODE["FUDAI_HAVE_GET"]
		end
	else
		resp.retcode = G_ERRCODE["FUDAI_BUY_FIRST"]
	end
	player:SendToClient(SerializeCommand(resp))
end
