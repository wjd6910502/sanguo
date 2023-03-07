function OnMessage_MafiaUpdateMember(player, role, arg, others)
	player:Log("OnMessage_MafiaUpdateMember, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("MafiaUpdateMemberInfo")
	resp.flag = 0
	resp.member = arg.member_info

	player:SendToClient(SerializeCommand(resp))
end
