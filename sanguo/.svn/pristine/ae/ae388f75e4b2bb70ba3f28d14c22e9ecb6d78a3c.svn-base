function OnMessage_TestFloat(player, role, arg, others)
	--player:Log("OnMessage_TestFloat, "..DumpTable(arg).." "..DumpTable(others))

	local cmd = NewCommand("TestFloat")
	cmd.seed = arg.seed
	cmd.count = arg.count
	player:SendToClient(SerializeCommand(cmd))
end
