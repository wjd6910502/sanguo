function OnMessage_MafiaHeartBeat(mafia, arg, others)
--	API_Log("OnMessage_MafiaHeartBeat, "..DumpTable(arg).." "..DumpTable(others))

	--Ŀǰֻ��Ҫ����һ�����飬�Ǿ��ǲ鿴�Ƿ���Ҫ��ռ�����ȡ�
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
