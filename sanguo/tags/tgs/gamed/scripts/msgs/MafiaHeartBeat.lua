function OnMessage_MafiaHeartBeat(mafia, arg, others)
--	API_Log("OnMessage_MafiaHeartBeat, "..DumpTable(arg).." "..DumpTable(others))

	--目前只需要处理一个事情，那就是查看是否需要清空祭祀进度。
	local ed = DataPool_Find("elementdata")
	local quanju = ed.gamedefine[1]
	local mafia_info = mafia._data
	local clear_time = API_MakeTodayTime(quanju.league_build_reset_time, 0, 0)
	if mafia_info._last_heartbeat <= clear_time and arg.now > clear_time then
		if mafia_info._jisi ~= 0 then
			mafia_info._jisi = 0
			MAFIA_MafiaUpdateExp(mafia_info)
		end
	end

	mafia_info._last_heartbeat = arg.now
end
