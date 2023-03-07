function OnMessage_TopListInsertInfo(player, role, arg, others)
	player:Log("OnMessage_TopListInsertInfo, "..DumpTable(arg).." "..DumpTable(others))
	
	TOP_InsertData(others.toplist._data._top_data, arg.typ, role._roledata._base._id, arg.data, arg.data2,
			role._roledata._base._name, role._roledata._base._photo, role._roledata._base._photo_frame, 
			role._roledata._base._badge_map, role._roledata._status._level, 0, 0, 0)
end
