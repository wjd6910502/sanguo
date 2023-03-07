function OnMessage_RoleUpdateInfoMafiaTop(player, role, arg, others)
	player:Log("OnMessage_RoleUpdateInfoMafiaTop, "..DumpTable(arg).." "..DumpTable(others))

	local mafia_data = others.mafias[arg.mafia_id]
	local mafia_info = mafia_data._data

	TOP_InsertData(others.toplist._data._top_data, mafia_info._mashu_toplist_id, role._roledata._base._id, arg.data,
			role._roledata._base._name, role._roledata._base._photo, role._roledata._base._photo_frame, role._roledata._base._badge_map,
			role._roledata._status._level, 0, 0, 0)

	mafia_info._all_mashu_score = mafia_info._all_mashu_score + arg.score

	TOP_InsertData(others.toplist._data._top_data, 8, mafia_info._id, mafia_info._all_mashu_score,
			mafia_info._name, mafia_info._flag,0, CACHE.BadgeInfoMap(), mafia_info._level, 0, 0, 0)
end
