function OnMessage_PveArenaHeartBeat(arg, others)
 	--API_Log("OnMessage_PveArenaHeartBeat, "..DumpTable(arg))
	local pve_arena = others.pvearena._data
	local now = API_GetTime()

	if now >= pve_arena._time_stamp + 3600*24 then
		local ed = DataPool_Find("elementdata")
		local quanju = ed.gamedefine[1]
		PVEARENA_SendRewardOnTime(pve_arena._pve_arena_data_map_data)
		local reward_time = API_MakeTodayTime(quanju.arena_reward_time, 0, 0)
		pve_arena._time_stamp = reward_time
	end
end
