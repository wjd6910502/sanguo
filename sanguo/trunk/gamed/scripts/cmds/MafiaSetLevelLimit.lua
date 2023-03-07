function OnCommand_MafiaSetLevelLimit(player, role, arg, others)
	player:Log("OnCommand_MafiaSetLevelLimit, "..DumpTable(arg).." "..DumpTable(others))
	
	local mafia_data = others.mafias[role._roledata._mafia._id:ToStr()]
	local resp = NewCommand("MafiaSetLevelLimit_Re")

	resp.level = arg.level
	resp.need_approval = arg.need_approval

	if mafia_data == nil then
		resp.retcode = G_ERRCODE["NO_MAFIA"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MafiaSetLevelLimit, error=NO_MAFIA")
		return
	end

	local mafia_info = mafia_data._data

	if role._roledata._mafia._position ~= G_MAFIA_POSITION["BANGZHU"] and role._roledata._mafia._position ~= G_MAFIA_POSITION["JUNSHI"] then
		resp.retcode = G_ERRCODE["MAFIA_SET_LEVEL_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MafiaSetLevelLimit, error=MAFIA_SET_LEVEL_ERR")
		return
	end

	if arg.level < 0 or arg.need_approval > 1 or arg.need_approval < 0 then
		return
	end

	local need_broadcast = 0

	if mafia_info._level_limit ~= arg.level then
		mafia_info._level_limit = arg.level
		need_broadcast = 1
	end

	if mafia_info._need_approval ~= arg.need_approval then
		mafia_info._need_approval = arg.need_approval
		need_broadcast = 1
	end

	--广播出去，给所有的玩家
	if need_broadcast == 1 then
		MAFIA_MafiaUpdateInterfaceInfo(mafia_info)
	end
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))

end
