function OnMessage_PveArenaSendReward(arg, others)
	--API_Log("OnMessage_PveArenaSendReward, "..DumpTable(arg))
	local pve_arena = others.pvearena._data

	PVEARENA_SendRewardOnTime(pve_arena._pve_arena_data_map_data)
end
