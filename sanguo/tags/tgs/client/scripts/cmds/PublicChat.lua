function OnCommand_PublicChat(player, role, arg, others)
	--API_Log("OnCommand_PublicChat, "..DumpTable(arg))

	g_others[arg.src.id] = arg.src.name
	g_others_mafia_id[arg.src.id] = arg.src.mafia_id
end
