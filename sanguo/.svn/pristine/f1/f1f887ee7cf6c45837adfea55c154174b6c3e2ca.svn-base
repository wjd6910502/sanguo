function OnCommand_MafiaGet(player, role, arg, others)
	player:Log("OnCommand_MafiaGet, "..DumpTable(arg).." "..DumpTable(others))

	local my_mafia = others.mafias[role._roledata._mafia._id:ToStr()]
	local resp = NewCommand("MafiaGet_Re")
	if my_mafia~=nil then
		TASK_ChangeCondition(role, G_ACH_TYPE["MAFIA_JISI"], 0, my_mafia._data._jisi)

		resp.retcode = G_ERRCODE["SUCCESS"]
		resp.mafia = MAFIA_MakeMafia(my_mafia._data)
	else
		resp.retcode = G_ERRCODE["NO_MAFIA"]
		player:Log("OnCommand_MafiaGet, error=NO_MAFIA")
	end
	player:SendToClient(SerializeCommand(resp))
end
