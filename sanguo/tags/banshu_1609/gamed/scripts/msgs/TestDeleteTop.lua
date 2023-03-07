function OnMessage_TestDeleteTop(player, role, arg, others)
	player:Log("OnMessage_TestDeleteTop, "..DumpTable(arg).." "..DumpTable(others))
	
	TOP_DeleteData(others.toplist._data._top_data, arg.id, role._roledata._base._id)
end
