function OnMessage_AudienceUpdateNum(player, role, arg, others)
	player:Log("OnMessage_AudienceUpdateNum, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("AudienceUpdateNum")
	resp.num = arg.num
	player:SendToClient(SerializeCommand(resp))
end
