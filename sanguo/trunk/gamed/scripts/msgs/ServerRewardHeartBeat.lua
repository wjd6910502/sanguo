function OnMessage_ServerRewardHeartBeat(arg, others)
	API_Log("OnMessage_ServerRewardHeartBeat, "..DumpTable(arg)..", others="..DumpTable(others))

	local now = API_GetTime()
	local expireds = {}

	local manager = others.server_reward._data
	for sr in Cache_Map(manager._map) do
		--�ж���Ч��
		if now>sr._end_time then
			--�Ѿ�������
			expireds[#expireds+1] = sr._id
		end
	end

	for _,id in ipairs(expireds) do
		manager._map:Delete(id)
	end
end
