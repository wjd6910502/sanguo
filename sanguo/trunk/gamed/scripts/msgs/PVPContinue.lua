function OnMessage_PVPContinue(player, role, arg, others)
	player:Log("OnMessage_PVPContinue, "..DumpTable(arg).." "..DumpTable(others))

	local cmd = NewCommand("PVPContinue")
	cmd.fight_continue_time = arg.continue_time
	player:SendToClient(SerializeCommand(cmd))
end
