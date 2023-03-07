function OnCommand_MafiaSetAnnounce(player, role, arg, others)
	player:Log("OnCommand_MafiaSetAnnounce, "..DumpTable(arg).." "..DumpTable(others))
	
	local mafia_data = others.mafias[role._roledata._mafia._id:ToStr()]
	local resp = NewCommand("MafiaSetAnnounce_Re")

	resp.announce = arg.announce

	if mafia_data == nil then
		resp.retcode = G_ERRCODE["NO_MAFIA"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	local mafia_info = mafia_data._data

	if role._roledata._mafia._position ~= G_MAFIA_POSITION["BANGZHU"] and role._roledata._mafia._position ~= G_MAFIA_POSITION["JUNSHI"] then
		resp.retcode = G_ERRCODE["MAFIA_SET_LEVEL_ERR"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	if player:IsValidRolename(arg.announce) == false then
		resp.retcode = G_ERRCODE["MAFIA_ANNOUNCE_INVALID"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	mafia_info._announce = arg.announce

	MAFIA_MafiaUpdateInterfaceInfo(mafia_info)
		
	--更新帮会的信息到简易帮会表中去
	local msg = NewMessage("UpdateMafiaInfoTop")
	msg.level_flag = 0
	msg.id = mafia_info._id:ToStr()
	msg.name = mafia_info._name
	msg.announce = mafia_info._announce
	msg.level = mafia_info._level
	msg.boss_id = mafia_info._boss_id:ToStr()
	msg.boss_name = mafia_info._boss_name
	msg.level_limit = mafia_info._level_limit
	msg.num = mafia_info._member_map:Size()
	player:SendMessage(CACHE.Int64(0), SerializeMessage(msg))
	
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
end
