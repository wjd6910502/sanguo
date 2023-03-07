function OnCommand_PvpEnter_Re(player, role, arg, others)
	API_Log("OnCommand_PvpEnter_Re, "..DumpTable(arg).." "..DumpTable(others))

	g_Pvp["PvpEnter_Re"] = arg
	--local cmd2 = NewCommand("PVPReady")
	--API_SendGameProtocol(SerializeCommand(cmd2))
end
