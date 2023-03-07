function OnMessage_JieYiUpdateReply(player, role, arg, others)
	player:Log("OnMessage_JieYiUpdateReply, "..DumpTable(arg).." "..DumpTable(others))
		
	local resp = NewCommand("JieYiReply_Re")
	
	resp.id  =  arg.id
	resp.retcode = arg.agreement		
	resp.typ = arg.typ
	resp.role_id = arg.role_id
	role:SendToClient(SerializeCommand(resp))
		
end

