function OnMessage_PrintPveArenaMisc(player, role, arg, others)
	player:Log("OnMessage_PrintPveArenaMisc, "..DumpTable(arg).." "..DumpTable(others))

	local pve_arena = others.pvearena._data._pve_arena_data_map_data
	PVEARENA_PrintRoleInfo(pve_arena)
end
