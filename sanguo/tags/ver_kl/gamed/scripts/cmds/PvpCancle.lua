function OnCommand_PvpCancle(player, role, arg, others)
	player:Log("OnCommand_PvpCancle, "..DumpTable(arg).." "..DumpTable(others))

	role:SendPVPCancle()
end
