function OnMessage_TopListUpdateInfo(player, role, arg, others)
	player:Log("OnMessage_TopListUpdateInfo, "..DumpTable(arg).." "..DumpTable(others))

	TOP_UpdateData(others.toplist._data._top_data, role._roledata._base._id, role._roledata._base._name, role._roledata._status._level,
			role._roledata._base._photo, role._roledata._base._photo_frame, role._roledata._base._badge_map)
end
