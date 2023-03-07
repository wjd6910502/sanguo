function OnCommand_SetPveArenaHero(player, role, arg, others)
	player:Log("OnCommand_SetPveArenaHero, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("SetPveArenaHero_Re")
	
	if table.getn(arg.heros) == 0 then
		resp.retcode = G_ERRCODE["HERO_COUNT_ZERO"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	local heros = role._roledata._hero_hall._heros

	for i = 1, table.getn(arg.heros) do
		local h = heros:Find(arg.heros[i])
		if h == nil then
			resp.retcode = G_ERRCODE["NO_HERO"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
	end

	role._roledata._pve_arena_info._defence_hero_info:Clear()
	for i = 1, table.getn(arg.heros) do
		local value = CACHE.Int()
		value._value = arg.heros[i]
		role._roledata._pve_arena_info._defence_hero_info:PushBack(value)
	end
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
	
	ROLE_UpdateMiscPveArenaHeroInfo(role, arg.heros[1])

	return

end
