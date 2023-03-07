function OnMessage_RoleUpdateInfoMafiaTop(player, role, arg, others)
	player:Log("OnMessage_RoleUpdateInfoMafiaTop, "..DumpTable(arg).." "..DumpTable(others))

	TOP_InsertData(others.toplist._data._top_data, arg.typ_id, role._roledata._base._id, arg.data,
			role._roledata._base._name, role._roledata._base._photo, role._roledata._status._level, 0, 0, 0)

end
