function OnCommand_MafiaChangeName(player, role, arg, others)
	player:Log("OnCommand_MafiaChangeName, "..DumpTable(arg).." "..DumpTable(others))

	--TODO: ?Ƿ????ּ???
	local resp = NewCommand("MafiaChangeName_Re")
	if player:IsValidRolename(arg.name) == false then
		resp.retcode = G_ERRCODE["INVALID_NAME"]
		player:SendToClient(SerializeCommand(resp))
		return
	end
	
	player:AllocMafiaChangeName(arg.name)
end
