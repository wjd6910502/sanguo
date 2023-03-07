function OnMessage_UpdateRoleMaShuScoreTop(player, role, arg, others)
	player:Log("OnMessage_UpdateRoleMaShuScoreTop, "..DumpTable(arg).." "..DumpTable(others))

	TOP_InsertData(others.toplist._data._top_data, 7, role._roledata._base._id, role._roledata._mashu_info._today_max_score, 
			role._roledata._base._name, role._roledata._base._photo, role._roledata._status._level, 0, 0, 0)

end
