function OnCommand_SkinEquip(player, role, arg, others)
	player:Log("OnCommand_SkinEquip, "..DumpTable(arg).." "..DumpTable(others))

	local resp = NewCommand("SkinEquip_Re")
	resp.skinid = arg.skinid

	--判断玩家是否有这个皮肤
	local skin_info = role._roledata._backpack._skin_items:Find(arg.skinid)
	if skin_info == nil then
		resp.retcode = G_ERRCODE["SKIN_NOT_EXIST"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	--查看这个皮肤是否已经过期
	local time = API_GetTime()
	if skin_info._time ~= 0  and time >= skin_info._time then
		resp.retcode = G_ERRCODE["SKIN_TIME_OUT"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	local ed = DataPool_Find("elementdata")
	local dress_info = ed:FindBy("dress_id", arg.skinid)
	
	--判断这个武将是否存在
	local hero_info = role._roledata._hero_hall._heros:Find(dress_info.owner_id)
	if hero_info == nil then
		resp.retcode = G_ERRCODE["SKIN_GET_HERO_FIRST"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	hero_info._skin = arg.skinid
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
end
