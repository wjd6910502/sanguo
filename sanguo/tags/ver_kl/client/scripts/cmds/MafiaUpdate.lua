function OnCommand_MafiaUpdate(player, role, arg, others)
	API_Log("OnCommand_MafiaUpdate, "..DumpTable(arg))

	g_mafia_id = arg.mafia.id
end
