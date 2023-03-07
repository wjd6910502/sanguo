function OnCommand_DailySign(player, role, arg, others)
	player:Log("OnCommand_DailySign, "..DumpTable(arg).." "..DumpTable(others))

	--数据统计日志
	local source_id = G_SOURCE_TYP["DAILY_SIGN"]

	local now = API_GetTime()
 	--5*3600
	now = now - 18000
	local now_time = os.date("*t", now)
	
	local resp = NewCommand("DailySign_Re")
	if now_time.yday == role._roledata._status._dailly_sign._today_flag then
		resp.retcode = G_ERRCODE["DAILY_SIGN_HAVE"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_DailySign, error=DAILY_SIGN_HAVE")
		return
	end

 	role._roledata._status._dailly_sign._sign_date = role._roledata._status._dailly_sign._sign_date + 1
 	role._roledata._status._dailly_sign._today_flag = now_time.yday

	local ed = DataPool_Find("elementdata")
	local index = math.fmod(role._roledata._status._dailly_sign._sign_date, 150)
	if index == 0 then
		index = 150
	end
	local sign_info = ed:FindBy("sign_daily", index)
	if sign_info == nil then
		resp.retcode = G_ERRCODE["DAILY_DATA_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_DailySign, error=DAILY_DATA_ERR")
		return
	end

	local Reward = DROPITEM_Reward(role, sign_info.sign_reward_id)
	ROLE_AddReward(role, Reward, source_id)

	local reward_info = {}
	local item_count = table.getn(Reward.item)
	resp.retcode = G_ERRCODE["SUCCESS"]
	resp.item = {}
	for i = 1, item_count do
		reward_info.tid = Reward.item[i].itemid
		reward_info.count = Reward.item[i].itemnum
		resp.item[#resp.item+1] = reward_info
	end
	resp.sign_date = role._roledata._status._dailly_sign._sign_date
	resp.today_flag = 1
	player:SendToClient(SerializeCommand(resp))

	--这里是宝箱成就
	TASK_ChangeCondition(role, G_ACH_TYPE["CHONGZHI"], G_ACH_NINTEEN_TYPE["DAILYSIGNBOX"], 1)
end
