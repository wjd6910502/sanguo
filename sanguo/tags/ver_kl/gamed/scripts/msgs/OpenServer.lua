function OnMessage_OpenServer(playermap, msg)
	API_Log("OnMessage_OpenServer, "..DumpTable(msg))

	local mist = API_GetLuaMisc()
	local top = API_GetLuaTopList()._top_manager
	local pve_arena = API_GetLuaPveArena()._data

	local server_time = mist._miscdata._open_server_time


	--PVP赛季的结束时间
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	
	if server_time == 0 then
		if quanju.pvp_3v3_season_reset_time >= 0 and quanju.pvp_3v3_season_reset_time <= 23 then
			mist._miscdata._open_server_time = API_MakeTodayTime(quanju.pvp_3v3_season_reset_time, 0, 0)
			mist._miscdata._pvp_season_end_time = mist._miscdata._open_server_time
		else
			mist._miscdata._open_server_time = API_MakeTodayTime(0, 0, 0)
			mist._miscdata._pvp_season_end_time = mist._miscdata._open_server_time
		end
		local top_list = CACHE.TopList()
		
		top_list._top_list_type = 1
		top:Insert(1, top_list)
		top_list._top_list_type = 2
		top:Insert(2, top_list)
		top_list._top_list_type = 3
		top:Insert(3, top_list)
		top_list._top_list_type = 4
		top:Insert(4, top_list)
		top_list._top_list_type = 5
		top:Insert(5, top_list)
		top_list._top_list_type = 6
		top:Insert(6, top_list)
	end

	for i = 1, 6 do
		if top:Find(i) == nil then
			local top_list = CACHE.TopList()
			top_list._top_list_type = i
			top:Insert(i, top_list)
		end
	end

	--排行榜的刷新时间
	local top_it = top:SeekToBegin()
	local toplist = top_it:GetValue()
	while toplist ~= nil do
		if toplist._new_top_list_by_data._timestamp == 0 then
			local now = API_GetTime()
			if quanju.pvp_3v3_daily_reward_time >= 0 and quanju.pvp_3v3_daily_reward_time <= 23 then
				toplist._new_top_list_by_data._timestamp = API_MakeTodayTime(quanju.pvp_3v3_daily_reward_time, 0, 0)
				if toplist._new_top_list_by_data._timestamp <= now then
					toplist._new_top_list_by_data._timestamp = toplist._new_top_list_by_data._timestamp + 3600*24
				end
			else
				toplist._new_top_list_by_data._timestamp = API_MakeTodayTime(5, 0, 0)
				if toplist._new_top_list_by_data._timestamp <= now then
					toplist._new_top_list_by_data._timestamp = toplist._new_top_list_by_data._timestamp + 3600*24
				end
			end
		end
		top_it:Next()
		toplist = top_it:GetValue()
	end

	--JJC发奖时间
	if pve_arena._time_stamp == 0 then
		local now = API_GetTime()
		local reward_time = API_MakeTodayTime(quanju.arena_reward_time, 0, 0)
		if now >= reward_time then
			pve_arena._time_stamp = reward_time
		else
			pve_arena._time_stamp = reward_time - 24*3600
		end
	end
	

	--初始化版本限制信息(临时)
	local client_ver_limit_map = mist._miscdata._client_ver_limit_map
	local cvl = CACHE.ClientVersionLimit()
	cvl._client_id = "Android 2016-04-14"
	cvl._exe_ver_min = "10"
	cvl._data_ver_min = "100"
	client_ver_limit_map:Insert(cvl._client_id, cvl)

	--初始化模板用户
	if not API_InitSystemPlayers() then
		error("API_InitSystemPlayers")
	end

	local it = playermap:SeekToBegin()
	local r = it:GetValue()
	while r~=nil do
		API_Log("for role id: "..r._roledata._base._id:ToStr().." name: "..r._roledata._base._name.." time: "..r._roledata._base._create_time)
		if r._roledata._base._id:Less(10+1) and r._roledata._base._create_time==0 then --role_id[1,10]为系统默认角色
			r._roledata._base._create_time = API_GetTime()
			--以下同创建角色
			ROLE_Init(r)--角色的一些数据进行初始化
			TASK_RefreshTask(r)--角色的成就进行初始化
			TASK_ChangeCondition(r, G_ACH_TYPE["LEVEL_FINISH"], 0, r._roledata._status._level)
		end
		it:Next()
		r = it:GetValue()
	end

	for role in Cache_Map(playermap) do
		ROLE_OnlineInit(role)
	end

	--for r in Cache_ReverseMap(playermap) do
	--	API_Log("for role id: "..r._roledata._base._id:ToStr().." name: "..r._roledata._base._name)
	--end

	--调用API函数，去处理一下C++中的初始化数据
	--开服
	API_OpenServer()
end
