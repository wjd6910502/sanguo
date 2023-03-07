function OnMessage_TongQueTaiNoticeRoleJoin(player, role, arg, others)
	player:Log("OnMessage_TongQueTaiNoticeRoleJoin, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("TongQueTaiNoticeRoleJoin")
	player:SendToClient(SerializeCommand(resp))
end
