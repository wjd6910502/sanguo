function OnMessage_MafiaAddNewApply(player, role, arg, others)
	player:Log("OnMessage_MafiaAddNewApply, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("MafiaUpdateApplyList")
	resp.del_flag = 0
	resp.apply_info = {}
	
	resp.apply_info.id = arg.id
	resp.apply_info.name = arg.name
	resp.apply_info.photo = arg.photo
	resp.apply_info.level = arg.level
	resp.apply_info.zhanli = arg.zhanli

	player:SendToClient(SerializeCommand(resp))
end
