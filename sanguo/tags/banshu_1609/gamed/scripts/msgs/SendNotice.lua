function OnMessage_SendNotice(player, role, arg, others)
	player:Log("OnMessage_SendNotice, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("SendNotice")
	resp.notice_id = arg.notice_id
	resp.notice_para = arg.notice_para
	
	player:SendToClient(SerializeCommand(resp))
end
