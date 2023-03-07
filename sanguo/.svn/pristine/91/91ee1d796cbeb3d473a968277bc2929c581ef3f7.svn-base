function OnMessage_SendNotice(player, role, arg, others)
	player:Log("OnMessage_SendNotice, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("SendNotice")
	resp.notice_id = arg.notice_id
	resp.notice_para = arg.notice_para
	resp.time = API_GetTime()
	
	player:SendToClient(SerializeCommand(resp))
end
