function OnCommand_GetJiaNianHuaInfo(player, role, arg, others)
	player:Log("OnCommand_GetJiaNianHuaInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("GetJiaNianHuaInfo_Re")

	local ed = DataPool_Find("elementdata")
	local mist = API_GetLuaMisc()
	local activity = ed.activity[1]
	local flag = true

	--开服活动开始5天后注册玩家无法开启开服活动
	if activity.enter_end_date ~= 0 then
		local over_day = os.date("*t", role._roledata._base._create_time).yday-os.date("*t", mist._miscdata._open_server_time).yday
		if over_day >= activity.enter_end_date then
			flag = false
		end
	end

	resp.join_flag = flag
	player:SendToClient(SerializeCommand(resp))
end
