function OnMessage_UpdateRoleMaShuScoreAllRoleTop(player, role, arg, others)
	player:Log("OnMessage_UpdateRoleMaShuScoreAllRoleTop, "..DumpTable(arg).." "..DumpTable(others))

	TOP_ALL_Role_UpdateData(others.toplist_all_role._data._data, 1, role._roledata._base._id, role._roledata._base._name,
		role._roledata._base._photo, role._roledata._status._level, role._roledata._mafia._name, 100, 0)
end
