function OnMessage_MafiaDelNewApply(player, role, arg, others)
	player:Log("OnMessage_MafiaDelNewApply, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("MafiaUpdateApplyList")
	resp.del_flag = 1
	resp.apply_info = {}
	
	resp.apply_info.id = arg.id

	player:SendToClient(SerializeCommand(resp))
end
