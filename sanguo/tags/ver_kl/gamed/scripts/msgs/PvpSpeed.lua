function OnMessage_PvpSpeed(player, role, arg, others)
	player:Log("OnMessage_PvpSpeed, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("PvpSpeed")
	resp.speed = arg.speed
	player:SendToClient(SerializeCommand(resp))
end
