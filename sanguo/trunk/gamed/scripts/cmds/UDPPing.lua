function OnCommand_UDPPing(player, role, arg, others)
	--player:Log("OnCommand_UDPPing, "..DumpTable(arg))

	local resp = NewCommand("UDPPing_Re")
	resp.client_send_time = arg.client_send_time
	player:SendUDPToClient(SerializeCommand(resp))
end
