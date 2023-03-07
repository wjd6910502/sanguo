function OnCommand_CreateRole_Re(player, role, arg, others)
	--API_Log("OnCommand_CreateRole_Re, "..DumpTable(arg))

	if arg.retcode==G_ERRCODE["SUCCESS"] then
		g_role_id=arg.info.base.id
		g_mafia_id = arg.info.mafia.id
	end
end
