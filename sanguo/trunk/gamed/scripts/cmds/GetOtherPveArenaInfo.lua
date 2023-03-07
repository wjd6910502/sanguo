function OnCommand_GetOtherPveArenaInfo(player, role, arg, others)
	player:Log("OnCommand_GetOtherPveArenaInfo, "..DumpTable(arg).." "..DumpTable(others))

	local pve_arena = others.pvearena._data._pve_arena_data_map_data
	local dest_role = others.roles[arg.roleid]

	if dest_role == nil then
		return
	end

	--查看你自己的信息没有任何的意义呀
	if role._roledata._base._id:ToStr() == dest_role._roledata._base._id:ToStr() then
		return
	end

	local resp = NewCommand("GetOtherPveArenaInfo_Re")
	resp.info = {}
	resp.info.name = dest_role._roledata._base._name
	resp.info.id = dest_role._roledata._base._id:ToStr()
	resp.info.rank = PVEARENA_GetRank(pve_arena, dest_role._roledata._base._id, dest_role._roledata._pve_arena_info._score)
	resp.info.score = dest_role._roledata._pve_arena_info._score
	resp.info.level = dest_role._roledata._status._level
	resp.info.mafia_name = dest_role._roledata._mafia._name
	resp.info.photo = dest_role._roledata._base._photo
	resp.info.photo_frame = dest_role._roledata._base._photo_frame
	resp.info.badge_info = {}
	local badge_info_it = dest_role._roledata._base._badge_map:SeekToBegin()
	local badge_info = badge_info_it:GetValue()
	while badge_info ~= nil do
		local tmp_badge_info = {}
		tmp_badge_info.id = badge_info._id
		tmp_badge_info.typ = badge_info._pos
		resp.info.badge_info[#resp.info.badge_info+1] = tmp_badge_info

		badge_info_it:Next()
		badge_info = badge_info_it:GetValue()
	end

	resp.info.hero_info = {}
	resp.info.hero_info.heroinfo = {}
	local zhanli = 0
	local heroid_it = dest_role._roledata._pve_arena_info._defence_hero_info:SeekToBegin()
	local heroid = heroid_it:GetValue()
	while heroid ~= nil do
		local hero_info = dest_role._roledata._hero_hall._heros:Find(heroid._value)
		if hero_info ~= nil then
			zhanli = zhanli + HERO_CalZhanli(dest_role, heroid._value)
			local tmp_hero = {}
			tmp_hero.id = heroid._value
			tmp_hero.level = hero_info._level
			tmp_hero.star = hero_info._star
			tmp_hero.grade = hero_info._order
			resp.info.hero_info.heroinfo[#resp.info.hero_info.heroinfo+1] = tmp_hero
		end
		heroid_it:Next()
		heroid = heroid_it:GetValue()
	end

	resp.info.hero_score = zhanli

	role:SendToClient(SerializeCommand(resp))
	return
end
