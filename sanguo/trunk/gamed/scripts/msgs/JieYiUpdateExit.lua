function OnMessage_JieYiUpdateExit(player, role, arg, others)
	player:Log("OnMessage_JieYiUpdateExit, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("JieYiExitCurrentJieYi_Re")
	resp.id = arg.id
	resp.retcode = arg.retcode
	resp.name = arg.name
	resp.brother_id = arg.brother_id 
	role:SendToClient(SerializeCommand(resp))	
	
end
