function OnMessage_DBHeartbeat(playermap, arg)
	--API_Log("OnMessage_DBHeartbeat, "..DumpTable(arg))
	API_LuaSave();
end
