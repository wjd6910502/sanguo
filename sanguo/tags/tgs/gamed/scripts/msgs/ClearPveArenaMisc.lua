function OnMessage_ClearPveArenaMisc(player, role, arg, others)
	--player:Log("OnMessage_ClearPveArenaMisc, "..DumpTable(arg).." "..DumpTable(others))
	--
	local pve_arena = others.pvearena._data
	pve_arena._pve_arena_data_map_data:Clear()
	pve_arena._all_num = 0
end
