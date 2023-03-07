function OnMessage_CloseServer(playermap, arg)
	API_Log("OnMessage_CloseServer, "..DumpTable(arg))

	API_CloseServer()
	
	--就可以在这里广播观看信息了
	local msg = NewMessage("KickOut")
	msg.reason = 1

	API_SendMessageToAllRole(SerializeMessage(msg), CACHE.Int64List(), CACHE.Int64List(), CACHE.IntList())

	API_LuaSave()

	API_CustomerServiceServer(arg.sid, 0)
end
