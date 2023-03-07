function OnCommand_MafiaSetAnnounce(player, role, arg, others)
	player:Log("OnCommand_MafiaSetAnnounce, "..DumpTable(arg).." "..DumpTable(others))
	
	local mafia_data = others.mafias[role._roledata._mafia._id:ToStr()]
	local resp = NewCommand("MafiaSetAnnounce_Re")

	resp.announce = arg.announce

	if mafia_data == nil then
		resp.retcode = G_ERRCODE["NO_MAFIA"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MafiaSetAnnounce, error=NO_MAFIA")
		return
	end

	local mafia_info = mafia_data._data

	if role._roledata._mafia._position ~= G_MAFIA_POSITION["BANGZHU"] and role._roledata._mafia._position ~= G_MAFIA_POSITION["JUNSHI"] then
		resp.retcode = G_ERRCODE["MAFIA_SET_LEVEL_ERR"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MafiaSetAnnounce, error=MAFIA_SET_LEVEL_ERR")
		return
	end
	
	if player:IsValidRolename(arg.announce) == false then
		resp.retcode = G_ERRCODE["MAFIA_ANNOUNCE_INVALID"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MafiaSetAnnounce, error=MAFIA_ANNOUNCE_INVALID")
		return
	end

	mafia_info._announce = arg.announce

	MAFIA_MafiaUpdateInterfaceInfo(mafia_info)
		
	--更新帮会的信息到简易帮会表中去
	MAFIA_MafiaUpdateInfoTop(mafia_info, 0)
	
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
end
