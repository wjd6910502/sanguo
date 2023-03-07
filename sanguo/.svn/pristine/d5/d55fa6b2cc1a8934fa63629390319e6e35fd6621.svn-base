function OnMessage_TestDeleteTop(player, role, arg, others)
	player:Log("OnMessage_TestDeleteTop, "..DumpTable(arg).." "..DumpTable(others))
	
	TOP_DeleteData(others.toplist._top_manager, 4, role._roledata._base._id, role._roledata._pve_arena_info._score, 
			role._roledata._base._name, role._roledata._base._photo, role._roledata._status._level, 0, 0, 0)
end
