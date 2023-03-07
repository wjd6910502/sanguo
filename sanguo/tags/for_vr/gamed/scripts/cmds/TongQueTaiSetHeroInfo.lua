function OnCommand_TongQueTaiSetHeroInfo(player, role, arg, others)
	player:Log("OnCommand_TongQueTaiSetHeroInfo, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("TongQueTaiSetHeroInfo_Re")
	resp.hero = arg.hero

	if table.getn(arg.hero) < 3 then
		resp.retcode = G_ERRCODE["TONGQUETAI_SET_HERO_COUNT_LESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	for i = 1, table.getn(arg.hero) do
		local h = role._roledata._hero_hall._heros:Find(arg.hero[i])
		if h == nil then
			resp.retcode = G_ERRCODE["TONGQUETAI_SET_HERO_NO_HERO"]
			player:SendToClient(SerializeCommand(resp))
			return
		end
	end

	role._roledata._tongquetai_data._hero_info_list:Clear()

	for i = 1, table.getn(arg.hero) do
		local insert_data = CACHE.Int()
		insert_data._value = arg.hero[i]
		role._roledata._tongquetai_data._hero_info_list:PushBack(insert_data)
	end
	
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
end
