function OnMessage_ServerRewardHeartBeat(arg, others)
	API_Log("OnMessage_ServerRewardHeartBeat, "..DumpTable(arg)..", others="..DumpTable(others))

	local now = API_GetTime()
	local expireds = {}

	local manager = others.server_reward._data
	for sr in Cache_Map(manager._map) do
		--判断有效性
		if now>sr._end_time then
			--已经过期了
			expireds[#expireds+1] = sr._id
		end
	end

	for _,id in ipairs(expireds) do
		manager._map:Delete(id)
	end
end
