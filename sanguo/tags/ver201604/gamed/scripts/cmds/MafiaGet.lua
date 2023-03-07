function OnCommand_MafiaGet(player, role, arg, others)
	player:Log("OnCommand_MafiaGet, "..DumpTable(arg).." "..DumpTable(others))

	local my_mafia = others.mafias[role._mafia._id:ToStr()]
	local resp = NewCommand("MafiaGet_Re")
	if my_mafia~=nil then
		resp.retcode = G_ERRCODE["SUCCESS"]
		resp.mafia = MAFIA_MakeMafia(my_mafia)
	else
		resp.retcode = G_ERRCODE["NO_MAFIA"]
	end
	player:SendToClient(SerializeCommand(resp))
end
