function OnCommand_PVPEnd(player, role, arg, others)
	API_Log("OnCommand_PVPEnd, "..DumpTable(arg))

	g_Pvp["PVPEnd"] = arg
	--g_got_PVPEnd = true
end
