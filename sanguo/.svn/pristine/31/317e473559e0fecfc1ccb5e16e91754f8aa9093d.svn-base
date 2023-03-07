function OnMessage_UpdateSpecialTask(player, role, arg, others)
	player:Log("OnMessage_UpdateSpecialTask, "..DumpTable(arg).." "..DumpTable(others))

	if arg.hero_tupo then
		local heros = role._roledata._hero_hall._heros
		for hero in Cache_Map(heros) do
			TASK_ChangeCondition_Special(role, G_ACH_TYPE["HERO_TUPO"], hero._order, 0, 1)
		end
	end

	if arg.hero_star then
		local heros = role._roledata._hero_hall._heros
		for hero in Cache_Map(heros) do
			TASK_ChangeCondition_Special(role, G_ACH_TYPE["HERO_STAR"], hero._star, 0, 1)
		end
	end

	if arg.weapon_level then
		local weapon_items = role._roledata._backpack._weapon_items._weapon_items
		for weapon in Cache_List(weapon_items) do
			TASK_ChangeCondition_Special(role, G_ACH_TYPE["WEAPON_LEVELUP"], weapon._weapon_pro._level_up, 0, 1)
		end
	end

	if arg.equip_level then
		local equipments = role._roledata._backpack._equipment_items._equipment_items	
		for equipment in Cache_Map(equipments) do
			TASK_ChangeCondition_Special(role, G_ACH_TYPE["EQUIPMENT_LEVELUP"], equipment._equipment_pro._level_up, 0, 1)
		end
	end

	if arg.pverank then
		local pve_arena = API_GetLuaPveArena()._data
		local cur_rank = PVEARENA_GetRank(pve_arena._pve_arena_data_map_data, role._roledata._base._id, role._roledata._pve_arena_info._score)
		TASK_ChangeCondition(role, G_ACH_TYPE["LESSNUM"], G_ACH_TWENTYONE_TYPE["JJCRANK"], cur_rank)
	end

	if arg.pvpgrade then
		if role._roledata._pvp_info._win_count ~= 0 or role._roledata._pvp_info._fail_count ~= 0 then
			TASK_ChangeCondition(role, G_ACH_TYPE["LESSNUM"], G_ACH_TWENTYONE_TYPE["3V3GRADE"], role._roledata._pvp_info._pvp_grade)
		end
	end
end
