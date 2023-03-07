function OnCommand_PvpJoin_Re(player, role, arg, others)
	API_Log("OnCommand_PvpJoin_Re, "..DumpTable(arg).." "..DumpTable(others))

	g_Pvp["PvpJoin_Re"] = arg
end
