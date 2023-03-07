function OnCommand_GetActivityReward(player, role, arg, others)
	player:Log("OnCommand_GetActivityReward, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("GetActivityReward_Re")
	resp.activity_id = arg.activity_id
	resp.rewards = {}

	local ed = DataPool_Find("elementdata")
	local activity = ed:FindBy("activity_id", arg.activity_id)

	if activity == nil then
		resp.retcode = G_ERRCODE["ACTIVITY_NOT_EXIST"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_GetActivityReward, error=ACTIVITY_NOT_EXIST")
		return
	end

	if LIMIT_TestUseLimit(role, activity.limit_times, 1) == false then
		resp.retcode = G_ERRCODE["ACTIVITY_ALREADY_GET_REWARD"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_GetActivityReward, error=ACTIVITY_ALREADY_GET_REWARD")
		return
	end

	--判断领奖时间
	local mist = API_GetLuaMisc()
	local begindate = os.date("*t", mist._miscdata._open_server_time+activity.rewards_start_date*3600*24)
	local begin_time = begindate.year*100000000 + begindate.month*1000000 + begindate.day*10000 + activity.rewards_start_time*100
	local enddate = os.date("*t", mist._miscdata._open_server_time+activity.rewards_end_date*3600*24)
	local end_time = enddate.year*100000000 + enddate.month*1000000 + enddate.day*10000 + activity.rewards_end_time*100
	local now = API_GetTime()
	local now_time = os.date("*t", now)
	local cur_time = (now_time.year*10000 + now_time.month*100 + now_time.day)*10000+now_time.hour*100
	if cur_time < begin_time or cur_time >= end_time then
		resp.retcode = G_ERRCODE["ACTIVITY_NOT_IN_REWARD_TIME"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_GetActivityReward, error=ACTIVITY_NOT_IN_REWARD_TIME")
		return
	end

	local ach_num = 0
	local finish_num = 0
	for goal in DataPool_Array(activity.goals_data) do
		if goal.goal_id ~= 0 then
			local activitydetail = ed:FindBy("activitydetails_id", goal.goal_id)
			for l2 in DataPool_Array(activitydetail.l2_description) do
				for l3 in DataPool_Array(l2.l3_description) do
					if l3.rewarddetails ~= 0 then
						ach_num = ach_num + 1
						local task = role._roledata._task._finish_task:Find(l3.rewarddetails)
						if task ~= nil then
							finish_num = finish_num + 1
						end
					end
				end
			end
		end
	end

	--判断进度是否可以领奖
	local rate = math.ceil(finish_num/ach_num*100)

	if rate < activity.min_progress then
		resp.retcode = G_ERRCODE["ACTIVITY_CANNOT_GET_REWARD"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_GetActivityReward, error=ACTIVITY_CANNOT_GET_REWARD")
		return
	end

	--找到当前进度获得的固定奖励
	local reward_id = 0
	for progress in DataPool_Array(activity.tier_rewards) do
		if rate <= progress.tier_value then
			reward_id = progress.reward_id
			break
		end
	end

	local Reward = DROPITEM_Reward(role, reward_id)
	local add_items = ROLE_AddReward(role, Reward)

	for i =1 , #add_items do
		local tmp_item = {}
		tmp_item.tid = add_items[i].tid
		tmp_item.count = add_items[i].count
		
		resp.rewards[#resp.rewards +1] = tmp_item				
	end

	LIMIT_AddUseLimit(role, activity.limit_times, 1)

	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
	return

end
