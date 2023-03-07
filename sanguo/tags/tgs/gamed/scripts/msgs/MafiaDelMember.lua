function OnMessage_MafiaDelMember(player, role, arg, others)
	player:Log("OnMessage_MafiaDelMember, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("MafiaUpdateMemberInfo")
	resp.flag = 2
	resp.member = {}
	resp.member.id = arg.id

	player:SendToClient(SerializeCommand(resp))
end
