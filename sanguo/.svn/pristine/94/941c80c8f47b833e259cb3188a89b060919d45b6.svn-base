function OnMessage_CreateMafiaResult(player, role, arg, others)
	player:Log("OnMessage_CreateMafiaResult, "..DumpTable(arg))

	local resp = NewCommand("MafiaCreate_Re")
	if arg.retcode==G_ERRCODE["SUCCESS"] then
		resp.retcode = G_ERRCODE["SUCCESS"]
		local my_mafia = others.mafias[role._roledata._mafia._id:ToStr()]
		resp.mafia = MAFIA_MakeMafia(my_mafia)
	else
		resp.retcode = arg.retcode
	end
	player:SendToClient(SerializeCommand(resp))
end
