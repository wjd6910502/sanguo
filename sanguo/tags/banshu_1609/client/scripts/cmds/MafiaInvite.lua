function OnCommand_MafiaInvite(player, role, arg, others)
	API_Log("OnCommand_MafiaInvite, "..DumpTable(arg))

	g_mafia_invites[arg.src.id] = arg.src.mafia_id
end
