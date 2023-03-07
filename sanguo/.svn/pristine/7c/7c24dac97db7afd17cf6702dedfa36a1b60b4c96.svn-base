function OnMessage_YueZhanInfo(player, role, arg, others)
	player:Log("OnMessage_YueZhanInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("YueZhanInfo")

	resp.id = arg.id
	resp.channel = arg.channel
	resp.typ = arg.typ
	resp.announce = arg.announce
	resp.info_id = arg.info_id
	resp.creater = arg.creater
	resp.joiner = arg.joiner
	resp.time = API_GetTime()

	player:SendToClient(SerializeCommand(resp)) 
end
