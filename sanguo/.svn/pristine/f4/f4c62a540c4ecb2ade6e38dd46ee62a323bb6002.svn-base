function OnMessage_DeleteMafiaInfoTop(arg, others)
	API_Log("OnMessage_DeleteMafiaInfoTop, "..DumpTable(arg))
	
	local mafia_info = others.mafia_info
	local mafia_level_info = mafia_info._data._mafia_info:Find(arg.level)

	mafia_level_info._info:Delete(CACHE.Int64(arg.id))
end
