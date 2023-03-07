function OnCommand_PVPBegin(player, role, arg, others)
	API_Log("OnCommand_PVPBegin, "..DumpTable(arg))

	g_Pvp["PVPBegin"] = arg
	--g_got_PVPBegin = true
	--g_pvp_fight_start_time = arg.fight_start_time
	--API_SetPVPDInfo(arg.ip, arg.port)
end
