function OnMessage_MafiaUpdateExp(player, role, arg, others)
	player:Log("OnMessage_MafiaUpdateExp, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("MafiaUpdateExp")
	resp.jisi = arg.jisi
	resp.exp = arg.exp
	resp.level = arg.level

	player:SendToClient(SerializeCommand(resp))
end
