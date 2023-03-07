function OnCommand_LevelUpHeroStar(player, role, arg, others)
	player:Log("OnCommand_LevelUpHeroStar, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("LevelUpHeroStar_Re")
	resp.hero_id = arg.hero_id

	--查看当前武将的星级
	local heros = role._roledata._hero_hall._heros
	local hero = heros:Find(arg.hero_id)
	if hero == nil then
		resp.retcode = G_ERRCODE["NO_HERO"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--得到当前星级
	local cur_star = hero._star

	local ed = DataPool_Find("elementdata")
	local tem_hero = ed:FindBy("hero_id", arg.hero_id)

	if cur_star >= tem_hero.maxstar then
		resp.retcode = G_ERRCODE["HERO_STAR_MAX"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--查看武魂是否足够
	local need_soul = 0
	local flag = 1
	for soul in DataPool_Array(tem_hero.starsoul) do
		if flag == cur_star then
			need_soul = soul
			break
		end
		flag = flag + 1
	end

	if need_soul == 0 then
		resp.retcode = G_ERRCODE["HERO_STAR_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	if BACKPACK_HaveItem(role, tem_hero.soulID, need_soul) == false then
		resp.retcode = G_ERRCODE["HERO_STAR_SOUL_LESS"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	--local soul = role._roledata._hero_soul:Find(tem_hero.soulID)
	--if soul == nil or soul._num < need_soul then
	--	resp.retcode = G_ERRCODE["HERO_STAR_SOUL_LESS"]
	--	player:SendToClient(SerializeCommand(resp))
	--	return
	--end

	--扣除武魂
	BACKPACK_DelItem(role, tem_hero.soulID, need_soul)
	hero._star = hero._star + 1
	--更新武将
	HERO_UpdateHeroInfo(role, arg.hero_id)

	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
	return
end
