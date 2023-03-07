function OnCommand_MafiaDeclaration(player, role, arg, others)
	player:Log("OnCommand_MafiaDeclaration, "..DumpTable(arg).." "..DumpTable(others))
	
	local mafia_data = others.mafias[role._roledata._mafia._id:ToStr()]
	local resp = NewCommand("MafiaDeclaration_Re")

	resp.declaration = arg.declaration

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
	
	if player:IsValidRolename(arg.declaration) == false then
		resp.retcode = G_ERRCODE["MAFIA_ANNOUNCE_INVALID"]
		player:SendToClient(SerializeCommand(resp))
		return
	end

	mafia_info._declaration = arg.declaration

	MAFIA_MafiaUpdateInterfaceInfo(mafia_info)
	
	resp.retcode = G_ERRCODE["SUCCESS"]
	player:SendToClient(SerializeCommand(resp))
end
