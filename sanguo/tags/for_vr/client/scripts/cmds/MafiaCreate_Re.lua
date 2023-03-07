function OnCommand_MafiaCreate_Re(player, role, arg, others)
	API_Log("OnCommand_MafiaCreate_Re, "..DumpTable(arg))

	if arg.retcode == G_ERRCODE["SUCCESS"] then
		g_mafia_id = arg.mafia.id
	end
end
