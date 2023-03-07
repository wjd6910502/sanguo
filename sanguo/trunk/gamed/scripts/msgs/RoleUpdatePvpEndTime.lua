function OnMessage_RoleUpdatePvpEndTime(player, role, arg, others)
	player:Log("OnMessage_RoleUpdatePvpEndTime, "..DumpTable(arg).." "..DumpTable(others))

	local mist = others.misc
	role._roledata._pvp_info._pvp_season_end_time = mist._miscdata._pvp_season_end_time
	role._roledata._pvp_info._pvp_server_season_end_time = mist._miscdata._pvp_season_end_time

	local cmd = NewCommand("UpdatePvpEndTime")
	cmd.end_time = role._roledata._pvp_info._pvp_season_end_time
	player:SendToClient(SerializeCommand(cmd))
end
