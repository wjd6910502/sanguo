function OnCommand_GetMyPveArenaInfo(player, role, arg, others)
	player:Log("OnCommand_GetMyPveArenaInfo, "..DumpTable(arg).." "..DumpTable(others))

	local pve_arena = others.pvearena._data._pve_arena_data_map_data
	local resp = NewCommand("GetMyPveArenaInfo_Re")

	resp.score = role._roledata._pve_arena_info._score
	resp.rank = PVEARENA_GetRank(pve_arena, role._roledata._base._id, role._roledata._pve_arena_info._score)
	resp.last_attack_time = role._roledata._pve_arena_info._last_attack_time
	resp.defence_hero = {}

	local heroid_it = role._roledata._pve_arena_info._defence_hero_info:SeekToBegin()
	local heroid = heroid_it:GetValue()
	while heroid ~= nil do
		resp.defence_hero[#resp.defence_hero+1] = heroid._value
		heroid_it:Next()
		heroid = heroid_it:GetValue()
	end

	resp.pve_refreshtime = role._roledata._pve_arena_info._pve_refreshtime

	player:SendToClient(SerializeCommand(resp))
	return
end
