function OnMessage_MafiaUpdateInterfaceInfo(player, role, arg, others)
	player:Log("OnMessage_MafiaUpdateInterfaceInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("MafiaUpdateMafiaInfo")
	resp.info = arg.info

	player:SendToClient(SerializeCommand(resp))
end
