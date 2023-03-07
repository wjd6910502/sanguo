function OnMessage_TongQueTaiReload(player, role, arg, others)
	player:Log("OnMessage_TongQueTaiReload, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("TongQueTaiReLoad")
	resp.retcode = arg.retcode
	resp.role_index = arg.role_index
	resp.monster_index = arg.monster_index

	player:SendToClient(SerializeCommand(resp))
end
