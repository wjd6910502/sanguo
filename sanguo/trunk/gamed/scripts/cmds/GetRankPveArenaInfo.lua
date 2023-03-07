function OnCommand_GetRankPveArenaInfo(player, role, arg, others)
	player:Log("OnCommand_GetRankPveArenaInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("GetRankPveArenaInfo_Re")
	resp.info = {}
	local pve_arena = others.pvearena._data
		
	local fight_info = PVEARENA_GetRoleInfoByRank(pve_arena._pve_arena_data_map_data, arg.rank)
		
	if fight_info.role_id ~= "0" then
		local tmp_fight = {}
		tmp_fight.id = fight_info.role_id
		tmp_fight.name = fight_info.name
		tmp_fight.level = fight_info.level
		tmp_fight.score = fight_info.score
		tmp_fight.hero_score = fight_info.zhanli
		tmp_fight.mafia_name = fight_info.mafia_name
		tmp_fight.rank = arg.rank
		tmp_fight.photo = fight_info.photo
		tmp_fight.photo_frame = fight_info.photo_frame
		tmp_fight.badge_info = fight_info.badge
		
		tmp_fight.hero_info = {}
		tmp_fight.hero_info.heroinfo = {}
		for i = 1, table.getn(fight_info.hero_info) do
			tmp_fight.hero_info.heroinfo[#tmp_fight.hero_info.heroinfo+1] = fight_info.hero_info[i]
		end

		resp.info = tmp_fight
	end
		
	player:SendToClient(SerializeCommand(resp))
end
