function OnMessage_MafiaAddNewApply(player, role, arg, others)
	player:Log("OnMessage_MafiaAddNewApply, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("MafiaUpdateApplyList")
	resp.del_flag = 0
	resp.apply_info = arg.apply_info
	
	player:SendToClient(SerializeCommand(resp))
end
