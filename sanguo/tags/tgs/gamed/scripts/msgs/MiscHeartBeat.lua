function OnMessage_MiscHeartBeat(arg, others)
	--API_Log("OnMessage_MiscHeartBeat, "..DumpTable(arg).." "..DumpTable(others))

	local mist = others.misc

	--在这里检查赛季是否结束
	local server_event = mist._miscdata._server_event
	local now = API_GetTime()
	--这里是因为这个心跳是10秒进来一次的。
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
		--如果到了这里有可能是由于当时在停服维护，所以导致了这个问题
		local msg = NewMessage("PvpSeasonFinish")
		mist:SendMessage(SerializeMessage(msg), 0)
		local ed = DataPool_Find("elementdata")
		local quanju = ed.gamedefine[1]
		mist._miscdata._pvp_season_end_time = mist._miscdata._pvp_season_end_time + quanju.pvp_3v3_season_period*3600*24
	end

	--在这里处理超时的event
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
end
