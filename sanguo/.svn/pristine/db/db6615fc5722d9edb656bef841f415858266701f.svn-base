function OnMessage_DeleteMafiaInfoTop(arg, others)
	API_Log("OnMessage_DeleteMafiaInfoTop, "..DumpTable(arg))
	
	local mafia_info = others.mafia_info
	local mafia_level_info = mafia_info._data._mafia_info:Find(arg.level)

--	local del_id = CACHE.Int64()
--	del_id:Set(arg.id)

--	mafia_level_info._info:Delete(del_id)
	if mafia_level_info._info:Find(CACHE.Int64(arg.id)) ~= nil then
		API_Log("222222222222222222222222222222222222222222222222222222222222222222")
		mafia_level_info._info:Delete(CACHE.Int64(arg.id))
	end
end
