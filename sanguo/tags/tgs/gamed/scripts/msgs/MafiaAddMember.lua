function OnMessage_MafiaAddMember(player, role, arg, others)
	player:Log("OnMessage_MafiaAddMember, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("MafiaUpdateMemberInfo")
	resp.flag = 1
	resp.member = arg.member_info

	player:SendToClient(SerializeCommand(resp))
end
