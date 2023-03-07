function OnCommand_LegionGetInfo(player, role, arg, others)
	player:Log("OnCommand_LegionGetInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("LegionGetInfo_Re")
	resp.junxueguan_level = role._roledata._legion_info._junxueguan._level
	player:SendToClient(SerializeCommand(resp))
end
