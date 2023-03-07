function OnMessage_OpenServer(playermap, mafiamap, msg)
	API_Log("OnMessage_OpenServer, "..DumpTable(msg))

	local mist = API_GetLuaMiscManager()
	local top = API_GetLuaTopManager()._top_manager

	local server_time = mist._miscdata._open_server_time


	--PVP�����Ľ���ʱ��
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
	end

	--���а��ˢ��ʱ��
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

	--��ʼ���汾������Ϣ(��ʱ)
	local client_ver_limit_map = mist._miscdata._client_ver_limit_map
	local cvl = CACHE.ClientVersionLimit()
	cvl._client_id = "Android 2016-04-14"
	cvl._exe_ver_min = "10"
	cvl._data_ver_min = "100"
	client_ver_limit_map:Insert(cvl._client_id, cvl)

	--��ʼ��ģ���û�
	if not API_InitSystemPlayers() then
		error("API_InitSystemPlayers")
	end

	local it = playermap:SeekToBegin()
	local r = it:GetValue()
	while r~=nil do
		API_Log("for role id: "..r._roledata._base._id:ToStr().." name: "..r._roledata._base._name)
		if r._roledata._base._id:Less(10+1) and r._roledata._base._create_time==0 then --role_id[1,10]ΪϵͳĬ�Ͻ�ɫ
			r._roledata._base._create_time = API_GetTime()
			--����ͬ������ɫ
			ROLE_Init(r)--��ɫ��һЩ���ݽ��г�ʼ��
			TASK_RefreshTask(r)--��ɫ�ĳɾͽ��г�ʼ��
			TASK_ChangeCondition(r, G_ACH_TYPE["LEVEL_FINISH"], 0, r._roledata._status._level)
		end
		it:Next()
		r = it:GetValue()
	end

	--����API������ȥ����һ��C++�еĳ�ʼ������
	--����
	API_OpenServer()
end