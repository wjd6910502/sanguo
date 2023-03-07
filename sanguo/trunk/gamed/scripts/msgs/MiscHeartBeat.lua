function OnMessage_MiscHeartBeat(arg, others)
	--API_Log("OnMessage_MiscHeartBeat, "..DumpTable(arg).." "..DumpTable(others))

	local mist = others.misc

	--�������������Ƿ����
	local server_event = mist._miscdata._server_event
	local now = API_GetTime()
	--��������Ϊ���������10�����һ�εġ�
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	if now <= (mist._miscdata._pvp_season_end_time +quanju.pvp_3v3_season_period*3600*24) and 
	(now + 10) > (mist._miscdata._pvp_season_end_time + quanju.pvp_3v3_season_period*3600*24) then
		local msg = NewMessage("PvpSeasonFinish")
		mist:SendMessage(SerializeMessage(msg), now - (mist._miscdata._pvp_season_end_time+ quanju.pvp_3v3_season_period*3600*24))
		local ed = DataPool_Find("elementdata")
		local quanju = ed.gamedefine[1]
		mist._miscdata._pvp_season_end_time = mist._miscdata._pvp_season_end_time + quanju.pvp_3v3_season_period*3600*24
	elseif now > (mist._miscdata._pvp_season_end_time+quanju.pvp_3v3_season_period*3600*24) then
		--������������п��������ڵ�ʱ��ͣ��ά�������Ե������������
		local msg = NewMessage("PvpSeasonFinish")
		mist:SendMessage(SerializeMessage(msg), 0)
		local ed = DataPool_Find("elementdata")
		local quanju = ed.gamedefine[1]
		mist._miscdata._pvp_season_end_time = mist._miscdata._pvp_season_end_time + quanju.pvp_3v3_season_period*3600*24
	end

	--�����ﴦ����ʱ��event
	local event_it = server_event._event_info:SeekToBegin()
	local event = event_it:GetValue()
	local del_event = {}
	while event ~= nil do
		if event._event_end_time <= now then
			del_event[#del_event+1] = event._event_id
		end
		event_it:Next()
		event = event_it:GetValue()
	end
	for i = 1, table.getn(del_event) do
		server_event._event_info:Delete(del_event[i])
	end

	--�����ﴦ����ҽ�ֹ��½����ҽ����б�
	local forbidlodgin = mist._miscdata._forbidlogin_role_map
	for role in Cache_Map(forbidlodgin) do
		if now > (role._begintime+role._time*60) then
			forbidlodgin:Delete(role._roleid)
		end
	end
	local forbidtalk = mist._miscdata._forbidtalk_role_map
	for role in Cache_Map(forbidtalk) do
		if now > (role._begintime+role._time*60) then
			forbidtalk:Delete(role._roleid)
		end
	end


	--����������־��ÿ5�������һ��
	local date = os.date("%Y-%m-%d %H:%M:%S", now)
	local minute = os.date("%M", now)
	local second = os.date("%S", now)
	if tonumber(minute)%5 == 0 and tonumber(second) < 10 then
		API_BILog("{\"logtime\":\""..date.."\",\"logname\":\"onlineuser\",\"serverid\":\""..API_GetZoneId()..
			"\",\"os\":\"".."0".."\",\"platform\":\"".."laohu".."\",\"currentuser\":\""..API_GetActiveRoleCount().."\"}")
	end
end