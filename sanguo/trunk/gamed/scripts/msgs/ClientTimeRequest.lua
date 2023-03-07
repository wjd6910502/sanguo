function OnMessage_ClientTimeRequest(player, role, arg, others)
	--player:Log("OnMessage_ClientTimeRequest, "..DumpTable(arg).." "..DumpTable(others))

	--player:SendMessage(role._roledata._base._id, SerializeMessage(NewMessage("ClientTimeRequest")))
	player:SendToClient(SerializeCommand(NewCommand("UDPClientTimeRequest")))
end
