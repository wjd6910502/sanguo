function OnCommand_MafiaChangeName(player, role, arg, others)
	player:Log("OnCommand_MafiaChangeName, "..DumpTable(arg).." "..DumpTable(others))

	--TODO: 非法名字检查
	local resp = NewCommand("MafiaChangeName_Re")
	if player:IsValidRolename(arg.name) == false then
		resp.retcode = G_ERRCODE["INVALID_NAME"]
		player:SendToClient(SerializeCommand(resp))
		player:Log("OnCommand_MafiaChangeName, error=INVALID_NAME")
		return
	end
	
	player:AllocMafiaChangeName(arg.name)
end
