function OnMessage_ErrorInfo(player, role, arg, others)
	player:Log("OnMessage_ErrorInfo, "..DumpTable(arg).." "..DumpTable(others))
	
	local resp = NewCommand("ErrorInfo")
	resp.error_id = G_ERRCODE["LOAD_ROLE_DATA_AGAIN"]
	player:SendToClient(SerializeCommand(resp))
	return
end
