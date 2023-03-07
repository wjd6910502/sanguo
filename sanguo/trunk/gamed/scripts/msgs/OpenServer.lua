function OnMessage_OpenServer(playermap, msg)
	API_Log("OnMessage_OpenServer, "..DumpTable(msg))

	local mist = API_GetLuaMisc()
	local topdata = API_GetLuaTopList()._data
	local top = topdata._top_data
	local pve_arena = API_GetLuaPveArena()._data
	local allrole_top = API_GetLuaTopList_All_Role()._data._data
	local mafia_map = API_Mafia_GetMap()
	local mafia_insert_info = API_GetLuaMafia_Info()
	local version_info = API_GetLuaVersion_Info()

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
		top_list._top_list_type = 4
		top:Insert(4, top_list)
		top_list._top_list_type = 5
		top:Insert(5, top_list)
		top_list._top_list_type = 6
		top:Insert(6, top_list)
		top_list._top_list_type = 7
		top:Insert(7, top_list)
		top_list._top_list_type = 8
		top:Insert(8, top_list)
		top_list._top_list_type = 9
		top:Insert(9, top_list)
		top_list._top_list_type = 10
		top:Insert(10, top_list)
		top_list._top_list_type = 11
		top:Insert(11, top_list)
		top_list._top_list_type = 12
		top:Insert(12, top_list)

		--������Ϣ
		--�ʻ������⴦��
		local t = top:Find(9)
		if t ~= nil then
			local index = math.random(1, 3)
			t._reward_info._new_data1 = index
			t._reward_info._new_data2 = index
		end

		local insert_top = CACHE.TopListAllRoleDataMapData()
		insert_top._typ = 1
		allrole_top:Insert(1, insert_top)
		
		local insert_top = CACHE.TopListAllRoleDataMapData()
		insert_top._typ = 2
		allrole_top:Insert(2, insert_top)
		
		local insert_top = CACHE.TopListAllRoleDataMapData()
		insert_top._typ = 3
		allrole_top:Insert(3, insert_top)

		PVEARENA_InitArenaRobotData()
	end

	--�Զ����ɵ����а񣬴�1001��ʼ
	if topdata._top_list_type == 0 then
		topdata._top_list_type = 1001
	end

	for i = 1, 12 do
		if top:Find(i) == nil then
			local top_list = CACHE.TopList()
			top_list._top_list_type = i
			top:Insert(i, top_list)
		end
	end

	for i = 1, 3 do
		if allrole_top:Find(i) == nil then
			local insert_top = CACHE.TopListAllRoleDataMapData()
			insert_top._typ = i
			allrole_top:Insert(i, insert_top)
		end
	end

	--���а��ˢ��ʱ��
	local top_it = top:SeekToBegin()
	local toplist = top_it:GetValue()
	while toplist ~= nil do
		if toplist._new_top_list_by_data._timestamp == 0 then
			local toplist_data = ed:FindBy("rankinglist_id", toplist._top_list_type)
			local now = API_GetTime()
			local wday = os.date("*t", now).wday-1
			if wday == 0 then
				wday = 7
			end
			if toplist_data ~= nil then
				if toplist_data.refresh_cycle_type == G_TOPLIST_REFRESH_TYP["DAILY"] then
					toplist._new_top_list_by_data._timestamp = API_MakeTodayTime(toplist_data.refresh_time, 0, 0)
					if toplist._new_top_list_by_data._timestamp <= now then
						toplist._new_top_list_by_data._timestamp = toplist._new_top_list_by_data._timestamp + 3600*24
					end
				elseif toplist_data.refresh_cycle_type == G_TOPLIST_REFRESH_TYP["WEEK"] then
					local weekday = math.floor(toplist_data.refresh_time/100)
					local hour = toplist_data.refresh_time - weekday*100
					if weekday <= wday then
						weekday = weekday + 7
					end
					toplist._new_top_list_by_data._timestamp = API_MakeTodayTime(hour, 0, 0)+(weekday-wday)*3600*24
					if toplist._new_top_list_by_data._timestamp <= now then
						toplist._new_top_list_by_data._timestamp = toplist._new_top_list_by_data._timestamp + 7*3600*24
					end
				end
			else
				toplist._new_top_list_by_data._timestamp = API_MakeTodayTime(5, 0, 0)
			end
		end
		top_it:Next()
		toplist = top_it:GetValue()
	end

	--JJC����ʱ��
	if pve_arena._time_stamp == 0 then
		local now = API_GetTime()
		local reward_time = API_MakeTodayTime(quanju.arena_reward_time, 0, 0)
		if now >= reward_time then
			pve_arena._time_stamp = reward_time
		else
			pve_arena._time_stamp = reward_time - 24*3600
		end
	end

	--����������ɨ������ʱ��
	local allrole_top_info_it = allrole_top:SeekToBegin()
	local allrole_top_info = allrole_top_info_it:GetValue()
	while allrole_top_info ~= nil do
		if allrole_top_info._typ == 1 or allrole_top_info._typ == 2 or allrole_top_info._typ == 3 then
			local now = API_GetTime()
			if allrole_top_info._time_stamp == 0 then
				local reward_time = API_MakeTodayTime(quanju.global_reset_time, 0, 0)
				if now >= reward_time then
					allrole_top_info._time_stamp = reward_time
				else
					allrole_top_info._time_stamp = reward_time - 24*3600
				end
			else
				--����һ��ʱ��
				if allrole_top_info._time_stamp > now then
					local reward_time = API_MakeTodayTime(quanju.global_reset_time, 0, 0)
					if now >= reward_time then
						allrole_top_info._time_stamp = reward_time
					else
						allrole_top_info._time_stamp = reward_time - 24*3600
					end
				end
			end
		end
		
		allrole_top_info_it:Next()
		allrole_top_info = allrole_top_info_it:GetValue()
	end

	--�����Ϣ�Ĵ���,������Ҫ��һ���޸ģ����ǰ��Ѿ�ɾ���İ��Ͳ����ٽ��м�����
	local time1 = API_GetTime()
	local mafia_info_it = mafia_map:SeekToBegin()
	local mafia_info = mafia_info_it:GetValue()
	while mafia_info ~= nil do
		--������ֻ���в����������Ϊ����������еİ��ֻ��һ��
		if mafia_info._data._deleted ~= 1 then
			local mafia_level_info = mafia_insert_info._data._mafia_info:Find(mafia_info._data._level)
			if mafia_level_info == nil then
				local insert_mafia_info_list = CACHE.Mafia_InfoMapData()
				insert_mafia_info_list._level = mafia_info._data._level
				local insert_mafia_info = CACHE.Mafia_Info()
				
				insert_mafia_info._id = mafia_info._data._id
				insert_mafia_info._name = mafia_info._data._name
				insert_mafia_info._announce = mafia_info._data._announce
				insert_mafia_info._declaration = mafia_info._data._declaration
				insert_mafia_info._level = mafia_info._data._level
				insert_mafia_info._boss_id = mafia_info._data._boss_id
				insert_mafia_info._boss_name = mafia_info._data._boss_name
				insert_mafia_info._level_limit = mafia_info._data._level_limit
				insert_mafia_info._num = mafia_info._data._member_map:Size()

				insert_mafia_info_list._info:Insert(insert_mafia_info._id, insert_mafia_info)

				mafia_insert_info._data._mafia_info:Insert(mafia_info._data._level, insert_mafia_info_list)
			else
				--�ж��Ƿ��Ѿ�������
				local insert_mafia_info = CACHE.Mafia_Info()
				insert_mafia_info._id = mafia_info._data._id
				insert_mafia_info._name = mafia_info._data._name
				insert_mafia_info._announce = mafia_info._data._announce
				insert_mafia_info._level = mafia_info._data._level
				insert_mafia_info._boss_id = mafia_info._data._boss_id
				insert_mafia_info._boss_name = mafia_info._data._boss_name
				insert_mafia_info._level_limit = mafia_info._data._level_limit
				insert_mafia_info._num = mafia_info._data._member_map:Size()
				
				mafia_level_info._info:Insert(insert_mafia_info._id, insert_mafia_info)
			end
		end

		mafia_info_it:Next()
		mafia_info = mafia_info_it:GetValue()
	end
	local time1 = API_GetTime()
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
		API_Log("for role id: "..r._roledata._base._id:ToStr().." name: "..r._roledata._base._name.." time: "..r._roledata._base._create_time)
		if r._roledata._base._id:Less(10+1) then --role_id[1,10]ΪϵͳĬ�Ͻ�ɫ
			if r._roledata._base._create_time==0 then
				r._roledata._base._create_time = API_GetTime()
				--����ͬ������ɫ
				ROLE_Init(r)--��ɫ��һЩ���ݽ��г�ʼ��
				TASK_RefreshTask(r)--��ɫ�ĳɾͽ��г�ʼ��
				TASK_ChangeCondition(r, G_ACH_TYPE["LEVEL_FINISH"], 0, r._roledata._status._level)
			end
		else
			local cache = API_GetLuaRoleNameCache()
			local rolebrief = CACHE.RoleBrief()
			rolebrief._id = r._roledata._base._id
			rolebrief._name = r._roledata._base._name
			rolebrief._photo = r._roledata._base._photo
			rolebrief._level = r._roledata._status._level
			rolebrief._mafia_id = r._roledata._mafia._id
			rolebrief._mafia_name = r._roledata._mafia._name
			rolebrief._sex = r._roledata._base._sex
			rolebrief._photo_frame = r._roledata._base._photo_frame
			rolebrief._badge_map = CACHE.BadgeInfoMap()
			local badge_info_it = r._roledata._base._badge_map:SeekToBegin()
			local badge_info = badge_info_it:GetValue()
			while badge_info ~= nil do
				local tmp_badge_info = CACHE.BadgeInfo()
				tmp_badge_info._id = badge_info._id
				tmp_badge_info._pos = badge_info._pos
				rolebrief._badge_map:Insert(tmp_badge_info._id, tmp_badge_info)

				badge_info_it:Next()
				badge_info = badge_info_it:GetValue()
			end
			cache:Insert(rolebrief)
		end
		it:Next()
		r = it:GetValue()
	end

	--for role in Cache_Map(playermap) do
	--	ROLE_OnlineInit(role)
	--end
	local time1 = API_GetTime()
	--���ð汾����Ϣ
	local version_data = version_info._data._version_info
	version_data:Clear()
	for key, value in pairs(G_VERSION_INFO) do

		local find_version_info = version_data:Find(key)
		if find_version_info == nil then
			local insert_list = CACHE.VersionDataList()
			version_data:Insert(key, insert_list)
		end

		for i = 1, table.getn(value) do
			find_version_info = version_data:Find(key)
			local insert_data = CACHE.VersionData()
			insert_data._exe_ver = value[i].exe_ver
			insert_data._res_ver = value[i].res_ver
			find_version_info:PushBack(insert_data)
		end
	end
	--for r in Cache_ReverseMap(playermap) do
	--	API_Log("for role id: "..r._roledata._base._id:ToStr().." name: "..r._roledata._base._name)
	--end

	--����API������ȥ����һ��C++�еĳ�ʼ������
	--����
	API_OpenServer()
	local time1 = API_GetTime()

	API_Log("OnMessage_OpenServer, END")
end