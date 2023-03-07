function OnCommand_GetRoleInfo_Re(player, role, arg, others)
	API_Log("OnCommand_GetRoleInfo_Re, "..DumpTable(arg))

	g_got_GetRoleInfo_Re = true
	
	if arg.retcode == G_ERRCODE["SUCCESS"] then
		g_role_id = arg.info.base.id
		g_mafia_id = arg.info.mafia.id
	end
end
