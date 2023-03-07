function OnCommand_GetVersion(player, role, arg, others)
	player:Log("OnCommand_GetVersion, "..DumpTable(arg))

	local resp = NewCommand("GetVersion_Re")
	resp.version = 1
	resp.cmd_version = 2
	resp.data_version = 3
	player:SendToClient(SerializeCommand(resp))
end
