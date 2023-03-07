function OnMessage_ReloadLua(playermap, arg)
	API_Log("OnMessage_ReloadLua, "..DumpTable(arg))

	API_ReloadLua()
end
