function OnCommand_PVPInvite(player, role, arg, others)
	API_Log("OnCommand_PVPInvite, "..DumpTable(arg))

	g_pvp_invites[arg.src.id] = arg.src.name
end
