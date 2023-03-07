function OnMessage_ClearPveArenaTop(player, role, arg, others)
	--player:Log("OnMessage_ClearPveArenaTop, "..DumpTable(arg).." "..DumpTable(others))
	
	others.toplist._data._top_data:Delete(4)
	local top_list = CACHE.TopList()
	top_list._top_list_type = 4
	others.toplist._data._top_data:Insert(4, top_list)
end
